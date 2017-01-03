require 'yaml'

class Game
  attr_accessor :player1, :player2, :active_player, :fields
  def initialize
    @player1 = Player.new(1)
    @player2 = Player.new(2)
    @active_player = @player1
    @fields = create_board
    @victor = nil
  end

  def turn
    display_board
    drop_stone
    check_victory
    case @active_player
    when @player1 then @active_player = @player2
    when @player2 then @active_player = @player1
    end
  end

private
  def create_board
    fields = []
    7.times do
      column_array = []
      6.times do
        column_array << Field.new
      end
      fields << column_array
    end
    return fields
  end

  def display_board
    row = 6
    6.times do
      row -= 1
      @fields.each do |column|
        case column[row].status
        when 0 then print "[ ]"
        when 1 then print "[X]"
        when 2 then print "[O]"
        when 3 then print "[V]"
        end
      end
      puts "\r\n"
    end
  end

  def drop_stone
    puts "#{@active_player.name}, please choose a column to drop your stone into."
    selected_column = gets.chomp.to_i - 1
    target_row = nil
    while target_row == nil
      while selected_column < 0 || selected_column > 6
        puts "This is not a valid choice. Please enter a number between 1 and 7."
        selected_column = gets.chomp.to_i - 1
      end
      @fields[selected_column].each_with_index do |k, i|
        next if target_row != nil
        if k.status == 0
          target_row = i
        end
      end
      if target_row == nil
        puts "This row is full. Please indicate another."
        selected_column = gets.chomp.to_i - 1
      end
    end
    @fields[selected_column][target_row].status = @active_player.id

  end

  def check_victory
    check_rows
    check_columns
    check_diagonals
  end

  def check_rows
    row = 0
    6.times do
      series_counter = 0
      series = []
      @fields.each do |column|
        if column[row].status == @active_player.id
          series_counter += 1
          series << column[row]
        else
          series_counter = 0
          series = []
        end
        if series_counter == 4
          victory_end(series)
        end
      end
      row += 1
    end
  end

  def check_columns
    @fields.each do |column|
      series_counter = 0
      series = []
      column.each do |field|
        if field.status == @active_player.id
          series_counter += 1
          series << field
        else
          series_counter = 0
          series = []
        end
        if series_counter == 4
          victory_end(series)
        end
      end
    end
  end

  def check_diagonals
    @fields[0..3].each_with_index do |column, c_i|
      column[3..5].each_with_index do |field, r_i|
        series = []
        series << field << @fields[c_i+1][r_i-1] << @fields[c_i+2][r_i-2] << @fields[c_i+3][r_i-3]
        series_counter = series.take_while {|k| k.status == @active_player.id}
        if series_counter.length == 4
          victory_end(series)
        end
      end
      column[0..2].each_with_index do |field, r_i|
        series = []
        series << field << @fields[c_i+1][r_i+1] << @fields[c_i+2][r_i+2] << @fields[c_i+3][r_i+3]
        series_counter = series.take_while {|k| k.status == @active_player.id}
        if series_counter.length == 4
          victory_end(series)
        end
      end
    end
  end

  def victory_end(series)
    puts "Congratulations!"
    puts "#{@active_player.name} has won the game."
    series.each do |k|
      k.status = 3
    end
    display_board
    abort()
  end
end

class Field
  attr_accessor :status
  def initialize
    @status = 0
  end
end

class Player
  attr_accessor :name, :id
  def initialize(id)
    @id = id.to_i
    @name = get_name
  end

  def get_name
    puts "Hello, Player #{id}. What's your name?"
    name = gets.chomp
    while name == nil || name == ''
      name = gets.chomp
    end
    return name
  end
end

class Session
  attr_accessor :current_game
  def initialize
    case new?
    when true then @current_game = Game.new
    when false then @current_game = load_game
    end
  end

  def session_turn
    @current_game.turn
    while continue? == true
      @current_game.turn
    end
    abort("Thanks for playing!")
  end

private
  def new?
    puts "Welcome to Paul's version of Connect4. I hope you enjoy it."
    puts "Would you like to:"
    puts "[1]-Make a New Game?"
    puts "[2]-Load a Saved Game?"
    choice = gets.chomp.to_i
    while !choice == 1 && !choice == 2
      puts "This is not a valid response. Please enter 1 or 2."
      choice = gets.chomp.to_i
    end
    if choice == 1
      return true
    elsif choice == 2
      return false
    end
  end

  def load_game
    games = []
    File.open("saved_games.yml", "r").each("\n\n") do |object|
      games << YAML.load(object)
    end
    games.each.with_index {|game, index| puts "[#{index + 1}]- #{game.player1.name.capitalize} vs. #{game.player2.name.capitalize} "}
    puts "Please indicate which saved game you would like to load."
    indication = gets.chomp.to_i - 1
    while indication > games.length || indication < 0
      "Not a valid choice. Please re-enter."
      indication = gets.chomp.to_i
    end
    game = games[indication]
    return game
  end

  def save_game
    saved_game = @current_game.to_yaml
    f = File.open("saved_games.yml", "a")
    f.puts(saved_game + "\n")
    f.close
  end

  def continue?
    puts "Hello again. Would you like to:"
    puts "[1]-Continue?"
    puts "[2]-Save Your Game and Continue?"
    puts "[3]-Save and Exit?"
    choice = gets.chomp.to_i
    while !choice === 1 && !choice === 2 && !choice === 3
      puts "This is not a valid response. Please enter 1, 2 or 3."
      choice = gets.chomp.to_i
    end

    case choice
    when 1
      return true
    when 2
      save_game
      return true
    when 3
      save_game
      return false
    end
  end
end
