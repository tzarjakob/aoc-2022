defmodule Day12 do
  def map_elem(var) do
    <<v::utf8>> = var
    v
  end

  def map_row(row) do
    row
    |> Enum.map(&map_elem/1)
  end

  def check_if_edges(matrix, x1, y1, x2, y2, cl) do
    el1 = Enum.at(matrix, x1) |> Enum.at(y1)
    el2 = Enum.at(matrix, x2) |> Enum.at(y2)
    el1_val = y1 * cl + x1
    el2_val = y2 * cl + x2

    cond do
      el1 == hd('S') -> [{"S", el2_val}]
      el2 == hd('S') -> []
      el1 == hd('E') -> []
      el2 == hd('E') and el1 >= hd('z') - 1 -> [{el1_val, "E"}]
      el2 == hd('E') -> []
      el1 >= el2 - 1 -> [{el1_val, el2_val}]
      true -> []
    end
  end

  def define_edges_from_input(matrix) do
    rl = length(matrix) - 1
    cl = length(Enum.at(matrix, 0, 0)) - 1

    for irow <- 0..rl do
      for icol <- 0..cl do
        case {irow, icol} do
          {0, 0} ->
            check_if_edges(matrix, 0, 0, 0, 1, cl) ++ check_if_edges(matrix, 0, 0, 1, 0, cl)

          {0, ^cl} ->
            check_if_edges(matrix, 0, cl, 1, cl, cl) ++
              check_if_edges(matrix, 0, cl, 0, cl - 1, cl)

          {^rl, 0} ->
            check_if_edges(matrix, rl, 0, rl, 1, cl) ++
              check_if_edges(matrix, rl, 0, rl - 1, 0, cl)

          {^rl, ^cl} ->
            check_if_edges(matrix, rl, cl, rl, cl - 1, cl) ++
              check_if_edges(matrix, rl, cl, rl - 1, cl, cl)

          {0, x} ->
            check_if_edges(matrix, 0, x, 1, x, cl) ++
              check_if_edges(matrix, 0, x, 0, x + 1, cl) ++
              check_if_edges(matrix, 0, x, 0, x - 1, cl)

          {x, 0} ->
            check_if_edges(matrix, x, 0, x - 1, 0, cl) ++
              check_if_edges(matrix, x, 0, x + 1, 0, cl) ++ check_if_edges(matrix, x, 0, x, 1, cl)

          {x, ^cl} ->
            check_if_edges(matrix, x, cl, x + 1, cl, cl) ++
              check_if_edges(matrix, x, cl, x - 1, cl, cl) ++
              check_if_edges(matrix, x, cl, x, cl - 1, cl)

          {^rl, x} ->
            check_if_edges(matrix, rl, x, rl - 1, x, cl) ++
              check_if_edges(matrix, rl, x, rl, x + 1, cl) ++
              check_if_edges(matrix, rl, x, rl, x - 1, cl)

          {x, y} ->
            check_if_edges(matrix, x, y, x - 1, y, cl) ++
              check_if_edges(matrix, x, y, x + 1, y, cl) ++
              check_if_edges(matrix, x, y, x, y + 1, cl) ++
              check_if_edges(matrix, x, y, x, y - 1, cl)
        end
      end
    end
  end

  def process_input(str) do
    matrix =
      str
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&map_row/1)

    edges = matrix |> define_edges_from_input() |> List.flatten()

    l = length(matrix) * length(Enum.at(matrix, 0, 0)) - 2

    Graph.new()
    |> Graph.add_vertex("S")
    |> Graph.add_vertex("E")
    |> Graph.add_vertices(Enum.to_list(1..l))
    |> Graph.add_edges(edges)
  end

  def example() do
    File.read!("./lib/day12/example.aoc") |> process_input()
  end

  def input() do
    File.read!("./lib/day12/input.aoc") |> process_input()
  end

  def part_one() do
    val = input() |> Graph.dijkstra("S", "E") |> Enum.count()
    val - 1
  end
end
