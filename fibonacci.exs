defmodule Fibonacci do

  def compute(n) do
    initial_cache = %{0 => 0, 1 => 1}

    {:ok, agent} = Agent.start_link(fn -> initial_cache end)

    of(n, agent)
  end

  def of(n, agent) do
    of(n, agent, Agent.get(agent, &Map.get(&1, n)))
  end

  def of(n, agent, nil) do
    value = of(n-1, agent) + of(n-2, agent)
    Agent.update(agent, fn cache -> Map.put(cache, n, value) end)
    value
  end

  def of(_n, _agent, value) do
    value
  end
end
