defmodule TextClient.Mover do

  alias TextClient.State

  def move(game = %State{}) do
    tally = Hangman.make_move(game.game_service, game.guess)
    %State{ game | tally: tally}
  end
end
