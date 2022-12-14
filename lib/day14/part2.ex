defmodule Day14.Part2 do
  def process_input(str) do
    str
    |> String.split("\n")
    |> Enum.map(fn val ->
      b =
        String.split(val, " -> ")
        |> Enum.map(fn val -> String.split(val, ",") |> Enum.map(&String.to_integer/1) end)

      Enum.reduce(b, {Enum.at(b, 0), []}, fn [x, y], {[px, py], items} ->
        vals =
          for ix <- x..px do
            for iy <- y..py do
              {[ix, iy], :rock}
            end
          end
          |> List.flatten()

        {[x, y], items ++ vals}
      end)
      |> elem(1)
    end)
    |> List.flatten()
  end

  def example() do
    File.read!("./lib/day14/example.aoc") |> process_input()
  end

  def input() do
    File.read!("./lib/day14/input.aoc") |> process_input()
  end

  def find_laying_place({_x, y}, _map, maxy) when y > maxy do
    :stop
  end

  def find_laying_place({xc, yc}, map, maxy) do
    cmat = Map.get(map, {xc, yc}, :void)
    {xc, yc, cmat, maxy}

    if cmat != :void do
      :stop
    else
      cond do
        yc + 1 == maxy ->
          {xc, yc}

        Map.get(map, {xc, yc + 1}, :void) == :void ->
          find_laying_place({xc, yc + 1}, map, maxy)

        Map.get(map, {xc - 1, yc + 1}, :void) == :void ->
          find_laying_place({xc - 1, yc + 1}, map, maxy)

        Map.get(map, {xc + 1, yc + 1}, :void) == :void ->
          find_laying_place({xc + 1, yc + 1}, map, maxy)

        true ->
          {xc, yc}
      end
    end
  end

  def round_manager(state, maxy, i) do
    res = find_laying_place({500, 0}, state, maxy)

    case res do
      :stop -> i
      val -> round_manager(Map.put(state, val, :sand), maxy, i + 1)
    end
  end

  def sorter(v1, v2) do
    {_x1, y1} = v1
    {_x2, y2} = v2
    y1 > y2
  end

  def part_two() do
    map =
      input()
      |> Enum.reduce(Map.new(), fn {[x, y], content}, map -> Map.put(map, {x, y}, content) end)

    maxy = Enum.max(Map.keys(map), &sorter(&1, &2)) |> elem(1)
    round_manager(map, maxy + 2, 0)
  end
end
