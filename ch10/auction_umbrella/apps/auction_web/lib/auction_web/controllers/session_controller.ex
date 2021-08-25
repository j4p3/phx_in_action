defmodule AuctionWeb.SessionController do
  use AuctionWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{
        "user" => %{
          "username" => username,
          "password" => password
        }
      }) do
        case Auction.authenticate_user(username, password) do
          %Auction.User{} = user ->
            conn
            |> put_session(:user_id, user.id)
            |> put_flash(:info, "Logged in")
            |> redirect(to: Routes.user_path(conn, :show, user))
          _ ->
            conn
            |> put_flash(:error, "Invalid")
            |> render("new.html")
        end
  end

  def delete(conn, _params) do
    #
  end
end
