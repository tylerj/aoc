defmodule AdventOfCode.Y2022.Day22Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day22

  setup_all do
    [
      input: AdventOfCode.Input.get!(22, 2022)
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day22.part1(input) == 88226
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day22.part2(input) == 57305
    end
  end
end
