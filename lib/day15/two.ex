defmodule Day15.Two do
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

  def magic() do
    4_000_000
  end

  def bounds(val) do
    max(0, val) |> min(magic())
  end

  def compute_ints(sensors, beacons, _irow, ints) when sensors == [] and beacons == [] do
    ints
  end

  def compute_ints(sensors, beacons, irow, ints) do
    [sx, sy] = hd(sensors)
    [bx, by] = hd(beacons)
    d = distance(sx, sy, bx, by)

    if sy + d >= irow and sy - d <= irow do
      d1 = d - abs(sy - irow)
      nitem = List.to_tuple(Enum.sort([bounds(sx - d1), bounds(sx + d1)]))

      compute_ints(
        tl(sensors),
        tl(beacons),
        irow,
        ints ++ [nitem]
      )
    else
      compute_ints(tl(sensors), tl(beacons), irow, ints)
    end
  end

  def check_hole(ints, irow) do
    ints
    |> Enum.reduce({0, 0, :continue}, fn {x1, x2}, {acc1, acc2, state} ->
      cond do
        state != :continue -> {acc1, acc2, state}
        acc2 < x1 - 1 -> {acc1, acc2, compute_sol(acc2 + 1, irow)}
        true -> {acc1, max(acc2, x2), :continue}
      end
    end)
    |> elem(2)
  end

  def compute_sol(val, irow) do
    val * 4_000_000 + irow
  end

  def y(sensors, beacons, irow) do
    compute_ints(sensors, beacons, irow, [])
    |> Enum.sort()
    |> check_hole(irow)
  end

  def f(sensors, beacons, irow) do
    if irow > magic() do
      :stop
    else
      res = y(sensors, beacons, irow)

      case res do
        :continue -> f(sensors, beacons, irow + 1)
        _ -> res
      end
    end
  end

  def part_two() do
    {sensors, beacons} = input()
    f(sensors, beacons, 0)
  end
end
