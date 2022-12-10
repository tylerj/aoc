defmodule AdventOfCode.Y2022.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Y2022.Day05

  setup_all do
    [
      input:
        "    [D]    \n[N] [C]    \n[Z] [M] [P]\n 1   2   3 \n\nmove 1 from 2 to 1\nmove 3 from 1 to 3\nmove 2 from 2 to 1\nmove 1 from 1 to 2",
      crates: %{1 => ["N", "Z"], 2 => ["D", "C", "M"], 3 => ["P"]}
    ]
  end

  describe "part1/1" do
    test "returns expected value", %{input: input} do
      assert part1(input) == "CMZ"
    end
  end

  describe "part2/1" do
    test "returns expected value", %{input: input} do
      assert part2(input) == "MCD"
    end
  end

  describe "move_one_at_a_time/2" do
    test "reverses order of the crates when moved to another stack", %{crates: crates} do
      assert %{2 => ["M"], 3 => ["C", "D", "P"]} = move_one_at_a_time({2, 2, 3}, crates)
    end
  end

  describe "move_in_groups/2" do
    test "reverses order of the crates when moved to another stack", %{crates: crates} do
      assert %{2 => ["M"], 3 => ["D", "C", "P"]} = move_in_groups({2, 2, 3}, crates)
    end
  end
end
