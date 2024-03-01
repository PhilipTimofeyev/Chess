require 'yaml'

require_relative './lib/board'
require_relative './lib/player'

class Game
  attr_accessor :players, :board
  attr_reader :player_one, :player_two

  def initialize
    @board = Chessboard.new
    @player_one = Player.new('Player 1', :white)
    @player_two = Player.new('Player 2', :black)
    @players = [@player_one]
  end

  def load_game
    file = File.open('save_game/chess_save.yaml')
    from_yaml(file)
  end

  def save_game
    Dir.mkdir('save_game') unless Dir.exist?('save_game')

    filename = "save_game/chess_save.yaml"
    save_state = to_yaml

    File.open(filename, 'w') do |file|
      file.puts save_state
    end

    puts "Game Saved!"
    sleep 2
  end

  def to_yaml
    YAML.dump({
                board: board,
                players: players
              })
  end

  def clear
    Gem.win_platform? ? (system 'cls') : (system 'clear')
  end

  def from_yaml(string)
    data = YAML.safe_load(string,
                          permitted_classes: [Symbol, Chessboard, Rook, Knight, Queen,
                                              King, Bishop, Pawn, Empty, Player])

    self.board = data[:board]
    self.players = data[:players]
  end

  def start_menu
    response = nil
    loop do
      turn_options
      response = gets.chomp.to_i
      if board.squares.empty?
        break if [1, 2, 3, 4].include?(response)
      elsif [1, 2, 3, 4, 5].include?(response)
        break
      end
      clear
    end
    response
  end

  def menu_selection
    response = start_menu

    case response
    when 1 then new_game
    when 2 then save_game
    when 3
      begin
        load_game
      rescue StandardError
        puts "No previous save, please select a different option."
        sleep 2
        clear
        menu_selection
      end
    when 4 then quit_game
    when 5 then game_loop
    end
  end

  def quit_game
    puts "Thanks for playing!"
    exit
  end

  def new_game
    board.build_empty_board
    board.set_board_pieces
    board.to_s
  end

  def turn_options
    puts <<~TURN
      Select from the following options:
        1: New Game
        2: Save Game
        3. Load Game
        4. Quit Game
    TURN
    puts "  5. Continue" unless board.squares.empty?
  end

  def welcome
    clear
    puts "Welcome to Chess!"
    puts ""
    menu_selection
  end

  def game_loop
    clear
    loop do
      board.to_s
      break if board.checkmate? || board.stalemate?(players.first.color)
      if players.first.turn(board) == :M
        clear
        menu_selection
        next
      end
      if board.pawn_promotion?
        board.promote_pawn
        puts "Pawn promoted to queen!"
        sleep(2)
      end
      players.rotate!
    end

    end_conditions
  end

  def end_conditions
    winner = board.checkmate?.color == :black ? 'Player 1' : 'Player 2'
    if board.checkmate?
      puts "#{board.checkmate?.color.capitalize} is checkmated."
      puts "#{winner} wins!"
    elsif board.stalemate?(players.first.color)
      puts "It's a draw!"
    end
  end

  def play_again?
    puts "\nPlay again? (y/n)"

    response = nil
    loop do
      response = gets.chomp.downcase
      break if ['y', 'n'].include?(response)
      puts "Please enter (y) or (n)"
    end
    response == 'y' ? play : quit_game
  end

  def play
    welcome
    game_loop
    play_again?
  end
end

game = Game.new
game.play
