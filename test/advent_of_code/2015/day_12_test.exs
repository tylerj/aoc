defmodule AdventOfCode.Y2015.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Y2015.Day12

  setup_all do
    [
      input: """
      {"e":{"a":{"e":-39,"c":119,"a":{"c":65,"a":"orange","b":"green","d":"red"},"g":"violet"}}}
      """
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert part1(input) == 145
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert part2(input) == 80
    end
  end
end
