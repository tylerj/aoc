defmodule AdventOfCode.Y2022.Day12 do
  defdelegate parse(input), to: __MODULE__.Input

  alias __MODULE__.{Mover, Queue}

  def part1(input \\ nil) do
    input
    |> parse()
    |> find_end()
    |> Map.get(:endpoint)
    |> elem(1)
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> find_start()
    |> Map.get(:endpoint)
    |> elem(1)
  end

  def draw_part1(input \\ nil) do
    grid = parse(input)
    %{endpoint: {xy, _}} = coords = find_end(grid)

    draw_path(grid, MapSet.new(coords[xy]))
  end

  def draw_part2(input \\ nil) do
    grid = parse(input)
    %{endpoint: {xy, _}} = coords = find_start(grid)

    draw_path(grid, MapSet.new(coords[xy]))
  end

  def draw_path(grid, path, char \\ " ") do
    xs = for {{x, _}, _} <- grid, do: x
    ys = for {{_, y}, _} <- grid, do: y

    Enum.min(ys)..Enum.max(ys)
    |> Enum.each(fn y ->
      Enum.min(xs)..Enum.max(xs)
      |> Enum.map(fn x ->
        if MapSet.member?(path, {x, y}), do: char, else: grid[{x, y}]
      end)
      |> IO.puts()
    end)
  end

  defp find_end(%{?S => start_xy, ?E => end_xy} = grid) do
    Mover.navigate(
      {
        %{start_xy => []},
        Queue.add([], start_xy, 0)
      },
      grid,
      end_xy,
      :forward
    )
  end

  defp find_start(%{?E => end_xy} = grid) do
    Mover.navigate(
      {
        %{end_xy => []},
        Queue.add([], end_xy, 0)
      },
      grid,
      ?a,
      :backward
    )
  end

  defmodule Mover do
    # Endpoint found. EXIT.
    def navigate({%{endpoint: _} = seen, _}, _, _, _), do: seen

    def navigate({seen, [{weight, xy} | queue]}, grid, the_end, dir) do
      new_xys(xy)
      |> Enum.reduce({seen, queue}, fn next_xy, acc ->
        move(
          acc,
          %{
            xy: xy,
            next_xy: next_xy,
            this: grid[xy],
            next: grid[next_xy],
            end: the_end,
            weight: weight,
            dir: dir
          }
        )
      end)
      |> navigate(grid, the_end, dir)
    end

    def move(acc, %{next: nil}), do: acc

    def move(acc, %{this: this, next: next, dir: :forward}) when next - this > 1,
      do: acc

    def move(acc, %{this: this, next: next, dir: :backward}) when this - next > 1,
      do: acc

    # EXIT: found the end
    def move({seen, queue}, %{end: the_end, xy: xy, next_xy: next_xy, next: next, weight: wt})
        when the_end in [next_xy, next],
        do: {
          seen |> update_seen(xy, next_xy) |> Map.put(:endpoint, {next_xy, wt + 1}),
          queue
        }

    def move({seen, queue}, %{xy: xy, next_xy: next_xy, weight: weight}) do
      if seen[next_xy] do
        {seen, queue}
      else
        {
          update_seen(seen, xy, next_xy),
          Queue.add(queue, next_xy, weight + 1)
        }
      end
    end

    defp update_seen(seen, xy, next_xy), do: Map.put(seen, next_xy, [next_xy | seen[xy]])

    def new_xys({x, y}),
      do: [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x + 1, y}]
  end

  defmodule Queue do
    def add([{lowest_weight, _} | _] = queue, xy, weight) when weight <= lowest_weight do
      [{weight, xy} | queue]
    end

    def add([head | tail], xy, weight) do
      [head | add(tail, xy, weight)]
    end

    def add([], xy, weight) do
      [{weight, xy}]
    end
  end

  defmodule Input do
    @day 12
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      input
      |> String.split("\n", trim: true)
      |> parse()
      |> put_start()
      |> put_end()
    end

    def parse(input) when is_list(input) do
      input
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, y}, acc ->
        row
        |> String.to_charlist()
        |> Enum.with_index()
        |> Enum.into(acc, fn {col, x} -> {{x, y}, col} end)
      end)
    end

    def put_start(grid) do
      start_xy = find_value(grid, ?S)
      grid |> Map.put(?S, start_xy) |> Map.put(start_xy, ?a)
    end

    def put_end(grid) do
      end_xy = find_value(grid, ?E)
      grid |> Map.put(?E, end_xy) |> Map.put(end_xy, ?z)
    end

    defp find_value(grid, value) do
      Enum.find_value(grid, fn
        {k, ^value} -> k
        _ -> nil
      end)
    end
  end
end
