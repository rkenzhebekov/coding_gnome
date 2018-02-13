defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "start returns list of words" do
    assert String.length(Dictionary.random_word) > 0
  end
end
