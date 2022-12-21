defmodule AdventOfCode.Y2022.Day20Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day20

  setup_all do
    [
      input: "1\n2\n-3\n3\n-2\n0\n4"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day20.part1(input) == 3
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day20.part2(input) == 1_623_178_306
    end
  end
end
