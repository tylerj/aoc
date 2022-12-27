defmodule AdventOfCode.Y2022.Day19 do
  defdelegate parse(input), to: __MODULE__.Input

  @priority_keys [:geode, :obsidian, :clay, :ore]
  @empty_robots Map.new(@priority_keys, &{&1, 0})
  @initial_state %{
    robots: Map.put(@empty_robots, :ore, 1),
    building_robot: nil,
    ore: 0,
    clay: 0,
    obsidian: 0,
    geode: 0
  }

  def initial_state(), do: @initial_state

  def part1(input \\ nil, num_minutes \\ 24) do
    parse(input)
    |> Enum.map(fn blueprint ->
      Task.async(fn ->
        {
          blueprint.id,
          simulate(@initial_state, blueprint, num_minutes)
        }
      end)
    end)
    |> Task.await_many(:infinity)
    |> Enum.map(fn {id, geodes} -> id * geodes end)
    |> Enum.sum()
  end

  def part2(input \\ nil, num_minutes \\ 32) do
    parse(input)
    |> Enum.take(3)
    |> Enum.map(fn blueprint ->
      Task.async(fn ->
        simulate(@initial_state, blueprint, num_minutes)
      end)
    end)
    |> Task.await_many(:infinity)
    |> Enum.product()
  end

  def simulate(state, blueprint, minutes) do
    cache = :ets.new(String.to_atom("cache_#{blueprint.id}"), [:set])
    stats = :ets.new(String.to_atom("stats_#{blueprint.id}"), [:set])
    :ets.update_counter(stats, :hits, 0, {:hits, 0})
    :ets.update_counter(stats, :misses, 0, {:misses, 0})
    geodes = simulate(state, blueprint, minutes, cache, stats)

    [hits, misses] =
      Enum.map([:hits, :misses], fn key -> Keyword.fetch!(:ets.lookup(stats, key), key) end)

    IO.puts("Blueprint #{blueprint.id} cache hits: #{hits} misses: #{misses} #{inspect(self())}")

    :ets.delete(cache)
    :ets.delete(stats)

    geodes
  end

  def simulate(state, _, 0, _cache, _stats), do: state.geode

  def simulate(state, blueprint, minutes, cache, stats) do
    cache_key = {Map.drop(state, [:building_robot]), minutes}

    case :ets.lookup(cache, cache_key) do
      [{_, cached}] ->
        :ets.update_counter(stats, :hits, 1, {:hits, 0})

        cached

      [] ->
        :ets.update_counter(stats, :misses, 1, {:misses, 0})

        possible_robot_builds(state, blueprint, minutes)
        |> Enum.map(&simulate_minute(&1, state, blueprint))
        |> Enum.map(&simulate(&1, blueprint, minutes - 1, cache, stats))
        |> Enum.max()
        |> tap(fn score -> :ets.insert(cache, {cache_key, score}) end)
    end
  end

  def simulate_minute(robot_type_to_build, state, blueprint) do
    state
    |> build_robot(robot_type_to_build, blueprint)
    |> mine_resources()
    |> add_built_robot()
  end

  def possible_robot_builds(state, blueprint, minutes) do
    @priority_keys
    |> Enum.filter(&should_build_robot?(state, &1, blueprint, minutes))
    |> Enum.take(2)
    |> then(fn types ->
      if :geode in types or :obsidian in types, do: types, else: [nil | types]
    end)
  end

  def mine_resources(%{robots: robots} = state) do
    robots
    |> Enum.reduce(state, fn
      {_, 0}, acc ->
        acc

      {robot_type, count}, acc ->
        Map.update!(acc, robot_type, &(&1 + count))
    end)
  end

  def should_build_robot?(state, type, blueprint, minutes) do
    can_build_robot?(state, type, blueprint) and
      need_robot?(state, type, blueprint) and
      worthwhile?(state, type, blueprint, minutes)
  end

  def can_build_robot?(state, type, blueprint) do
    Map.get(blueprint, type)
    |> Enum.all?(fn {k, cost} -> state[k] >= cost end)
  end

  def need_robot?(%{robots: robots}, type, blueprint),
    do: blueprint.max[type] > robots[type]

  def worthwhile?(_, :geode, _, minutes), do: minutes > 1
  def worthwhile?(_, :obsidian, _, minutes) when minutes <= 2, do: false

  def worthwhile?(state, :obsidian, %{max: max}, minutes),
    do: state.obsidian + state.robots.obsidian * (minutes - 2) < (minutes - 1) * max.obsidian

  def worthwhile?(_, :ore, _, minutes) when minutes <= 2, do: false

  def worthwhile?(state, :ore, %{max: max}, minutes),
    do: state.ore + state.robots.ore * (minutes - 2) < (minutes - 1) * max.ore

  def worthwhile?(_, :clay, _, minutes) when minutes <= 3, do: false

  def worthwhile?(state, :clay, %{max: max}, minutes),
    do: state.clay + state.robots.clay * (minutes - 3) < (minutes - 2) * max.clay

  def build_robot(state, type, blueprint) do
    state
    |> Map.put(:building_robot, type)
    |> deduct_cost(type, blueprint)
  end

  def deduct_cost(state, nil, _), do: state

  def deduct_cost(state, type, blueprint) do
    Map.get(blueprint, type)
    |> Enum.reduce(state, fn {cost_type, cost}, acc ->
      Map.update!(acc, cost_type, &(&1 - cost))
    end)
  end

  def add_built_robot(%{building_robot: nil} = state), do: state

  def add_built_robot(%{robots: robots, building_robot: robot_type} = state) do
    Map.merge(state, %{
      robots: Map.update!(robots, robot_type, &(&1 + 1)),
      building_robot: nil
    })
  end

  defmodule Input do
    @day 19
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
      |> String.split([" ", ":"], trim: true)
      |> Enum.map(&to_int/1)
      |> Enum.reject(&is_nil/1)
      |> then(fn [a, b, c, d, e, f, g] ->
        %{
          id: a,
          ore: %{ore: b},
          clay: %{ore: c},
          obsidian: %{ore: d, clay: e},
          geode: %{ore: f, obsidian: g},
          max: %{ore: Enum.max([b, c, d, f]), clay: e, obsidian: g}
        }
      end)
    end

    defp to_int(x), do: Integer.parse(x) |> return_int(x)

    defp return_int({int, ""}, _), do: int
    defp return_int(:error, _input), do: nil
  end
end
