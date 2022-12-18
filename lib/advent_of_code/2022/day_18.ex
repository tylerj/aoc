defmodule AdventOfCode.Y2022.Day18 do
  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    grid = input |> parse() |> MapSet.new()

    grid
    |> Enum.map(fn xyz ->
      6 - neighbor_count(grid, xyz)
    end)
    |> Enum.sum()
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> Enum.map(& &1)
  end

  def neighbor_count(set, {x, y, z}) do
    [
      {1, 0, 0},
      {-1, 0, 0},
      {0, 1, 0},
      {0, -1, 0},
      {0, 0, 1},
      {0, 0, -1}
    ]
    |> Enum.count(fn {a, b, c} ->
      MapSet.member?(set, {a + x, b + y, c + z})
    end)
  end

  defmodule Input do
    @day 18
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      input
      |> String.split("\n", trim: true)
      |> parse()
    end

    def parse(input) when is_list(input) do
      Stream.map(input, &parse_line/1)
    end

    def parse_line(line) do
      line
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end
  end
end
