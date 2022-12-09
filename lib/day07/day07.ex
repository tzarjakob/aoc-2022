defmodule Day07 do
  def input_man(str) do
    str
    |> String.split("$")
    |> Enum.map(fn val ->
      String.replace(val, "\n", " ") |> String.split(" ") |> Enum.reject(fn val -> val == "" end)
    end)
    |> Enum.reject(&Enum.empty?/1)
  end

  def example() do
    File.read!("./lib/day07/example.aoc")
    |> input_man()
  end

  def input() do
    File.read!("./lib/day07/input.aoc")
    |> input_man()
  end

  defp new_dir(args, wd) do
    args
    |> Enum.chunk_every(2)
    |> Enum.reduce(Map.new(), fn val, acc ->
      [size, name] = val

      if size == "dir" do
        if wd != "/" do
          Map.put(acc, wd <> "/" <> name, :dir)
        else
          Map.put(acc, wd <> name, :dir)
        end
      else
        if wd != "/" do
          Map.put(acc, wd <> "/" <> name, String.to_integer(size))
        else
          Map.put(acc, wd <> name, String.to_integer(size))
        end
      end
    end)
  end

  def remove_prev(wd) do
    nwd =
      wd
      |> String.split("/")
      |> Enum.reverse()
      |> tl()
      |> Enum.reverse()
      |> Enum.reject(fn val -> val == "" end)
      |> Enum.join("/")

    if String.starts_with?(nwd, "/") do
      nwd
    else
      "/" <> nwd
    end
  end

  defp explore_commands(cms, _wd, dirs) when cms == [] do
    dirs
  end

  defp explore_commands(cms, wd, dirs) do
    command = hd(cms)

    cond do
      hd(command) == "ls" ->
        explore_commands(tl(cms), wd, Map.put(dirs, wd, new_dir(tl(command), wd)))

      hd(command) == "cd" ->
        ndir = hd(tl(command))

        case ndir do
          ".." ->
            explore_commands(tl(cms), remove_prev(wd), dirs)

          "/" ->
            explore_commands(tl(cms), "/", dirs)

          _ ->
            if wd == "/" do
              explore_commands(tl(cms), wd <> ndir, dirs)
            else
              explore_commands(tl(cms), wd <> "/" <> ndir, dirs)
            end
        end

      true ->
        raise("unknown command")
    end
  end

  defp compute_size(_dir, content, map) when is_integer(content) do
    {content, map}
  end

  defp compute_size(dir, content, map) do
    {ncontents, nmap} =
      content
      |> Enum.map_reduce(map, fn {dir, val}, acc ->
        if val != :dir do
          {val, acc}
        else
          {res, ndirs} = compute_size(dir, Map.get(acc, dir), acc)
          {res, Map.replace!(ndirs, dir, res)}
        end
      end)

    res = Enum.reduce(ncontents, 0, fn val, acc -> acc + val end)
    {res, Map.replace(nmap, dir, res)}
  end

  defp compute_sizes(l, _map) when l == [] do
    []
  end

  defp compute_sizes(l, maps) do
    {dir, content} = hd(l)
    {res, nmaps} = compute_size(dir, content, maps)
    [{dir, res}] ++ compute_sizes(tl(l), nmaps)
  end

  defp count(dirs) do
    dirs
    |> Enum.reduce(0, fn {_dir, val}, acc ->
      cond do
        val <= 100_000 -> acc + val
        true -> acc
      end
    end)
  end

  def part_one() do
    dirs = explore_commands(tl(input()), "/", Map.new())

    compute_sizes(Map.to_list(dirs), dirs)
    |> count()
  end

  def free_space_req() do
    30_000_000
  end

  def total_space() do
    70_000_000
  end

  def part_two() do
    dirs = explore_commands(tl(input()), "/", Map.new())

    sizes =
      compute_sizes(Map.to_list(dirs), dirs)
      |> Enum.reduce(Map.new(), fn {key, value}, acc ->
        Map.put(acc, key, value)
      end)

    nec_space = (free_space_req() - (total_space() - Map.get(sizes, "/"))) |> IO.inspect()

    Enum.reduce(sizes, total_space(), fn {_dir, val}, acc ->
      if val >= nec_space and val < acc do
        val
      else
        acc
      end
    end)
  end
end
