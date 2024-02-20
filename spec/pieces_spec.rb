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