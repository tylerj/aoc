defmodule AdventOfCode.Y2022.Day02 do
  alias __MODULE__

  defdelegate parse(input), to: __MODULE__.Input

  def part1(input \\ nil) do
    input
    |> parse()
    |> Day02.Part1.score_lines()
    |> Enum.sum()
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> Day02.Part2.score_lines()
    |> Enum.sum()
  end

  defmodule Part1 do
    @shape_values %{
      :rock => 1,
      :paper => 2,
      :scissors => 3
    }

    @shape_map %{
      "A" => :rock,
      "B" => :paper,
      "C" => :scissors,
      "X" => :rock,
      "Y" => :paper,
      "Z" => :scissors
    }

    @outcome_values %{
      win: 6,
      lose: 0,
      draw: 3
    }

    def score_lines(input) do
      Enum.map(input, &score_line/1)
    end

    def score_line(line) do
      line
      |> String.split(" ", trim: true)
      |> calculate_score()
    end

    def calculate_score([them, me]) when is_binary(them) and is_binary(me) do
      calculate_score(@shape_map[them], @shape_map[me])
    end

    def calculate_score(them, me) when is_atom(them) and is_atom(me) do
      @outcome_values[win_lose_draw(them, me)] + @shape_values[me]
    end

    defp win_lose_draw(a, a), do: :draw
    defp win_lose_draw(:rock, :paper), do: :win
    defp win_lose_draw(:rock, :scissors), do: :lose
    defp win_lose_draw(:paper, :scissors), do: :win
    defp win_lose_draw(:paper, :rock), do: :lose
    defp win_lose_draw(:scissors, :rock), do: :win
    defp win_lose_draw(:scissors, :paper), do: :lose
  end

  defmodule Part2 do
    @shape_values %{
      :rock => 1,
      :paper => 2,
      :scissors => 3
    }

    @shapes %{
      "A" => :rock,
      "B" => :paper,
      "C" => :scissors
    }

    @outcomes %{
      "X" => :lose,
      "Y" => :draw,
      "Z" => :win
    }

    @outcome_values %{
      win: 6,
      lose: 0,
      draw: 3
    }

    def score_lines(input) do
      Enum.map(input, &score_line/1)
    end

    def score_line(line) do
      line
      |> String.split(" ")
      |> calculate_score()
    end

    def calculate_score([them, outcome]) when is_binary(them) and is_binary(outcome) do
      calculate_score(@shapes[them], @outcomes[outcome])
    end

    def calculate_score(them, outcome) do
      @outcome_values[outcome] + @shape_values[my_shape(them, outcome)]
    end

    defp my_shape(them_shape, :draw), do: them_shape
    defp my_shape(:rock, :win), do: :paper
    defp my_shape(:rock, :lose), do: :scissors
    defp my_shape(:paper, :win), do: :scissors
    defp my_shape(:paper, :lose), do: :rock
    defp my_shape(:scissors, :win), do: :rock
    defp my_shape(:scissors, :lose), do: :paper
  end

  defmodule Input do
    @day 2
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      input |> String.split("\n", trim: true)
    end
  end
end
