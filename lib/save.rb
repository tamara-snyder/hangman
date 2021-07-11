require 'yaml'

module Save
  @@saves = Dir.entries("output").length - 2

  def save_game
    Dir.mkdir("output") unless Dir.exists?("output")
    @filename = "#{get_save_name}.yaml"
    File.open("output/#{@filename}", "w") {|file| file.write to_yaml}
    puts "Your game has been saved as #{@filename}."
    exit!
  end

  def load_game
    files = display_saves
    if !files.empty?
      puts "Enter the number of the game you'd like to resume:"
      file_number = gets.chomp.to_i - 1
      save = files[file_number]
      from_yaml(save)
      File.delete("output/#{save}") if File.exist?("output/#{save}")
    else
      puts "No saves found. Starting a new game..."
      new_game
    end
  end

  def get_save_name
    name = "save_#{@@saves + 1}"
  end

  def display_saves
    files = Dir.entries("output").select {|name| /yaml/.match(name)}.sort
    puts "Game #\tFile Name(s)"
    files.each_with_index do |name, index|
      puts "#{index + 1}\t#{name.to_s}"
    end
    files
  end

  def to_yaml
    YAML.dump ({
      "letters_guessed" => @letters_guessed,
      "turns_remaining" => @turns_remaining,
      "word" => @word,
      "blanks" => @blanks
    })
  end

  def from_yaml(filename)
    file = YAML.load(File.read("output/#{filename}"))

    # DON'T use commas here or you'll get everything combined into an array :|
    @letters_guessed = file["letters_guessed"]
    @turns_remaining = file["turns_remaining"]
    @word = file["word"]
    @blanks = file["blanks"]
  end
end