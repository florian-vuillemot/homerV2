defmodule Homer.ViewsConverter do
  @doc """
    Get data map who contain list field at key and return list of id of each list element.

    ## Examples
      iex> get_id(%{li: [%{id: 3}]}, :li)
           %{li: [3]}

      iex> get_id(%{li: [%{id: 3}, %{id: 5}]}, :li)
           %{li: [3, 5]}

      iex> get_id(%{li: %{id: 3}}, :li)
           %{li: 3}

      iex> get_id(%{li: [%{other_name: 3}, %{id: 5}]}, :li)
           nil

      iex> get_id(%{li: %{other_name: 3}, %{id: 5}}, :li)
           nil

      iex> get_id(nil, [])
           nil

  """
  def get_id(data, key) when is_map(data) do
    case Map.has_key?(data, key) do
      true ->
        get_id(data, key, Map.get(data, key))
      _ -> nil
    end
  end

  defp get_id(data, key, li) when is_list(li) do
    list_id = Enum.map(li, fn invest -> invest.id end)
    case Enum.any?(list_id, fn elem -> elem == nil end) do
      false ->
        Map.replace(data, key, list_id)
      _ ->
        nil
    end
  end
  defp get_id(data, key, element) when is_map(element) do
    Map.replace(data, key, element.id)
  end
  defp get_id(_, _, _) do
    nil
  end
end