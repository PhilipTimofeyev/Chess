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
		if square.is_a?(Array)
			letter, number = square
		else
			letter, number = convert_sym_to_string_arr(square)
		end

		number.between?('1', '8') && letter.between?("A", "H")
	end

	def update_position(new_square)
		self.current_square = new_square
	end

	def same_column?(square)
		current_column = convert_sym_to_string_arr(current_square).first
		new_square_column = convert_sym_to_string_arr(square).first

		current_column == new_square_column
	end

	def all_squares_in_column(board)
		square = convert_sym_to_string_arr(current_square)
		column = square.first
		board.squares.keys.select {|key| key.match?(column)}
	end

	def all_squares_in_row(board)
		square = convert_sym_to_string_arr(current_square)
		row = square.last
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

	def valid_column_squares(board)
		column_squares = all_squares_in_column(board)

		idx = column_squares.find_index(current_square)

		bottom_half = column_squares[0...idx].reverse
		top_half = column_squares[idx + 1..-1]

		bottom_valid = find_valid_squares(bottom_half, board)
		top_valid = find_valid_squares(top_half, board)

		bottom_valid + top_valid
	end

	def valid_row_squares(board)
		row_squares = all_squares_in_row(board)

		idx = row_squares.find_index(current_square)

		left_half = row_squares[0...idx].reverse
		right_half = row_squares[idx + 1..-1]

		bottom_valid = find_valid_squares(left_half, board)
		top_valid = find_valid_squares(right_half, board)

		bottom_valid + top_valid
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

class Rook
	include Misc

	attr_accessor :current_square
	attr :color, :name

	def initialize(current_square, color)
		@name = 'Rook'
		@color = color
		@display = color == :black ? '♜' : '♖'
		@current_square = current_square
	end

	def to_s
		@display
	end

	def validated_moveset(board)
		valid_column_squares(board) + valid_row_squares(board)
	end

end
