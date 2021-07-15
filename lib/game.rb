require_relative "color.rb"
require_relative "save.rb"

class Game
  include Save
  attr_accessor :letters_guessed, :turns_remaining, :blanks, :saves_number
  attr_reader :word, :mode

  def initialize
    @letters_guessed = {}
    @turns_remaining = 10
    puts "H A N G M A N\n".teal.bold
    load_game
    play
  end

  def play
    puts @blanks
    puts
    while !game_over?
      turn
    end

    puts winner? ? "The word was indeed '#{@word.bold}'. You win!".green : "Oh no! You didn't guess the word in time :[\nThe word was '#{@word.bold}'.".red

    play_again
  end

  def load_dictionary
    # Keep only words that are between 5-12 letters long and are not proper nouns
    File.readlines("words.txt").select do |word|
      word.gsub!(/[^A-Za-z]/, "").length.between?(5, 12) && word.downcase.eql?(word)
    end
  end

  def choose_random_word
    load_dictionary.sample.downcase
  end

  def correct_letter?(letter)
    @word.include?(letter)
  end

  def valid_guess?(string)
    # Turn only counts if the user: 
    # - entered only one character
    # - entered an alphabetic character
    # - has not already guessed the character
    string.length == 1 && string[/[a-z]+/]  == string && !@letters_guessed.keys.include?(string)
  end

  def turn_input
    puts "Enter a single letter that you haven't already guessed, 'save' to save game, or 'quit' to quit."
    guess = gets.chomp.downcase
    puts
    p @word
    if guess.eql?("save")
      save_game
    elsif guess.eql?("quit")
      exit!
    elsif valid_guess?(guess)
      @letters_guessed[guess] = correct_letter?(guess)
      if !@word.include?(guess)
        @turns_remaining -= 1
      end
      return guess
    elsif guess.length > 1
      if guess.eql?(@word)
        @blanks = @word
        return guess
      else
        return @turns_remaining -= 1
      end
    end

    turn_input
  end

  def turn
    puts "Turns remaining: ".teal.bold + "#{@turns_remaining}"
    puts "Letters guessed: ".teal.bold + "#{@letters_guessed.map {|key, value| value == true ? "#{key.green}" : "#{key.red}"}.join(", ")}"
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
    puts
  end

  def game_over?
    @turns_remaining == 0 || winner?
  end

  def winner?
    @word.eql?(@blanks)
  end

  def new_game
    @word = choose_random_word
    @blanks = "_" * @word.length
    @letters_guessed = {}
    @turns_remaining = 10
    puts
    play
  end

  def play_again
    puts "Play again? Press 'y' for yes or 'n' for no"
    input = gets.chomp.downcase
    if input.eql?("y")
      new_game
    else
      exit!
    end
  end
end

Game.new