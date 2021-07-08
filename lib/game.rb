# require "display.rb"

class Game
  attr_accessor :letters_guessed, :turns_remaining, :blanks
  attr_reader :word
  def initialize
    @letters_guessed = {}
    @turns_remaining = 10
    @word = choose_random_word
    @blanks = "_" * @word.length
  end

  def play
    puts @blanks
    while !game_over?
      turn
    end

    puts winner? ? "You win! :]" : "Oh no! You didn't guess the word in time :[\nThe word was '#{@word}'."
  end

  def load_dictionary
    File.readlines("words.txt").select{|word| word.gsub!(/[^A-Za-z]/, "").length.between?(5, 12)}
  end

  def choose_random_word
    load_dictionary.sample.downcase
  end

  def correct_letter?(letter)
    @word.include?(letter)
  end

  def valid_guess?(string)
    string.length == 1 && !@letters_guessed.keys.include?(string)
  end

  def turn_input
    puts "Enter a single letter that you haven't already guessed:"
    guess = gets.chomp
    if valid_guess?(guess)
      @letters_guessed[guess] = correct_letter?(guess)
      if !@word.include?(guess)
        @turns_remaining -= 1
      end
      return guess
    end

    turn_input
  end

  def turn
    puts "Turns remaining: #{@turns_remaining}"
    puts "Letters guessed: #{@letters_guessed.keys.join(", ")}"
    update_string(turn_input)
  end

  def update_string(letter)
    word = @word.split("")
    word.each_with_index do |char, index|
      if char.eql? letter
        @blanks[index] = char
      end
    end
    puts @blanks
  end

  def game_over?
    @turns_remaining == 0 || winner?
  end

  def winner?
    @word.eql?(@blanks)
  end

  def self.new_game
    puts "Play again? Press 'y' for yes or 'n' for no."
    input = gets.chomp.downcase
    if input == 'y'
      play
    else
      puts "Thanks for playing!"
    end
  end

  def self.play_game
    game = Game.new
    game.play
  end
end


Game.play_game