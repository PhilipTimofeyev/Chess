module Misc
	def convert_sym_to_string_arr(sym)
		[sym.to_s[0], sym.to_s[1..-1]]
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
		letter, number = square.is_a?(Array) ? square : convert_sym_to_string_arr(square)

		number.to_i.between?(1, 8) && letter.between?("A", "H")
	end

	def update_position(new_square)
		self.current_square = new_square
	end

	def same_column?(square)
		current_column, _ = convert_sym_to_string_arr(current_square)
		new_square_column, _ = convert_sym_to_string_arr(square)

		current_column == new_square_column
	end

	def all_squares_in_column(board)
		column, row = convert_sym_to_string_arr(current_square)
		board.squares.keys.select {|key| key.match?(column)}
	end

	def all_squares_in_row(board)
		column, row = convert_sym_to_string_arr(current_square)
		board.squares.keys.select {|key| key.match?(row)}
	end

	def find_valid_squares(arr, board)
		valid_squares = []

		arr.each do |square|
			if board[square].color == :empty
				valid_squares << square
			elsif board[square].color == color
				break
			else
				 valid_squares << square
				 break
			end
		end
		valid_squares
	end

	def valid_squares(square_list, board)
		current_square_idx = square_list.find_index(current_square)

		first_half = square_list[0...current_square_idx].reverse
		second_half = square_list[current_square_idx + 1..-1]

		first_half_valid = find_valid_squares(first_half, board)
		second_half_valid = find_valid_squares(second_half, board)

		first_half_valid + second_half_valid
	end

	def find_antidiagonal_root(board)
		letter, number = convert_sym_to_string_arr(current_square)

		until number == '1' || letter == 'A' do
			number = preceding_number(number)
			letter = preceding_letter(letter)
		end

		[letter, number]
	end

	def antidiagonal_squares(board)
		letter, number = find_antidiagonal_root(board)

		squares = []

		until number > '8' || letter > 'H' do
			squares << convert_arr_to_sym([letter, number])
			number = number.succ
			letter = letter.succ
		end

		squares
	end

	def find_main_diagonal_root(board)
		letter, number = convert_sym_to_string_arr(current_square)

		until number == '8' || letter == 'A' do
			number = number.succ
			letter = preceding_letter(letter)
		end

		[letter, number]
	end

	def main_diagonal_squares(board)
		letter, number = find_main_diagonal_root(board)

		squares = []

		until number < '1' || letter > 'H' do
			squares << convert_arr_to_sym([letter, number])
			number = preceding_number(number)
			letter = letter.succ
		end

		squares
	end

end

class Empty
	attr :name, :color

	def initialize
		@name = 'Empty'
		@color = :empty
		@display = "_"
	end

	def to_s
		@display
	end

end

class BasicPiece
	include Misc

	attr_accessor :current_square
	attr :color, :name

	def initialize(current_square, color)
		@color = color
		@current_square = current_square
	end

end

class Pawn < BasicPiece

	def initialize(current_square, color)
		@name = 'Pawn'
		@display = color == :black ? '♟︎' : '♙'
		super
	end

	def full_moveset_white(board)
		letter, number = convert_sym_to_string_arr(current_square)

		diagonal_left = [preceding_letter(letter), number.succ]
		center_forward_one = [letter, number.succ]
		center_forward_two = number == "2" ? [letter, number.succ.succ] : nil
		diagonal_right = [letter.succ, number.succ]

		center_forward_two = board[convert_arr_to_sym(center_forward_one)].color == :empty ? center_forward_two : nil

		all_moves = [diagonal_left, center_forward_one, center_forward_two, diagonal_right].compact

		all_moves.map {|square| convert_arr_to_sym(square)}
	end

	def full_moveset_black(board)
		letter, number = convert_sym_to_string_arr(current_square)

		diagonal_left = [preceding_letter(letter), preceding_number(number)]
		center_forward_one = [letter, preceding_number(number)]
		center_forward_two = number == "7" ? [letter, (number.to_i - 2).to_s] : nil
		diagonal_right = [letter.succ, preceding_number(number)]

		center_forward_two = board[convert_arr_to_sym(center_forward_one)].color == :empty ? center_forward_two : nil

		all_moves = [diagonal_left, center_forward_one, center_forward_two, diagonal_right].compact

		all_moves.map {|square| convert_arr_to_sym(square)}
	end

	#need to add conversion to queen if reaches other side

	def validated_moveset(board)
		all_moves = color == :black ? full_moveset_black(board) : full_moveset_white(board)

		within_bounds = all_moves.select { |square| within_bounds?(square) }
		valid_moves = within_bounds.select { |square|board[square].color != color }

		valid_moves = valid_moves.reject {|square| same_column?(square) && board[square].color != :empty}
		valid_moves = valid_moves.reject {|square| !same_column?(square) && board[square].color == :empty}

		valid_moves
	end

	def to_s
		@display
	end

end

class Rook < BasicPiece

	def initialize(current_square, color)
		@name = 'Rook'
		@color = color
		super
	end

	def to_s
		@display
	end

	def validated_moveset(board)
		column_squares = all_squares_in_column(board)
		row_squares = all_squares_in_row(board)
		valid = valid_squares(column_squares, board) + valid_squares(row_squares, board)
		valid.sort
	end

end

class Bishop < BasicPiece

	def initialize(current_square, color)
		@name = 'Bishop'
		@color = color
		super
	end

	def to_s
		@display
	end

	def validated_moveset(board)
		left_right =  antidiagonal_squares(board)
		right_left = main_diagonal_squares(board)

		valid = valid_squares(left_right, board) + valid_squares(right_left, board)
		valid.sort
	end

end

class Queen < BasicPiece

	def initialize(current_square, color)
		@name = 'Queen'
		@color = color
		super
	end

	def to_s
		@display
	end

	def validated_moveset(board)
		left_right_diag =  antidiagonal_squares(board)
		right_left_diag = main_diagonal_squares(board)
		column_squares = all_squares_in_column(board)
		row_squares = all_squares_in_row(board)

		row = valid_squares(row_squares, board)
		column = valid_squares(column_squares, board)
		diag_left_right = valid_squares(left_right_diag, board)
		diag_right_left = valid_squares(right_left_diag, board)

		row + column + diag_left_right + diag_right_left
	end

end

#King cannot place itself in check

class King < BasicPiece

	def initialize(current_square, color)
		@name = 'King'
		@color = color
		super
	end

	def to_s
		@display
	end

	def full_moveset(board)
		c_letter, c_number = convert_sym_to_string_arr(current_square)

		board.squares.keys.select do |square|
			letter, number = convert_sym_to_string_arr(square)
			
			letter.between?(preceding_letter(c_letter), c_letter.succ) &&
			number.between?(preceding_number(c_number), c_number.succ)
		end
	end

	def validated_moveset(board)
		squares = full_moveset(board)

		#don't need within bounds here

		squares.select do |square|
			within_bounds?(square) && board[square].color != color
		end.sort
	end

end

class Knight < BasicPiece

	def initialize(current_square, color)
		@name = 'Knight'
		@color = color
		super
	end

	def to_s
		@display
	end

	def full_moveset(board)
		letter, number = convert_sym_to_string_arr(current_square)

		moveset = [
							[letter.succ, number.succ.succ],
							[letter.succ, preceding_number(preceding_number(number))],
							[letter.succ.succ, number.succ],
							[letter.succ.succ, preceding_number(number)],
							[preceding_letter(letter), number.succ.succ],
							[preceding_letter(letter), preceding_number(preceding_number(number))],
							[preceding_letter(preceding_letter(letter)), number.succ],
							[preceding_letter(preceding_letter(letter)), preceding_number(number)]
							]

	end

	def validated_moveset(board)
		squares = full_moveset(board)
		squares.map! {|square| convert_arr_to_sym(square)}

		within_bounds_squares = squares.select {|square| within_bounds?(square) }

		validated_squares = within_bounds_squares.select {|square| board[square].color != color}
		validated_squares.sort
	end

end


