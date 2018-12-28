# Intro to Networking for Games
In my never-ending journey to amass enough knowledge to build more complex video games, I have encountered many different topics. Today's topic is network programming, and specifically how that applies to video games --- it can be quite different from other kinds of net code. Here are some ways it can differ:

+ **Low latency** --- Multi-player games really care about how fast information gets from one user to another, as that can dictate the player's experience. New data is often transferred 10, 30 or 60 times per second.
+ **Data gets stale quickly** --- As much of the data being transferred is regarding momentary fragments of the state of the world (character positions, events, etc.), data can become stale quickly, and so it is not critical that all data is acted upon; it may be immediately discarded if no longer relevant.
+ **Binary data transfer** --- There are many text-based formats used all over non-game net code (HTML, JSON, etc.) but games, given their concern for efficiency and speed, almost always opt for binary formats.
+ **Non-blocking** --- The network code is not the *top dog* of the game code, that position belongs to game-play simulation and graphics code. Therefore, it is important that the network programming model allows maximum flexibility, and does not enforce rules upon other aspects of the code. Handling network events may need to fit into the frame loop, and so cannot block execution of a frame (causing frame-rate drops) while waiting for data to arrive --- it must be [non-blocking](https://en.wikipedia.org/wiki/Asynchronous_I/O).

Games designed to be played over the internet have the choice of [TCP](https://en.wikipedia.org/wiki/Transmission_Control_Protocol) or [UDP](https://en.wikipedia.org/wiki/User_Datagram_Protocol) protocols. TCP is designed around opening persistent connections between computers, with data arriving reliably (complete, and in the correct order). UDP is fire and forget --- each packet of data has a destination and gets send off into the ether as fast as possible, hopefully arriving successfully at the other end but with no guarantees. UDP sounds awfully error-prone, but considering some of the common characteristics of games mentioned above, it is the better choice. UDP aligns well with the fact that game data becomes stale quickly, so the leaps and bounds that TCP goes to to ensure every data packet arrives correctly, even if it is already too old to use, is unhelpful, and has a significant performance penalty.

This guide hopes to teach you how to send and receive UDP packets in a cross-platform and future-proof way, and goes on to discuss some tips on how to utilise these tools effectively. There are many other topics that you'll want to read up on to improve your network programming skills, and I have provided some of my favourites in the [Further Reading](#further-reading) section.

## UDP with BSD-style Sockets
So UDP it is. This section will describe everything you need to know about BSD sockets (and the near-identical [Winsock](https://docs.microsoft.com/en-us/windows/desktop/WinSock/windows-sockets-start-page-2) on Windows) to send and receive UDP packets on every major operating system using C. These are utilities provided directly by your OS, so there's nothing to download or install. Let's get started by including the necessary headers.

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

## Further Reading
I learned a great deal reading [Glenn Fiedler's many articles on game network programming](https://gafferongames.com/). It's the best singular resource I have found on the internet for network game programming. I learned how to use BSD-sockets from [Beej's Guide to Network Programming](https://beej.us/guide/bgnet/html/single/bgnet.html), and extended that knowledge slightly to better support Windows by reading Microsoft's [Winsock 2 Documentation](https://docs.microsoft.com/en-gb/windows/desktop/WinSock/). Reading the source code of the [ENet](http://enet.bespin.org/) library was also very helpful, as it is a very high quality game-focused networking library built atop UDP using sockets. Outside of these major resources, a handful of articles also helped, including this classic write-up of [Age of Empires' net code](https://www.gamasutra.com/view/feature/131503/1500_archers_on_a_288_network_.php?print=1) on Gamasutra.
