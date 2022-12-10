defmodule AdventOfCode.Y2022.Day06Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day06

  describe "part1/1" do
    test "returns expected value" do
      assert Day06.part1("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
      assert Day06.part1("nppdvjthqldpwncqszvftbrmjlhg") == 6
      assert Day06.part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
      assert Day06.part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11
    end
  end

  describe "part2/1" do
    test "returns expected value" do
      assert Day06.part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
      assert Day06.part2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
      assert Day06.part2("nppdvjthqldpwncqszvftbrmjlhg") == 23
      assert Day06.part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
      assert Day06.part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26
    end
  end

  describe "Benchmarks" do
    setup do
      [
        input: Day06.parse("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"),
        p1_n: 4,
        p1_value: 11,
        p2_n: 14,
        p2_value: 26
      ]
    end

    test "returns expected value for part 1", %{input: input, p1_value: x, p1_n: n} do
      assert x == Day06.Benchmark.list_recursion(input, n)
      assert x == Day06.Benchmark.chunk(input, n, Enum)
      assert x == Day06.Benchmark.chunk(input, n, Stream)
      assert x == Day06.Benchmark.enum_slice(input, n)
    end

    test "returns expected value for part 2", %{input: input, p2_value: x, p2_n: n} do
      assert x == Day06.Benchmark.list_recursion(input, n)
      assert x == Day06.Benchmark.chunk(input, n, Enum)
      assert x == Day06.Benchmark.chunk(input, n, Stream)
      assert x == Day06.Benchmark.enum_slice(input, n)
    end
  end
end
