defmodule Dive do
  @doc """
  Problem one: Follow directions to find your x/y position, where x is your forward/backward motion whilte y is your depth. Return the product of x and y.

  ## Examples

      iex> Dive.follow_instructions('lib/instructions.txt')
      1855892637

  """
  def follow_instructions(path) do
    {:ok, file} = File.read(path)

    coordinates =
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split/1)
      |> Enum.map(fn [dir, amount] -> [dir, String.to_integer(amount)] end)
      |> dive()

    coordinates[:x] * coordinates[:y]
  end

  @doc """
  Get postition following instructions

  down X increases your aim by X units.
  up X decreases your aim by X units.
  forward X does two things:
      It increases your horizontal position by X units.
      It increases your depth by your aim multiplied by X.

  ## Examples

      iex> Dive.dive([["forward", 3], ["down", 2], ["forward", 1], ["up", 1], ["backward", 2]])
      %{x: 2, y: 2, aim: 1}

  """
  def dive(instructions) do
    Enum.reduce(instructions, %{aim: 0, x: 0, y: 0}, fn [direction, value], acc ->
      move(acc, direction, value)
    end)
  end

  def move(position, "forward", amount) do
    Map.put(position, :x, position[:x] + amount)
    |> Map.put(:y, position[:y] + position[:aim] * amount)
  end

  def move(position, "backward", amount), do: Map.put(position, :x, position[:x] - amount)
  def move(position, "down", amount), do: Map.put(position, :aim, position[:aim] + amount)
  def move(position, "up", amount), do: Map.put(position, :aim, position[:aim] - amount)
end
