require 'spec_helper'

=begin
What do I need?
Procedural:
1. initialize game (including new board(+fields) and 2 players)
2. each player adds a drop
  - validity of move checked
  - victory condition checked after each move
  until a. game is paused b. board is filled or c. somebody wins

Classes:
- game --> :player1, :player2, many :fields {array of fields}, :victor, :active_player
- field --> :status, :row, :column
- players --> :name, :color

Methods:
Game.new --> Player.new; game.create_fields; Field.new;
game.turn --> field.fill; game.check_victory; game.change_active_player
game.save & game.exit

=end

describe Game do
  before(:all) do
    my_game = Game.new
  end

  describe '.new' do
    it 'creates a new game object' do
      expect(my_game).to be_instance_of(Game)
    end

    it 'creates two player objects' do
      expect(my_game.player1).to be_instance_of(Player)
      expect(my_game.player2).to be_instance_of(Player)
    end

    it 'creates many fields' do
      expect(my_game.fields.each).to be_instance_of(Field)
    end
  end

  describe '#turn' do
    it 'changes the status of a field instance'

    it 'checks the victory condition'

    it 'changes the active player'
  end

  describe '#save' do
    it 'saves the game object into a db'
  end

  describe '#exit' do
    it 'aborts the game'
  end

end

describe Field do
  

end
