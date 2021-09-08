defmodule AuctionWeb.Api.ItemView do
  use AuctionWeb, :view

  def render("index.json", %{items: items}) do
    render_many(items, __MODULE__, "item.json")
  end

  def render("show.json", %{item: item}) do
    render_one(item, __MODULE__, "item_with_bids.json")
  end

  def render("item.json", %{item: item}) do
    %{
      id: item.id,
      title: item.title,
      description: item.description,
      ends_at: item.ends_at
    }
  end

  def render("item_with_bids.json", %{item: item}) do
    render("item.json", %{item: item})
    |> Map.put(:bids, render_many(item.bids, AuctionWeb.Api.BidView, "bid.json"))
  end
end
