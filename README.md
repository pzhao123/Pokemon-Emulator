# Pokemon-Emulator

### By Peter Zhao and Benson Ma

## Overview

This is a simulator for the popular game Pokemon, where a player can train, catch, and battle Pokemon. Due to the complexity of adding Pokemon, there are only two species of Pokemon in this game: Pikachu and Charmander. The player starts out with a single Pokemon and builds up their own Pokemon arsenal by training and catching. Training Pokemon are necessary in order to defeat the gym leader at the end and earn a badge. The player can move around several maps, which consist of two towns and a route with grassy areas full of Pokemon.

## Implementation

Our code for this simulator can be divided into two main parts: one regulating the movement of the player across the maps, and one regulating the battle scene between Pokemon. For the movement of the player, we used two global variables, horizontal and vertical, to know where the player is in relation to how much distance the player has traveled from their starting point. This allows us to create a fluid interface where the world moves to simulate player movement until the player reaches the borders of the map, where the turtle will start moving on its own. This also allows us to put in constraints for where the player can move, so that the player will not walk into the trees and houses. For the battle scene, we implemented a turn-based algorithm using a global variable called playerTurn? to make sure that the player cannot make two moves at once and that the wild Pokemon will make their move right after the player’s turn.

## How to Use

Please first download this repository and load `POKEMON.nlogo`.

When you press setup, you will begin in Pallet Town, with a level 5 Pikachu. You can use the W, A, S, and D keys on your keyboard to move around the map. There are three maps in this world: Pallet Town, Route 1, and Sandgem Town. When you move into Route 1, there are patches of grass where you can find wild Pokemon. Here is where you can use the battle buttons on the bottom right part of the world to select what you want to do. You use Move 1 to use your basic attack, and Move 2, which unlocks at level 10, does even more damage. There is a run button, which allows you to escape from battle. Once you have lowered the wild Pokemon’s health low enough, you can catch it using the Pokeball button. You can only have up to two Pokemon at a time, and can switch between the two Pokemon using the switch button. Through battling and defeating other Pokemon, your Pokemon will gain experience and level up. The damage and health it has scales accordingly to its level. If your Pokemon are low on health, you can walk back to a town, which will restore your Pokemon back to full health. In Sandgem Town, there is a gym leader, Brawly, waiting for you. The objective of this game is to defeat him. He has a level 25 Pokemon, which has a large amount of health and attack. Since his Pokemon has such a high level, you must train your Pokemon in Route 1 and level them up in order to defeat him and earn your badge. Good luck!
