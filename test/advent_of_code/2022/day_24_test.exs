defmodule AdventOfCode.Y2022.Day24Test do
  use ExUnit.Case

  alias AdventOfCode.Y2022.Day24

  setup_all do
    [
      input: "#.######\n#>>.<^<#\n#.<..<<#\n#>v.><>#\n#<^v^^>#\n######.#"
    ]
  end

  describe "part1" do
    test "returns expected value", %{input: input} do
      assert Day24.part1(input) == 18
    end
  end

  # describe "part2" do
  #   test "returns expected value", %{input: input} do
  #     assert Day24.part2(input) == []
  #   end
  # end
end
