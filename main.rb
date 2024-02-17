require_relative './lib/board'
require_relative './lib/player'

board = Chessboard.new
board.build_empty_board
board.set_board_pieces
player_one = Player.new
player_one.select_color
player_two = Player.new
player_two.color = player_one.color == :white ? :black : :white

board.to_s

loop do
  
  player_one.turn(board)
  board.to_s
  player_two.turn(board)
  board.to_s
end