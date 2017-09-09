defmodule Homer.ModelUtilitiesTest do
  use Homer.DataCase

  def test_length(list_1, list_2) when is_list(list_2) do
    v1 = length list_1
    v2 = length list_2
    assert v1 == v2
  end

  def test_length(list_1, nb) when is_integer(nb) do
    v1 = length list_1
    assert v1 == nb
  end

  @doc """
    Apply length test on tuple list.

    iex> test_lengths(%{k: []}, [{:k, 0}])

    iex> test_lengths(%{k: [1, 2], k2: [1]}, [{:k, 2}, {:k2, 1}])

    iex> test_lengths(%{k: []}, [{:k, 2}])
         error
  """
  def test_lengths(map, list) do
    Enum.map(
      list,
      fn {key, value} -> test_length(Map.get(map, key), value) end
    )
  end
end