defmodule AdventOfCode.Y2022.Day19 do
  defdelegate parse(input), to: __MODULE__.Input

  @priority_keys [:geode, :obsidian, :clay, :ore]

  @empty_robots Map.new(@priority_keys, &{&1, 0})

  @doc """
    {
      minute,
      {ore_robot, coal_robot, obsidian_robot, }
    }
  """
  @initial_state %{
    minute: 0,
    robots: Map.put(@empty_robots, :ore, 1),
    building_robot: nil,
    ore: 0,
    clay: 0,
    obsidian: 0,
    geode: 0
  }

  def initial_state(), do: @initial_state

  def part1(input, num_minutes) do
    parse(input)
    |> Enum.map(fn blueprint ->
      {
        blueprint,
        simulate(@initial_state, blueprint, num_minutes)
      }
    end)
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(& &1)
  end

  def simulate([%{minute: minute} | _] = states, _, total_minutes) when minute >= total_minutes,
    do: states

  def simulate(states, blueprint, total_minutes) do
    states
    |> Enum.map(&simulate_minute(&1, blueprint))
    |> simulate(blueprint, total_minutes)
  end

  def simulate_minute(state, blueprint) do
    possible_robot_builds(state, blueprint)
    |> Enum.map(fn robot_type_to_build ->
      state
      |> build_robot(robot_type_to_build, blueprint)
      |> mine_resources()
      |> add_built_robot()
      |> Map.update!(:minute, &(&1 + 1))
    end)
    |> Enum.uniq()
  end

  def possible_robot_builds(state, blueprint) do
    if can_build_robot?(state, :geode, blueprint) do
      [:geode]
    else
      [nil | Enum.filter(@priority_keys, &can_build_robot?(state, &1, blueprint))]
    end
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

  # def build_robot?(state, type, blueprint) do
  #   can_build_robot?(state, type, blueprint) and need_robot?(state, type, blueprint)
  # end

  # def need_robot?(%{minute: minute}, :ore, _) when minute > 5, do: false
  # def need_robot?(%{minute: minute}, :clay, _) when minute > 14, do: false
  # def need_robot?(%{minute: minute}, :obsidian, _) when minute > 20, do: false

  # def need_robot?(%{robots: robots}, type, _) when minute > 20, do: false

  # def need_robot?(%{robots: robots}, type, blueprint) do
  #   Enum.any?(blueprint, fn
  #     {_, %{^type => v}} -> robots[type] < v
  #     _ -> false
  #   end)
  # end

  def can_build_robot?(state, type, blueprint) do
    Map.get(blueprint, type)
    |> Enum.all?(fn {k, cost} -> state[k] >= cost end)
  end

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
          index: a,
          ore: %{ore: b},
          clay: %{ore: c},
          obsidian: %{ore: d, clay: e},
          geode: %{ore: f, obsidian: g}
        }
      end)
    end

    defp to_int(x), do: Integer.parse(x) |> return_int(x)

    defp return_int({int, ""}, _), do: int
    defp return_int(:error, _input), do: nil

    def flatten([]), do: []
    def flatten(nil), do: []
    def flatten([[a | _] = path | b]) when is_binary(a), do: [Enum.reverse(path) | flatten(b)]
    def flatten([a | b]), do: flatten(a) ++ flatten(b)
    def flatten(v), do: [v]
  end
end
