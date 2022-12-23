defmodule AdventOfCode.Y2022.Day23 do
  defdelegate parse(input), to: __MODULE__.Input

  @directions ~w(N S W E)a

  def part1(input \\ nil) do
    input
    |> parse()
    |> move_elves(@directions, 1, 10)
    |> count_empty_tiles()
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> move_elves(@directions, 1)
    |> elem(1)
  end

  def move_elves(grid, directions, round, stop_round \\ nil) do
    # IO.inspect(List.first(directions), label: "MOVING ELVES")
    # :timer.sleep(500)

    with {:ok, proposals} <- gather_proposals(grid, directions) do
      grid
      |> move_proposals(proposals)
      # |> draw_grid("AFTER ROUND #{round}")
      |> then(fn grid ->
        if stop_round && round == stop_round do
          grid
        else
          move_elves(grid, next_directions(directions), round + 1, stop_round)
        end
      end)
    else
      :done -> {grid, round}
    end
  end

  def next_directions([head | tail]), do: tail ++ [head]

  def gather_proposals(grid, directions) do
    grid
    |> Map.keys()
    |> Enum.map(&find_next_spot(&1, grid, directions))
    |> Enum.reject(&is_nil/1)
    |> return_proposals()
  end

  def find_next_spot(xy, grid, directions) do
    if neighbors_empty?(xy, nil, grid) do
      nil
    else
      directions
      |> Enum.find_value(fn direction ->
        if neighbors_empty?(xy, direction, grid) do
          {xy, move_direction(xy, direction)}
        else
          nil
        end
      end)
    end
  end

  def neighbors_empty?(xy, direction, grid) do
    neighbors(xy, direction)
    |> Enum.all?(fn neighbor -> grid[neighbor] |> is_nil() end)
  end

  def neighbors({x, y}, :N),
    do: [{x - 1, y - 1}, {x, y - 1}, {x + 1, y - 1}]

  def neighbors({x, y}, :S),
    do: [{x - 1, y + 1}, {x, y + 1}, {x + 1, y + 1}]

  def neighbors({x, y}, :W),
    do: [{x - 1, y - 1}, {x - 1, y}, {x - 1, y + 1}]

  def neighbors({x, y}, :E),
    do: [{x + 1, y - 1}, {x + 1, y}, {x + 1, y + 1}]

  def neighbors({x, y}, nil) do
    [
      {x, y - 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1},
      {x, y + 1},
      {x - 1, y + 1},
      {x - 1, y},
      {x - 1, y - 1}
    ]
  end

  def move_direction({x, y}, :N), do: {x, y - 1}
  def move_direction({x, y}, :S), do: {x, y + 1}
  def move_direction({x, y}, :W), do: {x - 1, y}
  def move_direction({x, y}, :E), do: {x + 1, y}

  def return_proposals([]), do: :done

  def return_proposals(proposals) do
    {:ok,
     proposals
     |> Enum.reduce(%{}, fn {from, to}, acc ->
       Map.update(acc, to, [from], fn from_list -> [from | from_list] end)
     end)}
  end

  def move_proposals(grid, proposed_moves) do
    proposed_moves
    |> Enum.reduce(grid, fn
      {xy, [from]}, acc -> acc |> Map.delete(from) |> Map.put(xy, ?#)
      _, acc -> acc
    end)
  end

  def count_empty_tiles(grid) do
    {{min_x, max_x}, {min_y, max_y}} = get_min_max_xys(grid)

    min_x..max_x
    |> Enum.map(fn x ->
      Enum.count(min_y..max_y, fn y -> grid[{x, y}] |> is_nil() end)
    end)
    |> Enum.sum()
  end

  def draw_grid(grid, label \\ "") do
    IO.puts(label)

    {{min_x, max_x}, {min_y, max_y}} = get_min_max_xys(grid)

    min_y..max_y
    |> Enum.each(fn y ->
      Enum.map(min_x..max_x, fn x ->
        grid[{x, y}] || ?.
      end)
      |> IO.puts()
    end)

    grid
  end

  def get_min_max_xys(grid) do
    {
      grid |> Enum.map(fn {{x, _}, _} -> x end) |> Enum.min_max(),
      grid |> Enum.map(fn {{_, y}, _} -> y end) |> Enum.min_max()
    }
  end

  defmodule Input do
    @day 23
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
      input
      |> Enum.with_index()
      |> Enum.reduce(%{}, &parse_line/2)
    end

    def parse_line({line, row}, grid) do
      line
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.reduce(grid, fn
        {?#, col}, acc -> Map.put(acc, {col, row}, ?#)
        _, acc -> acc
      end)
    end
  end
end
