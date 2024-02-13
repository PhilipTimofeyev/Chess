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

end

class Pawn
	include Misc

	def initialize
		@name = 'Pawn'
		@display = '♙'
	end

	def moveset(current_square)
		letter, number = convert_to_string_arr(current_square)

		diagonal_left = [preceding_letter(letter), number.succ]
		center_top = [letter, number.succ]
		diagonal_right = [letter.succ, number.succ]

		all_moves = [diagonal_left, center_top, diagonal_right]

		all_moves.map {|square| convert_to_sym(square)}
	end
end
