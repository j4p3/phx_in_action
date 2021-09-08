defmodule AuctionWeb.ItemControllerTest do
  use AuctionWeb.ConnCase

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Auction.Repo)
  end

  test "GET /", %{conn: conn} do
    test_item_title = "test_item"
    {:ok, _item} = Auction.insert_item(%{title: test_item_title})
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ test_item_title
  end

  describe "POST /items" do
    test "creates an Item given valid params", %{conn: conn} do
      before_count = Enum.count(Auction.list_items)
      post conn, "/items", %{"item" => %{"title" => "test"}}
      assert Enum.count(Auction.list_items) == before_count + 1
    end

    test "redirects to new Item given valid params", %{conn: conn} do
      conn = post conn, "/items", %{"item" => %{"title" => "test"}}
      assert redirected_to(conn) =~ ~r|/items/\d+|
    end

    test "errors given invalid params", %{conn: conn} do
      before_count = Enum.count(Auction.list_items)
      post conn, "/items", %{"item" => %{"invalid_param" => "test"}}
      assert Enum.count(Auction.list_items) == before_count
    end

    test "errors return new Item form", %{conn: conn} do
      conn = post conn, "/items", %{"item" => %{"invalid_param" => "test"}}
      assert html_response(conn, 200) =~ "<h1>New Item</h1>"
    end
  end
end
