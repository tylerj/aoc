defmodule AdventOfCode.Y2022.Day20 do
  defdelegate parse(input), to: __MODULE__.Input

  @decryption_key 811_589_153

  def part1(input \\ nil) do
    input = parse(input)
    size = length(input)

    input = Enum.with_index(input)
    final_list = Enum.reduce(input, input, &move_element(&1, &2, size))
    zero_index = Enum.find_index(final_list, fn {x, _} -> x == 0 end)

    [1000, 2000, 3000]
    |> Enum.map(fn offset ->
      final_list
      |> Enum.at(rem(zero_index + offset, size))
      |> elem(0)
    end)
    |> Enum.sum()
  end

  def part2(input \\ nil) do
    input = parse(input)
    size = length(input)

    input =
      input
      |> Enum.map(&(&1 * @decryption_key))
      |> Enum.with_index()

    final_list =
      1..10
      |> Enum.reduce(input, fn _, acc ->
        Enum.reduce(input, acc, &move_element(&1, &2, size))
      end)

    zero_index = Enum.find_index(final_list, fn {x, _} -> x == 0 end)

    [1000, 2000, 3000]
    |> Enum.map(fn offset ->
      final_list
      |> Enum.at(rem(zero_index + offset, size))
      |> elem(0)
    end)
    |> Enum.sum()
  end

  def move_element({0, _}, list, _), do: list

  def move_element({value, _} = element, list, size) do
    current_index = Enum.find_index(list, fn x -> x == element end)

    list
    |> List.delete_at(current_index)
    |> List.insert_at(new_index(current_index, value, size), element)
  end

  # To actually go backwards in the list, we can't just go from index 0 to -1.
  # That's the same spot in the circle, just at the end of the list instead of the beginning.
  # Therefore, we need to subtract one more to get the proper negative index.
  def new_index(current_index, value, size) do
    case rem(current_index + value, size - 1) do
      i when i < 0 -> i - 1
      i -> i
    end
  end

  defmodule Input do
    @day 20
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
      Enum.map(input, &String.to_integer/1)
    end
  end
end
