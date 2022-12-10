defmodule AdventOfCode.Y2022.Day04 do
  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    input
    |> parse()
    |> Enum.count(&fully_contained?/1)
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> Enum.count(&overlapping?/1)
  end

  defp fully_contained?([a1, a2, b1, b2]) do
    (a1 >= b1 and a2 <= b2) or (b1 >= a1 and b2 <= a2)
  end

  defp overlapping?([a1, a2, b1, b2]) do
    (a1 >= b1 and a1 <= b2) or (b1 >= a1 and b1 <= a2)
  end

  defmodule Input do
    @day 4
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

    defp parse_line(line) do
      line
      |> String.split(["-", ","], trim: true)
      |> Enum.map(&String.to_integer/1)
    end
  end
end
