defmodule AdventOfCode.Y2022.Day03Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day03

  setup_all do
    [
      input:
        "vJrwpWtwJgWrhcsFMMfFFhFp\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\nPmmdzqPrVvPwwTWBwg\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\nttgJtRGJQctTZtZT\nCrZsJsPPZsGzwwsLwLmpwMDw"
    ]
  end

  describe "Part1.call/1" do
    test "returns expected value", %{input: input} do
      assert Day03.Part1.call(input) == 157
    end
  end

  describe "Part2.call/1" do
    test "returns expected value", %{input: input} do
      assert Day03.Part2.call(input) == 70
    end
  end
end
