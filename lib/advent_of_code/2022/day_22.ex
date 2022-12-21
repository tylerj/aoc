defmodule AdventOfCode.Y2022.Day22 do
  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    input
    |> parse()
    |> Enum.map(& &1)
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> Enum.map(& &1)
  end

  defmodule Input do
    @day 22
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
      # |> String.split(["-", ","], trim: true)
      # |> Enum.map(&String.to_integer/1)
    end
  end
end
