defmodule AuctionTest do
  import Ecto.Query
  use ExUnit.Case
  doctest Auction, import: true
  alias Auction.{Item, Repo}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "list_items/0" do
    setup do
      items = for i <- 1..3, do: Repo.insert!(%Item{title: "Item #{i}"})
      %{items: items}
    end

    test "returns all Items", %{items: items} do
      assert items == Auction.list_items()
    end
  end

  describe "get_item/1" do
    setup do
      items = for i <- 1..2, do: Repo.insert!(%Item{title: "Item #{i}"})
      %{item: Enum.at(items, 0)}
    end

    test "returns a single Item", %{item: item} do
      assert item == Auction.get_item(item.id)
    end
  end

  describe "insert_item/1" do
    test "inserts an Item in DB" do
      count_q = Ecto.Query.select(Item, [i], count(i.id))
      before_count = Repo.one(count_q)
      {:ok, _item} = Auction.insert_item(%{title: "test_item"})
      assert Repo.one(count_q) == before_count + 1
    end

    test "Item in DB has provided attributes" do
      attrs = %{title: "test_item", description: "test_description"}
      {:ok, item} = Auction.insert_item(attrs)
      assert item.title == attrs.title
      assert item.description == attrs.description
    end

    test "returns error code on error" do
      assert {:error, _changeset} = Auction.insert_item(%{foo: "bar"})
    end
  end
end
