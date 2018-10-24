class Round < ActiveRecord::Base
  belongs_to :game
  belongs_to :player_one, class_name: 'User', foreign_key: 'player_one_id'
  belongs_to :player_two, class_name: 'User', foreign_key: 'player_two_id'
  belongs_to :winner, class_name: 'User', foreign_key: 'winner_id'
  has_many :pieces
  after_initialize :set_current_player

  def set_current_player
    @current_player = player_one
  end

  def current_player
    @current_player
  end

  def change_player
    @current_player == player_one ? @current_player = player_two : @current_player = player_one
  end

end
