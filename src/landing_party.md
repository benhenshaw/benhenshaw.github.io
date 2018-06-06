# Landing Party: An Escape Room
In my third and final year at [Goldsmiths, University of London](https://www.gold.ac.uk/) I worked on an [escape room](https://en.wikipedia.org/wiki/Escape_room) with three other students[^1], for a module called *Pervasive Gaming and Immersive Theatre*. The project was about crash landing a space ship on the surface of a planet. Here I will share some of the details of the experience as it is unlikely to be run again.

<iframe src="https://www.youtube-nocookie.com/embed/BITzAWG2GfA" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

## Conception
The initial idea began as the concept of limited communication. In order to best express this concept, communication would need to be centre to the tasks that players were tackling. We achieved this by having hidden information that players must communicate to each other to complete their objectives, reified by dividing the players up into two separate rooms, each with their own information and tasks.

The theme and narrative of the piece came naturally when considering ways in which we could limit or control communication; poor reception, lost signals, and backup text communication: remote space exploration. With our core concept in place, we wrapped our split-rooms mechanic in the theme of a spacecraft trying to land on a remote base. This also conveniently gave a reason for time-limiting the experience: the ship will crash into the surface of the planet given enough time.


## Description
*This is a description of the entire escape room experience as it was implemented for the showing on the 22nd of March, 2018:*

When an attendee enters the building they are given a ticket with a geometric symbol on it. They are lead to a room with a projection and voice over that tells them which of two rooms to enter, the **ship** or the **base**, based on the symbol on their ticket. Once the attendees have entered their rooms the doors are closed and the experience begins.

Both teams are equipped with a voice intercom system, allowing them to communicate, and are confronted with a locked computer to which they must find the password. In order to complete this puzzle, the **ship**’s inhabitants must read the [Cyrillic](https://en.wikipedia.org/wiki/Cyrillic_script) letters from a poster in their room to the **base** team, who has a computer keyboard with Cyrillic letters on it. The password can be deciphered by matching each Cyrillic character to the Latin character that shares the same key.

Once both teams have entered the correct password, a voice will announce to both teams that they must press the button to start the ‘automated landing process’. In actuality, this will trigger the lights and intercom to cut out, and a warning message to announce that a malfunction has occurred. Now that the teams cannot talk to each other, they will need to use the computer’s text communication (set up like an instant messenger) to continue to work together.

The **base** team must then solve a puzzle by connecting two of eight wires in order to turn on three LEDs on a physical map. One of these LEDs is marked ‘BASE’. The team will need to communicate this information to the **ship** team (using the text chat). The **ship** team have a radar screen on their computer. There are three coloured blips on the radar, matching the colours of the LEDs. They must correctly identify the LED that was labelled ‘BASE’, and then use a third screen, the ‘CONTROL’ screen, to enter a direction of travel, such that they land on top of that blip. This can be failed, ending the experience.

Once the **ship** has successfully landed, the **ship** team will need to communicate a sequence of four colours from a strip of LEDs to the **base** team; these lights were only visible once the power had gone out. With this information, the **base** team can connect four wires on the back of a panel containing a fingerprint sensor. Once correctly connected, a member of that team must place each finger on the sensor, in the order dictated on screen. Once that has been completed, the doors will unlock, the teams will be reunited, an announcement will be made, and the attendees will be escorted out.

### Control Room
The team running the experience have a control room which contains screens displaying a camera feed from each room, power switches to all major components of the experience, and a speaker to play ambient sound and voice over. This allowed us to observe and record our attendees, and to trigger key events in the experience at the right time.

## Implementation
While there were many interesting and complex components in the escape room, I would like to highlight the on-screen interface and network code that I implemented.

<iframe src="https://www.youtube-nocookie.com/embed/lhiUzz0yYzQ" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

The system was written in C using [SDL2](https://libsdl.org/) and [ENet](http://enet.bespin.org/). As the experience uses a separate computer in each room, any data had to be transferred between them over a local network. A dedicated server passes text between the clients, and text rendering is done using a bitmap font and custom rendering routine.

[^1]: Kotryna Sajeviciute, Daniel San, and Alice Casey.
