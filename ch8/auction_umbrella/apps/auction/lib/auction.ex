defmodule Auction do
  alias Auction.Item
  @repo Auction.Repo

  @spec list_items :: [Item]
  def list_items() do
    @repo.all(Item)
  end

  @spec get_item(integer()) :: Item | nil
  def get_item(id) do
    @repo.get!(Item, id)
  end

  @spec get_item_by(Map) :: [Item] | nil
  def get_item_by(attrs) do
    @repo.get_by(Item, attrs)
  end

  def insert_item(attrs) do
    Auction.Item
    |> struct(attrs)
    |> @repo.insert()
  end

  def delete_item(%Auction.Item{} = item), do: @repo.delete(item)
end
