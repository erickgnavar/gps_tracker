defmodule GpsTracker.SessionController do
  use GpsTracker.Web, :controller
  alias GpsTracker.User
  alias GpsTracker.Repo
  alias GpsTracker.Session

  def new(conn, _params) do
    render conn, "login.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Session.login(session_params, Repo) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/")
      {:error, message} ->
        conn
        |> put_flash(:info, message)
        |> render("login.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "logged out")
    |> redirect(to: "/")
  end
end
