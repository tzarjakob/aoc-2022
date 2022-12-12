defmodule Day12 do
  def process_input(str) do
    matrix = str |> String.split("\n") |> Enum.map(&String.graphemes/1)
    l = length(matrix) * length(Enum.at(matrix, 0, 0)) - 2

    Graph.new()
    |> Graph.add_vertex("S")
    |> Graph.add_vertex("E")
    |> Graph.add_vertices(Enum.to_list(1..l))
  end

  def example() do
    File.read!("./lib/day12/example.aoc") |> process_input()
  end

  def input() do
    File.read!("./lib/day12/input.aoc") |> process_input()
  end

  def part_one() do
    example()
    |> Graph.dijkstra("S", "E")
  end
end
