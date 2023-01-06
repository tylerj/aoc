defmodule AdventOfCode.Y2015.TemplateDay01Test do
  use ExUnit.Case

  import AdventOfCode.Y2015.TemplateDay01

  setup_all do
    [
      input: ""
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert part1(input) == []
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert part2(input) == []
    end
  end
end
