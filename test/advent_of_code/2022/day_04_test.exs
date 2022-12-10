defmodule AdventOfCode.Y2022.Day04Test do
  use ExUnit.Case

  import AdventOfCode.Y2022.Day04

  setup_all do
    [
      input: "2-4,6-8\n2-3,4-5\n5-7,7-9\n2-8,3-7\n6-6,4-6\n2-6,4-8"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert part1(input) == 2
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert part2(input) == 4
    end
  end
end
