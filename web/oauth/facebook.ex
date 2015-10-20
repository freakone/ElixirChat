defmodule Facebook do
  @moduledoc """
  An OAuth2 strategy for Facebook.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode

  # Public API

  def client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: "438582729682814",#System.get_env("CLIENT_ID"),
      client_secret: "bfceed8f31a3f8c5a9779dc15d682a95",#System.get_env("CLIENT_SECRET"),
      redirect_uri: "http://lvh.me:4000/auth/facebook/callback",#System.get_env("REDIRECT_URI"),
      site: "https://graph.facebook.com",
      authorize_url: "https://www.facebook.com/dialog/oauth",
      token_url: "https://graph.facebook.com/v2.3/oauth/access_token"
    ])
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(client(), params)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end