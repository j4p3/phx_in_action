defmodule AuctionWeb.BidController do
  use AuctionWeb, :controller
  plug :authorize_access

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"bid" => %{"amount" => amount}, "item_id" => item_id}) do
    user_id = conn.assigns.current_user.id
    case Auction.insert_bid(%{amount: amount, item_id: item_id, user_id: user_id}) do
      {:ok, bid} ->
        html = Phoenix.View.render_to_string(AuctionWeb.BidView, "bid.html", bid: bid, username: conn.assigns.current_user.username)
        AuctionWeb.Endpoint.broadcast("item:#{item_id}", "new_bid", %{body: html})
        redirect(conn, to: Routes.item_path(conn, :show, bid.item_id))
      {:error, bid} ->
        item = Auction.get_item(bid.item_id)  # couldn't this just be a call to bid.item?
        render(conn, AuctionWeb.ItemView, "show.html", item: item, bid: bid)
    end
  end

  defp authorize_access(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "Must be logged in to place bid")
    |> redirect(to: Routes.item_path(conn, :index))
    |> halt()
  end
  defp authorize_access(conn, _opts), do: conn
end
