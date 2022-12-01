defmodule Day01 do
  def part_one() do
    File.read!("./lib/day01/input.aoc")
    |> String.split("\n\n")
    |> Enum.map(fn s -> String.split(s, "\n") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn list -> Enum.sum(list) end)
    |> Enum.max()
  end

  def part_two() do
    File.read!("./lib/day01/input.aoc")
    |> String.split("\n\n")
    |> Enum.map(fn s -> String.split(s, "\n") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn list -> Enum.sum(list) end)
    |> Enum.sort(&(&1 >= &2))
    |> Enum.split(3)
    |> elem(0)
    |> Enum.sum()
  end
end
