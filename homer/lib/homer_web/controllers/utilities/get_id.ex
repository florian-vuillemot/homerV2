defmodule HomerWeb.Utilities.GetId do

  @doc """
    Return the id of user in conn
"""
  def get_id(conn) do
    {_, %{"aud" => aud}} = conn.private.guardian_default_claims
    [_, id] = String.split(aud, ":")
    id
  end

end