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

end