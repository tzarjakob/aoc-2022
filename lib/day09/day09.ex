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

  defp tmovs(hx, hy, tx, ty) do
    dx = hx - tx
    dy = hy - ty

    cond do
      abs(dx) <= 1 and abs(dy) <= 1 -> {tx, ty}
      # horizontally and vertically
      dx == 0 and dy == -2 -> {tx, ty - 1}
      dx == 0 and dy == 2 -> {tx, ty + 1}
      dx == -2 and dy == 0 -> {tx - 1, ty}
      dx == 2 and dy == 0 -> {tx + 1, ty}
      # diagonally
      dx < 0 and dy > 0 -> {tx - 1, ty + 1}
      dx > 0 and dy < 0 -> {tx + 1, ty - 1}
      dx < 0 and dy < 0 -> {tx - 1, ty - 1}
      dx > 0 and dy > 0 -> {tx + 1, ty + 1}
      true -> raise("Unhandled case #{hx}-#{hy}, #{tx}-#{ty}")
    end
  end

  defp move_tail(nhpos, tx, ty) do
    {hx, hy} = nhpos

    tmovs(hx, hy, tx, ty)
  end

  defp move_head_tail(hpos, tpos, dir) do
    {hx, hy} = hpos
    {tx, ty} = tpos
    nhpos = move_head(hx, hy, dir)
    ntpos = move_tail(nhpos, tx, ty)
    {nhpos, ntpos}
  end

  defp steps(_hpos, _tpos, instructions, visited) when instructions == [] do
    visited
  end

  defp steps(hpos, tpos, instructions, visited) do
    {dir, val} = hd(instructions)
    {nhpos, ntpos} = move_head_tail(hpos, tpos, dir)

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

  defp move_tails(_head, tail, _dir) when tail == [] do
    []
  end

  defp move_tails(head, tail, dir) do
    {tx, ty} = hd(tail)
    nt = move_tail(head, tx, ty)
    [nt] ++ move_tails(nt, tl(tail), dir)
  end

  defp sec_steps(_posl, instructions, visited) when instructions == [] do
    visited
  end

  defp sec_steps(posl, instructions, visited) do
    {dir, val} = hd(instructions)

    {hx, hy} = hd(posl)
    nh = move_head(hx, hy, dir)
    nposl = [nh] ++ move_tails(nh, tl(posl), dir)

    if val - 1 == 0 do
      sec_steps(nposl, tl(instructions), MapSet.put(visited, List.last(nposl)))
    else
      new_instr = {dir, val - 1}
      sec_steps(nposl, [new_instr] ++ tl(instructions), MapSet.put(visited, List.last(nposl)))
    end
  end

  def part_two() do
    MapSet.size(sec_steps(List.duplicate({0, 0}, 10), input(), MapSet.new([])))
  end
end
