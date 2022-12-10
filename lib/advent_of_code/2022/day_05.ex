defmodule AdventOfCode.Y2022.Day05 do
  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    {crates, moves} = parse(input)

    moves
    |> Enum.reduce(crates, &move_one_at_a_time/2)
    |> Map.values()
    |> Enum.map(&hd/1)
    |> Enum.join("")
  end

  def part2(input \\ nil) do
    {crates, moves} = parse(input)

    moves
    |> Enum.reduce(crates, &move_in_groups/2)
    |> Map.values()
    |> Enum.map(&hd/1)
    |> Enum.join("")
  end

  def move_one_at_a_time({x, from, to}, crate_map) do
    Enum.reduce(
      1..x,
      crate_map,
      fn _, acc ->
        [crate | tail] = Map.get(acc, from)

        acc
        |> Map.put(from, tail)
        |> Map.update!(to, &[crate | &1])
      end
    )
  end

  def move_in_groups({x, from, to}, crate_map) do
    {moving, staying} = crate_map[from] |> Enum.split(x)

    crate_map
    |> Map.put(from, staying)
    |> Map.update!(to, &(moving ++ &1))
  end

  defmodule Input do
    @day 5
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      [crates, moves] = String.split(input, "\n\n", trim: true)

      {parse_crates(crates), parse_moves(moves)}
    end

    def parse_crates(crates) do
      crates
      |> String.split("\n", trim: true)
      |> Enum.reverse()
      |> Enum.reduce(%{}, &parse_crate_line/2)
    end

    def parse_crate_line(line, crate_map) do
      Regex.scan(~r/(\[(?<letter>.)\]|\s{4})/, line, capture: :all_names)
      |> Enum.with_index(1)
      |> Enum.reduce(crate_map, fn
        {[""], _}, acc -> acc
        {[letter], index}, acc -> Map.update(acc, index, [letter], &[letter | &1])
      end)
    end

    def parse_moves(moves) do
      moves
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_move_line/1)
    end

    def parse_move_line(line) do
      Regex.run(~r/move (\d+) from (\d+) to (\d+)/, line)
      |> tl()
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end
  end
end
