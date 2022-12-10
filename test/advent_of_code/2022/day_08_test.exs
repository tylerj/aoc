defmodule AdventOfCode.Y2022.Day08Test do
  use ExUnit.Case

  import AdventOfCode.Y2022.Day08

  setup_all do
    [
      input: "30373\n25512\n65332\n33549\n35390"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert part1(input) == 21
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert part2(input) == 8
    end
  end
end
