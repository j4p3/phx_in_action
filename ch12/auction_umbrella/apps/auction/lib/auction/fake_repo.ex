defmodule Auction.FakeRepo do
  alias Auction.Item

  @items [
    %Item{
      id: 1,
      title: "Item A",
      description: "Item A description",
      ends_at: ~N[2021-12-12 12:00:00]
    },
    %Item{
      id: 2,
      title: "Item B",
      description: "Item B description",
      ends_at: ~N[2022-12-12 12:00:00]
    },
    %Item{
      id: 3,
      title: "Item C",
      description: "Item C description",
      ends_at: ~N[2023-12-12 12:00:00]
    }
  ]

  @spec all(Item) :: [Item]
  def all(Item), do: @items

  @spec get!(Item, integer()) :: Item
  def get!(Item, id) do
    Enum.find(@items, fn (item) -> item.id == id end)
  end

  @spec get_by(Item, Map) :: [Item] | nil
  def get_by(Item, attrs \\ %{}) do
    Enum.find(@items, fn(item) ->
      Enum.all?(Map.keys(attrs), fn(key) ->
        Map.get(item, key) === attrs[key]
      end)
    end)
  end
end
