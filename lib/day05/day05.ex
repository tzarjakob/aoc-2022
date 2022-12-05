defmodule Day05 do
  def get_moves(str) do
    str
    |> String.split("\n")
    |> Enum.map(fn val ->
      String.split(val, " ")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def example() do
    moves = get_moves(File.read!("./lib/day05/example.txt"))

    {[
       ["N", "Z"],
       ["D", "C", "M"],
       ["P"]
     ], moves}
  end

  def input() do
    moves = get_moves(File.read!("./lib/day05/input.txt"))

    {[
       ["G", "W", "L", "J", "B", "R", "T", "D"],
       ["C", "W", "S"],
       ["M", "T", "Z", "R"],
       ["V", "P", "S", "H", "C", "T", "D"],
       ["Z", "D", "L", "T", "P", "G"],
       ["D", "C", "Q", "J", "Z", "R", "B", "F"],
       ["R", "T", "F", "M", "J", "D", "B", "S"],
       ["M", "V", "T", "B", "R", "H", "L"],
       ["V", "S", "D", "P", "Q"]
     ], moves}
  end

  def simplify(stacks, moves) when moves == [] do
    Enum.reduce(stacks, [], fn l, acc -> [hd(l)] ++ acc end) |> Enum.reverse() |> Enum.join("")
  end

  def simplify(stacks, moves) do
    [n, from, to] = hd(moves)
    {to_move, new_from} = Enum.split(Enum.at(stacks, from - 1), n)
    new_to = Enum.reverse(to_move) ++ Enum.at(stacks, to - 1)

    new_stacks =
      stacks
      |> List.replace_at(from - 1, new_from)
      |> List.replace_at(to - 1, new_to)

    simplify(new_stacks, tl(moves))
  end

  def part_one() do
    {stacks, moves} = input()
    simplify(stacks, moves)
  end

  def simplify_sec(stacks, moves) when moves == [] do
    Enum.reduce(stacks, [], fn l, acc -> [hd(l)] ++ acc end) |> Enum.reverse() |> Enum.join("")
  end

  def simplify_sec(stacks, moves) do
    [n, from, to] = hd(moves)
    {to_move, new_from} = Enum.split(Enum.at(stacks, from - 1), n)
    new_to = to_move ++ Enum.at(stacks, to - 1)

    new_stacks =
      stacks
      |> List.replace_at(from - 1, new_from)
      |> List.replace_at(to - 1, new_to)

    simplify_sec(new_stacks, tl(moves))
  end

  def part_two() do
    {stacks, moves} = input()
    simplify_sec(stacks, moves)
  end
end
