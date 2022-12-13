defmodule Day13P1 do
  def process_input(str) do
    str
    |> String.split("\n\n")
    |> Enum.map(fn pair ->
      pair |> String.split("\n") |> Enum.map(&Jason.decode!/1)
    end)
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

  def compute_sol(pair, {acc, index}) do
    [p1, p2] = pair

    if f(p1, p2) < 0 do
      {acc + index, index + 1}
    else
      {acc, index + 1}
    end
  end

  def part_one() do
    input() |> Enum.reduce({0, 1}, &compute_sol/2)
  end
end
