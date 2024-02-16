

class Player
	attr_reader :name, :color

	def initalize
		@name = "Arthur"
	end

	def turn(board)
		piece = select_piece(board)

		puts "Where would you like to move #{board.squares[piece].name} #{board.squares[piece].current_square}?"
		p board[piece].validated_moveset(board)

		move_to = gets.chomp.to_sym

		board.move_piece(piece, move_to)
	end

	def select_color
		puts "Will you be playing as the white pieces, or black pieces?"

		response = nil

		loop do
			response = gets.chomp
			break if ["black", "white"].include?(response)
			puts "Not a valid color. Please enter 'white' or 'black'."
		end

		@color = response.to_sym
	end

	def validate_color?(board, square)
		board[square].color == color
	end

	def select_piece(board)
		puts "Select a chess piece to move"
		square = nil

		loop do
			square = gets.chomp.to_sym

			break if board.squares.keys.include?(square) && board[square].color == color
			puts "Please select one of your pieces."
		end
		square
	end

end	