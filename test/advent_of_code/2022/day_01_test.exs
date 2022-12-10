defmodule AdventOfCode.Y2022.Day01Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day01

  setup_all do
    input = "1000\n2000\n3000\n\n4000\n\n5000\n6000\n\n7000\n8000\n9000\n\n10000"

    [
      input: input,
      parsed_input: Day01.parse(input)
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day01.part1(input)
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day01.part2(input)
    end
  end

  describe "find_top_n/2" do
    test "returns top 1 total", %{parsed_input: input} do
      assert Day01.find_top_n(input, 1) == [24000]
    end

    test "returns top 3 totals, in ascending order", %{parsed_input: input} do
      assert Day01.find_top_n(input, 3) == [10000, 11000, 24000]
    end
  end
end
