# Super Moonshot Adventure

![PIC 1](https://github.com/elennick/moonshotadv/blob/main/pics/title-black-bgrd.png)

## General
This game is my submission to the Github Gameoff 2020 gamejam: https://itch.io/jam/game-off-2020/rate/832614

Itch game page: https://elennick.itch.io/httpselennickitchiosuper-moonshot-adventure

YouTube playthrough by Bastion Top: https://www.youtube.com/watch?v=UcqN7U5xUXw&t=2990s

Super Moonshot Adventure was created using:
* LOVE2D 11.3 - https://love2d.org
* Various art assets from Itch.io - https://itch.io/game-assets/free
* Sound effects from Freesound.org - https://freesound.org
* Music by David Harris - https://david-harris.itch.io/ost-many-stars
* Title art by Kristian Correa.

## Libraries
SMA uses several libraries available for Love2D/Lua including:
* Love.js - https://github.com/Davidobot/love.js (build for the web)
* Middleclass - https://github.com/kikito/middleclass (provide OOP structure)
* Anim8 - https://github.com/kikito/anim8 (animations)
* Windfield - https://github.com/a327ex/windfield (physics)
* json.lua - https://github.com/rxi/json.lua (json serialization)
* love-release - https://github.com/MisterDA/love-release (generate executables)
* CPML - https://github.com/excessive/cpml (game math)

## Debug
There are debug commands available if you build with the `debug` option enabled. Currently it can only be enabled by setting the value to true in the code itself here: https://github.com/elennick/moonshotadv/blob/main/main.lua#L26

While this option is enabled, you can press ESCAPE to bring up the pause menu and press the following keys to toggle debug actions:
* V - sets the volume to 0
* R - restarts the current level
* N - skips to the next level
* Q - calls `love.event.quit()` and stops the game
* L - tries to load levels JSON from the system clipboard

## Building Levels
All levels in the game are loaded on startup from a JSON file located in the `levels/` directory: https://github.com/elennick/moonshotadv/blob/main/levels/levels.json.

This file can be modified or added to by updating the information and rebuilding and restarting the game. Additionally, levels can be loaded dynamically while the game is running using the L debug option.

## Makefile commands
This project has several targets to help run and build from the command line in Mac OSX (and possibly Linux). Most of these targets revolve around building and running the web version of the game. In order for most of these targets to function, several other commands will need to be available including `make`, `love`, `love-js` and `python`.
* `make local` = build and run game using local Love2D install
* `make web` = build using love.js and run in Chrome
* `make web-build` = build using love.js
* `make web-zip` = build using love.js and zip into deployment artifact
* `make web-clean` = delete the /build directory generated by love.js
* `make release-build` = generate windows and macos executables using love-release

## Screenshots
![PIC 2](https://github.com/elennick/moonshotadv/blob/main/pics/screenshot1.png)
![PIC 3](https://github.com/elennick/moonshotadv/blob/main/pics/screenshot2.png)
![PIC 4](https://github.com/elennick/moonshotadv/blob/main/pics/screenshot3.png)
![PIC 5](https://github.com/elennick/moonshotadv/blob/main/pics/screenshot4.png)
![PIC 6](https://github.com/elennick/moonshotadv/blob/main/pics/screenshot5.png)
![PIC 7](https://github.com/elennick/moonshotadv/blob/main/pics/screenshot6.png)
