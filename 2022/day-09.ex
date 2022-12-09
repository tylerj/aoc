defmodule Day09 do
  defmodule Input do
    def parse(input) when is_binary(input) do
      input
      |> String.split("\n")
      |> parse()
    end

    def parse(input) when is_list(input) do
      Stream.map(input, &parse_line/1)
    end

    def parse_line(line) do
      line
      |> String.split(" ")
      |> then(fn [dir, num] -> [dir, String.to_integer(num)] end)
    end
  end

  defmodule Part1 do
    @init_state {{0, 0}, {0, 0}, MapSet.new([{0, 0}])}

    def part1(input) do
      input
      |> Day09.Input.parse()
      |> Enum.reduce(@init_state, &make_moves/2)
      |> elem(2)
      |> MapSet.size()
    end

    defp make_moves([move, num], state) do
      for _ <- 1..num, reduce: state do
        acc -> make_move(move, acc)
      end
    end

    defp make_move(dir, {head_xy, tail_xy, set}) do
      new_head_xy = move_head(head_xy, dir)
      new_tail_xy = move_tail(tail_xy, new_head_xy, head_xy)

      {new_head_xy, new_tail_xy, MapSet.put(set, new_tail_xy)}
    end

    def move_head({x, y}, "U"), do: {x, y + 1}
    def move_head({x, y}, "D"), do: {x, y - 1}
    def move_head({x, y}, "L"), do: {x - 1, y}
    def move_head({x, y}, "R"), do: {x + 1, y}

    defp move_tail({a, _}, {b, _}, old_head) when abs(a - b) > 1, do: old_head
    defp move_tail({_, a}, {_, b}, old_head) when abs(a - b) > 1, do: old_head
    defp move_tail(tail_xy, _, _), do: tail_xy
  end

  defmodule Part2 do
    @init_list List.duplicate({0, 0}, 10)
    @init_state {@init_list, MapSet.new([{0, 0}])}

    def part2(input) do
      input
      |> Day09.Input.parse()
      |> Enum.reduce(@init_state, &make_moves/2)
      |> elem(1)
      |> MapSet.size()
    end

    defp make_moves([move, num], state) do
      for _ <- 1..num, reduce: state do
        acc -> make_move(move, acc)
      end
    end

    defp make_move(dir, {[head | tail], set}) do
      new_head = Day09.Part1.move_head(head, dir)
      new_tails = move_tails(tail, new_head)

      {[new_head | new_tails], add(set, new_tails)}
    end

    defp add(set, tails), do: MapSet.put(set, List.last(tails))

    defp move_tails([xy | tail], prior) do
      new_xy = move_tail(xy, prior)

      [new_xy | move_tails(tail, new_xy)]
    end

    defp move_tails([], _), do: []

    defp move_tail({tx, ty}, {hx, hy}) when abs(hx - tx) > 1 or abs(hy - ty) > 1 do
      x =
        cond do
          hx > tx -> 1
          hx < tx -> -1
          hx == tx -> 0
        end

      y =
        cond do
          hy > ty -> 1
          hy < ty -> -1
          hy == ty -> 0
        end

      {tx + x, ty + y}
    end

    defp move_tail(tail_xy, _), do: tail_xy
  end
end
