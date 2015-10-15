defmodule GpsTracker.Session do
  alias GpsTracker.User
  alias GpsTracker.Repo
  import Plug

  def login(params, repo) do
    user = Repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      {true, _} -> {:ok, user}
      {false, message} -> {:error, message}
    end
  end

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Repo.get(User, id)
  end

  def logged_in?(conn), do: !!current_user(conn)

  defp authenticate(user, password) do
    case user do
      nil -> {false, "email does not exist"}
      _ -> case Comeonin.Bcrypt.checkpw(password, user.encrypted_password) do
        true -> {true, nil}
        false -> {false, "Incorrect password"}
      end
    end
  end
end
