class Display
  # def print_blanks(word)
  #   blanks = ""
  #   for char in 1..word.length do
  #     blanks += " _ "
  #   end
  #   puts blanks
  # end
  def initialize
  end
  
  def turn
    guess = gets.chomp
    return guess if @game.valid_move?
  end
end

# test = Display.new
# test.print_blanks("hello")