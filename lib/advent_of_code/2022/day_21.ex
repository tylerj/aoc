defmodule AdventOfCode.Y2022.Day21 do
  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    input
    |> parse()
    |> solve("root")
    |> trunc()
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> Map.update!("root", fn {_, a, b} ->
      {:==, a, b}
    end)
    |> search(1, 0)
  end

  def solve(map, key) when is_binary(key), do: solve(map, map[key])
  def solve(_, num) when is_integer(num), do: num

  def solve(map, {:==, a, b}) do
    a = solve(map, a) |> trunc()
    b = solve(map, b) |> trunc()

    {a - b, a, b}
  end

  def solve(map, {op, a, b}),
    do: apply(Kernel, op, [solve(map, a), solve(map, b)])

  def search(map, root, exponent) do
    value = root * 10 ** exponent

    map
    |> Map.put("humn", value)
    |> solve("root")
    # |> then(fn {diff, _, _} = res ->
    #   IO.puts("DIFF: #{diff}, VALUE: #{value}")
    #   res
    # end)
    |> handle_result(map, root, exponent)
  end

  def handle_result({0, _, _}, _map, root, exp), do: root * 10 ** exp

  def handle_result({diff, _, _}, map, 1, 0) when diff < 0 do
    map
    |> Map.update!("root", fn {:==, a, b} -> {:==, b, a} end)
    |> search(1, 0)
  end

  def handle_result({diff, _, _}, map, 1, exp) when diff > 0 do
    search(map, 1, exp + 1)
  end

  def handle_result(_, map, 1, exp) do
    search(map, 2, exp - 1)
  end

  def handle_result({diff, _, _}, map, root, exp) when diff > 0 do
    search(map, root + 1, exp)
  end

  def handle_result(_, map, root, exp) do
    search(map, (root - 1) * 10 + 1, exp - 1)
  end

  defmodule Input do
    @day 21
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
      input
      |> Stream.map(&parse_line/1)
      |> Enum.into(%{})
    end

    def parse_line(line) do
      line
      |> String.split([": ", " "], trim: true)
      |> then(fn
        [name, number] -> {name, String.to_integer(number)}
        [name, a, op, b] -> {name, {String.to_atom(op), a, b}}
      end)
    end
  end
end
