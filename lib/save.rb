require 'yaml'

module Save
  # Get save number so that they don't repeat
  # Rescue value of 0 in case no saved games exist (can't read nil array)
  @@saves = Dir.entries("output").select {|name| /yaml/.match(name)}.sort[-1][5].to_i rescue 0

  def save_game
    @filename = "#{get_save_name}.yaml"
    File.open("output/#{@filename}", "w") {|file| file.write to_yaml}
    puts "Your game has been saved as #{@filename}."
    exit!
  end

  def load_game
    Dir.mkdir("output") unless Dir.exists?("output")
    files = get_files
    if !files.empty?
      display_saves
      puts "Enter the number of the game you'd like to resume, or enter 'new' for a new game:"
      input = gets.chomp
      if input == "new"
        new_game
      elsif input 
        begin
          file_number = input.to_i - 1
          save = files[file_number]
          puts "Opening #{save}..."
          from_yaml(save)
          File.delete("output/#{save}") if File.exist?("output/#{save}")
        rescue
        puts "Game not found. Starting a new game..."
        new_game
        end
      end
    else
      new_game
    end
  end

  def get_save_name
    "save_#{@@saves + 1}"
  end

  def get_files
    Dir.entries("output").select {|name| /yaml/.match(name)}.sort
  end

  def display_saves
    puts "Game #\tFile Name(s)".teal
    puts "----------------------"
    get_files.each_with_index do |name, index|
      puts "#{index + 1}\t#{name.to_s}"
    end
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