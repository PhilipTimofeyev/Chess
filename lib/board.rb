
class Chessboard
  EMPTY_SQUARE = '_'
  LOWER_BOUND = 0
  UPPER_BOUND = 7
  LETTERS = %w(A B C D E F G H)

  attr_accessor :squares

  def initialize
    @squares = {}
  end

  def build_board
    (LOWER_BOUND + 1..UPPER_BOUND + 1).each do |row|
      LETTERS.each do |column|
        squares[(column.to_s + row.to_s).to_sym] = EMPTY_SQUARE
      end
    end
  end

  def display_board
    row_count = UPPER_BOUND

    squares.values.reverse.each_slice(UPPER_BOUND + 1) do |row| 
      puts "#{row_count + 1}|#{row.reverse.map{|square| square}.join("|")}|" 
      row_count -= 1
    end

    label_columns
  end

  def display_column_labels
    puts "  " + LETTERS.map{|n| n.to_s}.join(" ")
  end

  def within_bounds?(square)
    squares.keys.include?(square)
  end
end
