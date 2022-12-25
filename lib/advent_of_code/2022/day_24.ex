defmodule AdventOfCode.Y2022.Day24 do
  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    grid = parse(input)

    progress_minute([grid.start_point], 1, grid)
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> Enum.map(& &1)
  end

  def progress_minute(points, minute, grid) do
    with new_grid <- progress_blizzard(grid),
         new_points <- expand_points(points, new_grid) do
      # :timer.sleep(1000)
      # IO.puts("Minute #{minute}:")
      # draw(new_grid, new_points)

      if grid.end_point in new_points do
        minute
      else
        progress_minute(new_points, minute + 1, new_grid)
      end
    end
  end

  def expand_points(
        points,
        %{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y, end_point: end_point} = grid
      ) do
    points
    |> Enum.flat_map(fn {x, y} ->
      [
        {x, y},
        {x - 1, y},
        {x + 1, y},
        {x, y - 1},
        {x, y + 1}
      ]
    end)
    |> Enum.uniq()
    # |> IO.inspect(label: "NEW POINTS PRE")
    |> Enum.filter(fn
      ^end_point ->
        true

      {x, y} when x in min_x..max_x and y in min_y..max_y ->
        Enum.empty?(grid[{x, y}])

      _ ->
        false
    end)

    # |> IO.inspect(label: "NEW POINTS POST")
  end

  def progress_blizzard(grid) do
    grid
    |> Enum.reduce(grid, fn
      {_, []}, acc ->
        acc

      {xy, directions}, acc when is_list(directions) ->
        Enum.reduce(directions, acc, &move_direction(&1, xy, &2))

      _, acc ->
        acc
    end)
  end

  def move_direction(direction, xy, grid) do
    grid
    |> Map.update!(
      xy,
      fn list -> List.delete(list, direction) end
    )
    |> Map.update!(
      new_xy(direction, xy, grid),
      fn list -> [direction | list] end
    )
  end

  def new_xy(?^, {x, y}, %{min_y: y, max_y: max_y}), do: {x, max_y}
  def new_xy(?v, {x, y}, %{max_y: y, min_y: min_y}), do: {x, min_y}
  def new_xy(?<, {x, y}, %{min_x: x, max_x: max_x}), do: {max_x, y}
  def new_xy(?>, {x, y}, %{max_x: x, min_x: min_x}), do: {min_x, y}

  def new_xy(?^, {x, y}, _), do: {x, y - 1}
  def new_xy(?v, {x, y}, _), do: {x, y + 1}
  def new_xy(?<, {x, y}, _), do: {x - 1, y}
  def new_xy(?>, {x, y}, _), do: {x + 1, y}

  def draw(grid, points \\ []) do
    0..(grid.max_y + 1)
    |> Enum.each(fn y ->
      0..(grid.max_x + 1)
      |> Enum.map(fn x ->
        cond do
          {x, y} in points ->
            "E"

          grid.start_point == {x, y} ->
            "."

          grid.end_point == {x, y} ->
            "."

          x < grid.min_x ->
            "#"

          x > grid.max_x ->
            "#"

          y < grid.min_y ->
            "#"

          y > grid.max_y ->
            "#"

          grid[{x, y}] == [] ->
            "."

          true ->
            case grid[{x, y}] do
              [] -> "."
              [dir] -> List.to_string([dir])
              list -> list |> length() |> to_string()
            end
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    grid
  end

  defmodule Input do
    @day 24
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
      input =
        input
        |> Enum.map(&String.to_charlist/1)
        |> Enum.with_index()

      first_row = Enum.at(input, 0)
      last_row = Enum.at(input, -1)

      rows = Enum.slice(input, 1..-2)

      grid = %{
        min_x: 1,
        max_x: (first_row |> elem(0) |> length()) - 2,
        min_y: 1,
        max_y: (last_row |> elem(1)) - 1,
        start_point: {
          first_row |> elem(0) |> Enum.find_index(&(&1 == ?.)),
          first_row |> elem(1)
        },
        end_point: {
          last_row |> elem(0) |> Enum.find_index(&(&1 == ?.)),
          last_row |> elem(1)
        }
      }

      Enum.reduce(rows, grid, &parse_row/2)
    end

    def parse_row({chars, y}, grid) do
      chars
      |> Enum.with_index()
      |> Enum.reduce(grid, fn
        {?#, _}, acc -> acc
        {?., x}, acc -> Map.put(acc, {x, y}, [])
        {char, x}, acc -> Map.put(acc, {x, y}, [char])
      end)
    end
  end
end
