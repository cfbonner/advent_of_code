defmodule BinaryDiagnostic do
  @moduledoc """
  Day 3: Binary Diagnostic
  """

  @doc """

  Part 1: 

  You need to use the binary numbers in the diagnostic report to generate 
  two new binary numbers (called the gamma rate and the epsilon rate). 
  The power consumption can then be found by multiplying the gamma rate by the epsilon rate.

  ## Examples

      iex> BinaryDiagnostic.power_consumption('lib/dataset_sample.txt')
      198

      iex> BinaryDiagnostic.power_consumption('lib/dataset.txt')
      2743844

  """
  def power_consumption(filepath) do
    {:ok, file} = File.read(filepath)

    dataset =
      file
      |> String.split("\n", trim: true)
      |> Enum.map(fn data ->
        String.split(data, "", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    gamma = gamma_rate(dataset)
    epsilon = epsilon_rate(gamma)

    {gamma_decimal, _} = Integer.parse(gamma, 2)
    {epsilon_decimal, _} = Integer.parse(epsilon, 2)

    gamma_decimal * epsilon_decimal
  end

  @doc """

  Each bit in the gamma rate can be determined by finding the most common bit 
  in the corresponding position of all numbers in the diagnostic report. 
  If the sum of the 1s is greater than half the length of the dataset, than it is the most common bit.

  ## Examples

      iex> BinaryDiagnostic.gamma_rate([[1, 0, 1, 1, 0], [1, 0, 1, 1, 0], [1, 1, 1, 0, 0]])
      "10110"

  """
  def gamma_rate(two_dim_array) do
    dataset_length = Enum.count(two_dim_array)

    two_dim_array
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sum/1)
    |> Enum.map(fn n ->
      if n > dataset_length / 2, do: 1, else: 0
    end)
    |> Enum.join()
  end

  @doc """

  Flips bit values

  ## Examples

      iex> BinaryDiagnostic.epsilon_rate("10110")
      "01001"

  """
  def epsilon_rate(gamma) do
    gamma
    |> String.split("", trim: true)
    |> Enum.map(fn val ->
      case val do
        "1" -> "0"
        "0" -> "1"
      end
    end)
    |> Enum.join()
  end

  @doc """

  Part 2: 

  Find life support rating, which can be determined 
  by multiplying the oxygen generator rating by the CO2 scrubber rating.

  ## Examples

      # iex> BinaryDiagnostic.life_support_rating('lib/dataset_sample.txt')
      # 230

      # iex> BinaryDiagnostic.life_support_rating('lib/dataset.txt')
      # 6677951

  """
  def life_support_rating(filepath) do
    {:ok, file} = File.read(filepath)

    dataset =
      file
      |> String.split("\n", trim: true)
      |> Enum.map(fn data ->
        String.split(data, "", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    o2(dataset) * co2(dataset)
  end

  def o2(numbers) do
    recur(numbers, 0, fn ones, zeros -> 
      if ones >= zeros, do: 1, else: 0
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  def co2(numbers) do
    recur(numbers, 0, fn ones, zeros -> 
      if zeros <= ones, do: 0, else: 1
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  def recur([number], _pos, _fun), do: number

  def recur(numbers, pos, fun) do
    zero_count = Enum.count(numbers, &Enum.at(&1, pos) == 0)
    one_count = length(numbers) - zero_count
    to_keep = fun.(one_count, zero_count)
    remaining = Enum.filter(numbers, &Enum.at(&1, pos) == to_keep)
    recur(remaining, pos + 1, fun)
  end
end
