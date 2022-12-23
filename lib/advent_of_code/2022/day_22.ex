defmodule AdventOfCode.Y2022.Day22 do
  alias __MODULE__.Input

  @facing_values %{
    ?> => 0,
    ?v => 1,
    ?< => 2,
    ?^ => 3
  }

  def part1(input \\ nil) do
    {grid, instructions, start_point} = Input.parse(input)

    process_all_instructions(grid, instructions, start_point, :flat)
  end

  def part2(input \\ nil) do
    {grid, instructions, start_point} = Input.parse(input)

    process_all_instructions(grid, instructions, start_point, :cube)
  end

  def process_all_instructions(grid, instructions, start_point, shape) do
    instructions
    |> Enum.reduce({start_point, ?>}, fn
      dir, acc when dir in 'LR' ->
        change_facing(dir, acc)

      num, acc when is_integer(num) ->
        move(num, acc, grid, shape)
    end)
    |> then(fn {{col, row}, facing} ->
      1000 * row + 4 * col + Map.get(@facing_values, facing)
    end)
  end

  def change_facing(?R, {point, ?^}), do: {point, ?>}
  def change_facing(?R, {point, ?>}), do: {point, ?v}
  def change_facing(?R, {point, ?v}), do: {point, ?<}
  def change_facing(?R, {point, ?<}), do: {point, ?^}
  def change_facing(?L, {point, ?^}), do: {point, ?<}
  def change_facing(?L, {point, ?<}), do: {point, ?v}
  def change_facing(?L, {point, ?v}), do: {point, ?>}
  def change_facing(?L, {point, ?>}), do: {point, ?^}

  def move(num_moves, {point, facing}, grid, shape) do
    Enum.reduce_while(1..num_moves, {point, facing}, fn
      _num, acc ->
        case move_one(acc, grid, shape) do
          {:blocked, _} -> {:halt, acc}
          new_acc -> {:cont, new_acc}
        end
    end)
  end

  def move_one({point, facing}, grid, shape) do
    next_point = next_point(point, facing)

    case Map.get(grid, next_point) do
      ?# -> {:blocked, facing}
      ?. -> {next_point, facing}
      nil -> wrap_next_point(point, facing, grid, shape)
    end
  end

  def next_point({x, y}, ?^), do: {x, y - 1}
  def next_point({x, y}, ?>), do: {x + 1, y}
  def next_point({x, y}, ?v), do: {x, y + 1}
  def next_point({x, y}, ?<), do: {x - 1, y}

  def find_point(grid, point, new_facing, old_facing \\ nil) do
    case grid[point] do
      ?. -> {point, new_facing}
      ?# -> {:blocked, old_facing || new_facing}
      _ -> nil
    end
  end

  def wrap_next_point(xy, facing, grid, :flat), do: flat_wrap_next_point(xy, facing, grid)
  def wrap_next_point(xy, facing, grid, :cube), do: cube_wrap_next_point(xy, facing, grid)

  @doc """
    _ 2 1
    _ 3 _
    5 4 _
    6 _ _
  """
  # Up from 2
  # Right from left of 6
  # Same 6 y relative to 2 x
  def cube_wrap_next_point({x, 1}, ?^, grid) when x in 51..100 do
    find_point(grid, {1, x + 100}, ?>, ?^)
  end

  # Up from 1
  # Up from bottom of 6
  # Same 6 x relative to 1 x
  def cube_wrap_next_point({x, 1}, ?^, grid) when x in 101..150 do
    find_point(grid, {x - 100, 200}, ?^, ?^)
  end

  # Right from 1
  # Left from right of 4
  # Inverted y top to bottom
  # 1 -> 150
  # 2 -> 149
  # ...
  # 50 -> 101
  def cube_wrap_next_point({150, y}, ?>, grid) when y in 1..50 do
    find_point(grid, {100, 151 - y}, ?<, ?>)
  end

  # Down from 1
  # Left from right of 3
  # Same 3 y relative to 1 x
  # 101 -> 51
  # 102 -> 52
  # ...
  # 150 -> 100
  def cube_wrap_next_point({x, 50}, ?v, grid) when x in 101..150 do
    find_point(grid, {100, x - 50}, ?<, ?v)
  end

  # Right from 3
  # Up from bottom of 1
  # Same 1 x relative to 3 y
  def cube_wrap_next_point({100, y}, ?>, grid) when y in 51..100 do
    find_point(grid, {y + 50, 50}, ?^, ?>)
  end

  # Right from 4
  # Left from right of 1
  # Inverted y
  # 101 -> 50
  # 102 -> 49
  # ...
  # 150 -> 1
  def cube_wrap_next_point({100, y}, ?>, grid) when y in 101..150 do
    find_point(grid, {150, 151 - y}, ?<, ?>)
  end

  # Down from 4
  # Left from right of 6
  # Same 6 y relative to 4 x
  def cube_wrap_next_point({x, 150}, ?v, grid) when x in 51..100 do
    find_point(grid, {50, x + 100}, ?<, ?v)
  end

  # Right from 6
  # Up from bottom of 4
  # Same 4 x relative to 6 y
  def cube_wrap_next_point({50, y}, ?>, grid) when y in 151..200 do
    find_point(grid, {y - 100, 150}, ?^, ?>)
  end

  # Down from 6
  # Down from top of 1
  # Same 1 x relative to 6 x
  def cube_wrap_next_point({x, 200}, ?v, grid) when x in 1..50 do
    find_point(grid, {x + 100, 1}, ?v, ?v)
  end

  # Left from 6
  # Down from top of 2
  # Same 2 x relative to 6 y
  def cube_wrap_next_point({1, y}, ?<, grid) when y in 151..200 do
    find_point(grid, {y - 100, 1}, ?v, ?<)
  end

  # Left from 5
  # Right from left of 2
  # Inverted y
  # 101 -> 50
  # 102 -> 49
  # ...
  # 150 -> 1
  def cube_wrap_next_point({1, y}, ?<, grid) when y in 101..150 do
    find_point(grid, {51, 151 - y}, ?>, ?<)
  end

  # Up from 5
  # Right from left of 3
  # Same 3 y relative to 5 x
  def cube_wrap_next_point({x, 101}, ?^, grid) when x in 1..50 do
    find_point(grid, {51, x + 50}, ?>, ?^)
  end

  # Left from 3
  # Down from top of 5
  # Same 5 x relative to 3 y
  def cube_wrap_next_point({51, y}, ?<, grid) when y in 51..100 do
    find_point(grid, {y - 50, 101}, ?v, ?<)
  end

  # Left from 2
  # Right from left of 5
  # Inverted y
  # 1 -> 150
  # 2 ->
  # ...
  # 50 -> 101
  def cube_wrap_next_point({51, y}, ?<, grid) when y in 1..50 do
    find_point(grid, {1, 151 - y}, ?>, ?<)
  end

  # If facing is ?^, then start at y = num_rows and go down to 1
  # Find the first ?. or ?# value
  def flat_wrap_next_point({x, _}, ?^, grid) do
    Enum.find_value(
      grid.num_rows..1//-1,
      &find_point(grid, {x, &1}, ?^)
    )
  end

  # If facing is ?>, then start at x = 1 and go up to num_cols
  def flat_wrap_next_point({_, y}, ?>, grid) do
    Enum.find_value(
      1..grid.num_cols//1,
      &find_point(grid, {&1, y}, ?>)
    )
  end

  # If facing is ?v, then start at y = 1 and go up to num_rows
  def flat_wrap_next_point({x, _}, ?v, grid) do
    Enum.find_value(
      1..grid.num_rows//1,
      &find_point(grid, {x, &1}, ?v)
    )
  end

  # If facing is ?<, then start at x = num_cols go down to 1
  def flat_wrap_next_point({_, y}, ?<, grid) do
    Enum.find_value(
      grid.num_cols..1//-1,
      &find_point(grid, {&1, y}, ?<)
    )
  end

  defmodule Input do
    @day 22
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      with [grid, instructions] <- String.split(input, "\n\n", trim: true) do
        grid = parse_grid(grid)

        {
          grid,
          parse_instructions(instructions),
          start_point(grid)
        }
      end
    end

    def parse_grid(input) do
      grid_lines = String.split(input, "\n", trim: true)

      grid_lines
      |> Enum.with_index(1)
      |> Enum.reduce(%{}, &parse_grid_line/2)
      |> then(fn grid ->
        grid
        |> Map.put(
          :num_rows,
          grid |> Stream.map(fn {{_, y}, _} -> y end) |> Enum.max()
        )
        |> Map.put(
          :num_cols,
          grid |> Stream.map(fn {{x, _}, _} -> x end) |> Enum.max()
        )
      end)
    end

    def parse_grid_line({line, row}, grid) do
      line
      |> String.to_charlist()
      |> Enum.with_index(1)
      |> Enum.reduce(grid, fn
        {?\s, _}, acc -> acc
        {char, col}, acc -> Map.put(acc, {col, row}, char)
      end)
    end

    def parse_instructions(instructions) do
      Regex.scan(~r/(\d+|[LR])/, instructions, capture: :all_but_first)
      |> Enum.map(fn
        ["L"] -> ?L
        ["R"] -> ?R
        [num] -> String.to_integer(num)
      end)
    end

    def start_point(grid, col \\ 1) do
      case Map.get(grid, {col, 1}) do
        ?. -> {col, 1}
        _ -> start_point(grid, col + 1)
      end
    end
  end
end
