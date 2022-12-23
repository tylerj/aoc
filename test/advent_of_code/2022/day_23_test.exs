defmodule AdventOfCode.Y2022.Day23Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day23

  setup_all do
    [
      input: "....#..\n..###.#\n#...#.#\n.#...##\n#.###..\n##.#.##\n.#..#.."
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day23.part1(input) == 110
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day23.part2(input) == 20
    end
  end
end
