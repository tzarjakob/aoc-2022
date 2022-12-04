defmodule Day03 do
  def example do
    "./lib/day03/example.aoc"
  end

  def input do
    "./lib/day03/input.aoc"
  end

  def calculate_priority(vals) do
    if Enum.empty?(vals) do
      0
    else
      Enum.reduce(vals, 0, fn val, acc ->
        cond do
          val >= "a" and val <= "z" -> hd(String.to_charlist(val)) - 96 + acc
          val >= "A" and val <= "Z" -> hd(String.to_charlist(val)) - 38 + acc
          true -> acc
        end
      end)
    end
  end

  def part_one(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.map(fn val -> String.graphemes(val) end)
    |> Enum.map(fn val ->
      {first, second} = Enum.split(val, trunc(length(val) / 2))

      Enum.reject(first, fn val -> not Enum.member?(second, val) end)
      |> Enum.uniq()
      |> calculate_priority()
    end)
    |> Enum.sum()
  end

  def part_two(path) do
    File.read!(path)
    |> String.split("\n")
    |> Enum.map(fn val -> String.graphemes(val) |> MapSet.new() end)
    |> Enum.chunk_every(3)
    |> Enum.map(fn x ->
      Enum.reduce(x, &MapSet.intersection/2) |> MapSet.to_list() |> calculate_priority()
    end)
    |> Enum.sum()
  end
end
