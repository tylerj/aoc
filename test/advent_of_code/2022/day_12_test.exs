defmodule AdventOfCode.Y2022.Day12Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day12

  setup_all do
    [
      input: "Sabqponm\nabcryxxl\naccszExk\nacctuvwj\nabdefghi"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day12.part1(input) == 31
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day12.part2(input) == 29
    end
  end
end
