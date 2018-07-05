# For terminal only

class Game
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    self.set_up
  end

  def set_up
    system "clear"
    puts "Welcome to Tic Tac Toe by Command Line Games, Inc!"
    # sleep(1.5)
    puts
    print "Please choose your symbol"
    # sleep(0.8)
    print "."
    # sleep(0.3)
    print "."
    # sleep(0.3)
    print "."
    # sleep(0.5)
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
        # sleep(2.5)
        system "clear"
        puts "Please choose your symbol..."
      end
    end
      puts "Great choice! Your symbol is #{@hum} and the computer is #{@com}"
      # sleep(2.5)
      puts "Are you ready?!"
      # sleep(1.5)
      puts "Let's play!"
      # sleep(1)
      print "."
      # sleep(0.3)
      print "."
      # sleep(0.3)
      print "."
      # sleep(0.5)
    self.start_game
  end

  def start_game
    # start by printing the board
    system "clear"
    puts "Make your first move!"
    puts
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
    puts
    # loop through until the game was won or tied
    until game_is_over(@board) || tie(@board)
      puts "Enter [0-8] to choose a spot on the board:"
      get_human_spot
      if !game_is_over(@board) && !tie(@board)
        computer_response
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
        puts "That is not a valid spot, please try again:"
        spot = nil
      end
    end
  end

  def computer_response
    responses = [
      "Hmm, nice move. My turn...",
      "Oooh you're good. Let's see...",
      "You're playing to win, huh? Not on my watch...",
      "Interesting... Let's see how you deal with this!",
      "I see you're actually trying. Well you're not the only one...",
      "Ok, I see what you did there. Now check this out...",
      "Alright, alright. My turn!",
      "Boom. Choosing spots like a boss. But I'm playing like a CEO :P"
    ]
    puts responses[rand(0..7)]
    sleep(1.8)
    system "clear"
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
    computer_move_description(spot)
  end

  def computer_move_description(spot)
    spots = {
      0 => "top-left corner",
      1 => "top-middle",
      2 => "top-right corner",
      3 => "middle-left",
      4 => "center",
      5 => "middle-right",
      6 => "bottom-left corner",
      7 => "bottom-middle",
      8 => "bottom-right corner",
    }
    if !game_is_over(@board) && !tie(@board)
      puts "I took the #{spots[spot]} spot. Your turn."
      puts
    else
      # game over response logic  
    end
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    # depth and best_score are not being used - for minimax algorithm
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