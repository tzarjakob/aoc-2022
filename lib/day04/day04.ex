defmodule Day04 do
  def example do
    "./lib/day04/example.aoc"
  end

  def input do
    "./lib/day04/input.aoc"
  end

  defp read_input(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.map(fn str ->
      String.split(str, ",")
      |> Enum.map(fn val -> String.split(val, "-") |> Enum.map(&String.to_integer/1) end)
    end)
  end

  def part_one(path) do
    read_input(path)
    |> Enum.reduce(0, fn [[x1, x2], [x3, x4]], acc ->
      cond do
        (x1 >= x3 and x2 <= x4) or (x1 <= x3 and x2 >= x4) -> acc + 1
        true -> acc
      end
    end)
  end

  def part_two(path) do
    read_input(path)
    |> Enum.reduce(0, fn [[x1, x2], [x3, x4]], acc ->
      cond do
        x2 < x3 or x1 > x4 -> acc
        true -> acc + 1
      end
    end)
  end
end
