# Chess

Chess is the final project of the The Odin Project's Ruby course build using Ruby and tested using rspec.. It is meant to replicate the age old strategy game that people have been playing through the centuries using the Ruby language in a CLI.

It is composed of four main files:

- board.rb, which contains the structure of the board as well as the rules of the game such as checking and checkmating.
- pieces.rb, which contains all of their pieces and their movesets.
- player.rb, containing the player class allowing the players to make moves.
- main.rb, which is the game itself containing the game loop, ability to save, and menu.

When building the game, I used a methodology that worked well for me. I would break down the game into smaller pieces,  and write a plan on how to tackle a piece. Then I would code the plan, build the tests, refactor the code, and test again. This allowed me to smoothly and modularly add and build on top of the game without worrying about other parts breaking without me being aware of it.

When designing the board, I wanted the ability to select and move pieces to be as smooth and simple as possible. In an earlier project using a chessboard I designed it using coordinates from arrays within arrays. Where you select a square by a number coordinate representing the column and then another number coordinate representing the row, ie. `[0][1]` which would represent square `A2`. I found this system to be overly complicated to work with. To create a simpler system, I used the notation chess players use when moving squares, which is the letter (the file) and the number (the rank), ie. `A2`. By using a hash map with the square as the key, and the piece as the value, it made finding and modifying squares incredibly simple and allowed me to focus on the more challenging parts of the game.

The game functions by presenting a chessboard with the pieces layed out. The player playing as white goes first and makes a selection of a piece. Each piece has a validated moveset which returns all of the squares it is legally allowed to move. If the player selects a square that is not validated, a warning will appear and give the player all of the squares allowed. If the player changes their mind about using that piece, they can enter `1` and select a different piece. 

At any point in the game, either player can can enter `m` and return to the menu. In the menu, a player can request a new game, save the game, load an older game, continue the current game, or quit altogether.

After every turn, the game checks for a checkmate or stalemate. If it is either, the game ends and announces the winner or a draw. During a turn, the game checks if a king is in check or if the turn puts a king in check, and requires the player to select a different move. This was one of the more challenging aspects of building the game.

Although this was challening to build, it was very rewarding and helped me see how far I have come in my studies of the Ruby language. 

In future development, I would add a computer opponent capable of making decisions based on the board scenario. Such as capturing when it can and moving pieces into safe spots when they are at risk of being captured.

## Installation

Navigate to the `Chess` folder in the command line and run the script:

```bash
ruby main.rb
```

## License

[GNU](https://choosealicense.com/licenses/gpl-3.0/)
