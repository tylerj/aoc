defmodule AdventOfCode.Y2022.Day15Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day15

  setup_all do
    [
      input:
        "Sensor at x=2, y=18: closest beacon is at x=-2, y=15\nSensor at x=9, y=16: closest beacon is at x=10, y=16\nSensor at x=13, y=2: closest beacon is at x=15, y=3\nSensor at x=12, y=14: closest beacon is at x=10, y=16\nSensor at x=10, y=20: closest beacon is at x=10, y=16\nSensor at x=14, y=17: closest beacon is at x=10, y=16\nSensor at x=8, y=7: closest beacon is at x=2, y=10\nSensor at x=2, y=0: closest beacon is at x=2, y=10\nSensor at x=0, y=11: closest beacon is at x=2, y=10\nSensor at x=20, y=14: closest beacon is at x=25, y=17\nSensor at x=17, y=20: closest beacon is at x=21, y=22\nSensor at x=16, y=7: closest beacon is at x=15, y=3\nSensor at x=14, y=3: closest beacon is at x=15, y=3\nSensor at x=20, y=1: closest beacon is at x=15, y=3"
    ]
  end

  describe "part1/1" do
    test "returns expected value", %{input: input} do
      assert Day15.part1(input, 10) == 26
    end
  end

  describe "part2/1" do
    test "returns expected value", %{input: input} do
      assert Day15.part2(input) == 56_000_011
    end
  end
end
