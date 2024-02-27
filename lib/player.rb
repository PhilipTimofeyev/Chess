class Player
  attr_accessor :color
  attr_reader :name

  def initalize
    @name = "Arthur"
  end

  def turn(board)
    piece = nil
    square = nil

    loop do
      piece = select_piece(board)
      square = select_square(board, piece)

      if board.king_in_check?(color) && board.check?(square, board[piece])
        puts "This leaves king in check."
        puts "Enter a different square or enter 1 to select a different piece."
      elsif square
        break
      end
    end

    board.move_piece(piece, square)
  end

  def select_color
    puts "Will you be playing as white or black?"

    response = nil

    loop do
      response = gets.chomp.downcase
      break if ["black", "white"].include?(response)
      puts "Not a valid color. Please enter 'white' or 'black'."
    end

    @color = response.to_sym
  end

  def select_piece(board)
    square = nil
    puts "Enter a chess piece to move:"

    loop do
      square = gets.chomp.upcase.to_sym

      break if board.squares.keys.include?(square) && board[square].color == color
      puts "Please enter one of your pieces:"
    end

    square
  end

  def select_square(board, piece)
    puts "Where would you like to move #{board[piece].name} #{board[piece].current_square}?"
    puts "Enter 1 to change pieces."

    valid_squares = board[piece].validated_moveset(board)

    square = nil
    loop do
      square = gets.chomp.upcase.to_sym
      return false if square == :'1'
      if valid_squares.include?(square)
        break unless board.check?(square, board[piece])
        puts "#{square} will place the king in check. Select a different square or piece."
      else
        puts "Please enter a valid square or 1 to select a different piece:"
        puts valid_squares.empty? ? "No valid squares." : valid_squares.join(', ')
      end
    end
    square
  end
end
