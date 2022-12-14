defmodule AdventOfCode.Y2022.Day14 do
  alias __MODULE__.{Grid, Input}
  defdelegate parse(input), to: Input

  def part1(input \\ nil) do
    input
    |> parse()
    |> Grid.build()
    |> add_sand_p1({500, 0})
    |> elem(1)
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> Grid.build()
    |> add_sand_p2({500, 0})
    |> elem(1)
  end

  def add_sand_p1(grid, {x, y}, count \\ 0) do
    d = {x, y + 1}
    dl = {x - 1, y + 1}
    dr = {x + 1, y + 1}

    put_sand = fn xy ->
      grid
      |> Map.put(xy, "o")
      |> Map.delete({x, y + 2})
      |> add_sand_p1({500, 0}, count + 1)
    end

    case grid do
      %{^d => _, ^dl => _, ^dr => _} ->
        put_sand.({x, y})

      %{^d => _, ^dl => _, max_x: ^x} ->
        {:void, count, grid}

      %{^d => _, ^dl => _} ->
        add_sand_p1(grid, dr, count)

      %{^d => _, min_x: ^x} ->
        {:void, count, grid}

      %{^d => _} ->
        add_sand_p1(grid, dl, count)

      _ ->
        add_sand_p1(grid, d, count)
    end
  end

  def add_sand_p2(grid, {x, y}, count \\ 0) do
    next_y = y + 1
    d = {x, next_y}
    dl = {x - 1, next_y}
    dr = {x + 1, next_y}

    put_sand = fn xy ->
      grid
      |> Map.put(xy, "o")
      |> Map.delete({x, y + 2})
      |> add_sand_p2({500, 0}, count + 1)
    end

    case grid do
      %{{500, 0} => _} ->
        {:blocked, count, grid}

      %{floor_y: ^next_y} ->
        put_sand.({x, y})

      %{^d => _, ^dl => _, ^dr => _} ->
        put_sand.({x, y})

      %{^d => _, ^dl => _} ->
        add_sand_p2(grid, dr, count)

      %{^d => _} ->
        add_sand_p2(grid, dl, count)

      _ ->
        add_sand_p2(grid, d, count)
    end
  end

  defmodule Grid do
    def build(input) do
      input
      |> Enum.reduce(%{}, &add_path/2)
      |> add_min_max()
    end

    def add_path([xy | tail], grid) do
      add_path_segment(xy, tail, grid)
    end

    def add_path_segment(xy, [next_xy | tail], grid) do
      add_path_segment(
        next_xy,
        tail,
        add_to_grid(xy, next_xy, grid)
      )
    end

    def add_path_segment(_, [], grid), do: grid

    def add_to_grid({x1, y1}, {x2, y2}, grid) when x1 > x2 or y1 > y2,
      do: add_to_grid({x2, y2}, {x1, y1}, grid)

    def add_to_grid({x1, y1}, {x2, y2}, grid) do
      for x <- x1..x2, y <- y1..y2, reduce: grid do
        acc -> Map.put(acc, {x, y}, "#")
      end
    end

    def add_min_max(grid) do
      {min_x, max_x} = Enum.min_max(for {{x, _}, _} <- grid, do: x)
      max_y = Enum.max(for {{_, y}, _} <- grid, do: y)

      Map.merge(grid, %{min_x: min_x, max_x: max_x, max_y: max_y, floor_y: max_y + 2})
    end

    def draw(grid) do
      grid = add_min_max(grid)

      0..grid.max_y
      |> Enum.each(fn y ->
        grid.min_x..grid.max_x
        |> Enum.map(fn x -> grid[{x, y}] || "." end)
        |> Enum.join("")
        |> IO.puts()
      end)
    end
  end

  defmodule Input do
    @day 14
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
      |> String.split([" -> ", ","], trim: true)
      |> Stream.map(&String.to_integer/1)
      |> Stream.chunk_every(2)
      |> Enum.map(&List.to_tuple/1)
    end
  end
end
