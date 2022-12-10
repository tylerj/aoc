defmodule AdventOfCode.Y2022.Day08 do
  @directions ~w(up dn lt rt)a

  def part1(input \\ nil) do
    grid = __MODULE__.Input.parse(input)

    grid
    |> Map.keys()
    |> Enum.filter(&visible?(&1, grid))
    |> length()
  end

  def part2(input \\ nil) do
    grid = __MODULE__.Input.parse(input)

    grid
    |> Map.keys()
    |> Stream.map(&view_count(&1, grid))
    |> Stream.map(&Enum.product/1)
    |> Enum.max()
  end

  def visible?({0, _}, _), do: true
  def visible?({_, 0}, _), do: true

  def visible?(xy, grid),
    do: Enum.any?(@directions, &tallest_in_direction?(&1, xy, grid))

  def view_count({0, _}, _), do: [0]
  def view_count({_, 0}, _), do: [0]

  def view_count(xy, grid),
    do: Enum.map(@directions, &count_in_direction(&1, xy, grid))

  defp next({x, y}, :up), do: {x, y - 1}
  defp next({x, y}, :dn), do: {x, y + 1}
  defp next({x, y}, :lt), do: {x - 1, y}
  defp next({x, y}, :rt), do: {x + 1, y}

  def tallest_in_direction?(dir, xy, grid),
    do: do_tallest(dir, next(xy, dir), grid[xy], grid)

  defp do_tallest(dir, xy, height, grid) do
    case grid[xy] do
      nil -> true
      x when x >= height -> false
      _ -> do_tallest(dir, next(xy, dir), height, grid)
    end
  end

  def count_in_direction(dir, xy, grid),
    do: do_count(dir, next(xy, dir), grid[xy], 0, grid)

  defp do_count(dir, xy, height, count, grid) do
    case grid[xy] do
      nil -> count
      x when x >= height -> count + 1
      _ -> do_count(dir, next(xy, dir), height, count + 1, grid)
    end
  end

  defmodule Input do
    @day 8
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_map(input), do: input

    def parse(input) when is_binary(input) do
      input
      |> String.split("\n", trim: true)
      |> parse()
    end

    def parse(input) when is_list(input) do
      input
      |> Stream.with_index()
      |> Stream.flat_map(&parse_line/1)
      |> Enum.into(%{})
    end

    def parse_line({line, idx_y}) do
      line
      |> String.split("", trim: true)
      |> Stream.with_index()
      |> Enum.map(fn {height, idx_x} ->
        {{idx_x, idx_y}, String.to_integer(height)}
      end)
    end
  end
end
