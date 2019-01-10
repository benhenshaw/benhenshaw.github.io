<!-- Created: 2018-10-15 -->
# MA Game Design Journal
> Approaches to Play\
> MA Independent Games and Playable Experience Design\
> Benedict Henshaw\
> 2018 -- 2019

This is a weekly journal kept during my MA in Independent Games and Playable Experience Design at Goldsmiths, Univesity of London.

#### Contents
+ [Week 01 --- Labyrinth](#week-01-labyrinth)
+ [Week 02 --- Fortune](#week-02-fortune)
+ [Week 03 --- Falling Blocks](#week-03-falling-blocks)
+ [Week 04 --- Magic Circle](#week-04-magic-circle)
+ [The Implications of Virtual World Design](#the-implications-of-virtual-world-design)
+ [Stylised Graphics in Video Games](#stylised-graphics-in-video-games)

---

# Week 01 --- Labyrinth
During the past few weeks I have been working on a small game idea. It started as a demonstration of a 2.5D ray-tracing technique, in the style of Wolfenstein 3D. It runs at a low resolution, and uses very small textures.

<figure>
<video src="files/labyrinth_demo.mp4" poster="files/labyrinth_demo_snap.jpg" controls loop>
    A short video of the ray-tracing demo.
    Unfortunately, your browser does not support the video tag.
</video>
</figure>

The goal is very simple - find your way through a labyrinth. The twist is that players can draw on the walls, and their drawings are shared via a server, so players can see each others drawings. I intend to make the labyrinth confusing and complex, so my intention for this mechanic is to allow players to help each other asynchronously --- leaving notes and markings for each other, returning to the game over time, and progressing together to move deeper into the labyrinth, and to find the exit. I chose drawing on walls over something like placing simple markers as I feel it allows for more player expression.

There are still some technical challenges involved in this that I have yet to solve. Most prominent is transferring the data for the wall drawings. Walls have 32x32 textures. If I were to store each pixel as one *bit*, one wall would require 128 *bytes* of storage to hold all the drawing data. If I were to limit the size of one level of the labyrinth to 16x16 tiles, then I would need a maximum of 32 Megabytes (16 x 16 x 128) to hold all of the drawing data; I would also prefer to have larger levels than this. This is too much data to be transferring often --- It may take several minutes to download on slower connections. Thus I will need to construct a *streaming* technique that will load in drawing textures as needed, and storing them for later to avoid repeat downloads.

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

# Week 02 --- Fortune
A few years ago I went to Oxford for a *hackathon*. The event was well catered, and at some point during the late evening fortune cookies were given out. My fortune read "Relax and enjoy yourself."; something I took to heart during the event (I didn't end up submitting anything). I've been carrying this little fortune with me in my wallet ever since.

![Photo of my fortune.](files/relax_fortune.jpg)

This little piece of paper represents many things for me about that time. I met many people that certainly changed the course of my life. For many of us, our time at university is one we will remember fondly, and I enjoy carrying something with me that reminds me so clearly; like a snapshot of that time.

I would like to produce an installation piece that prints tiny personalised artworks for guests to keep. Perhaps in the style of a fortune cookie, but I would like to explore this further. This could be achieved using a Thermal Printer (like those used for receipts in cash machines), and some natural language generation for the text content. Perhaps some images could be generated also.

In other news, I have been thoroughly enjoying Physical Computing. When I was a child, my grandfather taught me lots of things about electronics --- how circuits work, how to read resistors, and plenty more. I had not used this knowledge for almost 10 years, but it has come back to me in a surprising way. My grandpa passed away this year; I would love to show him what I have been doing, and thank him for inspiring my love of technology.

#### This Week's Thoughts
+ Using crappy computer generated voices to act out an interactive play about robots.
+ Emoji Ouija board.

---

# Week 03 --- Falling Blocks
I am a big fan of falling block games, such as [Tetris](https://en.wikipedia.org/wiki/Tetris), [Puyo Puyo](https://en.wikipedia.org/wiki/Puyo_Puyo), and [Dr. Mario](https://en.wikipedia.org/wiki/Dr._Mario). Lately, I have been playing quite a lot of Dr. Mario, which I enjoy in particular for the way that the blocks are structured, and how that affects the way they fall. The strategies one must employ to succeed in Dr. Mario have little in common with Tetris --- so it feels fresh to me as a Tetris addict.

![Dr. Mario for NES (1990)](files/dr_mario.gif)

Another aspect of these games that appeals to me is that one can look at any individual frame of the game and they can know how well the player is doing with only a basic understanding of the rules of the game. How high is the highest block? The answer to that question gives an indication of how long the play session has lasted, and how 'in trouble' the player is. In Tetris, a player with a slightly better understanding of the strategies employed in the game might notice that a player is attempting to leave space for a long piece, in order to get a four-row combo.

In Dr. Mario, one needs to be aware that blocks are *cleared* when four or more colours are matched horizontally or vertically. Thus, the arrangement of colours is very important (unlike Tetris), and so the questions one can pose to understand the state of the game are different. In my experience, it is harder to quickly scan for the arrangement of colours on screen, as opposed to only the arrangement of positive and negative space that needs to be understood in Tetris, and so I find the game more difficult, as my real-time decisions feel less informed.

Does this property of 'instant readability' exist outside of puzzle games? Maybe it has more to do with whether the game has a camera that selectively shows the state of the world, or how abstract the presentation of the game is --- non-puzzle games can have these properties too.

#### Prototyping

Inspired by these games, I put together the framework for a falling block game. The first demo just randomly drops blocks every *tick*, and deletes any row if it is filled, like Tetris --- it makes for quite a nice screen-saver!

<figure>
<video src="files/falling_blocks.mp4" poster="files/falling_blocks_snap.jpg" width="40%" controls loop>
    The first demo of the falling block game.
    Unfortunately, your browser does not support the video tag.
</video>
</figure>

If I have time next week, I will try to add some game-play and make something more interesting with this.

#### This Week's Thoughts
+ I have enjoyed teaching programming for the last few years, but I have noticed that I remember less and less what it is like to learn for the first time --- In some ways I think this will make me a less effective introductory teacher. I hope I can make up for this by planning my lessons more carefully, and taking in feedback.
+ I can't wait for Katamari Damacy to come out on Nintendo Switch and PC later this year --- it's my favourite game of all time, but I've only played it emulated.

---

# Week 04 --- Magic Circle
I have been thinking a lot about the magic circle as it applies to many situations in life. One such application struck me as worth investigating --- "Magic". A magician uses the magic circle to their benefit in several ways.

Firstly, they form a strong circle with the viewers by carefully giving them pieces of information ("This is a full deck of cards, take a look!") and on-boarding them so that each viewer is sure of their understanding of the situation, and places some trust in that understanding. This is something that video games also do when a player first starts playing --- giving the player cues to reinforce their understanding of the situation (can't walk through walls, other characters look at you as you walk passed confirming your existence to them, etc.).

Once this initial bond is formed, and the viewers are inside the circle, the magician will begin to perform an act. Given the set-up, viewers will have an expectation of the outcome. Their mental model of the situation will form its own prediction.

This is where the magician does their 'magic'. A magician does not need to perform something truly impossible, only something that reaches outside the viewer's mental model of the situation. In games, this could be compared to someone cheating at Monopoly by stealing extra money --- but not getting caught. One player has stepped outside the magic circle, but the other players are unaware. Some video games do this with NPCs, giving them extra resources behind the scenes (such as more units in an RTS) to make them more difficult to compete against. If the other players are made aware then the circle is broken, as players will need to resolve a problem that exists outside the game rules.

I think there are some interesting takeaways from this for games. The way in which a magician explicitly designs the steps that they will take to form the magic circle is something games can also do to improve the experience of a player who has just started playing.

#### This Week's Thoughts
+ [Dan-Ball](https://dan-ball.jp/en/) is a website full of weird and interesting games, and it has been around for a long time. [Powder game](https://dan-ball.jp/en/javagame/dust2/) is my favourite, and [this weird plant simulator](https://dan-ball.jp/en/javagame/aquarium/) is also cool.

---

The remainder of this journal does not follow a weekly schedule. Given that some weeks had more relevant happenings than others, and that I took some time off, I have decided to move to topic-based posts instead of weekly.

---

## The Implications of Virtual World Design
I have always been fascinated by [Massively Multi-player On-line Games](https://en.wikipedia.org/wiki/Massively_multiplayer_online_game). Since my earliest exposure to on-line games, I have craved the experience of shared persistent virtual spaces. As far as my memory is concerned, the first MMO I played was [RuneScape](https://en.wikipedia.org/wiki/Old_School_RuneScape). This game is unbelievably [grind-y](https://en.wikipedia.org/wiki/Grinding_%28gaming%29). It differs from many Role-Playing Games, as it has no classes or races.

![Screen-shot of **Old School RuneScape**, a recent official re-release of RuneScape 2 (2007).](files/runescape_stats.png)

In RuneScape, players have a large set of skills each of which starts at level 1, and can be increased to level 99. These skills have various impacts on the player's capabilities in the game. High stats in *Strength* and *Attack* make a player effective at *mêlée* combat. Some stats, such as *Woodcutting* and *Fishing* allow players to collect resources from the game world.

This freedom to create your own play-style in a free-form way has not been picked up by RPGs at large, though it solves one of their major common issues: when a player starts an RPG, they are usually presented with detailed and game-changing choices, and don't have a clue what any of them will mean for their experience.

![Fallout 4 (2015) presents new players with complex statistical decisions, while they likely have no idea what game-play impacts those choices will have.](files/fallout4_stat_selection.jpg)

This progress structure has implications for the message of the game. MMORPGs that enforce game-play constraints on players who have selected a particular race or class at the start of the game may be making unintentional statements about segregation and real-world class hierarchies. World of Warcraft (2004) allows players to choose certain races, but the game has no concept of mixed races. In a small but very real way Blizzard have put forward the idea that races do not, or should not, mix. Additionally, WoW suggests that a player's background decides the extent of what they can ever achieve.

> **"One cannot not communicate."**\
> --- *[Paul Watzlawick](https://en.wikipedia.org/wiki/Paul_Watzlawick#Five_basic_axioms)'s first axiom of communication*

In his [2010 GDC talk](https://gdcvault.com/play/1013804/MUD-Messrs-Bartle-and-Trubshaw), Richard Bartle outlines his design decisions for [MUD (1978)](https://en.wikipedia.org/wiki/MUD1), which is often considered the *first MMO*. MUD has 10 levels; all players start at level 1 and progress to level 10, with each step taking significant effort and often requiring assistance from other players. His rationale for this progression system stems from his own oppression in the British class system, being a northern lad with a strong accent. He created a world with no pre-existing class system, to give all players the freedom to succeed with equal footing, and also suggests that people should, and *must*, help each other to reach their goals.

![The character creator in World of Warcraft (2004) forces players to choose their race, class to begin playing the game.](files/wow_character_creator.jpg)

Though many modern MMOs stem from MUD, incorporating its level-based progress structure, I am hard pressed to find a single example that demonstrates some consideration for the meaning of this decision. In WoW, Guild Wars, and many others, the process of levelling up feels like a vestigial limb, a holdover from some old video game DNA that nobody wants to amputate. Players of these games use the term **Endgame** to describe activities to be done once the player has reached the maximum level, though in contrast most players believe this point to be where the game truly begins. Why not start the game here?

To me, the pre-endgame phase of World of Warcraft feels like adolescence. It's an awkward phase, where most players don't truly fit in, just going through the motions, waiting for the moment that they can begin to play with the adults. When I first played WoW I never felt the desire to level up. I stayed in the early teens for a very long time (months!), while most players continued on to higher and higher levels. I was about 12 years old at the time --- perhaps this is a reflection of my own subtle desire to never grow up.

---

<!-- # We Don't Know What Video Games Are **TODO**
Humans have been attempting to record their experiences for millennia. We painted walls with impressions of our surroundings; of the things we encountered; of ourselves. Nobody would tell these ancient people that they shouldn't have done this --- we seem to be unilaterally thankful for this peek into their lives, which greatly betters our understanding of the past and of ourselves.

Nowadays, we continue to capture our thoughts and feelings in paint and sounds. But there is a disagreement about the value of such activities. I have yet to meet someone who doesn't indulge in the consumption or creation of an artistic medium. But our social systems, our schools, and often our parents don't seem to think its worthwhile. [STEM](https://en.wikipedia.org/wiki/Science,_technology,_engineering,_and_mathematics) is touted as the king of human activity, while arts are the ineffectual queen. But who wants to live in a world without art?

As we continue our descent into the digital age, some of our long beloved mediums are making the leap to binary. Books became [Hypertext](https://en.wikipedia.org/wiki/Hypertext); musical performances became records which became .mp3 files; Theatre to film to on-line streaming video. But each of these hand-overs diverge from the original --- some are considered a poor approximation, others became wholly new, carrying a different message. In most cases, the original is still alive and well; sometimes as an act of protest against the virtual as with modern Vinyl records.

![Taking the Evening Cool by Ryōgoku Bridge (1745) --- Okumura Masanobu](files/taking_the_evening_cool_by_ryogoku_bridge.jpg)

Games pre-date living memory, but do modern video games attempt to approximate their analogue ancestors? There are early examples of digitising sports with [Pong (1972)](https://en.wikipedia.org/wiki/Pong) and the [slew](https://en.wikipedia.org/wiki/Tennis_(1984_video_game)) [of](https://en.wikipedia.org/wiki/Volleyball_(video_game)) [sports](https://en.wikipedia.org/wiki/Soccer_(1985_video_game)) [games](https://en.wikipedia.org/wiki/NES_Open_Tournament_Golf) for the [Nintendo Entertainment System](https://en.wikipedia.org/wiki/Nintendo_Entertainment_System), and one can find a version of Chess and Solitaire on any given computing platform. As video games moved beyond this the focus changed. Some designers began to embrace the unique properties of the medium, and produced works that did not imitate, and could not be recreated by other mediums. This trend has not defined the medium, as one might expect. We have not yet entered a future where all games embrace their medium.

Video games' current trends are rooted in Capitalism, both in their content and their production. 'Proven' ideas are copied in attempts to replicate past profit. Video game retailers perpetuate a hysteria of endless sales and discounts. The games themselves encourage players to collect items and purchase objects, many of which have no discernible capabilities other than to be owned.

What are video games in the modern world? Some consider them frivolous. Others hold them up as the most powerful medium with the most **potential** for social change.
 -->

## Stylised Graphics in Video Games
In the mid 90s we passed a milestone in computing; real-time 3D games became a possibility. Since then, a subset of video games have been attempting to create photorealistic graphics. Companies like [id Software](https://en.wikipedia.org/wiki/Id_Software), [Infinity Ward](https://www.infinityward.com/), and [Naughty Dog](https://en.wikipedia.org/wiki/Naughty_Dog) have been making increasingly complex attempts at modelling the real world.

Originally, these attempts were hampered by lack of processing power. As computers increased in complexity and capability, developer's techniques had to improve as well. For a time, many games embraced their low polygon counts and simple lighting, producing more cartoon-ish styles. Many of these games hold up fairly well, but those that attempted photorealism at the time look like hot garbage --- though this look has more recently come back into fashion ([Paratropic](https://arbitrarymetric.itch.io/paratopic), [Devil Daggers](http://devildaggers.com/), [Sokpop](https://sokpop.itch.io/)).

![Quake (1996), Virtua Fighter (1993), \
King's Quest: Mask of Eternity (1998), Tekken (1995)](files/90s_3d.jpg)

In [John Carmack's 2013 QuakeCon talk](https://www.youtube.com/watch?v=P6UKhR0T6cs), he notes that as an industry we have moved beyond being limited by processing power or programming ability, and that the most important problem we are now faced with is cataloguing and better understanding the characteristics of the various materials we use in our virtual worlds. In the name of photorealism we have developed powerful graphics hardware and vastly more complex rendering systems; we're now *capable* of producing incredibly detailed and (arguably) believable worlds; but to what end?

Many of my favourite games have distinctly unrealistic visual styles. Games like [Kentucky Route Zero](http://kentuckyroutezero.com/), [Katamari Damacy](https://en.wikipedia.org/wiki/Katamari_Damacy), and [Rock of Ages](https://en.wikipedia.org/wiki/Rock_of_Ages_%28video_game%29), take a drastically different approach to visual style. Many of these projects are produced by small teams with low budgets or time constraints, but have embraced their limitations to produce works of beauty.

![Rock of Ages uses cut-outs from famous paintings for **all** of the games characters. 3D-modelling hundreds of characters would not have been feasible for this production.](files/rockofages.jpg)

The costs of production for photorealism at the standards made possible by modern graphics hardware and techniques is immense. As independent developers, we cannot compete on this front; but honestly, who wants to? The short but dense history of video games has taught us that only games that choose style over realism will continue to look timelessly great.

There are many techniques used to achieve this, but I think the key to finding your style is to consider your limitations and to be selective about what you put into the game. Don't try to include a poor attempt at high fidelity, just do a great job at low-fi! Break the rules: use 2D puppets in a 3D game (Rock of Ages), or render pixel-thin lines and untextured polygons (Kentucky Route Zero) --- whatever works.

![Katamari Damacy (2004), The Legend of Zelda: The Wind Waker (2003),\
Super Mario Sunshine (2002), Ōkami (2006)](files/nice_looking_older_3d_games.jpg)
