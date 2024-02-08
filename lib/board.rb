

class Square
  EMPTY_SQUARE = '_'

  attr_accessor :chess_piece
  attr_reader :coordinate

  def initialize
    @chess_piece = EMPTY_SQUARE
  end
end

class Chessboard
  LOWER_BOUND = 0
  UPPER_BOUND = 7
  LETTERS = %w(A B C D E F G H)

  attr_accessor :board

  def initialize
    @board = {}
  end

  def build_board
    (LOWER_BOUND + 1..UPPER_BOUND + 1).each do |row|
      LETTERS.each do |column|
        board[(column.to_s + row.to_s).to_sym] = Square.new
      end
    end
  end

  def display_board
    row_count = UPPER_BOUND

    board.values.reverse.each_slice(UPPER_BOUND + 1) do |row| 
      puts "#{row_count + 1}|#{row.reverse.map{|square| square.chess_piece}.join("|")}|" 
      row_count -= 1
    end

    label_columns
  end

  def label_columns
    puts "  " + LETTERS.map{|n| n.to_s}.join(" ")
  end
end

