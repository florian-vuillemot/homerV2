defmodule Homer.ControllerUtilitiesTest do
  def convert_fk(map, []), do: map
  def convert_fk(map, [key | tl]) do
    Homer.ViewsConverter.get_list_id(map, key)
    |> convert_fk(tl)
  end
end