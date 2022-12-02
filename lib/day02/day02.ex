defmodule Day02 do
  def path() do
    "./lib/day02/input.aoc"
  end

  def map_values(val) do
    case val do
      "A" -> :rock
      "B" -> :paper
      "C" -> :scissors
      "X" -> :rock
      "Y" -> :paper
      "Z" -> :scissors
    end
  end

  def el_points(val) do
    case val do
      :rock -> 1
      :paper -> 2
      :scissors -> 3
    end
  end

  def result_points(adv, you) do
    if adv == you do
      3
    else
      case {adv, you} do
        {:rock, :paper} -> 6
        {:rock, :scissors} -> 0
        {:paper, :scissors} -> 6
        {:paper, :rock} -> 0
        {:scissors, :paper} -> 0
        {:scissors, :rock} -> 6
      end
    end
  end

  def part_one() do
    File.read!(path())
    |> String.split("\n")
    |> Enum.map(fn str -> String.split(str, " ") |> Enum.map(&map_values/1) end)
    |> Enum.reduce(0, fn x, acc ->
      acc + el_points(Enum.at(x, 1)) + result_points(Enum.at(x, 0), Enum.at(x, 1))
    end)
  end

  def map_values_part_two(val) do
    case val do
      "A" -> :rock
      "B" -> :paper
      "C" -> :scissors
      "X" -> :lose
      "Y" -> :draw
      "Z" -> :win
    end
  end

  def transform_vals(vals) do
    case vals do
      [:rock, :win] -> [:rock, :paper]
      [:rock, :draw] -> [:rock, :rock]
      [:rock, :lose] -> [:rock, :scissors]
      [:scissors, :win] -> [:scissors, :rock]
      [:scissors, :draw] -> [:scissors, :scissors]
      [:scissors, :lose] -> [:scissors, :paper]
      [:paper, :win] -> [:paper, :scissors]
      [:paper, :draw] -> [:paper, :paper]
      [:paper, :lose] -> [:paper, :rock]
    end
  end

  def part_two() do
    File.read!(path())
    |> String.split("\n")
    |> Enum.map(fn str ->
      String.split(str, " ")
      |> Enum.map(&map_values_part_two/1)
      |> transform_vals()
    end)
    |> Enum.reduce(0, fn x, acc ->
      acc + el_points(Enum.at(x, 1)) + result_points(Enum.at(x, 0), Enum.at(x, 1))
    end)
  end
end
