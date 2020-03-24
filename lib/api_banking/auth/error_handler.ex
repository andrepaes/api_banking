defmodule ApiBanking.Auth.ErrorHandler do
  @moduledoc """
    This module provide friendly error messages for auth errors
  """
  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, to_string(type))
  end
end
