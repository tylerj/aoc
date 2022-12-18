defmodule AdventOfCode.Y2022.Day17 do
  defdelegate parse(input), to: __MODULE__.Input

  @start_grid %{top: 0, bottom: 0, piece_count: 0}

  @part1_num_pieces 2022
  @part2_num_pieces 1_000_000_000_000

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
    |> play(@start_grid, @part1_num_pieces)
    |> Map.get(:top)
  end

  def part2(input \\ nil) do
    input
    |> parse()
    |> calculate_top_row(@part2_num_pieces)
  end

  def calculate_top_row(input, total_pieces) when is_binary(input) do
    parse(input) |> calculate_top_row(total_pieces)
  end

  def calculate_top_row(input, total_pieces) do
    try do
      [
        {row_1_num_pieces, row_1_number},
        {row_2_num_pieces, row_2_number},
        {row_3_num_pieces, row_3_number}
      ] = get_full_top_rows(input, @start_grid, 3).full_rows

      diff_num_pieces_between_full_rows = row_2_num_pieces - row_1_num_pieces
      diff_row_number_between_full_rows = row_2_number - row_1_number

      if row_3_num_pieces - row_2_num_pieces != diff_num_pieces_between_full_rows or
           row_3_number - row_2_number != diff_row_number_between_full_rows do
        raise "Row differences are not identical as expected. Cannot proceed with this logic."
      end

      num_full_row_cycles =
        div(total_pieces - row_1_num_pieces, diff_num_pieces_between_full_rows)

      pieces_through_last_full_cycle =
        row_1_num_pieces + num_full_row_cycles * diff_num_pieces_between_full_rows

      pieces_remaining_after_last_full_cycle = total_pieces - pieces_through_last_full_cycle

      pieces_to_simulate_remaining_count =
        row_1_num_pieces + pieces_remaining_after_last_full_cycle

      top_of_simulation = play(input, @start_grid, pieces_to_simulate_remaining_count).top
      rows_added_to_top = top_of_simulation - row_1_number

      final_top_row_count =
        row_1_number + diff_row_number_between_full_rows * num_full_row_cycles + rows_added_to_top

      final_top_row_count
    rescue
      MatchError -> raise "Could not find any full top rows. Cannot proceed."
    end
  end

  def get_full_top_rows(input, grid, num_full_rows) do
    play(
      input,
      Map.merge(grid, %{num_full_rows: num_full_rows, full_rows: []}),
      100_000
    )
  end

  def play(input, grid, max_pieces) do
    play_next_piece(
      input,
      Map.put(grid, :max_pieces, max_pieces),
      input,
      @pieces
    )
  end

  # END GAME: max_pieces == piece_count
  def play_next_piece(_, %{piece_count: x, max_pieces: x} = grid, _, _), do: grid

  def play_next_piece(_, %{num_full_rows: x, full_rows: rows} = grid, _, _)
      when length(rows) >= x,
      do: grid

  def play_next_piece(input, grid, next_input, []),
    do: play_next_piece(input, grid, next_input, @pieces)

  def play_next_piece(input, grid, next_input, [piece | p_tail]) do
    # if grid.piece_count > 0 && rem(grid.piece_count, 1_000_000) == 0 do
    #   IO.puts("#{grid.top / grid.piece_count}")
    # end

    grid = add_full_top_row(grid)
    next_piece = start_piece(grid, piece)
    # draw_grid(next_piece, grid)
    play_piece(trim_grid(grid), next_piece, next_input, p_tail, input)
  end

  def top_row_full?(grid), do: Enum.all?(1..7, fn x -> grid[{x, grid.top}] end)

  def add_full_top_row(%{full_rows: rows} = grid) when is_list(rows) do
    if top_row_full?(grid) do
      # IO.puts("TOP ROW FULL. TOP: #{grid.top}, COUNT: #{grid.piece_count}")
      Map.put(grid, :full_rows, [{grid.piece_count, grid.top} | rows])
    else
      grid
    end
  end

  def add_full_top_row(grid), do: grid

  def trim_grid(%{top: top, bottom: bottom} = grid) when top - bottom > 2000 do
    # IO.puts("TRIMMING GRID - BOTTOM: #{bottom}, TOP: #{top}")
    bottom..(bottom + 1000 - 1)
    |> Enum.reduce(grid, fn y, acc ->
      Map.drop(acc, Enum.map(1..7, &{&1, y}))
    end)
    |> Map.put(:bottom, bottom + 1000)
  end

  def trim_grid(grid), do: grid

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
