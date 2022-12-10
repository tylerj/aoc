defmodule AdventOfCode.Y2022.Day06 do
  alias __MODULE__

  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    input |> parse() |> find_marker(4)
  end

  def part2(input \\ nil) do
    input |> parse() |> find_marker(14)
  end

  def find_marker(char_list, prior_chars \\ [], marker_size, index \\ 0)

  def find_marker([h1 | t1], prior, n, index) when length(prior) < n do
    find_marker(t1, prior ++ [h1], n, index + 1)
  end

  def find_marker([h1 | t1], [_ | t2] = prior, n, index) do
    if set_size(prior) < n,
      do: find_marker(t1, t2 ++ [h1], n, index + 1),
      else: index
  end

  def set_size(list), do: list |> MapSet.new() |> MapSet.size()

  defmodule Input do
    @day 6
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      input |> String.to_charlist()
    end
  end

  defmodule Benchmark do
    defdelegate set_size(list), to: Day06

    def list_recursion(input, n) do
      Day06.find_marker(input, n)
    end

    def chunk(input, n, module) do
      input
      |> module.chunk_every(n, 1)
      |> module.with_index(n)
      |> Enum.find(fn {list, _} ->
        n == set_size(list)
      end)
      |> elem(1)
    end

    def enum_slice(input, n) do
      n..length(input)
      |> Enum.find(fn i ->
        n ==
          input
          |> Enum.slice((i - n)..(i - 1))
          |> set_size()
      end)
    end
  end
end
