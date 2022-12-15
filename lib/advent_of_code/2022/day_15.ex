defmodule AdventOfCode.Y2022.Day15 do
  defdelegate parse(input), to: __MODULE__.Input

  @part1_y 2_000_000
  @max_part2 4_000_000

  def part1(input \\ nil, y_axis \\ @part1_y) do
    input = parse(input)
    total = x_ranges_for_y_axis(input, y_axis) |> total_ranges_size()

    # subtract out any beacons on that y axis
    total - beacon_count(input, {nil, y_axis})
  end

  def part2(input \\ nil, min \\ 0, max \\ @max_part2) do
    input = parse(input)

    min..max
    |> Enum.find_value(fn y_axis ->
      case x_ranges_for_y_axis(input, y_axis) do
        [_] ->
          false

        ranges ->
          if x = missing_point_in_ranges(ranges) do
            {x, y_axis}
          else
            nil
          end
      end
    end)
    |> then(fn {x, y} -> x * @max_part2 + y end)
  end

  def x_ranges_for_y_axis(input, y_axis) do
    input
    |> Enum.map(fn {{sx, sy} = sensor_xy, beacon_xy} ->
      manh_distance(sensor_xy, beacon_xy)

      y_distance = abs(sy - y_axis)
      x_distance = manh_distance(sensor_xy, beacon_xy) - y_distance

      if x_distance > 0 do
        (sx - x_distance)..(sx + x_distance)
      else
        nil
      end
    end)
    |> combine_ranges()
  end

  def manh_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def total_ranges_size(ranges) do
    ranges
    |> combine_ranges()
    |> Stream.map(fn first..last -> last - first + 1 end)
    |> Enum.sum()
  end

  def combine_ranges(ranges) do
    [r1 | ranges] = Stream.reject(ranges, &is_nil/1) |> Enum.sort()

    Enum.reduce(ranges, [r1], fn
      _..l2, [_..l1 | _] = ranges when l2 < l1 ->
        ranges

      f2..l2, [f1..l1 | tail] when f2 <= l1 ->
        [f1..l2 | tail]

      r2, ranges ->
        [r2 | ranges]
    end)
    |> Enum.sort()
  end

  def missing_point_in_ranges([_f..l, f.._l]) when l + 2 == f, do: l + 1

  def beacon_count(input, {nil, y}) do
    uniq_beacons(input)
    |> Enum.count(fn
      {_, ^y} -> true
      _ -> false
    end)
  end

  def beacon_count(input, {x, nil}) do
    uniq_beacons(input)
    |> Enum.count(fn
      {^x, _} -> true
      _ -> false
    end)
  end

  def uniq_beacons(input) do
    input
    |> Stream.map(fn {_sensor, beacon} -> beacon end)
    |> Stream.uniq()
  end

  defmodule Input do
    @day 15
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
      input |> Stream.map(&parse_line/1) |> Stream.map(&List.to_tuple/1)
    end

    def parse_line(line) do
      Regex.scan(~r/[xy]=(?<xy>\-?\d+)/, line, capture: :all_names)
      |> Stream.map(fn [v] -> String.to_integer(v) end)
      |> Stream.chunk_every(2)
      |> Enum.map(&List.to_tuple/1)
    end
  end
end
