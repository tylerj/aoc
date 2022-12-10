defmodule AdventOfCode.Y2022.Day07 do
  alias __MODULE__

  def part1(input \\ nil) do
    __MODULE__.Part1.part1(input)
  end

  def part2(input \\ nil) do
    __MODULE__.Part2.part2(input)
  end

  defmodule Input do
    @day 7
    @year 2022

    def parse(nil) do
      AdventOfCode.Input.get!(@day, @year) |> parse()
    end

    def parse(input) when is_binary(input) do
      input
      |> String.split("\n", trim: true)
      |> parse()
    end

    def parse(input) when is_list(input) do
      Stream.map(input, &parse_line/1)
    end

    defp parse_line("$ ls"), do: :ls
    defp parse_line("$ cd " <> dir), do: {:cd, dir}
    defp parse_line("dir " <> dir), do: {:dir, dir}

    defp parse_line(file) do
      with [size, name] <- String.split(file, " ") do
        {:file, {name, String.to_integer(size)}}
      end
    end
  end

  defmodule Directory do
    defstruct [:name, :parent, size: 0, files: [], children: []]

    def init(name) do
      %__MODULE__{
        name: name,
        parent: parent_from_name(name)
      }
    end

    def parent_from_name("/"), do: nil

    def parent_from_name(name) do
      String.replace(name, ~r/(^\/.*)\/?[^\/]+$/U, "\\1")
    end

    def update_sizes(directory_map) do
      for {name, dir} <- directory_map, into: %{} do
        {name, update_size(dir, directory_map)}
      end
    end

    defp update_size(%{} = directory, map) do
      %{directory | size: calculate_size(directory, map)}
    end

    defp calculate_size(%{children: children} = directory, map) do
      files_size(directory) + children_size(children, map)
    end

    defp files_size(%{files: files}) do
      files
      |> Enum.map(&elem(&1, 1))
      |> Enum.sum()
    end

    defp children_size(children, map) do
      children
      |> Enum.map(&calculate_size(map[&1], map))
      |> Enum.sum()
    end
  end

  defmodule Part1 do
    alias Day07.{Directory, Input}

    @dir_list %{
      "/" => Directory.init("/")
    }

    def part1(input) do
      build_directories_with_sizes(input)
      |> Map.values()
      |> Stream.filter(&(&1.size <= 100_000))
      |> Stream.map(& &1.size)
      |> Enum.sum()
    end

    def build_directories_with_sizes(input) do
      input
      |> Input.parse()
      |> Enum.reduce({"/", @dir_list}, &process_line/2)
      |> elem(1)
      |> Directory.update_sizes()
    end

    def process_line(:ls, noop), do: noop
    def process_line({:cd, "/"}, {_, map}), do: {"/", map}
    def process_line({:cd, ".."}, {dir, map}), do: {map[dir].parent, map}
    def process_line({:cd, cd}, {dir, map}), do: {dir_name(dir, cd), map}

    def process_line({:file, file}, {dir, map}) do
      {
        dir,
        Map.update!(map, dir, &add_item(&1, :files, file))
      }
    end

    def process_line({:dir, new_dir}, {dir, map}) do
      new_dir = dir_name(dir, new_dir)

      {
        dir,
        map
        |> Map.update!(dir, &add_item(&1, :children, new_dir))
        |> Map.put(new_dir, Directory.init(new_dir))
      }
    end

    defp add_item(map, key, item) do
      Map.update!(map, key, &[item | &1])
    end

    defp dir_name("/", dir), do: "/" <> dir
    defp dir_name(a, b), do: a <> "/" <> b
  end

  defmodule Part2 do
    @total_space 70_000_000
    @desired 30_000_000

    def part2(input) do
      dirs = Day07.Part1.build_directories_with_sizes(input)
      file_size = Map.get(dirs["/"], :size)

      unused = @total_space - file_size
      deficit = max(0, @desired - unused)

      dirs
      |> Map.values()
      |> Stream.filter(&(&1.size >= deficit))
      |> Stream.map(& &1.size)
      |> Enum.min()
    end
  end
end
