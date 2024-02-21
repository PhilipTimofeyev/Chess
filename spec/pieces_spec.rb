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

  before do 
    board.build_empty_board
    board.set_board_pieces
  end

  let(:pawn) { described_class.new }
  let(:board) {Chessboard.new}

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

  describe Rook do

    before do 
      board.build_empty_board
      board.set_board_pieces
    end

    let(:rook) { described_class.new }
    let(:board) {Chessboard.new}

    describe 'moveset' do
      it 'only shows column and row for current square' do
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


end