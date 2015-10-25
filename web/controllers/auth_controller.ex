defmodule ElixirChat.AuthController do
  use ElixirChat.Web, :controller
  alias OAuth2.AccessToken

  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    token = get_token!(provider, code)
    user = get_user!(provider, token)
    
    if AccessToken.expires?(token) do
        ElixirChat.User.oauth user, token, provider

        conn
        |> put_session(:current_user, user)
        |> put_session(:access_token, token.access_token)
        |> redirect(to: "/")
    else
        conn
        |> redirect(to: "/login-error")
    end

  end

  defp authorize_url!("facebook"), do: Facebook.authorize_url!
  defp authorize_url!(_), do: raise "No matching provider available"

  defp get_token!("facebook", code), do: Facebook.get_token!(code: code)
  defp get_token!(_, _), do: raise "No matching provider available"

  defp get_user!("facebook", token) do 
    AccessToken.get!(token, "/me?fields=id,email,name,picture") 
    |> Enum.reduce(%{}, fn ({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)
    |> Map.put_new(:email, "")
  end
end