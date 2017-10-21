defmodule HomerWeb.Utilities.Convertor do
  def get_correct_key(attrs, atom, nil_value \\ nil) do
    res = case Map.has_key?(attrs, atom) do
      true -> Map.get(attrs, atom)
      _ -> Map.get(attrs, to_string(atom))
    end

    case is_nil(res) do
      true -> nil_value
      _ -> res
    end
  end
end
