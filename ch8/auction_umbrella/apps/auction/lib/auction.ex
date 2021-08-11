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

  @spec insert_item(Map) :: {:ok, Item} | {:error, struct}
  def insert_item(attrs) do
    Item
    |> struct(attrs)
    |> @repo.insert()
  end

  @spec update_item(Item, Map) :: {:ok, Item} | {:error, Ecto.Changeset}
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> @repo.update()
  end

  @spec delete_item(Item) :: {:ok, Item} | {:error, Ecto.Changeset}
  def delete_item(%Auction.Item{} = item), do: @repo.delete(item)
end
