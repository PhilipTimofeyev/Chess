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
    squares[:C1] = Bishop.new(:C1, :white)
    squares[:F1] = Bishop.new(:F1, :white)

    squares[:C8] = Bishop.new(:C8, :black)
    squares[:F8] = Bishop.new(:F8, :black)
  end

  def set_knights
    squares[:B1] = Knight.new(:B1, :white)
    squares[:G1] = Knight.new(:G1, :white)

    squares[:B8] = Knight.new(:B8, :black)
    squares[:G8] = Knight.new(:G8, :black)
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
    puts ""
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
    squares[new_sq].increase_move_count
  end

  def clear
    Gem.win_platform? ? (system 'cls') : (system 'clear')
  end

  def opponent_pieces(piece)
    op_color = piece.color == :black ? :white : :black
    squares.values.select { |op_piece| op_piece.color == op_color }
  end

  def promote_pawn
    pawn = pawn_promotion?

    color = pawn.color
    square = pawn.current_square

    squares[square] = Queen.new(square, color)
  end

  def pawn_promotion?
    squares.values.select do |square|
      square.is_a?(Pawn) && square.current_square.match?(/1|8/)
    end.first
  end

  def find_king(color)
    squares.values.select do |chess_piece|
      chess_piece.is_a?(King) && chess_piece.color == color
    end.first
  end

  def queen_side_castling(current_sq, new_sq)
    switch_squares(current_sq, new_sq) if self[current_sq].is_a?(King) &&
                                          [:E1, :E8].include?(current_sq) &&
                                          [:A1, :A8].include?(new_sq) &&
                                          self[current_sq].queen_side_castle?(self)
  end

  def king_side_castling(current_sq, new_sq)
    switch_squares(current_sq, new_sq) if self[current_sq].is_a?(King) &&
                                          [:E1, :E8].include?(current_sq) &&
                                          [:H1, :H8].include?(new_sq) &&
                                          self[current_sq].king_side_castle?(self)
  end

  def switch_squares(current_sq, new_sq)
    piece_one = self[current_sq]
    piece_two = self[new_sq]

    self[new_sq] = piece_one
    self[current_sq] = piece_two

    self[new_sq].update_position(new_sq)
    self[current_sq].update_position(current_sq)

    self[new_sq].increase_move_count
    self[current_sq].increase_move_count
  end

  def check?(square, piece)
    king = find_king(piece.color)

    orig_square = piece.current_square
    board_state = squares.clone

    move_piece(piece.current_square, square)

    result = opponent_pieces(piece).any? do |op_piece|
      op_piece.validated_moveset(self).include?(king.current_square)
    end

    self.squares = board_state
    move_piece(orig_square, orig_square)
    2.times { piece.decrease_move_count }

    result
  end

  def king_in_check?(color)
    king = find_king(color)

    check?(king.current_square, king)
  end

  def checkmate?
    kings = squares.values.select { |piece| piece.is_a?(King) }

    result = kings.select do |king|
      moves = king.validated_moveset(self) << king.current_square
      next if moves.empty?
      moves.all? { |square| check?(square, king) }
    end

    result.empty? ? false : result.first
  end

  def stalemate?(color)
    pieces = squares.values.select { |piece| piece.color == color }

    no_valid = pieces.all? do |piece|
      piece.validated_moveset(self).all? { |move| check?(move, piece) }
    end

    no_valid && !king_in_check?(color)
  end
end

