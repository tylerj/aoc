defmodule AdventOfCode.Y2022.Day13 do
  alias __MODULE__.Input

  @keys [[[2]], [[6]]]

  def part1(input \\ nil) do
    input
    |> Input.parse()
    |> Stream.with_index(1)
    |> Stream.map(fn {[a, b], index} ->
      if correct?(a, b), do: index, else: 0
    end)
    |> Enum.sum()
  end

  def part2(input \\ nil) do
    (@keys ++ Input.parse_lines(input))
    |> Enum.sort(fn a, b -> correct?(a, b) end)
    |> Stream.with_index(1)
    |> Stream.map(fn {v, index} ->
      if v in @keys, do: index, else: 1
    end)
    |> Enum.product()
  end

  def correct?([], _), do: true
  def correct?(_, []), do: false
  def correct?([a | t1], [a | t2]), do: correct?(t1, t2)
  def correct?([a | _], [b | _]) when is_integer(a) and is_integer(b) and a < b, do: true
  def correct?([a | _], [b | _]) when is_integer(a) and is_integer(b) and a > b, do: false

  def correct?([a | t1], [b | t2]) when is_list(a) and not is_list(b),
    do: correct?([a | t1], [[b] | t2])

  def correct?([a | t1], [b | t2]) when not is_list(a) and is_list(b),
    do: correct?([[a] | t1], [b | t2])

  def correct?([a | _], [b | _]), do: correct?(a, b)

  defmodule Input do
    @day 13
    @year 2022

    def parse(nil), do: remote_input() |> parse()

    def parse(input) do
      input
      |> String.split("\n\n", trim: true)
      |> Stream.map(&parse_lines/1)
    end

    def parse_lines(nil), do: remote_input() |> parse_lines()

    def parse_lines(lines) do
      lines
      |> String.split("\n", trim: true)
      |> Enum.map(&Jason.decode!/1)
    end

    def remote_input(), do: AdventOfCode.Input.get!(@day, @year)
  end
end
