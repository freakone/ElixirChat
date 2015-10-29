defmodule ElixirChat.AuthController do
  use ElixirChat.Web, :controller
  alias OAuth2.AccessToken
  alias ElixirChat.User

  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end

  def logged_in?(conn), do: !!current_user(conn)

  def logout(conn, %{}) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end

  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def callback(conn, %{"provider" => provider, "error_code" => code}) do
    conn
    |> put_flash(:error, "Login failed")
    |> redirect(to: "/")
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    token = get_token!(provider, code)
    user = get_user!(provider, token)
    
    if AccessToken.expires?(token) do
        user_db = User.oauth user, token, provider
        user_db = %{id: user_db.model.id, name: user_db.model.name, image: user_db.model.image}
        
        conn
        |> put_session(:current_user, user_db)
        |> redirect(to: "/")
    else
        conn
        |> put_flash(:error, "Unknown login error")
        |> redirect(to: "/")
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