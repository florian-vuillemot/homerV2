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


  def same_fk(elements, attrs, key_id) when is_list(key_id) do
    Enum.each(key_id,
      fn key ->
        case Map.has_key?(elements, key) and  Map.has_key?(attrs, key) do
          true ->
            Map.get(elements, key) == Map.get(attrs, key_id)
          _ ->
            false
        end
      end
    )
    Enum.any?(true)
  end
end