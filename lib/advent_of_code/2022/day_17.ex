defmodule AdventOfCode.Y2022.Day17 do
  defdelegate parse(input), to: __MODULE__.Input

  @start_grid %{top: 0, piece_count: 0, max_pieces: 2022}

  # Each piece should have units placed according to the following:
  # {x, top + y}
  # i.e.
  # {
  #   use this as the x coordinate,
  #   add this to the current top as the y coordinate
  # }
  @h_line [{3, 4}, {4, 4}, {5, 4}, {6, 4}]
  @plus [{3, 5}, {4, 5}, {5, 5}, {4, 4}, {4, 6}]
  @l [{3, 4}, {4, 4}, {5, 4}, {5, 5}, {5, 6}]
  @v_line [{3, 4}, {3, 5}, {3, 6}, {3, 7}]
  @square [{3, 4}, {4, 4}, {3, 5}, {4, 5}]
  @pieces [@h_line, @plus, @l, @v_line, @square]

  def grid, do: @start_grid
  def pieces, do: @pieces

  def part1(input \\ nil) do
    input
    |> parse()
    |> play(@start_grid)
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> Enum.map(& &1)
  end

  def play(input, grid),
    do: play_next_piece(input, grid, [], @pieces)

  # END GAME: max_pieces == piece_count
  def play_next_piece(_, %{piece_count: x, max_pieces: x} = grid, _, _), do: grid

  def play_next_piece(input, grid, next_input, []),
    do: play_next_piece(input, grid, next_input, @pieces)

  # def play_next_piece(input, grid, [], pieces),
  #   do: play_next_piece(input, grid, input, pieces)

  def play_next_piece(input, grid, next_input, [piece | p_tail]) do
    next_piece = start_piece(grid, piece)
    IO.puts("Rock begins falling (##{grid.piece_count + 1}):")
    # draw_grid(next_piece, grid)
    play_piece(grid, next_piece, next_input, p_tail, input)
  end

  def play_piece(grid, piece, [], next_pieces, full_input),
    do: play_piece(grid, piece, full_input, next_pieces, full_input)

  def play_piece(grid, piece, [direction | input], next_pieces, full_input) do
    case play_round(grid, piece, direction) do
      %{} = new_grid ->
        # IO.puts("Rock comes to rest:")
        # draw_grid([], new_grid)
        play_next_piece(full_input, new_grid, input, next_pieces)

      moved_piece when is_list(moved_piece) ->
        play_piece(grid, moved_piece, input, next_pieces, full_input)
    end
  end

  def play_round(grid, piece, direction) do
    piece
    |> jet(grid, direction)
    |> down(grid)
  end

  def jet(piece, grid, ?>) do
    with {_, new_piece} <- move(piece, grid, 1, 0) do
      # IO.puts("Jet of gas pushes rock right:")
      # draw_grid(new_piece, grid)
      new_piece
    end
  end

  def jet(piece, grid, ?<) do
    with {_, new_piece} <- move(piece, grid, -1, 0) do
      # IO.puts("Jet of gas pushes rock left:")
      # draw_grid(new_piece, grid)
      new_piece
    end
  end

  def down(piece, grid) do
    with {:ok, new_piece} <- move(piece, grid, 0, -1) do
      # IO.puts("Rock falls 1 unit:")
      # draw_grid(new_piece, grid)
      new_piece
    else
      {:blocked, piece} -> put_piece(piece, grid)
    end
  end

  def move(piece, grid, x_mod, y_mod) do
    new_piece = Enum.map(piece, fn {x, y} -> {x + x_mod, y + y_mod} end)

    if valid_piece?(new_piece, grid), do: {:ok, new_piece}, else: {:blocked, piece}
  end

  def valid_piece?(piece, grid) do
    Enum.all?(piece, &valid_xy?(&1, grid))
  end

  def valid_xy?({0, _}, _), do: false
  def valid_xy?({8, _}, _), do: false
  def valid_xy?({_, 0}, _), do: false
  def valid_xy?(xy, grid), do: is_nil(Map.get(grid, xy))

  def put_piece(piece, grid) do
    Enum.reduce(piece, grid, fn xy, acc -> Map.put(acc, xy, ?#) end)
    |> Map.update!(:top, fn top ->
      top_of_piece = piece |> Enum.map(fn {_, y} -> y end) |> Enum.max()
      max(top, top_of_piece)
    end)
    |> Map.update!(:piece_count, &(&1 + 1))
  end

  # Return list of {x, y} coords of all spots the piece should start
  def start_piece(%{top: top}, piece) do
    Enum.map(piece, fn {x, y} -> {x, y + top} end)
  end

  def draw_grid(piece, grid) do
    (grid.top + 7)..0//-1
    |> Enum.each(fn y ->
      0..8
      |> Enum.map(fn x ->
        case {x, y} do
          {0, 0} -> '+'
          {8, 0} -> '+'
          {_, 0} -> '-'
          {0, _} -> '|'
          {8, _} -> '|'
          xy -> if xy in piece, do: '@', else: grid[xy] || '.'
        end
      end)
      |> IO.puts()
    end)
  end

  defmodule Input do
    @day 17
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input), do: input |> String.trim() |> String.to_charlist()
    def parse(input) when is_list(input), do: input
  end
end
