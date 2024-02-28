class Player
  attr_reader :player_name, :color

  def initialize(player_name, color)
    @player_name = player_name
    @color = color
  end

  def announce_capture(piece, square, board)
    if board[square].color != :empty
    	puts "#{board[piece].name} #{piece} captures #{board[square].name} #{square}"
    	sleep 3
    end
  end

  def turn(board)
    piece = nil
    square = nil

    loop do
      piece = select_piece(board)
      break if piece == :M
      square = select_square(board, piece)

      if board.king_in_check?(color) && board.check?(square, board[piece])
        puts "This leaves king in check."
        puts "Enter a different square or enter 1 to select a different piece."
      elsif square
        break
      end
    end

    return piece if piece == :M

    announce_capture(piece, square, board)
    board.move_piece(piece, square)
  end

  def select_piece(board)
    square = nil
    puts "#{player_name} enter a #{color} chess piece to move:"

    loop do
      square = gets.chomp.upcase.to_sym

      break if square == :M
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
