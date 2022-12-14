defmodule AdventOfCode.Y2022.Day14Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day14

  setup_all do
    [
      input: "498,4 -> 498,6 -> 496,6\n503,4 -> 502,4 -> 502,9 -> 494,9"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day14.part1(input) == 24
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day14.part2(input) == 93
    end
  end
end
