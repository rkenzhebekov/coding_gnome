defmodule SocketGallowsWeb.HangmanChannel do
  use Phoenix.Channel

  def join("hangman:game", _, socket) do
    game = Hangman.new_game()
    socket = assign(socket, :game, game)
    start_timer()
    {:ok, socket}
  end

  def handle_in("tally", _, socket) do
    tally = socket.assigns.game |> Hangman.tally()
    push(socket, "tally", tally)
    {:noreply, socket}
  end

  def handle_in("make_move", guess, socket) do
    tally = socket.assigns.game |> Hangman.make_move(guess)
    push(socket, "tally", tally)
    {:noreply, socket}
  end

  def handle_in("new_game", _, socket) do
    socket = socket |> assign(:game, Hangman.new_game())
    start_timer()
    handle_in("tally", nil, socket)
  end

  def handle_info({:tick, 0}, socket) do
    tally = socket.assigns.game |> Hangman.tally()
    tally = %{tally | game_state: :out_of_time}
    push(socket, "tally", tally)
    {:noreply, socket}
  end

  def handle_info({:tick, seconds_left}, socket) do
    push(socket, "seconds_left", %{seconds_left: seconds_left})
    Process.send_after(self(), {:tick, seconds_left - 1}, 1000)
    {:noreply, socket}
  end

  defp start_timer() do
    Process.send_after(self(), {:tick, 10}, 1000)
  end
end

