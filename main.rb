require_relative './lib/board'
require_relative './lib/player'

board = Chessboard.new
board.build_empty_board
board.set_board_pieces
player = Player.new
player.select_color

board.to_s

loop do
  player.turn(board)

  board.to_s
end