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
      # breaker has 12 turns (while loop)
      while @turns <= 12
        # breaker inputs combination
        puts "Turn #{@turns}, please enter your guess: "
        @breaker.input_guess
        # checks combination
        # if correct_guess?, break out of loop
        @turns += 1
      end

    end

    def correct_guess?
      return true if @breaker.guess == @maker.combination
      false
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
      # guess needs to have 4 items max and needs to match COLOR
      loop do
        @guess = gets.chomp.downcase.split
        @guess.unshift(nil)
        break if valid_guess?
        puts "Invalid input, please try again."
      end
    end

    private

    def valid_guess?
      # Array size needs to be exactly 5
      return false unless @guess.length == 5
      # each element has to be contained in COLORS
      (1..4).each { |n| return false unless COLORS.include? @guess[n] }
      true
    end
  end
end

include Mastermind

b = Breaker.new
b.input_guess
p b.guess