defmodule Day13P2 do
  def process_input(str) do
    val =
      str
      |> String.split("\n\n")
      |> Enum.join("\n")
      |> String.split("\n")
      |> Enum.map(&Jason.decode!/1)

    val ++ [[[2]]] ++ [[[6]]]
  end

  def example() do
    File.read!("./lib/day13/example.aoc") |> process_input()
  end

  def input() do
    File.read!("./lib/day13/input.aoc") |> process_input()
  end

  def f(v1, v2) do
    {isi1, isi2} = {is_integer(v1), is_integer(v2)}

    case {isi1, isi2} do
      {true, true} ->
        v1 - v2

      {true, false} ->
        f([v1], v2)

      {false, true} ->
        f(v1, [v2])

      {false, false} ->
        res =
          Enum.zip(v1, v2)
          |> Enum.map(fn {v1, v2} -> f(v1, v2) end)
          |> Enum.find(0, fn x -> x > 0 or x < 0 end)

        cond do
          res != 0 -> res
          true -> length(v1) - length(v2)
        end
    end
  end

  def sorter(val1, val2) do
    if f(val1, val2) >= 0 do
      false
    else
      true
    end
  end

  def part_two() do
    l = input() |> Enum.sort(&sorter(&1, &2))
    x1 = Enum.find_index(l, fn val -> val == [[2]] end)
    x2 = Enum.find_index(l, fn val -> val == [[6]] end)
    (x1 + 1) * (x2 + 1)
  end
end
