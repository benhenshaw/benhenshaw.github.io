# MA Game Design Journal
> Approaches to Play\
> MA Independent Games and Playable Experience Design\
> Benedict Henshaw\
> 2018 - 2019

This is a weekly journal kept during my MA in Independent Games and Playable Experience Design at Goldsmiths, Univesity of London.

---

# Week 01 -- Labyrinth
During the past few weeks I have been working on a small game idea. It started as a demonstration of a 2.5D ray-tracing technique, in the style of Wolfenstein 3D. It runs at a low resolution, and uses very small textures.

<video src="files/labyrinth_demo.mp4" poster="files/labyrinth_demo_snap.jpg" controls loop>
    A short video of the ray-tracing demo.
    Unfortunately, your browser does not support the video tag.
</video>

The goal is very simple - find your way through a labyrinth. The twist is that players can draw on the walls, and their drawings are shared via a server, so players can see each others drawings. I intend to make the labyrinth confusing and complex, so my intention for this mechanic is to allow players to help each other asynchronously -- leaving notes and markings for each other, returning to the game over time, and progressing together to move deeper into the labyrinth, and to find the exit. I chose drawing on walls over something like placing simple markers as I feel it allows for more player expression.

There are still some technical challenges involved in this that I have yet to solve. Most prominent is transferring the data for the wall drawings. Walls have 32x32 textures. If I were to store each pixel as one *bit*, one wall would require 128 *bytes* of storage to hold all the drawing data. If I were to limit the size of one level of the labyrinth to 16x16 tiles, then I would need a maximum of 32 Megabytes (16 x 16 x 128) to hold all of the drawing data; I would also prefer to have larger levels than this. This is too much data to be transferring often -- It may take several minutes to download on slower connections. Thus I will need to construct a *streaming* technique that will load in drawing textures as needed, and storing them for later to avoid repeat downloads.

Given my more technical background, I am trying to force myself into situations where I do less programming and more game design. I think this project is a case of the opposite, and so I may put it on hold for a little while, and come back to it when I feel like a technical challenge.

#### This Week's Thoughts
+ The combination of fascination, surprise and grossness that you get when you lift up a rock and find a thousand creepy crawlies.
    - Randomly generated insects (maybe Genetic Algorithm)?
    - Bug Hunt, a-la Animal Crossing?
    - What does it feel like to walk around when you have a hundred legs?
+ Tiny version of SimCity, but its about growing vegetables.
    - Run hose-lines and sprinklers for watering.
    - Manage soil statistics.
    - Harvest, plant, and sell crops.

---

# Week 02 -- Fortune
A few years ago I went to Oxford for a *hackathon*. The event was well catered, and at some point during the late evening fortune cookies were given out. My fortune read "Relax and enjoy yourself."; something I took to heart during the event (I didn't end up submitting anything). I've been carrying this little fortune with me in my wallet ever since.

![Photo of my fortune.](files/relax_fortune.jpg)

This little piece of paper represents many things for me about that time. I met many people that certainly changed the course of my life. For many of us, our time at university is one we will remember fondly, and I enjoy carrying something with me that reminds me so clearly; like a snapshot of that time.

I would like to produce an installation piece that prints tiny personalised artworks for guests to keep. Perhaps in the style of a fortune cookie, but I would like to explore this further. This could be achieved using a Thermal Printer (like those used for receipts in cash machines), and some natural language generation for the text content. Perhaps some images could be generated also.

In other news, I have been thoroughly enjoying Physical Computing. When I was a child, my grandfather taught me lots of things about electronics -- how circuits work, how to read resistors, and plenty more. I had not used this knowledge for almost 10 years, but it has come back to me in a surprising way. My grandpa passed away this year; I would love to show him what I have been doing, and thank him for inspiring my love of technology.

#### This Week's Thoughts
+ Using crappy computer generated voices to act out an interactive play about robots.
+ Emoji Ouija board.