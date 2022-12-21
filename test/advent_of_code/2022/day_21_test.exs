defmodule AdventOfCode.Y2022.Day21Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day21

  setup_all do
    [
      input:
        "root: pppw + sjmn\ndbpl: 5\ncczh: sllz + lgvd\nzczc: 2\nptdq: humn - dvpt\ndvpt: 3\nlfqf: 4\nhumn: 5\nljgn: 2\nsjmn: drzm * dbpl\nsllz: 4\npppw: cczh / lfqf\nlgvd: ljgn * ptdq\ndrzm: hmdt - zczc\nhmdt: 32"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day21.part1(input) == 152
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day21.part2(input) == 301
    end
  end
end
