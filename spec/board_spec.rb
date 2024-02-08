require_relative '../lib/board'


describe Chessboard do
  subject(:board) {described_class.new}

  describe 'chessboard' do
    before {board.build_board}

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


end