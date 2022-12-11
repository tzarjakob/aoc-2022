defmodule Day11 do
  def get_last_word_as_integer(item) do
    item |> String.split() |> List.last() |> String.to_integer()
  end

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
    test = stest |> get_last_word_as_integer()
    ift = sift |> get_last_word_as_integer()
    iff = siff |> get_last_word_as_integer()
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

  def t_and_dest(item, op, test, ift, iff) do
    item |> apply_op(op) |> div(3) |> trunc() |> apply_test(test, ift, iff)
  end

  def round_sim(state, count) do
    state
    |> Enum.reduce({state, count}, fn item, {accstate, acccount} ->
      [mnitem, _til, _top, _ttest, _tift, _tiff] = item
      [mn, il, op, test, ift, iff] = Enum.at(accstate, mnitem)

      nstate =
        Enum.reduce(il, accstate, fn item, accaccstate ->
          {nnm, nworry} = t_and_dest(item, op, test, ift, iff)

          List.update_at(accaccstate, nnm, fn item ->
            [tmn, til, top, ttest, tift, tiff] = item
            [tmn, til ++ [nworry], top, ttest, tift, tiff]
          end)
        end)

      {
        List.replace_at(nstate, mnitem, [mn, [], op, test, ift, iff]),
        Map.update(acccount, mnitem, length(il), fn val -> val + length(il) end)
      }
    end)
  end

  def round_manager(n, _state, count) when n == 0 do
    count
  end

  def round_manager(n, state, count) do
    {state, count} = round_sim(state, count)
    round_manager(n - 1, state, count)
  end

  def part_one() do
    state = input()

    s =
      round_manager(20, state, Map.new())
      |> Enum.map(fn {_mon, val} -> val end)
      |> Enum.sort(&(&1 >= &2))

    Enum.at(s, 0) * Enum.at(s, 1)
  end

  def part_two() do
  end
end
