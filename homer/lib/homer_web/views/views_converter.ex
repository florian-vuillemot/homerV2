defmodule Homer.ViewsConverter do
  @doc """
    Get data map who contain list field at key and return list of id of each list element.

    ## Examples
      iex> get_list_id(%{li: [%{id: 3}]}, :li)
           %{li: [3]}

      iex> get_list_id(%{li: [%{id: 3}, %{id: 5}]}, :li)
           %{li: [3, 5]}

      iex> get_list_id(%{li: [%{other_name: 3}, %{id: 5}]}, :li)
           nil

      iex> get_list_id(nil, [])
           nil

  """
  def get_list_id(data, key) when is_map(data) do
    case Map.has_key?(data, key) do
      true ->
        list_id = Enum.map(Map.get(data, key), fn invest -> invest.id end)
        case Enum.any?(list_id, fn elem -> elem == nil end) do
          false ->
            Map.replace(data, key, list_id)
          _ ->
            nil
        end
      _ -> nil
    end
  end
end