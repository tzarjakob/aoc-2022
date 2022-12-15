defmodule Day15.One do
  def mn() do
    2_000_000
  end

  def process_input(str) do
    str
    |> String.split("\n")
    |> Enum.reduce({[], []}, fn row, {sensors, cbs} ->
      [sx, sy, cbx, cby] = String.split(row) |> Enum.map(&String.to_integer/1)
      {sensors ++ [[sx, sy]], cbs ++ [[cbx, cby]]}
    end)
  end

  def input() do
    File.read!("./lib/day15/input.aoc") |> process_input()
  end

  def example() do
    File.read!("./lib/day15/example.aoc") |> process_input()
  end

  def distance(x1, y1, x2, y2) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def fill_set(sensors, beacons, set) when sensors == [] and beacons == [] do
    set
  end

  def fill_set(sensors, beacons, set) do
    [sx, sy] = hd(sensors)
    [bx, by] = hd(beacons)
    d = distance(sx, sy, bx, by)

    if mn() <= sy + d and mn() >= sy - d do
      d1 = abs(sy - mn()) - d

      nset =
        Enum.to_list((sx - d1)..(sx + d1))
        |> Enum.reduce(set, fn i, acc -> MapSet.put(acc, i) end)

      fill_set(tl(sensors), tl(beacons), nset)
    else
      fill_set(tl(sensors), tl(beacons), set)
    end
  end

  def f(beacons) do
    beacons
    |> Enum.reduce(MapSet.new(), fn [x, y], acc ->
      if y == mn() do
        MapSet.put(acc, x)
      else
        acc
      end
    end)
  end

  def part_one() do
    {sensors, beacons} = input()

    fill_set(sensors, beacons, MapSet.new())
    |> MapSet.difference(f(beacons))
    |> MapSet.size()
  end
end
