defmodule AdventOfCode.Y2022.Day03 do
  alias __MODULE__

  def part1(input \\ nil), do: Day03.Part1.call(input)
  def part2(input \\ nil), do: Day03.Part2.call(input)

  defmodule Part1 do
    def call(input) do
      input
      |> Day03.Input.parse()
      |> Stream.map(&String.to_charlist/1)
      |> Stream.map(&Enum.split(&1, round(length(&1) / 2)))
      |> Stream.map(&find_common_char/1)
      |> Stream.map(&char_value/1)
      |> Enum.sum()
    end

    defp find_common_char({left, right}) do
      Enum.find(left, &Enum.member?(right, &1))
    end

    def char_value(x) when x in ?a..?z, do: x - 96
    def char_value(x) when x in ?A..?Z, do: x - 38
  end

  defmodule Part2 do
    def call(input) do
      input
      |> Day03.Input.parse()
      |> Stream.map(&String.to_charlist/1)
      |> Stream.chunk_every(3)
      |> Stream.map(&process_group/1)
      |> Enum.sum()
    end

    def process_group(list) do
      list
      |> intersections()
      |> Enum.at(0)
      |> Day03.Part1.char_value()
    end

    def intersections([last_item]),
      do: MapSet.new(last_item)

    def intersections([head | tail]),
      do: MapSet.intersection(MapSet.new(head), intersections(tail))
  end

  defmodule Input do
    @day 3
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      input |> String.split("\n", trim: true)
    end
  end
end
