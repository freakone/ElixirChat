defmodule ElixirChat.AuthController do
  use ElixirChat.Web, :controller
  require Logger

  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    token = get_token!(provider, code)
    user = get_user!(provider, token)

    if token.expires? do
        IO.inspect(user)
    else

    end

    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, token.access_token)
    |> redirect(to: "/")
  end

  defp authorize_url!("facebook"), do: Facebook.authorize_url!
  defp authorize_url!(_), do: raise "No matching provider available"

  defp get_token!("facebook", code), do: Facebook.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider available"

  defp get_user!("facebook", token), do: OAuth2.AccessToken.get!(token, "/me?fields=id,email,name,picture")
end