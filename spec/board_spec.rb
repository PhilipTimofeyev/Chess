require_relative '../lib/board'


describe Chessboard do
  subject(:board) {described_class.new}
  before {board.build_board}

  describe 'building board' do

    it 'has 64 squares' do
      squares = board.squares
      num_of_squares = squares.count

      expect(num_of_squares).to be 64
    end

    it 'contains only empty squares' do
      squares = board.squares.values

      expect(squares.all? {|square| square == '_'}).to be true
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


end