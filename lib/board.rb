require_relative 'pieces'

class Chessboard
  EMPTY_SQUARE = '_'
  LOWER_BOUND = 0
  UPPER_BOUND = 7
  LETTERS = %w(A B C D E F G H)

  attr_accessor :squares

  def initialize
    @squares = {}
  end

  def build_empty_board
    (LOWER_BOUND + 1..UPPER_BOUND + 1).each do |row|
      LETTERS.each do |column|
        squares[(column.to_s + row.to_s).to_sym] = Empty.new
      end
    end
  end

  def set_board_pieces
    set_pawns
  end

  def set_pawns
    white_pawn_squares = squares.select {|square| square.match?(/2/)}
    white_pawn_squares.each_key {|square| squares[square] = Pawn.new(square, :white)}

    black_pawn_squares = squares.select {|square| square.match?(/7/)}
    black_pawn_squares.each_key {|square| squares[square] = Pawn.new(square, :black)}
  end

  def display_board
    row_count = UPPER_BOUND

    display_column_labels
    squares.values.reverse.each_slice(UPPER_BOUND + 1) do |row| 
      puts "#{row_count + 1}|#{row.reverse.map{|square| square}.join("|")}|#{row_count + 1}" 
      row_count -= 1
    end
    display_column_labels
  end

  def to_s
    display_board
  end

  def display_column_labels
    puts "  " + LETTERS.map{|n| n.to_s}.join(" ")
  end

  def within_bounds?(square)
    squares.keys.include?(square)
  end

  def []=(square, piece)
    @squares[square] = piece
    piece.update_position(square)
  end

  def [](square)
    @squares[square]
  end

  def move_piece(current_sq, new_sq)
    piece = squares[current_sq]
    squares[current_sq] = EMPTY_SQUARE
    squares[new_sq] = piece
    squares[new_sq].update_position(new_sq)
  end

end

# x = Chessboard.new
# x.build_empty_board
# x.set_board_pieces
# p x[:D2].validated_moveset(x.squares)
# x.to_s
