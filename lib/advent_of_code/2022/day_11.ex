defmodule AdventOfCode.Y2022.Day11 do
  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    map = parse(input)
    count = Map.new(Map.keys(map), &{&1, 0})

    Enum.reduce(map, {0, 20, 3, false, count, map}, fn {idx, monkey}, acc ->
      Enum.reduce(monkey[:items], acc, &process_item(idx, &1, &2))
    end)
    |> parse_answer()
  end

  def part2(input \\ nil) do
    map = parse(input)
    count = Map.new(Map.keys(map), &{&1, 0})

    Enum.reduce(map, {0, 10000, 1, mod_trick(map), count, map}, fn {idx, monkey}, acc ->
      Enum.reduce(monkey[:items], acc, &process_item(idx, &1, &2))
    end)
    |> parse_answer()
  end

  defp mod_trick(map) do
    map |> Map.values() |> Enum.map(& &1.test) |> Enum.product()
  end

  defp process_item(_, _, {round, round, div_by, mod_by, count, map}) do
    {0, round, div_by, mod_by, count, map}
  end

  defp process_item(idx, item, {round, total_rounds, div_by, mod_by, count, map}) do
    %{op: {op, opx}} = monkey = map[idx]

    count = Map.update!(count, idx, &(&1 + 1))
    item = if mod_by, do: rem(item, mod_by), else: item
    item = apply(Kernel, op, [item, opx]) |> div(div_by)
    next = if rem(item, monkey[:test]) == 0, do: monkey[:ift], else: monkey[:iff]
    round = if next > idx, do: round, else: round + 1

    process_item(next, item, {round, total_rounds, div_by, mod_by, count, map})
  end

  def parse_answer(acc) do
    acc
    |> elem(4)
    |> Map.values()
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  defmodule Input do
    @day 11
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      input
      |> String.split("\n\n", trim: true)
      |> parse()
    end

    def parse(input) when is_list(input) do
      input
      |> Stream.map(&parse_line/1)
      |> Enum.into(%{})
    end

    def parse_line(line) do
      line
      |> String.split("\n", trim: true)
      |> parse_line_item()
      |> Enum.into(%{})
      |> then(fn %{monkey: index} = map ->
        {index, map}
      end)
    end

    def parse_line_item([monkey, items, op, test, ift, iff]) do
      %{
        monkey: parse_monkey(monkey),
        items: parse_items(items),
        op: parse_op(op),
        test: parse_test(test),
        ift: parse_ift(ift),
        iff: parse_iff(iff)
      }
    end

    import String, only: [to_integer: 1]

    defp parse_monkey(<<"Monkey ", idx::binary-size(1), _::binary>>),
      do: to_integer(idx)

    defp parse_test(<<"  Test: divisible by ", rest::binary>>),
      do: to_integer(rest)

    defp parse_ift(<<"    If true: throw to monkey ", idx::binary-size(1)>>),
      do: to_integer(idx)

    defp parse_iff(<<"    If false: throw to monkey ", idx::binary-size(1)>>),
      do: to_integer(idx)

    defp parse_items("  Starting items: " <> items),
      do: String.split(items, ", ") |> Enum.map(&to_integer/1)

    defp parse_op(<<"  Operation: new = old ", rest::binary>>) do
      case String.split(rest, " ") do
        [_op, "old"] -> {:**, 2}
        [op, val] -> {String.to_atom(op), to_integer(val)}
      end
    end
  end
end
