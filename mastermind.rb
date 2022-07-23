# 6 colors
# 4 for the combination, duplicates allowed
# 12 turns

module Mastermind
  COLORS = ['blue', 'red', 'green', 'yellow', 'purple', 'brown']

  class Game
    def initialize # computer player, human player
      @board = Array.new(5) # Change name to @guess?
      @turns = 1
      #@combination = Array.new(5) # could change size to 4
      @maker = Maker.new()  # computer player, human player
      @breaker = Breaker.new() # computer player, human player
    end

    def play
      # have maker create their combination
      # breaker has 12 turns (while loop)
        # breaker inputs combination
        # checks combination
        # if correct_guess?, break out of loop
    end

    def correct_guess?
      return true if @board == @maker.combination
      false
    end
  end

  class Maker # currently the computer player randomly creates a combination
    attr_reader :combination

    def initialize
      @combination = Array.new(5)
    end

    def create_combination
      (1..4).each do |n|
        @combination[n] = COLORS.sample
      end
    end
  end

  class Breaker
  end
end

include Mastermind

a = Maker.new
a.create_combination