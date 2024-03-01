require_relative '../lib/pieces'
require_relative '../lib/board'

describe Misc do

  let(:piece_class) { Class.new { extend Misc } }
  let(:board) {Chessboard.new}

  before do 
    board.build_empty_board
    board.set_board_pieces
  end
  
  describe "conversions" do
    it 'converts a symbol to a string array' do
      sym = :A1
      correct = ['A', '1']
      result = piece_class.convert_sym_to_string_arr(sym)

      expect(result).to eq(correct)
    end

    it 'converts a symbol with number greater than 9 to a string array' do
      sym = :A12
      correct = ['A', '12']
      result = piece_class.convert_sym_to_string_arr(sym)

      expect(result).to eq(correct)
    end
  end

  describe 'preceding letter/number' do
    it 'gives the preceding letter' do
      letter = 'D'
      correct = 'C'
      result = piece_class.preceding_letter(letter)

      expect(result).to eq(correct)
    end

    it 'gives the preceding number' do
      number = '5'
      correct = '4'
      result = piece_class.preceding_number(number)

      expect(result).to eq(correct)
    end
  end

  describe 'updating position' do
    it 'sets current square to new position' do
      piece_to_move = :C2
      new_square = :C4
      board.move_piece(piece_to_move, new_square)

      expect(board[:C4].current_square).to be :C4
    end
  end

  describe 'checks if square is within board boundary' do

    it 'validates square when passed an in bound array' do
      valid_square = ['B', '3']
      result = piece_class.within_bounds?(valid_square)

      expect(result).to be true
    end

    it 'validates square when passed an in bound symbol' do
      valid_square = :B3
      result = piece_class.within_bounds?(valid_square)

      expect(result).to be true
    end

    it 'validates square when passed an out of bound array' do
      valid_square = ['Z', '4']
      result = piece_class.within_bounds?(valid_square)

      expect(result).to be false
    end

    it 'validates square when passed an out of bound symbol' do
      valid_square = :B12
      result = piece_class.within_bounds?(valid_square)

      expect(result).to be false
    end
  end
end

describe Pawn do

  let(:board) {Chessboard.new}

  before do 
    board.build_empty_board
    board.set_board_pieces
  end

  describe 'moveset white' do
    it 'can move two squares forward from starting position' do
      pawn = :D2
      correct_moveset = [:D3, :D4]
      result = board[pawn].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end

    it 'can capture diagonally but only move forward one' do
      board.move_piece(:E2, :E3)
      board.move_piece(:F7, :F4)
      pawn = :E3
      correct_moveset = [:E4, :F4]
      result = board[pawn].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end

    it 'does not jump over pieces' do
      board.move_piece(:E2, :D3)
      pawn = :D2
      correct_moveset = []
      result = board[pawn].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end

    it 'does not capture same color pieces' do
      board.move_piece(:F7, :C3)
      board.move_piece(:E2, :E3)
      pawn = :D2
      correct_moveset = [:C3, :D3, :D4]
      result = board[pawn].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end

    it 'converts to other piece when reaching other side white' do
      board.move_piece(:A2, :A8)
      board.promote_pawn

      promoted_pawn = board[:A8]

      expect(promoted_pawn.is_a?(Queen)).to be true
    end

    it 'converts to other piece when reaching other side black' do
      board.move_piece(:A7, :A1)
      board.promote_pawn

      promoted_pawn = board[:A1]

      expect(promoted_pawn.is_a?(Queen)).to be true
    end
  end
    describe 'moveset black' do
      it 'can move two squares forward from starting position' do
        pawn = :D7
        correct_moveset = [:D6, :D5]
        result = board[pawn].validated_moveset(board)

        expect(result).to eq(correct_moveset)
      end

      it 'can capture diagonally but only move forward one' do
        board.move_piece(:E7, :E6)
        board.move_piece(:F2, :F5)
        pawn = :E6
        correct_moveset = [:E5, :F5]
        result = board[pawn].validated_moveset(board)

        expect(result).to eq(correct_moveset)
      end

      it 'does not jump over pieces' do
        board.move_piece(:E7, :D6)
        pawn = :D7
        correct_moveset = []
        result = board[pawn].validated_moveset(board)

        expect(result).to eq(correct_moveset)
      end

      it 'does not capture same color pieces' do
        board.move_piece(:F2, :C6)
        board.move_piece(:E7, :E6)
        pawn = :D7
        correct_moveset = [:C6, :D6, :D5]
        result = board[pawn].validated_moveset(board)

        expect(result).to eq(correct_moveset)
      end
    end
  end

describe Rook do

  let(:board) {Chessboard.new}

  before do 
    board.build_empty_board
    board.set_board_pieces
  end

  describe 'moveset' do
    it 'only returns column and row for current square' do
      board.move_piece(:A1, :C4)
      rook = :C4
      correct_moveset = [:A4, :B4, :C3, :C5, :C6, :C7, :D4, :E4, :F4, :G4, :H4]
      result = board[rook].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end

    it 'only captures opposite color' do
      board.move_piece(:A1, :C4)
      board.move_piece(:A2, :C3)
      board.move_piece(:B2, :B4)
      board.move_piece(:B7, :C5)
      board.move_piece(:C7, :D4)

      rook = :C4
      correct_moveset = [:C5, :D4]
      result = board[rook].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end
  end
end

describe Bishop do

  let(:board) {Chessboard.new}

  before do 
    board.build_empty_board
    board.set_board_pieces
  end

  describe 'moveset' do
    it 'only returns diagonal squares for current square' do
      board.move_piece(:C1, :B4)
      bishop = :B4
      correct_moveset = [:A3, :A5, :C3, :C5, :D6, :E7]

      result = board[bishop].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end

    it 'only captures opposite color' do
      board.move_piece(:C1, :C4)
      board.move_piece(:A2, :B3)
      board.move_piece(:B2, :B5)
      board.move_piece(:B7, :D5)
      board.move_piece(:C7, :D3)

      bishop = :C4
      correct_moveset = [:D3, :D5]
      result = board[bishop].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end
  end
end

describe Queen do

  let(:board) {Chessboard.new}

  before do 
    board.build_empty_board
    board.set_board_pieces
  end

  describe 'moveset' do
    it 'returns row, column, and diagonals for current square' do
      board.move_piece(:D1, :B4)
      queen = :B4
      correct_moveset = 
      [:A4, :C4, :D4, :E4, :F4, :G4, :H4, 
      :B3, :B5, :B6, :B7, 
      :A3, :C5, :D6, :E7, 
      :A5, :C3]

      result = board[queen].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end

    it 'only captures opposite color' do
      board.move_piece(:D1, :C4)
      board.move_piece(:A2, :B3)
      board.move_piece(:B2, :B5)
      board.move_piece(:B7, :D5)
      board.move_piece(:C7, :D3)
      board.move_piece(:H2, :C3)
      board.move_piece(:E2, :B4)
      board.move_piece(:H7, :C5)
      board.move_piece(:E7, :D4)

      queen = :C4
      correct_moveset = [:D4, :C5, :D5, :D3]
      result = board[queen].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end
  end
end

describe King do

  let(:board) {Chessboard.new}

  before do 
    board.build_empty_board
    board.set_board_pieces
  end

  describe 'moveset' do
    it 'returns row, column, and diagonals for current square' do
      board.move_piece(:E1, :B4)
      king = :B4
      correct_moveset = [:A3, :A4, :A5, :B3, :B5, :C3, :C4, :C5]

      result = board[king].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end

    it 'only captures opposite color' do
      board.move_piece(:D1, :C4)
      board.move_piece(:A2, :B3)
      board.move_piece(:B2, :B5)
      board.move_piece(:B7, :D5)
      board.move_piece(:C7, :D3)
      board.move_piece(:H2, :C3)
      board.move_piece(:E2, :B4)
      board.move_piece(:H7, :C5)
      board.move_piece(:E7, :D4)

      king = :C4
      correct_moveset = [:D4, :C5, :D5, :D3]
      result = board[king].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end
  end  

  describe '#queen_side_castle' do

    it 'returns false if in between squares are not empty' do
      king = board[:E1]
      result = king.queen_side_castle?(board)

      expect(result).to be false
    end

    it 'returns false if king as moved' do
      board.build_empty_board
      board.set_kings
      board.set_rooks
      board.set_pawns

      king = board[:E1]
      board.move_piece(:E1, :C1)
      board.move_piece(:C1, :E1)
      result = king.queen_side_castle?(board)

      expect(result).to be false
    end

    it 'returns false if castle places king in check' do
      board.build_empty_board
      board.set_kings
      board.set_rooks

      king = board[:E1]
      result = king.queen_side_castle?(board)

      expect(result).to be false
    end

    it 'returns false if in between square places king in check' do
      board.build_empty_board
      board.set_kings
      board.set_rooks
      board.set_pawns
      board[:C7] = Queen.new(:C7, :white)

      king = board[:E8]
      result = king.queen_side_castle?(board)

      expect(result).to be false
    end

    it 'returns false if king is in check' do
      board.build_empty_board
      board.set_kings
      board.set_rooks
      board.set_pawns
      board[:E7] = Queen.new(:E7, :white)

      king = board[:E8]
      result = king.queen_side_castle?(board)

      expect(result).to be false
    end

    it 'returns rook position if all rules are followed' do
      board.build_empty_board
      board.set_kings
      board.set_rooks
      board.set_pawns
      
      king = board[:E8]
      result = king.queen_side_castle?(board)

      expect(result).to be :A8
    end
  end

  describe '#king_side_castle' do

    it 'returns false if in between squares are not empty' do
      king = board[:E1]
      result = king.king_side_castle?(board)

      expect(result).to be false
    end

    it 'returns false if king as moved' do
      board.build_empty_board
      board.set_kings
      board.set_rooks
      board.set_pawns

      king = board[:E1]
      board.move_piece(:E1, :C1)
      board.move_piece(:C1, :E1)
      result = king.king_side_castle?(board)

      expect(result).to be false
    end

    it 'returns false if castle places king in check' do
      board.build_empty_board
      board.set_kings
      board.set_rooks

      king = board[:E1]
      result = king.king_side_castle?(board)

      expect(result).to be false
    end

    it 'returns false if in between square places king in check' do
      board.build_empty_board
      board.set_kings
      board.set_rooks
      board.set_pawns
      board[:F7] = Queen.new(:F7, :white)

      king = board[:E8]
      result = king.king_side_castle?(board)

      expect(result).to be false
    end

    it 'returns false if king is in check' do
      board.build_empty_board
      board.set_kings
      board.set_rooks
      board.set_pawns
      board[:E7] = Queen.new(:E7, :white)

      king = board[:E8]
      result = king.king_side_castle?(board)

      expect(result).to be false
    end

    it 'returns rook position if all rules are followed' do
      board.build_empty_board
      board.set_kings
      board.set_rooks
      board.set_pawns
      
      king = board[:E8]
      result = king.king_side_castle?(board)

      expect(result).to be :H8
    end
  end
end

describe Knight do

  let(:board) {Chessboard.new}

  before do 
    board.build_empty_board
    board.set_knights
  end

  describe 'moveset' do
    it 'returns row, column, and diagonals for current square' do
      board.move_piece(:B1, :D4)
      knight = :D4
      correct_moveset = [:B3, :B5, :C2, :C6, :E2, :E6, :F3, :F5]

      result = board[knight].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end


    it 'only captures opposite color' do
      board.set_board_pieces

      board.move_piece(:B1, :D4)
      board.move_piece(:A2, :B3)
      board.move_piece(:B2, :B5)
      board.move_piece(:B7, :E6)
      board.move_piece(:C7, :F3)

      knight = :D4
      correct_moveset = [:C6, :E6, :F3, :F5]
      result = board[knight].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end

    it 'can jump over pieces' do 
      board.set_board_pieces
      board.move_piece(:B7, :C3)

      knight = :B1
      correct_moveset = [:A3, :C3]
      result = board[knight].validated_moveset(board)

      expect(result).to eq(correct_moveset)
    end
  end  
end

