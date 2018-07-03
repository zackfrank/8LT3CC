# For terminal only

class Game
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    self.set_up
  end

  def set_up
    system "clear"
    puts "Welcome to Tic Tac Toe by Command Line Games, Inc!"
    sleep(1.5)
    puts
    print "Please choose your symbol"
    sleep(0.8)
    print "."
    sleep(0.3)
    print "."
    sleep(0.3)
    print "."
    sleep(0.5)
    puts
    @hum = nil
    until @hum
      puts "[1] for 'X'"
      puts "[2] for 'O'"
      print "Entry: "
      choice = gets.chomp.to_i
      if choice == 1
        @hum = "X"
        @com = "O"
      elsif choice == 2
        @hum = "O" 
        @com = "X"
      else
        puts "#{choice} is not a valid option. Please try again..."
        sleep(2.5)
        system "clear"
        puts "Please choose your symbol..."
      end
    end
      sleep(0.5)
      puts "Great choice! Your symbol is #{@hum} and the computer is #{@com}"
      sleep(2.5)
      puts "Are you ready?!"
      sleep(1.5)
      puts "Let's play!"
      sleep(1)
      print "."
      sleep(0.3)
      print "."
      sleep(0.3)
      print "."
      sleep(0.5)
      system "clear"
      puts
    self.start_game
  end

  def start_game
    # start by printing the board
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
    puts "Enter [0-8]:"
    # loop through until the game was won or tied
    until game_is_over(@board) || tie(@board)
      get_human_spot
      if !game_is_over(@board) && !tie(@board)
        eval_board
      end
      puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
    end
    puts "Game over"
  end

  def get_human_spot
    spot = nil
    until spot
      spot = gets.chomp.to_i
      if @board[spot] != "X" && @board[spot] != "O"
        @board[spot] = @hum
      else
        spot = nil
      end
    end
  end

  def eval_board
    spot = nil
    until spot
      if @board[4] == "4"
        spot = 4
        @board[spot] = @com # if available, comp takes middle spot
      else
        spot = get_best_move(@board, @com)
        if @board[spot] != "X" && @board[spot] != "O"
          @board[spot] = @com
        else
          spot = nil
        end
      end
    end
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    # depth and best_score are not being used
    # available_spaces = []
    best_move = nil
    # board.each do |s|             # refactored below:
      # if s != "X" && s != "O"
      #   available_spaces << s
      # end
    # end
    available_spaces = board.select {|s| s != "X" && s != "O" }
    available_spaces.each do |as|
      board[as.to_i] = @com
      if game_is_over(board)
        best_move = as.to_i
        board[as.to_i] = as
        return best_move
      else
        board[as.to_i] = @hum
        if game_is_over(board)
          best_move = as.to_i
          board[as.to_i] = as
          return best_move
        else
          board[as.to_i] = as
        end
      end
    end
    if best_move
      return best_move
    else
      n = rand(0..available_spaces.count)
      return available_spaces[n].to_i
    end
  end

  def game_is_over(b)

    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1
  end

  def tie(b)
    b.all? { |s| s == "X" || s == "O" }
  end

end

game = Game.new