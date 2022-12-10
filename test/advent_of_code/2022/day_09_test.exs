defmodule AdventOfCode.Y2022.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Y2022.Day09

  setup_all do
    [
      input1: "R 4\nU 4\nL 3\nD 1\nR 4\nD 1\nL 5\nR 2",
      input2: "R 5\nU 8\nL 8\nD 3\nR 17\nD 10\nL 25\nU 20"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input1: input} do
      assert part1(input) == 13
    end
  end

  describe "part2" do
    test "returns expected value", %{input1: input1, input2: input2} do
      assert part2(input1) == 1
      assert part2(input2) == 36
    end
  end
end
