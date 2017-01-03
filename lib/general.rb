class Game
  attr_accessor :player1, :player2, :active_player, :fields
  def initialize
    @player1 = Player.new(1)
    @player2 = Player.new(2)
    @active_player = @player1
    @fields = create_board
    @victor = nil
  end

  def create_board
    @field = []
    7.times do
      column_array = []
      6.times do
        column_array << Field.new
      end
      @field << column_array
    end
  end

  def turn
    drop_stone
    check_victory
    case @active_player
    when @player1 then @active_player = @player2
    when @player2 then @active_player = @player1
    end
  end

  def drop_stone
    puts "#{@active_player.name}, please choose a column to drop your stone into."
    selected_column = gets.chomp.to_i - 1
    while selected_column < 0 || selected_column > 6
      puts "This is not a valid choice. Please enter a number between 1 and 7."
      selected_column = gets.chomp.to_i - 1
    end
    target_row = nil
    fields[selected_column].each_with_index do |k, i|
      next if target_row != nil
      if k.status == 0
        target_row = i
      end
    end


  end

  def check_victory
    #rows
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

    #columns
    @fields.each do |column|
      series_counter = 0
      series = []
      column.each do |field|
        if field == @active_player.id
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

    #diagonals
    
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
    puts "Hello, #{@color} Player. What's your name?"
    name = gets.chomp
    while name == nil || name == ''
      name = gets.chomp
    end
    return name
  end
end
