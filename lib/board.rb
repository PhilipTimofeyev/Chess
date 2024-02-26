require_relative 'pieces'

class Chessboard
  #change lower upper bound to arr (rows/numbers)
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
    # set_pawns
    set_rooks
    set_bishops
    set_knights
    set_queens
    set_kings
  end

  def set_pawns
    white_pawn_squares = squares.select { |square| square.match?(/2/) }
    white_pawn_squares.each_key { |square| squares[square] = Pawn.new(square, :white) }

    black_pawn_squares = squares.select { |square| square.match?(/7/) }
    black_pawn_squares.each_key { |square| squares[square] = Pawn.new(square, :black) }
  end

  def set_rooks
    squares[:A1] = Rook.new(:A1, :white)
    squares[:H1] = Rook.new(:H1, :white)

    squares[:A8] = Rook.new(:A8, :black)
    squares[:H8] = Rook.new(:H8, :black)
  end

  def set_bishops
    squares[:B1] = Bishop.new(:B1, :white)
    squares[:G1] = Bishop.new(:G1, :white)

    squares[:B8] = Bishop.new(:B8, :black)
    squares[:G8] = Bishop.new(:G8, :black)
  end

  def set_knights
    squares[:C1] = Knight.new(:C1, :white)
    squares[:F1] = Knight.new(:F1, :white)

    squares[:C8] = Knight.new(:C8, :black)
    squares[:F8] = Knight.new(:F8, :black)
  end

  def set_queens
    squares[:D1] = Queen.new(:D1, :white)
    squares[:D8] = Queen.new(:D8, :black)
  end

  def set_kings
    squares[:E1] = King.new(:E1, :white)
    squares[:E8] = King.new(:E8, :black)
  end

  def display_board
    row_count = UPPER_BOUND

    display_column_labels
    squares.values.reverse.each_slice(UPPER_BOUND + 1) do |row|
      puts "#{row_count + 1}|#{row.reverse.map { |square| square }
      .join('|')}|#{row_count + 1}"
      row_count -= 1
    end
    display_column_labels
  end

  def to_s
    clear
    display_board
  end

  def display_column_labels
    puts "  #{LETTERS.map(&:to_s).join(' ')}"
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
    squares[current_sq] = Empty.new
    squares[new_sq] = piece
    squares[new_sq].update_position(new_sq)
  end

  def clear
    Gem.win_platform? ? (system 'cls') : (system 'clear')
  end

  def check?(square, piece)
    opponent_color = piece.color == :black ? :white : :black

    orig_square = piece.current_square

    board_state = squares.clone

    opponent_pieces = squares.values.select {|square| square.color == opponent_color }

    move_piece(piece.current_square, square)

    result = opponent_pieces.any? do |piece|
      piece.validated_moveset(self).include?(square)
    end

    self.squares = board_state
    move_piece(orig_square, orig_square)

    result
  end
end

