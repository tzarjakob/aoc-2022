# When a stateful solution is easy, and a stateless not

defmodule Day08 do
  @on_load :load_nifs

  def load_nifs() do
    :erlang.load_nif('./lib/day08/part_two_nif', 0)
  end

  def part_two_nif(_PATH) do
    raise("Not implemented")
  end

  def process_input(str) do
    str
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn l -> Enum.map(l, &String.to_integer/1) end)
  end

  def example() do
    File.read!("./lib/day08/example.aoc") |> process_input()
  end

  def input() do
    File.read!("./lib/day08/input.aoc") |> process_input()
  end

  def check_if_visible(row) do
    row
    |> Enum.map_reduce(-1, fn item, acc ->
      if item > acc do
        # visible
        {true, item}
      else
        # not visible
        {false, acc}
      end
    end)
  end

  def vis(square, direction) do
    case direction do
      :left ->
        square
        |> Enum.map(fn val ->
          elem(
            check_if_visible(val),
            0
          )
        end)

      :right ->
        square
        |> Enum.map(fn val ->
          elem(
            val
            |> Enum.reverse()
            |> check_if_visible(),
            0
          )
          |> Enum.reverse()
        end)

      :up ->
        square
        |> Enum.zip_with(fn l -> l end)
        |> Enum.map(fn val ->
          elem(
            check_if_visible(val),
            0
          )
        end)
        |> Enum.zip_with(fn l -> l end)

      :down ->
        square
        |> Enum.zip_with(fn l -> l end)
        |> Enum.map(fn val ->
          elem(
            val
            |> Enum.reverse()
            |> check_if_visible(),
            0
          )
          |> Enum.reverse()
        end)
        |> Enum.zip_with(fn l -> l end)
    end
    |> List.flatten()
  end

  def part_one() do
    s = input()

    Enum.zip_with([vis(s, :right), vis(s, :left), vis(s, :up), vis(s, :down)], fn l ->
      Enum.any?(l)
    end)
    |> IO.inspect()
    |> List.flatten()
    |> Enum.count(fn x -> x end)
  end

  def part_two() do
    part_two_nif('./lib/day08/input.aoc')
  end
end
