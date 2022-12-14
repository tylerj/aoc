defmodule AdventOfCode.Y2022.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Y2022.Day17

  setup_all do
    [
      input: ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert part1(input) == 3068
    end
  end

  # describe "part2" do
  #   test "returns expected value", %{input: input} do
  #     assert part2(input) == []
  #   end
  # end
end
