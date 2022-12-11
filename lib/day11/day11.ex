defmodule Day11 do
  def catch_useful_stuff(l) do
    [snmon, ssitems, sop, stest, sift, siff] = l

    nmon =
      snmon
      |> String.split(":")
      |> Enum.at(0)
      |> String.split()
      |> Enum.at(1)
      |> String.to_integer()

    sitems =
      ssitems
      |> String.split(":")
      |> Enum.at(1)
      |> String.split(",")
      |> Enum.map(fn val -> String.trim(val) |> String.to_integer() end)

    top = sop |> String.split(":") |> Enum.at(1) |> String.split()
    op = [Enum.at(top, 3), Enum.at(top, 4)]
    test = stest |> String.split() |> List.last() |> String.to_integer()
    ift = sift |> String.split() |> List.last() |> String.to_integer()
    iff = siff |> String.split() |> List.last() |> String.to_integer()
    [nmon, sitems, op, test, ift, iff]
  end

  def process_input(str) do
    str
    |> String.split("\n\n")
    |> Enum.map(fn val ->
      String.split(val, "\n")
      |> Enum.map(fn val -> String.trim(val) end)
      |> catch_useful_stuff()
    end)
  end

  def example do
    File.read!("./lib/day11/example.aoc")
    |> process_input()
  end

  def input do
    File.read!("./lib/day11/input.aoc")
    |> process_input()
  end

  def apply_op(val, opstring) do
    [op, mol] = opstring

    nmol =
      if mol == "old" do
        val
      else
        String.to_integer(mol)
      end

    case op do
      "+" -> val + nmol
      "*" -> val * nmol
      true -> raise("unknown operator")
    end
  end

  def apply_test(val, test, ift, iff) do
    # ritorna il numero di scimmia a cui va lanciato e il val
    nmon =
      cond do
        rem(val, test) == 0 -> ift
        true -> iff
      end

    {nmon, val}
  end

  def round_sim(state, _tmap, nstate, count) when state == [] do
    {nstate, count}
  end

  def round_sim(state, tmap, nstate, count) do
    [mn, il, op, test, ift, iff] = hd(state)

    ntmap =
      Enum.reduce(il, tmap, fn item, acc ->
        {nnm, nworry} = item |> apply_op(op) |> div(3) |> trunc() |> apply_test(test, ift, iff)
        Map.update(acc, nnm, [] ,fn item -> item ++ [nworry] end)
      end)

    oldval = Map.get(count, mn, 0)

    round_sim(
      tl(state),
      ntmap,
      nstate ++ [[mn, [], op, test, ift, iff]],
      Map.put(count, mn, oldval + length(il))
    )
  end

  def round_manager(n, state, count) when n == 0 do
    {state, count}
  end

  def round_manager(n, state, count) do
    {nstate, ncount} = round_sim(state, Map.new(), [], count)
    round_manager(n - 1, nstate, ncount)
  end

  def part_one() do
    state = example()
    round_manager(1, state, Map.new())
  end

  def part_two() do
  end
end
