<!-- Created: 2019-01-22 -->

# Intro to UDP Networking for Games

> **TL;DR:** *See [this github repo](https://github.com/benhenshaw/quick_udp) for a small UDP networking library that implements all the information presented here.*

In my never-ending journey to amass enough knowledge to build more complex video games, I have encountered many different topics. Today's topic is network programming, and specifically how that applies to video games --- it can be quite different from other kinds of net code. Here are some ways it can differ:

+ **Low latency** --- Multi-player games really care about how fast information gets from one user to another, as that can dictate the player's experience. New data is often transferred 10, 30 or 60 times per second.
+ **Data gets stale quickly** --- As much of the data being transferred is regarding momentary fragments of the state of the world (character positions, events, etc.), data can become stale quickly, so it is not critical that all data is acted upon; it may be immediately discarded if no longer relevant.
+ **Binary data transfer** --- There are many text-based formats used all over non-game net code (HTML, JSON, etc.) but games, given their concern for efficiency and speed, almost always opt for binary formats.
+ **Non-blocking** --- The network code is not the *top dog* of the game code, that position belongs to game-play simulation and graphics code. Therefore, it is important that the network programming model allows maximum flexibility, and does not enforce rules upon other aspects of the code. Handling network events may need to fit into the frame loop, and so cannot block execution of a frame (causing frame-rate drops) while waiting for data to arrive --- it must be [non-blocking](https://en.wikipedia.org/wiki/Asynchronous_I/O).

Games designed to be played over the internet have the choice of [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) or [UDP](https://en.wikipedia.org/wiki/User_Datagram_Protocol) protocols. TCP is designed around opening persistent connections between computers, with data arriving reliably (complete, and in the correct order). UDP is fire and forget --- each packet of data has a destination and gets send off into the ether as fast as possible, hopefully arriving successfully at the other end but with no guarantees. UDP sounds awfully error-prone, but considering some of the common characteristics of games mentioned above, it is the better choice. UDP aligns well with the fact that game data becomes stale quickly, so the leaps and bounds that TCP goes to to ensure every data packet arrives correctly, even if it is already too old to use, is unhelpful, and has a significant performance penalty.

This guide hopes to teach you how to send and receive UDP packets in a cross-platform and future-proof way (supporting IPv6), and goes on to discuss some tips on how to utilise these tools effectively. There are many other topics that you'll want to read up on to improve your network programming skills, and I have provided some of my favourites in the [Further Reading](#further-reading) section.

## Overview
Here is a quick description of some key networking concepts. It may be advantageous to read up further on any of these that feel unclear, as they will be referenced later in this article.

> **[Packet](https://en.wikipedia.org/wiki/Network_packet)** --- A network packet is a unit of data that can be transferred across a network. A packet consists of control information, which is used to get that packet to the correct destination; and user data, which is the actual data that the program has sent.

> **[Socket](https://en.wikipedia.org/wiki/Network_socket)** --- A network socket is an internal endpoint for sending or receiving data within a node on a computer network. Concretely, it is a representation of this endpoint in networking software (protocol stack), such as an entry in a table (listing communication protocol, destination, status, etc.), and is a form of system resource. https://en.wikipedia.org/wiki/Handle_(computing)

> **[Address](https://en.wikipedia.org/wiki/Network_address) (also [IP Address](https://en.wikipedia.org/wiki/IP_address))** --- A network address is an (often unique) identifier for a node or host on a telecommunications network. An Internet Protocol address (IP address) is a numerical label assigned to each device connected to a computer network that uses the [Internet Protocol](https://en.wikipedia.org/wiki/Internet_Protocol) for communication.

## UDP with BSD-style Sockets
This section will describe everything you need to know about BSD sockets (and the near-identical [Winsock](https://docs.microsoft.com/en-us/windows/desktop/WinSock/windows-sockets-start-page-2) on Windows) to send and receive UDP packets on every major operating system using C. These are utilities provided directly by your OS, so there's nothing to download or install. Let's get started by including the necessary headers.

```C
#ifdef _WIN32
    #include <winsock2.h>
    #include <ws2tcpip.h>
    typedef int socklen_t;
#else
    #include <sys/types.h>
    #include <sys/socket.h>
    #include <sys/ioctl.h>
    #include <netinet/in.h>
    #include <arpa/inet.h>
    #include <netdb.h>
    #include <fcntl.h>
    #include <unistd.h>
    #define INVALID_SOCKET -1
    #define SOCKET int
#endif
```

There's an `#ifdef` in there which allows us to include different libraries on Windows (a.k.a. Win32) from every other platform. This is a pattern that will reoccur a few times in these examples, allowing us to use different code on each platform. Here I have also added a few extras that help smooth over other differences between platforms. Exactly what these are should become clear later on.

On Windows, Winsock requires that we call an initialisation and shutdown function, but BSD sockets (all other platforms) do not. To abstract this we can write two functions using `#ifdef` like before to choose the right code for the current platform at compile time.

```C
int init_network(void)
{
#ifdef _WIN32
    WSADATA wsa_data;
    if (WSAStartup(MAKEWORD(2, 2), &wsa_data) != 0) return 0;
#endif
    return 1;
}

int shutdown_network(void)
{
#ifdef _WIN32
    return WSACleanup() != SOCKET_ERROR;
#endif
    return 1;
}
```

Now we are able to start sending and receiving network packets. To receive packets we need to start *listening* for them. We can do this with the `getaddrinfo()` function. This function needs to know what we want from it: what address and port we want to listen to, and the fact that we want to support IPv4 and IPv6.

```C
struct addrinfo hints;
memset(&hints, 0, sizeof(hints))
hints.ai_family   = AF_UNSPEC;
hints.ai_socktype = SOCK_DGRAM;
hints.ai_flags    = AI_PASSIVE;

struct addrinfo * info_list = NULL;
int result = getaddrinfo(NULL, "1234", &hints, &info_list);
if (result != 0) return 0;
```

Here we set some *hints* to be given to `getaddrinfo()` --- parameters that might not be acknowledged, but help us get what we want. `hints.ai_family` allows us to specify the kind of address we want; `AF_UNSPEC` says *any type is fine*, while `AF_INET` would give us only IPv4 addresses, and `AF_INET6` would give us only IPv6 addresses[^1]. `hints.ai_socktype = SOCK_DGRAM` specifies UDP, while `SOCK_STREAM` would give us TCP. `hints.ai_flags = AI_PASSIVE`, when used in conjunction with the fact that our first parameter to `getaddrinfo()` is `NULL`, means that we don't want to use a specific address, but to receive packets using all available addresses on this machine.

`getaddrinfo()` returns a linked list of `struct addrinfo`s to the pointer given as its last parameter. This list contains one or more possible addresses that we could bind to. Binding tells the Operating System to give our program any packets that came to that address and port. On some platforms, the act of binding requires some higher permissions --- on Windows it pops up a little dialogue box to ask the user's consent. Here's how decide which of these addresses to bind to:

```C
// Our successfully initialised linked list from earlier.
struct addrinfo * info_list;

// Our resulting socket.
SOCKET socket_number = INVALID_SOCKET;

// Go through each address, attempt to open the socket and bind to it.
struct addrinfo * i = NULL;
for (i = info_list; i != NULL; i = i->ai_next)
{
    // This socket could not be opened, so move on to the next one.
    socket_number = socket(i->ai_family, i->ai_socktype, i->ai_protocol);
    if (socket_number == INVALID_SOCKET)
    {
        continue;
    }

    // We could not bind to this socket, so move on.
    int result = bind(socket_number, i->ai_addr, i->ai_addrlen);
    if (result == SOCKET_ERROR) {
        // The socket is still open, so we should close it here!
        continue;
    }

    break;
}

// We're done with the the list now.
freeaddrinfo(info_list);

if (i == NULL)
{
    // If i is NULL we reached the end of the list, which that means we could not
    // successfully bind to any address. There is likely a network configuration
    // issue if this occurred, or there's a bug somewhere in your code!
    exit(1)
}
```

If everything was successful, the variable `socket_number` can now be used to receive UDP packets. This is done using the function `recvfrom()`. This function also gives us the address of the computer that sent the packet[^2], which we use to reply.

```C
// An array of bytes that will be filled with the packet's data.
unsigned char buffer[1024];
memset(buffer, 0, 1024);

// A structure that will be filled with the sender's address.
// We can use this later to send packets back.
// This is optional; if you don't want the address
// you can pass NULL and a length of 0.
struct sockaddr_storage sender_address;
socklen_t address_length = sizeof(sender_address);

// The call to recvfrom tells us how long the packet was and
int bytes_received = recvfrom(socket_number, buffer, 1024,
    0, (struct sockaddr *)&sender_address, &address_length);
if (bytes_received != SOCKET_ERROR)
{
    ***TODO***
    char address_string[128];
    inet_ntop(***);

    printf("Got %d bytes from %s:\n", bytes_received, address_string);
    buffer[1024 - 1] = '\0';
    puts(buffer);
}
```

### A Brief Detour
Now would be an ideal time to test if our program can receive packets. We can use the super simple program `nc`, which comes pre-installed on any UNIX-like machine (but not on Windows) to send some data to our program.

## Further Reading
I learned a great deal reading [Glenn Fiedler's many articles on game network programming](https://gafferongames.com/). It's the best singular resource I have found on the internet for network game programming. I learned how to use BSD-sockets from [Beej's Guide to Network Programming](https://beej.us/guide/bgnet/html/single/bgnet.html), and extended that knowledge slightly to better support Windows by reading Microsoft's [Winsock 2 Documentation](https://docs.microsoft.com/en-gb/windows/desktop/WinSock/). Reading the source code of the [ENet](http://enet.bespin.org/) library was also very helpful, as it is a very high quality game-focused networking library built atop UDP using sockets. Outside of these major resources, a handful of articles also helped, including this classic write-up of [Age of Empires' net code](https://www.gamasutra.com/view/feature/131503/1500_archers_on_a_288_network_.php?print=1) on Gamasutra.

[^1]: We can also use `AF_INET6` and then `setsockopt()` to disable `IPV6_V6ONLY`, thus allowing both IPv4 and IPv6 addresses. Some suggest this as a better method, as `AF_UNSPEC` can give us addresses that are neither IPv4 or IPv6, but something else entirely.

[^2]: The address returned from `recvfrom()` comes from the control data inside the packet itself. Therefore it is relatively easy to fake the sender address. It is common to save this address and check if a new packet has the same address to verify that the packet is from the same computer. You should combine this with other methods of verification if you want security (which you probably do).
