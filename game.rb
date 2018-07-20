# For terminal only
require_relative 'human.rb'
require_relative 'computer.rb'

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
    player_setup
    name_players
    choose_symbol
    who_goes_first
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

  def player_setup
    game_types = [
      "[1] Human vs. Human",
      "[2] Human vs. Computer",
      "[3] Computer vs. Computer"
    ]
    puts "Please choose a game type:"
    puts "#{game_types[0]}"
    puts "#{game_types[1]}"
    puts "#{game_types[2]}"
    print "Entry: "
    @game_type = gets.chomp.to_i
    @player1 = nil
    until @player1 do
      if @game_type == 1
        @player1 = Human.new
        @player2 = Human.new
      elsif @game_type == 2
        @player1 = Human.new
        @player2 = Computer.new
      elsif @game_type == 3
        @player1 = Computer.new
        @player2 = Computer.new
      else
        puts
        puts "#{@game_type} is not a valid entry. Please choose [1] [2] or [3]:"
        @game_type = gets.chomp.to_i
      end
    end
    puts
    puts "Great! You chose #{game_types[@game_type-1]}"
    puts "[ANY KEY] to continue."
    gets.chomp
    system "clear"
  end

  def name_players
    @names = {
      @player1 => nil,
      @player2 => nil
    }
    def enter_name
      print "Player 1, please enter your name: "
      name = gets.chomp
      until name != ""
        print "Please enter at least one alphanumeric character as your name: "
        name = gets.chomp
      end
      @names[@player1] = name
    end
    if @game_type == 1
      enter_name
      print "Please enter a name for Player 2: "
      name = gets.chomp
      until name != ""
        print "Please enter at least one alphanumeric character to name Player 2: "
        name = gets.chomp
      end
      @names[@player2] = name
    elsif @game_type == 2
      enter_name
      @names[@player2] = "Computer"
    elsif @game_type == 3
      @names[@player1] = "Computer 1"
      @names[@player2] = "Computer 2"
    end
  end

  def choose_symbol
    system "clear"
    print "Please choose the symbol for #{@names[@player1]}"
    # sleep(0.8)
    print "."
    # sleep(0.3)
    print "."
    # sleep(0.3)
    print "."
    # sleep(0.5)
    puts
    until @player1.make_move == "X" || @player1.make_move == "O"
      puts "[1] for 'X'"
      puts "[2] for 'O'"
      print "Entry: "
      choice = gets.chomp.to_i
      if choice == 1
        @player1.set_symbol("X")
        @player2.set_symbol("O")
      elsif choice == 2
        @player1.set_symbol("O")
        @player2.set_symbol("X")
      else
        puts
        puts "#{choice} is not a valid option. Please try again:"
        # sleep(2.5)
        # system "clear"
      end
    end
      puts
      puts "Great choice! #{@names[@player1]}'s symbol is '#{@player1.make_move}' and #{@names[@player2]}'s is '#{@player2.make_move}'"
      puts "[ANY KEY] to continue."
      gets.chomp
  end

  def who_goes_first
    system "clear"
    puts "Who goes first?"
    puts "[1] #{@names[@player1]}"
    puts "[2] #{@names[@player2]}"
    print "Entry: "
    choice = gets.chomp.to_i
    until @current_player
      if choice == 1
        @current_player = @player1
      elsif choice == 2
        @current_player = @player2
      else
        print "#{choice} is not a valid choice, please choose [1] or [2]: "
        choice = gets.chomp.to_i
      end
    end
    puts
    puts "Great! #{@names[@current_player]} will go first."
    puts "[ANY KEY] to continue."
    gets.chomp
  end

  def start_game
    # start by printing the board
    system "clear"
    puts "#{@names[@current_player]}, make your first move!"
    # loop through until the game was won or tied
    if @game_type == 1
      human_vs_human
    elsif @game_type == 2
      human_vs_computer
    elsif @game_type == 3
      computer_vs_computer
    end
    end_of_game    
  end

  def switch_player
    @current_player == @player1 ? @current_player = @player2 : @current_player = @player1
  end

  def opposite_player(player)
    player == @player1 ? @player2 : @player1
  end

  def human_vs_human
    until game_is_over(@board) || tie(@board)
      print_board
      get_human_spot
      switch_player
      unless game_is_over(@board) || tie(@board)
        if @current_player == @player1
          puts "#{@names[@player1]}'s turn."
        else
          puts "#{@names[@player2]}'s turn."
        end
      end
    end
  end

  def get_human_spot
    spot = nil
    until spot
      puts "Enter [0-8] to choose a spot on the board:"
      spot = gets.chomp.to_i
      if @board[spot] != "X" && @board[spot] != "O" && spot.between?(0, 8)
        @board[spot] = @current_player.make_move
        system "clear"
        puts "#{@names[@current_player]} chose: #{spot} - the #{spots[spot]} spot"
      else
        puts "That is not a valid spot, please try again."
        spot = nil
      end
    end
  end

  def human_vs_computer
    if @current_player.class == Computer
      sleep(1.5)
      puts
    end
    until game_is_over(@board) || tie(@board)
      if @current_player.class == Human
        print_board
        get_human_spot
        print_board
        unless game_is_over(@board) || tie(@board)
          computer_response
        end
      else
        eval_board
        unless game_is_over(@board) || tie(@board)
          puts "Your turn, #{@names[@player1]}."
        end
      end
      switch_player
    end
  end

  def computer_vs_computer
    until game_is_over(@board) || tie(@board)
      eval_board
      unless game_is_over(@board) || tie(@board)
        print_board
        switch_player
        puts "#{@names[@current_player]}'s turn."
        puts "[ANY KEY] to continue"
        gets.chomp
        system "clear"
      end
    end
  end

  def print_board
    puts
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
    puts
  end

  def computer_response
    responses = [
      "Hmm, nice move. My turn...",
      "Oooh you're good. Let's see...",
      "You're playing to win, huh? Not on my watch...",
      "Interesting... Let's see how you deal with this...",
      "I see you're actually trying. Well you're not the only one...",
      "Ok, I see what you did there. Now check this out...",
      "Alright, alright. My turn!",
      "Boom. Choosing spots like a boss. But I'm playing like a CEO :P"
    ]
    puts "Computer: #{responses[rand(0..7)]}"
    puts "[ANY KEY] to continue."
    gets.chomp
    system "clear"
  end

  def eval_board
    # spot = nil
    # until spot
    #   if @board[4] == "4"
    #     spot = 4
    #     @board[spot] = @current_player.make_move # if available, comp takes middle spot
    #   else
    #     spot = get_best_move(@board, @current_player)
    #     if @board[spot] != "X" && @board[spot] != "O"
    #       @board[spot] = @current_player.make_move
    #     else
    #       spot = nil
    #     end
    #   end
    # end

    spot = get_best_move(@board, @current_player)
    @board[spot] = @current_player.make_move
    computer_move_description(spot)
  end

  def get_best_move(board, player, depth = 0)
    minimax(board, player, depth)
    puts "Best move is #{@choice}"
    return @choice.to_i
  end

  def spots
    {
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
  end

  def computer_move_description(spot)
    if !game_is_over(@board) && !tie(@board)
      puts "#{@names[@current_player]}: I took the #{spots[spot]} spot.\n\n"
    end
  end

  def available_spaces(board)
    unless game_is_over(board) || tie(board)
      board.select {|s| s != "X" && s != "O" }
    end
  end


  # def get_best_move(board, next_player, depth = 0, best_score = {})
  #   # depth and best_score are not being used - for minimax algorithm
  #   best_move = nil
  #   available_spaces(board).each do |as|
  #     board[as.to_i] = @current_player.make_move
  #     if game_is_over(board)
  #       best_move = as.to_i
  #       board[as.to_i] = as
  #       return best_move
  #     else
  #       board[as.to_i] = opposite_player(@current_player).make_move
  #       if game_is_over(board)
  #         best_move = as.to_i
  #         board[as.to_i] = as
  #         return best_move
  #       else
  #         board[as.to_i] = as
  #       end
  #     end
  #   end
  #   if best_move
  #     return best_move
  #   else
  #     n = rand(0..available_spaces(board).count)
  #     return available_spaces(board)[n].to_i
  #   end
  # end

  def get_score(board, depth)
    winner(board)
    if @winner == @current_player
      return 10 - depth
    elsif @winner == opposite_player(@current_player)
      return depth - 10
    else
      return 0
    end
  end

  def minimax(board, player, depth)
    if game_is_over(board) || tie(board)
      return get_score(board, depth)
    end

    depth += 1

    scores = []
    moves = []

    # puts "Outside of loop available spaces: #{available_spaces(board)}"

    available_spaces(board).each do |space|
      new_board = board.dup # temporary representation of current board
      new_board[space.to_i] = player.make_move # make potential move on temp board 
      # puts "--------------"
      # puts "Start of Each Loop"
      # puts "available spaces: #{available_spaces(board)}"
      # puts "space: #{space}"
      # puts "board: #{board}"
      # puts "depth: #{depth}"
      # puts "Last move: #{@names[player]}"
      # puts "new_board: #{new_board}"
      # puts "Next move: #{@names[opposite_player(player)]}"
      # puts "--------------"
      scores << minimax(new_board, opposite_player(player), depth) # store potential state of board in array
      moves << space # store possible move (available space) in array
      # puts "--------------"
      # puts "POST SCORES"
      # puts "Last move: #{@names[player]}"
      # puts "Next move: #{@names[opposite_player(player)]}"
      # puts "available spaces: #{available_spaces(board)}"
      # puts "space: #{space}"
      # puts "board: #{board}"
      # puts "new_board: #{new_board}"
      # puts "available spaces: #{available_spaces(board)}"
      # puts "winner: #{@names[winner(new_board)]}"
      # puts "scores = #{scores}"
      # puts "moves = #{moves}"
      # puts "--------------"
    end

    # p scores
    # p moves

    if @current_player == player
      # This is the max calculation
      max_score_index = scores.each_with_index.max[1]
      @choice = moves[max_score_index]
      # puts "@choice = #{@choice}"
      return scores[max_score_index]
    else
      # This is the min calculation
      min_score_index = scores.each_with_index.min[1]
      @choice = moves[min_score_index]
      # puts "@choice = #{@choice}"
      return scores[min_score_index]
    end
  end

  # def winning_possibilities(b)
  # use this in game_is_over and winner
  #   [
  #     [b[0], b[1], b[2]],
  #     [b[3], b[4], b[5]],
  #     [b[6], b[7], b[8]],
  #     [b[0], b[3], b[6]],
  #     [b[1], b[4], b[7]],
  #     [b[2], b[5], b[8]],
  #     [b[0], b[4], b[8]],
  #     [b[2], b[4], b[6]]
  #   ]
  # end

  def game_is_over(b) #switch to someone_wins or something so game_is_over can be used to combine this and tie
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

  def winner(b)
    winning_possibilities = [
      [b[0], b[1], b[2]],
      [b[3], b[4], b[5]],
      [b[6], b[7], b[8]],
      [b[0], b[3], b[6]],
      [b[1], b[4], b[7]],
      [b[2], b[5], b[8]],
      [b[0], b[4], b[8]],
      [b[2], b[4], b[6]]
    ]
    if winning_possibilities.detect {|possible_win| possible_win.all? @player2.make_move }
      @winner = @player2
    elsif winning_possibilities.detect {|possible_win| possible_win.all? @player1.make_move }
      @winner = @player1
    else
      @winner = 'Tie'
    end
  end

  def winning_message
    if @winner == @player1
      return "#{@names[@player1]} wins! Great job #{@names[@player1]}! Play again!"
    elsif @winner == @player2
      return "#{@names[@player2]} wins! Nice try #{@names[@player1]}! Play again!"
    else
      return "It was a tie! Play again!"
    end
  end

  def end_of_game
    system "clear"
    puts "*** GAME OVER ***"
    print_board
    winner(@board)
    puts "*** #{winning_message} ***\n\n"
    puts "[1] To play again"
    puts "[2] To quit"
    choice = gets.chomp.to_i
    if choice == 1
      Game.new
    end
  end

end

game = Game.new