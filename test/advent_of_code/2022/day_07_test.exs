defmodule AdventOfCode.Y2022.Day07Test do
  use ExUnit.Case

  import AdventOfCode.Y2022.Day07

  setup_all do
    [
      input:
        "$ cd /\n$ ls\ndir a\n14848514 b.txt\n8504156 c.dat\ndir d\n$ cd a\n$ ls\ndir e\n29116 f\n2557 g\n62596 h.lst\n$ cd e\n$ ls\n584 i\n$ cd ..\n$ cd ..\n$ cd d\n$ ls\n4060174 j\n8033020 d.log\n5626152 d.ext\n7214296 k"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert part1(input) == 95437
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert part2(input) == 24_933_642
    end
  end
end
