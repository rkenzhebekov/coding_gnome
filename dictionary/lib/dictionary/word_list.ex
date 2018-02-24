defmodule Dictionary.WordList do

  @me __MODULE__

  @external_resource File.read!(Path.expand("../../assets/words.txt", __DIR__))

  def start_link() do
    Agent.start_link(&word_list/0, name: @me)
  end

  def random_word() do
    Agent.get(@me, &Enum.random/1)
  end

  def word_list() do
    [ content |_ ] = @external_resource
    content
    |> String.split(~r/\n/)
  end
end

