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
      # have maker create their combination
      @maker.create_combination
      p @maker.combination
      # breaker has 12 turns (while loop)
      while @turns <= 12
        # breaker inputs combination
        puts "Turn #{@turns}, please enter your guess: "
        @breaker.input_guess
        # if correct_guess?, break out of loop
        break if correct_guess?
        # otherwise, new instance function to check
        give_hint
        @turns += 1
      end

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
      p guess_color_count
      p combination_color_count

      guess_color_count.each do |k, v|
        unless combination_color_count[k] == 0 || guess_color_count[k] == 0
          puts "guess color count: #{guess_color_count[k]}"
          puts "key: #{k} value: #{v}"
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
  end

  class Maker # currently the computer player randomly creates a combination
    attr_reader :combination

    def initialize
      @combination = Array.new(5)
    end

    def create_combination
      (1..4).each { |n| @combination[n] = COLORS.sample }
    end
  end

  class Breaker
    attr_reader :guess

    def input_guess
      loop do
        @guess = gets.chomp.downcase.split
        @guess.unshift(nil)
        break if valid_guess?
        puts "Invalid input, please try again."
      end
    end

    private

    def valid_guess?
      return false unless @guess.length == 5
      (1..4).each { |n| return false unless COLORS.include? @guess[n] }
      true
    end
  end
end

include Mastermind

game = Game.new
game.play