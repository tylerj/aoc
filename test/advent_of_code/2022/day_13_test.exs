defmodule AdventOfCode.Y2022.Day13Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day13

  setup_all do
    [
      input:
        "[1,1,3,1,1]\n[1,1,5,1,1]\n\n[[1],[2,3,4]]\n[[1],4]\n\n[9]\n[[8,7,6]]\n\n[[4,4],4,4]\n[[4,4],4,4,4]\n\n[7,7,7,7]\n[7,7,7]\n\n[]\n[3]\n\n[[[]]]\n[[]]\n\n[1,[2,[3,[4,[5,6,7]]]],8,9]\n[1,[2,[3,[4,[5,6,0]]]],8,9]"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day13.part1(input) == 13
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day13.part2(input) == 140
    end
  end
end
