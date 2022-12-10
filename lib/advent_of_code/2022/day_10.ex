defmodule AdventOfCode.Y2022.Day10 do
  defdelegate parse(input), to: __MODULE__.Input

  @checkpoints [20, 60, 100, 140, 180, 220]
  @row_width 40

  def part1(input \\ nil) do
    input
    |> parse()
    |> Enum.reduce({1, 1, []}, &process_instruction(&1, &2, :part1))
    |> elem(2)
    |> Enum.map(fn {cycle, register} -> cycle * register end)
    |> Enum.sum()
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> Enum.reduce({1, 1, []}, &process_instruction(&1, &2, :part2))
    |> elem(2)
    |> Enum.reverse()
    |> draw_image()
  end

  def process_instruction(["noop"], acc, part), do: do_cycle(acc, part)
  def process_instruction(["addx", v], acc, part), do: do_inc(acc, v, part)

  defp do_cycle(acc, part) do
    acc
    |> capture(part)
    |> increment_cycle()
  end

  defp do_inc(acc, v, part) do
    acc
    |> do_cycle(part)
    |> do_cycle(part)
    |> increment_register(v)
  end

  defp increment_cycle({cycle, register, list}),
    do: {cycle + 1, register, list}

  defp increment_register({count, register, list}, v),
    do: {count, register + v, list}

  defp capture({cycle, register, list}, :part1) when cycle in @checkpoints,
    do: {cycle, register, [{cycle, register} | list]}

  defp capture({cycle, register, list}, :part2) do
    char = if sprite_visible?(cycle, register), do: "#", else: "."

    {cycle, register, [char | list]}
  end

  defp capture(acc, _), do: acc

  defp sprite_visible?(cycle, register) do
    cycle_index = rem(cycle - 1, @row_width)
    cycle_index in (register - 1)..(register + 1)
  end

  defp draw_image(list) do
    list |> Enum.chunk_every(@row_width) |> Enum.each(&IO.puts/1)
  end

  defmodule Input do
    @day 10
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
      |> String.split(" ", trim: true)
      |> Enum.map(&to_int/1)
    end

    defp to_int(x), do: Integer.parse(x) |> return_int(x)

    defp return_int({int, ""}, _), do: int
    defp return_int(:error, input), do: input
  end
end
