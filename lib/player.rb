

class Player
	attr_accessor :color
	attr_reader :name

	def initalize
		@name = "Arthur"
	end

	def turn(board)
		piece = select_piece(board)

		select_square(board, piece)
	end

	def select_color
		puts "Will you be playing as the white or black?"

		response = nil

		loop do
			response = gets.chomp.downcase
			break if ["black", "white"].include?(response)
			puts "Not a valid color. Please enter 'white' or 'black'."
		end

		@color = response.to_sym
	end

	def validate_color?(board, square)
		board[square].color == color
	end

	def select_piece(board)
		puts "Enter a chess piece to move"
		square = nil

		loop do
			square = gets.chomp.upcase.to_sym

			break if board.squares.keys.include?(square) && board[square].color == color
			puts "Please enter one of your pieces:"
		end
		square
	end

	def select_square(board, piece)
		puts "Where would you like to move #{board.squares[piece].name} #{board.squares[piece].current_square}?"

		valid_squares = board[piece].validated_moveset(board)

		square = nil
		loop do
			square = gets.chomp.upcase.to_sym
			if valid_squares.include?(square)
				if board[piece].is_a?(King) && board.check?(square, board[piece])
					board.to_s
					puts "#{square} will place the king in check. Select a different square."
				else
					break
				end
			else
				board.to_s
				puts "Please enter one of the valid squares:"
				puts valid_squares.join(' ')
			end
		end

		board.move_piece(piece, square)
	end

end	