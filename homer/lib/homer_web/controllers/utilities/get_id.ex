defmodule HomerWeb.Utilities.GetId do

  @doc """
    Return the id of user in conn
"""
  def get_id(conn) do
    {_, %{"aud" => aud}} = conn.private.guardian_default_claims
    [_, id_str] = String.split(aud, ":")
    {id, _} = Integer.parse(id_str)
    id
  end

end