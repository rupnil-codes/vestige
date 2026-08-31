<!--
 Copyright (C) 2026 Rupnil Codes
 
 This file is part of vestige.
 
 Vestige is free software: you can redistribute it and/or modify
 it under the terms of the AGPL-3.0 License.
-->

<h1 align="center">
vestige
</h1>
<h4 align="center">
    <a 
        href=""
        target="_blank" 
    >
        <b>🡽 Play Now! 🡽</b>
    </a>
</h4>

<p align="center">
  <img src="https://raw.githubusercontent.com/rupnil-codes/vestige/refs/heads/main/banner.png" width="100%" style="max-width: 400px;" alt="Override.exe">
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Godot%20Engine-%5E4.7.0-blue?style=for-the-badge&logo=godotengine&logoColor=white" alt="Godot Engine %5E4.7.0">
    <img src="https://img.shields.io/github/license/rupnil-codes/vestige?style=for-the-badge" alt="GNU AGPL 3.0">
    <img src="https://hackatime-badge.hackclub.com/U0A4UTULSLE/vestige?style=for-the-badge" alt="Hackatime Badge">
    <img src="https://img.shields.io/github/commit-activity/w/rupnil-codes/vestige?style=for-the-badge" alt="Commit Activity">
    <img src="https://img.shields.io/github/last-commit/rupnil-codes/vestige?style=for-the-badge" alt="Commit History">
</p>

<h3 align="center">
    Explore a mysterious forest with something that ceases to exist.
</h3>

---

## Table of Contents
* [Overview](#overview)
* [Backstory](#backstory)
    * [About me](#about-me)
    * [About the Game](#about-the-game)
* [Requirements](#requirements)
* [Playing: Quick Start](#playing-quick-start)
    * [Pre-compiled](#pre-compiled)
    * [Building from Source](#building-from-source)
* [Features](#features)
  * [Unfinished Features](#unfinished-features)
* [What I learnt](#what-i-learnt)
* [Project Status](#project-status)
* [Contributors](#contributors)
* [Versioning](#versioning)
* [License](LICENSE)

---

## Overview

**Vestige** is a psychological and atmospherical horror game with a retro low-poly PSX style game made in Godot engine.
The word "vestige" refers to a trace of something; according to google its "a small part of something that is left after the rest of it has gone".
I do not want to elaborate further on the correlation between a vestige (trace) and the vestige (game) but its about a faint memory of something you are trying to forget.

The game itself is pretty straight-forward and its mostly story driven, there are barely any player interactions but thats the point.
It has three main parts -- the ground, the watchtower and the bunker.

---

## Backstory

> You wake up in the middle of the woods, no memories of past experiences or life... Or is it?
> There's no one else in the forest other than you. Right?
> Is it all your imagination? or is there something, that someone or something is trying to tell you

### About me:

I've worked on webapps, backends and frontends but never quite on games yk and it has been my _dream_ to learn game dev and make a game that I'd call mine.
This has been my goal for a long time and I initially waited for stardance to start working on this game, did just that.
However, after a month I got to know about Macondo and it was a no-brainer to not switch, and here i am! shipping to macondo.
Macondo gave me the motivation I needed to start working on the game and actually finish it!

### About the Game:

When I started working on Vestige on June 1, I remember not knowing how to use godot, blender or any gamedev related stuff.
I swear I didnt even know what to do! I have to extend my gratitude towards @seb for getting me started on this.

During the first days of vestige the idea I had about this game was VERY different than it is today.
And I think thats a good thing, ideas are meant to evolve, grow and transform into something you didnt think of before!

> The game is not meant to tell you what its about, it's your task to figure it out!

---

## Requirements

- A Windows, Linux or macOS machine,
- At least 8gb ram, No fancy GPU needed,
- ~200mb of storage (or whatever the binary is),
- A keyboard and a mouse,
- Headphones for better experience, &
- Curiosity and sheer will.

---

## Playing: Quick Start

### Pre-compiled

A full release of Vestige for all platforms can be found in the GitHub Release: [GitHub Release](https://github.com/rupnil-codes/vestige/releases/latest).
I've included all the major OS-es and their architectures so yeah! shouldn't be too difficult to find the one right for you.

### Building from Source

Building from source requires you to have the following two things installed:
- Godot Engine 4.7
- Blender

#### 1. Clone the repository
```bash
git clone https://github.com/rupnil-codes/vestige.git
cd vestige
```
#### 2. Open Godot
```godotproject
Open Godot Engine in the same folder
```
#### 3. Run Development Instance
```godotproject
Run Project (Top Right) or by pressing F5
```
#### 4. Compile for Production
I have pre configured all the major OS-es! So you need not worry.
```godotproject
Project -> Export -> Choose OS
```

Then the final compiled webapp will be in the `bin/` directory. If you don't change anything.

---

## Features

I wanted to do WAYY more than I could manage in this short amount of time aha. 
Its not particularly short, but its short enough because I wanted to make ALL the assets by myself.
THis was a kind of self-imposed challenge But i managed to keep the art time under 30%!
I remember counting it before and it came out below 30% and im NOT gonna do that again yo.

Anyways, here are some of the notable features, that I think are worth mentioning:

- A start menu with a sleek animation.
- Realistic walking and climbing mechanics with sounds.
- Insane Shader.
- Atmospheric overhaul and ambience.
- Natural forest.
- Elements of eeriness and spooks.
- Hand made, organically grown models and assets.
- Great Sound Effects.
- Deep lore.

### Unfinished features:

- More stuff in the Bunker.
- A proper pause menu.
- Settings.
- Optimizations.
- Easter Eggs.
- More lore.
- Much more.

> There are a TON of stuff that I did / did not do, most of them are documented in `TODO.md`

---

## What I learnt

I think this project deserves a seat at my top 2 projects YET! I've learnt as much as I've learnt while getting into webdev.

### Technical Skills
- **Godot Engine:** Before starting this project I only knew about unity and unreal engine. I had tried making a game in unity before, but I completely followed a tutorial.
                    This project taught me how to use Godot and I'd say I learnt a lot! from animations, to textures, shaders, meshes, players, so much!
- **GDScript:** GDScript is the scripting language used to code in Godot, I also leant it while making this game, its like python but i loved it!

### Problem Solving
- Managing a huge codebase
- Synchronizing so many Different components
- Properly UV Unwrapping models
- Animating in Godot

### Personal Note:
<p>
Yeah so the format of this readme is made by me obv, its from another project, Override.exe.
Although I reused the template each and every part has been rewritten from the ground up. 
Anyways, I cant believe I am shipping another project! This is so fun. Thank you Hackclub!
</p>

---

## Project Status

<p><b>Version:</b> v1.1.1-release</p>
<p><b>Latest Release Version:</b> v1.1.0-release</p> 
<p><b>Status:</b> Finishing up</p>

---

## Contributors

There are several well-wishers and playtesters who have helped me improve the app,
either by playtesting or providing valuable feedback. I've listed them in no particular order.

1. [@seb](https://github.com/sebashtioon),
2. [@Flux3tor](https://github.com/Flux3tor),
3. [@Snxhit_](https://github.com/Snxhit),
4. [@Carlson](https://github.com/dinosaur890123),
5. [@Kuzu](https://github.com/KuzuiYaridomi),

> If i forgot to mention anyone, pls DM me on slack!

---

## Versioning

lets consider vX.Y.Z(M)-[stage].
Here the X is the major release
Y is the minor versions of a release
and Z is the tiniest bugs / readme changes and narratives
(M) is the appends to the Z

[stage] refers to... well stage of development.
I have 4 stages of development:
1. Pre-alpha: No prototype `v0.0.Z(M)-pre-alpha`
2. Alpha: One two scenes some assets `v0.Y.Z(M)-alpha` **usually** Y is less than 10.
3. Beta: Completed scenes / chapters ready for bug testing `v0.Y.Z(M)-beta`
4. Release: Bug tests passed fixed one two stuff - polishes `vX.Y.Z(M)-release`

---

<h4 align="center">
    Made with 💖 by @Rupnil
</h4>
<p align="center">
    If you found this project interesting, consider giving it a star :D
</p>
<p align="center">
    <a href="https://github.com/rupnil-codes/vestige/issues">Report a Bug</a> or <a href="https://github.com/rupnil-codes/vestige/issues">Suggest a new Feature</a>
</p>
