#make the option to show moves and hide them

require_relative './lib/board'
require_relative './lib/player'

board = Chessboard.new
board.build_empty_board
board.set_board_pieces
player_one = Player.new
player_one.select_color
player_two = Player.new
player_two.color = player_one.color == :white ? :black : :white

players = [player_one, player_two]
board.to_s

loop do
  players.first.turn(board)
  board.to_s
  break if board.checkmate? || board.stalemate?
  players.reverse!
end


puts "You won"