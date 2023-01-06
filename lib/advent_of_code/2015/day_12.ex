defmodule AdventOfCode.Y2015.Day12 do
  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    Regex.scan(~r/\-?\d+/, parse(input))
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part2(input \\ nil) do
    parse(input)
    |> Jason.decode!()
    |> sum_values(0)
  end

  def sum_values(int, sum) when is_integer(int), do: sum + int

  def sum_values(list, sum) when is_list(list) do
    Enum.reduce(list, sum, &sum_values/2)
  end

  def sum_values(%{} = map, sum) do
    v = Map.values(map)
    if Enum.member?(v, "red"), do: sum, else: sum_values(v, sum)
  end

  def sum_values(_, sum), do: sum

  defmodule Input do
    @day 12
    @year 2015

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      input
    end
  end
end
