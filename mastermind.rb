# 6 colors
# 4 for the combination, duplicates allowed
# 12 turns

module Mastermind
  COLORS = ['blue', 'red', 'green', 'yellow', 'purple', 'brown']

  class Game
    def initialize # computer player, human player
      @turns = 1
      @maker = Maker.new()  # computer player, human player
      @breaker = Breaker.new() # computer player, human player
    end

    def play
      puts "Enter '1' to be the Breaker."
      puts "Enter '2' to be the Maker."
      player_role = ask_player_role
      if player_role == 2
        puts "Choose the difficulty of the Breaker computer player:"
        puts "Enter '1' for Easy."
        puts "Enter '2' for Hard."
        loop do
          @difficulty = gets.chomp.to_i
          break if @difficulty == 1 or @difficulty == 2
          puts "Invalid input, enter '1' for easy or enter '2' for hard."
        end
      end
      # have maker create their combination
      @maker.combination = @maker.create_combination(player_role)
      if player_role == 2
        @breaker.computer_combination = []
        @breaker.computer_combination.replace(@maker.combination) 
      end
      # breaker has 12 turns (while loop)
      while @turns <= 12
        # breaker inputs combination
        puts "Turn #{@turns}:"
        @breaker.guess = @breaker.input_guess(player_role, @difficulty)
        # if correct_guess?, break out of loop
        break if correct_guess?
        # otherwise, new instance function to check
        give_hint
        @turns += 1
      end

      #p @maker.combination
      puts "The combination was #{@maker.combination[1]} #{@maker.combination[2]} #{@maker.combination[3]} #{@maker.combination[4]}."

      if @turns <= 12
        puts "The Breaker wins!"
      else
        puts "The Maker wins!"
      end
    end

    private

    def correct_guess?
      return true if @breaker.guess == @maker.combination
      false
    end

    def give_hint
      # combination: red blue red green
      # guess:       brown red brown red   no correct position
      # no duplicates: brown red    one correct color (should be 2 correct colors)
      @correct_positions = 0
      @correct_colors = 0
      guess_color_count = color_count(@breaker.guess)
      combination_color_count = color_count(@maker.combination)

      (1..4).each do |n|
        if @breaker.guess[n] == @maker.combination[n]
          current_color = @breaker.guess[n]
          guess_color_count[current_color] -= 1
          combination_color_count[current_color] -= 1
          @correct_positions += 1
        end
      end
      #p guess_color_count
      #p combination_color_count

      guess_color_count.each do |k, v|
        unless combination_color_count[k] == 0 || guess_color_count[k] == 0
          #puts "guess color count: #{guess_color_count[k]}"
          #puts "key: #{k} value: #{v}"
          @correct_colors += combination_color_count[k]
        end
      end

      puts "You have #{@correct_positions} correct color(s) in the correct positions."
      puts "You have #{@correct_colors} correct color(s) in the wrong positions."
    end

    def color_count(array)
      new_hash = array.each_with_object(Hash.new(0)) { |color, count| count[color] += 1 }
      new_hash.delete(nil)
      new_hash
    end

    def ask_player_role
      loop do
        player_role = gets.to_i
        return player_role if player_role == 1 || player_role == 2
        puts "Invalid input, enter '1' for breaker or '2' for maker."
      end
    end
  end

  class Player
    def ask_for_input(input)
      loop do
        input = gets.chomp.downcase.split
        input.unshift(nil)
        return input if valid_input?(input)
        puts "Invalid input, please try again."
      end
    end

    def valid_input?(input)
      return false unless input.length == 5
      (1..4).each { |n| return false unless COLORS.include? input[n] }
      true
    end
  end

  class Maker < Player # currently the computer player randomly creates a combination
    attr_accessor :combination

    def initialize
      @combination = Array.new(5)
    end

    def create_combination(player_role)
      if player_role == 1
        combination = Array.new(5)
        (1..4).each { |n| combination[n] = COLORS.sample }
        combination
      else
        puts "Enter your combination:"
        ask_for_input(@combination)
      end
    end
  end

  class Breaker < Player
    attr_accessor :guess, :computer_combination, :last_guess

    def initialize
      @computer_combination
      @last_guess = Array.new(5, nil)
    end

    def input_guess(player_role, difficulty=1)
      if player_role == 1
        ask_for_input(@guess)
      else
        # Make the computer randomly guess for now
        if difficulty == 1
          computer_guess = easy_difficulty
        else
          computer_guess = hard_difficulty(@last_guess)
          @last_guess = computer_guess
        end
        sleep 1
        puts "The computer guesses: #{computer_guess[1]} #{computer_guess[2]} #{computer_guess[3]} #{computer_guess[4]}"
        computer_guess
      end
    end

    private

    def easy_difficulty
      temp = Array.new(5)
      temp.unshift(nil)
      (1..4).each { |n| temp[n] = COLORS.sample }
      temp
    end

    def hard_difficulty(last_guess)
      temp = []
      temp.replace(@computer_combination)
      (1..4).each do |n|
        next if last_guess[n] == @computer_combination[n]
        temp[n] = COLORS.sample
      end
      temp
    end
  end
end

include Mastermind

game = Game.new
game.play