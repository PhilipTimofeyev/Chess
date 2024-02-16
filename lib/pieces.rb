module Misc
	def convert_sym_to_string_arr(sym)
		sym.to_s.chars
	end

	def convert_arr_to_sym(arr)
		arr.join.to_sym
	end

	def preceding_letter(letter)
		(letter.ord - 1).chr
	end

	def preceding_number(number)
		(number.to_i - 1).to_s
	end

	def within_bounds?(square)
		letter, number = convert_sym_to_string_arr(square)
		number.between?('1', '8') && letter.between?("A", "H")
	end

	def update_position(new_square)
		self.current_square = new_square
	end

end

class Pawn
	include Misc

	attr_accessor :current_square
	attr :color, :name

	def initialize(current_square, color)
		@name = 'Pawn'
		@color = color
		@display = color == :black ? '♟︎' : '♙'
		@current_square = current_square
	end

	def full_moveset_white
		letter, number = convert_sym_to_string_arr(current_square)

		diagonal_left = [preceding_letter(letter), number.succ]
		center_forward_one = [letter, number.succ]
		center_forward_two = number == "2" ? [letter, number.succ.succ] : nil
		diagonal_right = [letter.succ, number.succ]

		all_moves = [diagonal_left, center_forward_one, center_forward_two, diagonal_right].compact

		all_moves.map {|square| convert_arr_to_sym(square)}
	end

	def full_moveset_black
		letter, number = convert_sym_to_string_arr(current_square)

		diagonal_left = [preceding_letter(letter), preceding_number(number)]
		center_forward_one = [letter, preceding_number(number)]
		center_forward_two = number == "7" ? [letter, (number.to_i - 2).to_s] : nil
		diagonal_right = [letter.succ, preceding_number(number)]

		all_moves = [diagonal_left, center_forward_one, center_forward_two, diagonal_right].compact

		all_moves.map {|square| convert_arr_to_sym(square)}
	end

	#need to add conversion to queen if reaches other side

	def validated_moveset(board)
		all_moves = color == :black ? full_moveset_black : full_moveset_white

		diagonal_left = all_moves.first
		center_forward_one = all_moves[1]
		diagonal_right = all_moves.last

		validate_moves = all_moves.select {|square| within_bounds?(square) && (board[square] == '_') || board[square].color != color}

		validate_moves.delete(diagonal_left) if board[diagonal_left].nil? || board[diagonal_left] == '_' #can capture only diagonally
		validate_moves.delete(center_forward_one) unless board[center_forward_one].nil? || board[center_forward_one] == '_' #can only move forward if not capturing
		validate_moves.delete(diagonal_right) if board[diagonal_right].nil? || board[diagonal_right] == '_'  #can capture only diagonally

		validate_moves
	end


	def to_s
		@display
	end

end
