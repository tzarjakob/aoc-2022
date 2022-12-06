defmodule Day06 do
  def example do
    "mjqjpqmgbljsphdztnvjfqwrcgsmlb" |> String.graphemes()
  end

  def input do
    File.read!("./lib/day06/input.aoc") |> String.graphemes()
  end

  def calculate_first_solution(l, _chunk, _n) when l == [] do
    raise("error: no solution")
  end

  def calculate_first_solution(l, chunk, n) do
    if chunk == Enum.uniq(chunk) do
      n
    else
      calculate_first_solution(tl(l), tl(chunk) ++ [hd(l)], n + 1)
    end
  end

  def part_one() do
    {chunk, l} = Enum.split(input(), 4)
    calculate_first_solution(l, chunk, 4)
  end

  def calculate_second_solution(l, _chunk, _n) when l == [] do
    raise("error: no solution")
  end

  def calculate_second_solution(l, chunk, n) do
    if chunk == Enum.uniq(chunk) do
      n
    else
      calculate_second_solution(tl(l), tl(chunk) ++ [hd(l)], n + 1)
    end
  end

  def part_two() do
    {chunk, l} = Enum.split(input(), 14)
    calculate_second_solution(l, chunk, 14)
  end
end
