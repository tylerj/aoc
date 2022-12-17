defmodule AdventOfCode.Y2022.Day16 do
  alias __MODULE__.Input

  @start_valve "AA"
  @part1_rounds 30
  @part2_rounds 26

  def part1(input \\ nil)

  def part1(input) when is_nil(input) or is_binary(input) do
    input |> Input.parse() |> part1()
  end

  def part1(%{} = grid) do
    next_step(grid, @start_valve, 0, 0, [], 1, @part1_rounds)
    |> Input.flatten()
    |> Enum.sort(:desc)
    |> List.first()
    |> elem(0)
  end

  def part2(input \\ nil)

  def part2(input) when is_binary(input) or is_nil(input) do
    input |> Input.parse() |> part2()
  end

  def part2(%{} = grid) do
    results =
      next_step(grid, @start_valve, 0, 0, [], 1, @part2_rounds)
      |> Input.flatten()
      |> Enum.sort(:desc)

    results
    |> Stream.map(fn {a, [_ | a_list]} ->
      a +
        Enum.find_value(results, fn {b, [_ | b_list]} ->
          a_list -- b_list == a_list && b
        end)
    end)
    |> Enum.max()
  end

  def next_step(_, _, _, total_pressure, open, round, num_rounds) when round > num_rounds do
    {total_pressure, open}
  end

  def next_step(grid, current_valve, current_rate, total_pressure, open, round, num_rounds) do
    grid
    |> Map.get(current_valve)
    |> Enum.filter(fn
      {:rate, _} ->
        false

      {v, d} ->
        v not in open && d < num_rounds - round
    end)
    |> then(fn
      l -> [{@start_valve, num_rounds - round} | l]
    end)
    |> Enum.map(fn {valve, distance} ->
      rate = grid |> Map.get(valve) |> Map.get(:rate, 0)

      num_rounds_to_open = distance + 1

      next_step(
        grid,
        valve,
        current_rate + rate,
        total_pressure + num_rounds_to_open * current_rate,
        [valve | open],
        round + num_rounds_to_open,
        num_rounds
      )
    end)
  end

  defmodule Input do
    @day 16
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
      |> Enum.into(%{})
      |> add_distances()
      |> Stream.reject(fn
        {"AA", _} -> false
        {_, %{rate: rate}} -> rate <= 0
      end)
      |> Stream.map(fn {k, map} -> {k, Map.delete(map, :edges)} end)
      |> Enum.into(%{})
    end

    def parse_line(line) do
      ~r/Valve ([A-Z]+) has flow rate=(\d+); tunnels? leads? to valves? (.+)/
      |> Regex.run(line, capture: :all_but_first)
      |> then(fn [valve, rate, leads_to] ->
        {valve, %{rate: String.to_integer(rate), edges: String.split(leads_to, ", ", trim: true)}}
      end)
    end

    def add_distances(grid) do
      Enum.reduce(grid, grid, fn {valve, _}, acc ->
        Map.update!(acc, valve, fn map ->
          valve_distances(grid, valve)
          |> Enum.reduce(map, fn {k, d, _}, acc ->
            Map.put(acc, k, d)
          end)
        end)
      end)
    end

    def shortest_paths(grid, from, to) do
      paths = paths_to(grid, from, to) |> flatten() |> Enum.sort_by(&length/1)
      l = List.first(paths) |> length()

      Enum.take_while(paths, fn p -> length(p) == l end)
    end

    def paths_to(grid, from, to) do
      paths_to(grid, from, to, from, [from])
    end

    def paths_to(_, _, to, current, path) when to == current, do: path

    def paths_to(grid, from, to, current, path) do
      Map.get(grid, current)
      |> Map.get(:edges)
      |> Enum.map(fn
        node -> if node in path, do: nil, else: paths_to(grid, from, to, node, [node | path])
      end)
    end

    def flatten([]), do: []
    def flatten(nil), do: []
    def flatten([[a | _] = path | b]) when is_binary(a), do: [Enum.reverse(path) | flatten(b)]
    def flatten([a | b]), do: flatten(a) ++ flatten(b)
    def flatten(v), do: [v]

    def valve_distances(grid, valve, open \\ []) do
      grid
      |> Stream.filter(fn {k, %{rate: r}} ->
        k != valve && k not in open && r > 0
      end)
      |> Stream.map(fn {k, %{rate: r}} ->
        d = (shortest_paths(grid, valve, k) |> List.first() |> length()) - 1
        {k, d, r}
      end)
      |> Enum.to_list()
      |> Enum.sort_by(fn {_, _, d} -> -d end)
    end
  end
end
