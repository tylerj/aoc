defmodule AdventOfCode.Y2022.Day01 do
  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    input
    |> parse()
    |> Enum.reduce({0, 0}, fn
      "", {current, max} when current > max ->
        {0, current}

      "", {_, max} ->
        {0, max}

      amt, {current, max} ->
        {current + String.to_integer(amt), max}
    end)
    |> then(fn {_, max} -> max end)
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> find_top_n(3)
    |> Enum.take(3)
    |> Enum.sum()
  end

  def find_top_n(input, top_n \\ 1) do
    leaders = List.duplicate(0, top_n)

    input
    |> Enum.reduce({0, leaders}, &apply_line/2)
    |> then(&update_leaders/1)
  end

  defp apply_line("", value_and_leaders) do
    {0, update_leaders(value_and_leaders)}
  end

  defp apply_line(line_amt, {acc, top}) do
    {acc + String.to_integer(line_amt), top}
  end

  defp update_leaders({value, leaders}) do
    [value | leaders] |> Enum.sort(:asc) |> Enum.drop(1)
  end

  def rank([a | [b | _]] = list) when a <= b, do: list
  def rank([a | [b | rest]]), do: [b | rank([a | rest])]
  def rank([_] = end_of_list), do: end_of_list

  defmodule Input do
    @day 1
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      input |> String.split("\n")
    end
  end
end
