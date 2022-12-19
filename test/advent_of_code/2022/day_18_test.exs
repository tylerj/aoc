defmodule AdventOfCode.Y2022.Day18Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day18

  setup_all do
    [
      input:
        "2,2,2\n1,2,2\n3,2,2\n2,1,2\n2,3,2\n2,2,1\n2,2,3\n2,2,4\n2,2,6\n1,2,5\n3,2,5\n2,1,5\n2,3,5"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day18.part1(input) == 64
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day18.part2(input) == 58
    end
  end
end
