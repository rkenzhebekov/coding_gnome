defmodule GallowsWeb.HangmanControllerTest do
  use GallowsWeb.ConnCase

  test "GET /hangman", %{conn: conn} do
    conn = get conn, "/hangman"
    assert html_response(conn, 200) =~ "Welcome to Hangman!"
  end
end
