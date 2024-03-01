require_relative '../lib/board'


describe Chessboard do
  subject(:board) {described_class.new}
  before {board.build_empty_board}

  describe 'building board' do

    it 'has 64 squares' do
      squares = board.squares
      num_of_squares = squares.count

      expect(num_of_squares).to be 64
    end

    it 'contains only empty squares' do
      squares = board.squares.values

      expected_color = :empty

      expect(squares.all? {|square| square.color == :empty}).to be true
    end

    it 'outputs column labels' do
      column_labels = "  A B C D E F G H\n"
      expect{board.display_column_labels}.to output(column_labels).to_stdout
    end
  end

  describe 'validating moves' do
    it 'in bounds' do
      within_board_boundary = :A4
      expect(board.within_bounds?(within_board_boundary)).to be true
    end

    it 'out of bounds letter' do
      out_of_board_boundary = :Q1
      expect(board.within_bounds?(out_of_board_boundary)).to be false
    end

    it 'out of bounds number' do
      out_of_board_boundary = :B22
      expect(board.within_bounds?(out_of_board_boundary)).to be false
    end

    it 'out of bounds letter & number' do
      out_of_board_boundary = :T14
      expect(board.within_bounds?(out_of_board_boundary)).to be false
    end
  end

  describe 'checkmate?' do
    example 'Arabian mate' do
      board[:H8] = King.new(:H8, :black)
      board[:H7] = Rook.new(:H7, :white)
      board[:F6] = Knight.new(:F6, :white)
      board[:G1] = King.new(:G1, :white)

      expect(board.checkmate?).to be board[:H8]
    end

    example 'Balestra mate' do

      board[:E8] = King.new(:E8, :black)
      board[:F6] = Queen.new(:B7, :white)
      board[:C6] = Bishop.new(:C6, :white)
      board[:G1] = King.new(:G1, :white)

      expect(board.checkmate?).to be board[:E8]
    end

    example 'Corridor mate' do

      board[:C7] = King.new(:C7, :black)
      board[:C4] = Queen.new(:C4, :white)
      board[:B1] = Rook.new(:B1, :white)
      board[:D1] = Rook.new(:D1, :white)
      board[:G1] = King.new(:G1, :white)

      expect(board.checkmate?).to be board[:C7]
    end

    example 'Smothered mate' do

      board[:H8] = King.new(:H8, :black)
      board[:C4] = Queen.new(:C4, :white)
      board[:F7] = Knight.new(:F7, :white)
      board[:G8] = Rook.new(:G8, :black)
      board[:G7] = Pawn.new(:G7, :black)
      board[:H7] = Pawn.new(:H7, :black)
      board[:G1] = King.new(:G1, :white)

      board.to_s

      expect(board.checkmate?).to be board[:H8]
    end
  end

  describe 'check?' do
    it 'Returns true if a move will place the king in check' do
      board[:C7] = King.new(:C7, :black)
      board[:C4] = Queen.new(:C4, :white)
      board[:B1] = Rook.new(:B1, :white)
      board[:C6] = Rook.new(:C6, :black)
      board[:G1] = King.new(:G1, :white)

      result = board.check?(:D6, board[:C6])

      expect(result).to be true
    end
  end

  describe 'king_in_check?' do
    it 'Returns true if the king is in check but not checkmate' do
      board[:C7] = King.new(:C7, :black)
      board[:C4] = Queen.new(:C4, :white)
      board[:B1] = Rook.new(:B1, :white)
      board[:G1] = King.new(:G1, :white)

      check = board.king_in_check?(:black)
      checkmate = board.checkmate?

      expect(check).to be true
      expect(checkmate).to be false
    end
  end

  describe 'stalemate?' do
    it 'Returns true if there is a draw' do
      board[:H8] = King.new(:H8, :black)
      board[:H6] = King.new(:H6, :white)
      board[:G6] = Rook.new(:G6, :white)

      result = board.stalemate?(:black)

      expect(result).to be true
    end

    it 'Returns true if there is a draw alternate' do
      board[:A8] = King.new(:A8, :black)
      board[:C4] = King.new(:C4, :white)
      board[:C7] = Queen.new(:C7, :white)

      result = board.stalemate?(:black)

      expect(result).to be true
    end
  end

  describe '#switch_squares' do

    before do 
      board.build_empty_board
      board.set_board_pieces
    end

    it 'switches position of two pieces' do
      king = :E1
      queen = :D1

      board.switch_squares(king, queen)

      expect(board[:E1].is_a?(Queen)).to be true
      expect(board[:D1].is_a?(King)).to be true
    end

    it 'updates position of piece' do
      king = :E1
      queen = :D1

      board.switch_squares(king, queen)

      queen_square = board[:E1].current_square

      expect(queen_square).to be :E1
    end

    it 'updates count of piece' do
      king = :E1
      queen = :D1

      queen_count_before = board[queen].moves

      board.switch_squares(king, queen)

      queen_count_after = board[:E1].moves

      expect(queen_count_before + 1).to be queen_count_after
    end
  end
end