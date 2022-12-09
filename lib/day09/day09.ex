defmodule Day09 do
  def example() do
    File.read!("./lib/day09/example.aoc")
    |> String.split("\n")
    |> Enum.map(fn val ->
      [dir, val] = String.split(val, " ")
      {dir, String.to_integer(val)}
    end)
  end

  def input() do
    File.read!("./lib/day09/input.aoc")
    |> String.split("\n")
    |> Enum.map(fn val ->
      [dir, val] = String.split(val, " ")
      {dir, String.to_integer(val)}
    end)
  end

  defp move_head(hx, hy, dir) do
    case dir do
      "R" -> {hx + 1, hy}
      "U" -> {hx, hy + 1}
      "D" -> {hx, hy - 1}
      "L" -> {hx - 1, hy}
    end
  end

  defp move_tail(nhpos, tx, ty) do
    {hx, hy} = nhpos

    cond do
      abs(hx - tx) <= 1 and abs(hy - ty) <= 1 -> {tx, ty}
      hx - tx == -2 -> {tx - 1, hy}
      hx - tx == 2 -> {tx + 1, hy}
      hy - ty == -2 -> {hx, ty - 1}
      hy - ty == 2 -> {hx, ty + 1}
      true -> raise("Unhandled case")
    end
  end

  defp steps(_hpos, _tpos, instructions, visited) when instructions == [] do
    visited
  end

  defp steps(hpos, tpos, instructions, visited) do
    {dir, val} = hd(instructions)
    {hx, hy} = hpos
    {tx, ty} = tpos
    nhpos = move_head(hx, hy, dir)
    ntpos = move_tail(nhpos, tx, ty)

    if val - 1 == 0 do
      steps(nhpos, ntpos, tl(instructions), MapSet.put(visited, ntpos))
    else
      new_instr = {dir, val - 1}
      steps(nhpos, ntpos, [new_instr] ++ tl(instructions), MapSet.put(visited, ntpos))
    end
  end

  def part_one() do
    MapSet.size(steps({0, 0}, {0, 0}, input(), MapSet.new([])))
  end

  def part_two() do
  end
end
