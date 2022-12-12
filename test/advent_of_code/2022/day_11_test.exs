defmodule AdventOfCode.Y2022.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Y2022.Day11

  setup_all do
    [
      input:
        "Monkey 0:\n  Starting items: 79, 98\n  Operation: new = old * 19\n  Test: divisible by 23\n    If true: throw to monkey 2\n    If false: throw to monkey 3\n\nMonkey 1:\n  Starting items: 54, 65, 75, 74\n  Operation: new = old + 6\n  Test: divisible by 19\n    If true: throw to monkey 2\n    If false: throw to monkey 0\n\nMonkey 2:\n  Starting items: 79, 60, 97\n  Operation: new = old * old\n  Test: divisible by 13\n    If true: throw to monkey 1\n    If false: throw to monkey 3\n\nMonkey 3:\n  Starting items: 74\n  Operation: new = old + 3\n  Test: divisible by 17\n    If true: throw to monkey 0\n    If false: throw to monkey 1"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert part1(input) == 10605
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert part2(input) == 2_713_310_158
    end
  end
end
