defmodule Day10 do
  def process_input(str) do
    str
    |> String.split("\n")
    |> Enum.map(&String.split/1)
  end

  def example do
    File.read!("./lib/day10/example.aoc")
    |> process_input()
  end

  def example1 do
    File.read!("./lib/day10/example1.aoc")
    |> process_input()
  end

  def input do
    File.read!("./lib/day10/input.aoc")
    |> process_input()
  end

  def simulation(inslist, cv, cycle, ci, citimer, state, ap) when ap == false do
    if cycle < 221 and rem(cycle + 20, 40) == 0 do
      simulation(inslist, cv, cycle, ci, citimer, Map.put(state, cycle, cv), true)
    else
      simulation(inslist, cv, cycle, ci, citimer, state, true)
    end
  end

  def simulation(inslist, cv, cycle, ci, citimer, state, _ap) when citimer != 0 do
    simulation(inslist, cv, cycle + 1, ci, citimer - 1, state, false)
  end

  def simulation(inslist, cv, cycle, ci, _citimer, state, _ap) do
    ncv =
      case ci do
        ["noop"] -> cv
        ["addx", val] -> cv + String.to_integer(val)
      end

    nci = hd(inslist)

    ncitimer =
      case nci do
        ["noop"] -> 1
        ["addx", _val] -> 2
      end

    if tl(inslist) == [] do
      state
    else
      simulation(tl(inslist), ncv, cycle + 1, nci, ncitimer - 1, state, false)
    end
  end

  def part_one() do
    input()
    |> simulation(1, 0, ["noop"], 0, Map.new(), false)
    |> Enum.reduce(0, fn {cycle, val}, acc ->
      acc + cycle * val
    end)
  end

  def part_two() do
  end
end
