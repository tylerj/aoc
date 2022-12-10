defmodule AdventOfCode.Y2022.Day02Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day02

  setup_all do
    input = "A Y\nB X\nC Z"

    [
      input: input,
      parsed_input: Day02.parse(input)
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day02.part1(input) == 15
    end
  end

  describe "part1.score_lines/1" do
    test "returns expected value", %{parsed_input: parsed} do
      assert Day02.Part1.score_lines(parsed) == [8, 1, 6]
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day02.part2(input) == 12
    end
  end

  describe "part2.score_lines/1" do
    test "returns expected value", %{parsed_input: input} do
      assert Day02.Part2.score_lines(input) == [4, 1, 7]
    end
  end
end
