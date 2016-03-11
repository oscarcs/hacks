# hacks
Haxe roguelike framework.

This project aims to provide a high-level, framework-agnostic, cross-platform framework for writing roguelikes in Haxe.

## What is this?
Currently, the project mostly consists mainly of an ASCII/tile renderer, data structures for world loading, tile loading, UI, seeded random, and color management.

Planned features include:

- Haxe implementation of common world generation and FoV algorithms.
- Saving and serialization routines.
- Loading entity definitions from file.
- Pathfinding.
- Turn scheduling and logging helper functions.

## How do I use this?
At the moment, there aren't any docs or example code. These are coming Soon™, once the API is relatively finalized. 

## Backend
The longterm goal is to provide a library with minimal dependency on a particular rendering framework.

The hacks.backends package provides different interfaces to Haxe rendering libraries. Only OpenFL is presently supported (specifically, the Flash target) as a rendering backend. This dependency could be substituted for another framework by implementing hacks.backends.IBackend - Luxe or heaps, for example. Something like [this project](https://github.com/mattj1/luxe_ascii) could work for that purpose.

## Contributing?
Feel free to make a pull request or file an issue.

___


The code is MIT-licensed. See LICENSE.txt.
