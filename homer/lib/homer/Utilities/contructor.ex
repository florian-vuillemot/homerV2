defmodule Homer.Utilities.Constructor do
  @doc """
    Return if a error occured on construct.

    ## Examples

      iex> error_on_create({:ok, %{id: 1}})
           false

      iex> error_on_create({:error, %{id: 1}})
           true
  """
  def error_on_create({:ok, _}), do: false
  def error_on_create(_), do: true


  @doc """
    If fk of attributes are same then fk of elements.
    Fk found in list.
    Give atom, convert in string if need.

    ## Examples

      iex> same_fk(nil, _, _)
           false
      iex> same_fk(_, nil, _)
           false

      iex> same_fk(_, _, [])
           true

      iex> same_fk(%{funding_id: 3}, %{funding_id: 3}, [:funding_id])
           true

      iex> same_fk(%{funding_id: 2}, %{funding_id: 3}, [:funding_id])
           false

      iex> same_fk(%{funding_id: 3}, %{funding_id: 3}, [:funding_id, :user_id])
           false

      iex> same_fk(%{funding_id: 3, user_id: 2}, %{funding_id: 3, user_id: 2}, [:funding_id, :user_id])
           true

      iex> same_fk(%{funding_id: 3, user_id: 1}, %{funding_id: 3, user_id: 2}, [:funding_id, :user_id])
           false
  """
  def same_fk(nil, _, _), do: false
  def same_fk(_, nil, _), do: false
  def same_fk(_, _, []), do: true
  def same_fk(elements, attrs, [hd_id|tl_id]) do
    element = found_atom_in_map(elements, hd_id)
    attr = found_atom_in_map(attrs, hd_id)

    case element == attr do
      true ->
        same_fk(elements, attrs, tl_id)
      _ ->
        false
    end
  end

  defp found_atom_in_map(map, key) do
    case Map.has_key?(map, key) do
      true ->
        Map.get(map, key)
      _ ->
        Map.get(map, Atom.to_string(key))
    end
  end
end