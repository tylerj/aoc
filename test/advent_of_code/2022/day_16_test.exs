defmodule AdventOfCode.Y2022.Day16Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day16

  setup_all do
    [
      input:
        "Valve AA has flow rate=0; tunnels lead to valves DD, II, BB\nValve BB has flow rate=13; tunnels lead to valves CC, AA\nValve CC has flow rate=2; tunnels lead to valves DD, BB\nValve DD has flow rate=20; tunnels lead to valves CC, AA, EE\nValve EE has flow rate=3; tunnels lead to valves FF, DD\nValve FF has flow rate=0; tunnels lead to valves EE, GG\nValve GG has flow rate=0; tunnels lead to valves FF, HH\nValve HH has flow rate=22; tunnel leads to valve GG\nValve II has flow rate=0; tunnels lead to valves AA, JJ\nValve JJ has flow rate=21; tunnel leads to valve II"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day16.part1(input) == 1651
    end
  end

  describe "part2" do
    test "returns expected value", %{input: input} do
      assert Day16.part2(input) == 1707
    end
  end
end
