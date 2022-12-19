defmodule AdventOfCode.Y2022.Day18 do
  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    grid = input |> parse() |> MapSet.new()

    grid
    |> Enum.map(fn xyz ->
      6 - neighbor_count(xyz, grid)
    end)
    |> Enum.sum()
  end

  def part2(input \\ nil) do
    grid = input |> parse() |> MapSet.new()
    outside_spaces = empty_outside_spaces(grid)

    grid
    |> Enum.map(fn xyz ->
      neighbor_count(xyz, outside_spaces)
    end)
    |> Enum.sum()
  end

  def neighbors({x, y, z}) do
    [
      {1, 0, 0},
      {-1, 0, 0},
      {0, 1, 0},
      {0, -1, 0},
      {0, 0, 1},
      {0, 0, -1}
    ]
    |> Enum.map(fn {a, b, c} -> {a + x, b + y, c + z} end)
  end

  def neighbor_count(xyz, set) do
    Enum.count(neighbors(xyz), &MapSet.member?(set, &1))
  end

  def empty_outside_spaces(grid) do
    {min, max} = min_max(grid)
    min = min - 1
    max = max + 1

    find_empty_spaces([{min, min, min}], MapSet.new(), grid, min, max)
  end

  def find_empty_spaces([], seen, _, _, _), do: seen

  def find_empty_spaces([next | queue], seen, grid, min, max) do
    next
    |> neighbors()
    |> Enum.reduce({queue, seen}, fn {x, y, z} = xyz, {queue, seen} ->
      cond do
        MapSet.member?(grid, xyz) -> {queue, seen}
        MapSet.member?(seen, xyz) -> {queue, seen}
        Enum.any?([x, y, z], &(&1 < min or &1 > max)) -> {queue, seen}
        true -> {[xyz | queue], MapSet.put(seen, xyz)}
      end
    end)
    |> then(fn {queue, seen} -> find_empty_spaces(queue, seen, grid, min, max) end)
  end

  def min_max(grid) do
    {min, max} = min_max_xyz(grid)

    {
      min |> Tuple.to_list() |> Enum.min(),
      max |> Tuple.to_list() |> Enum.max()
    }
  end

  def min_max_xyz(grid) do
    {min_x, max_x} = grid |> Enum.map(&elem(&1, 0)) |> Enum.min_max()
    {min_y, max_y} = grid |> Enum.map(&elem(&1, 1)) |> Enum.min_max()
    {min_z, max_z} = grid |> Enum.map(&elem(&1, 2)) |> Enum.min_max()

    {
      {min_x, min_y, min_z},
      {max_x, max_y, max_z}
    }
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
