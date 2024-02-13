module Misc
	def convert_to_string_arr(sym)
		sym.to_s.chars
	end

	def convert_to_sym(arr)
		arr.join.to_sym
	end

	def preceding_letter(letter)
		(letter.ord - 1).chr
	end

	def preceding_number(number)
		(number.to_i - 1).to_s
	end

	def within_bounds?(square)
		letter, number = square
		number.between?('1', '8') && letter.between?("A", "H")
	end

end

class Pawn
	include Misc

	attr_accessor :current_square

	def initialize(current_square)
		@name = 'Pawn'
		@display = '♙'
		@current_square = current_square
	end

	def full_moveset
		letter, number = convert_to_string_arr(current_square)

		diagonal_left = [preceding_letter(letter), number.succ]
		center_up_one = [letter, number.succ]
		center_up_two = number == "2" ? [letter, number.succ.succ] : nil
		diagonal_right = [letter.succ, number.succ]

		all_moves = [diagonal_left, center_up_one, center_up_two, diagonal_right].compact

		all_moves.map {|square| convert_to_sym(square)}
	end

	#need to make sure when selecting square, it is aware of what chess piece it is
	#need to add conversion to queen if reaches other side

	def validated_moveset(board)
		all_moves = full_moveset

		diagonal_left = all_moves.first
		center_up_one = all_moves[1]
		diagonal_right = all_moves.last

		all_moves = all_moves.select {|square| within_bounds?(convert_to_string_arr(square))}

		all_moves.delete(diagonal_left) unless board[diagonal_left].nil? || board[diagonal_left].empty? #can capture only diagonally
		all_moves.delete(center_up_one) if board[center_up_one].nil? || board[center_up_one].empty? #can only move forward if not capturing
		all_moves.delete(diagonal_right) unless board[diagonal_right].nil? || board[diagonal_right].empty?  #can capture only diagonally

		all_moves
	end

	def to_s
		@display
	end
end
