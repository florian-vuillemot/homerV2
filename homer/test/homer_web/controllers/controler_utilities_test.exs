defmodule Homer.ControllerUtilitiesTest do
  @doc """
    Get map and list of key struct in map.
    Each key is a list of struct.
    Each struct have a id.
    Return list with id

    ## Examples

      iex> convert_fk(%{elem1: [%{id: 2}, %{id: 3}]}, [:elem1])
           %{elem1: [2, 3]}

      iex> convert_fk(%{elem1: [%{id: 2}, %{id: 3}], elem2: [%{id: 2}, %{id: 3}]}, [:elem1, :elem2])
           %{elem1: [2, 3], elem2: [2, 3]}

  """
  def convert_fk(map, []), do: map
  def convert_fk(map, [key | tl]) do
    Homer.ViewsConverter.get_list_id(map, key)
    |> convert_fk(tl)
  end
end