# HxRL
Haxe roguelike library.

This project aims to provide a high-level, framework-agnostic, cross-platform library for writing roguelikes in Haxe.

## What is this?
A library for writing roguelikes. Currently, the project mostly consists mainly of a ASCII/tile renderer and data structures for world loading and UI.

Planned features include:

- Haxe implementation of common world generation and FoV algorithms.
- Saving and serialization routines.
- Loading tile and entity definitions from file.
- Pathfinding.
- Turn scheduling and logging helper functions.

## How do I use this?
At the moment, there aren't any docs or example code. These are coming Soon™, once the API is relatively finalized. 

## Backend
The longterm goal is to provide a library with minimal dependency on a particular rendering framework. This is because particular Haxe frameworks have different strengths and weaknesses. This is possible because roguelike/ASCII rendering is a relatively simple problem.

The library currently employs OpenFL (specifically, the Flash target) as a rendering backend. By modifying the Panel.hx class, this dependency can be substituted for another framework - Luxe or heaps, for example. Something like [this project](https://github.com/mattj1/luxe_ascii) could work for that purpose.

## Contributing?
Feel free to make a pull request or file an issue.

___
The code is MIT-licensed. See LICENSE.txt.
