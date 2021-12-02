defmodule SonarSweep do
  @moduledoc """
  Documentation for `SonarSweep`.
  """

  @doc """

  Calculate the depth increase from dataset

  ## Examples

      # Problem one: Comparing adjacent values

      iex> SonarSweep.calculate_depth_increase('lib/depth_report.txt')
      1766

      # Problem two: Comparing batches

      iex> SonarSweep.calculate_depth_increase('lib/depth_report.txt', 3)
      1797

  """
  def calculate_depth_increase(report, breadth \\ 1) do
    {:ok, file} = File.read(report)

    file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(breadth, 1, :discard)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [first, second] -> Enum.sum(second) > Enum.sum(first) end)
    |> Enum.count()
  end
end
