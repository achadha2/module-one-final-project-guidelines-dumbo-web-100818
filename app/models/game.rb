class Game < ActiveRecord::Base
  has_many :rounds
  has_many :users, through: :rounds
  after_initialize :set_board #:set_current_player
  attr_accessor :board

  def set_board
    @board = tic_tac_toe
  end

  def tic_tac_toe
    [
      [" ", " ", " "],
      [" ", " ", " "],
      [" ", " ", " "]
    ]
  end

  def display_board
    board.each_with_index do |row, index|
      puts row.join("|")
    end
  end

  def set_current_player(player:)
    @current_player = player
  end

  def current_player
    @current_player
  end

  def change_player(round:)
    @current_player == round.player_one ? @current_player = round.player_two : @current_player = round.player_one
  end

  def game_piece(round:)
    current_player == round.player_one ? "X" : "O"
  end

  def valid_move?(cell)
    cell == " "
  end

  def move(round:, player: current_player, position:)
    piece = Piece.create(round: round, user: player, placement: position, piece_type: game_piece(round: round))
    if (1..3).include?(position) && valid_move?(board[0][position-1])
      board[0][position-1] = piece.piece_type
    elsif (4..6).include?(position) && valid_move?(board[1][position-4])
      board[1][position-4] = piece.piece_type
    elsif (7..9).include?(position) && valid_move?(board[2][position-7])
      board[2][position-7] = piece.piece_type
    else
      puts "That is not a valid input!"
      turn(round: round)
    end
  end

  def turn(round:)
    puts "#{current_player.name}, it's your turn."
    # puts "Pick where you would like to place your piece (1-9)"
    # input = gets.chomp.to_i
    prompt = TTY::Prompt.new
    input = prompt.select("Pick where you would like to place your piece:", ["1", "2", "3", "4", "5", "6", "7", "8", "9"], per_page: 9)
    move(round: round, position: input.to_i)
  end

  def row_check
    checks = board.select { |row| row == ["X", "X", "X"] || row == ["O", "O", "O"]}
    !checks.empty?
  end

  def column_check
    cchecks = board.map.with_index do |row, index|
      !valid_move?(board[0][index]) && board[0][index] == board[1][index] && board[0][index] == board[2][index]
    end
    cchecks.include?(true)
  end

  def diagonal_check
    !valid_move?(board[2][0]) && board[2][0] == board[1][1] && board[2][0] == board[0][2]
  end

  def reverse_diagonal_check
    !valid_move?(board[0][0]) && board[0][0] == board[1][1] && board[0][0] == board[2][2]
  end

  def full_board
    !board.flatten.include?(" ")
  end

  def win?
    row_check || column_check || diagonal_check || reverse_diagonal_check
  end

  def win(round:)
    if win?
      round.update(winner: current_player)
      round.update(status: "complete")
    end
  end

  def draw
    puts "It looks like a draw"
  end

  def congratulations(round:)
    puts "Congratulations #{round.winner.name}!!!"
  end

  def start(round:)
    set_current_player(player: round.player_one)

    until full_board || round.status == "complete"
      system "clear"
      display_board
      turn(round: round)
      # binding.pry
      win(round: round)
      change_player(round: round) unless win(round: round)
    end
    display_board
    round.winner ? congratulations(round: round) : draw
  end

end
