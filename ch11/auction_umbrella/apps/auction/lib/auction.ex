defmodule Auction do
  alias Auction.{Repo, Bid, Item, User, Password}
  @repo Repo

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

  @spec new_item :: Ecto.Changeset.t()
  def new_item(), do: Item.changeset(%Item{})

  @spec edit_item(integer) :: Ecto.Changeset.t()
  def edit_item(id) do
    @repo.get!(Item, id)
    |> Item.changeset()
  end

  @spec insert_item(Map) :: {:ok, Item} | {:error, Ecto.Changeset}
  def insert_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
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

  def get_user(id), do: @repo.get!(User, id)

  def new_user, do: User.changeset_with_password(%User{})

  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> @repo.insert
  end

  @spec authenticate_user(bitstring(), bitstring()) :: User | {:error, bitstring()}
  def authenticate_user(username, password) do
    with user when not is_nil(user) <- @repo.get_by(User, %{username: username}),
         true <- Password.verify_with_hash(password, user.hashed_password) do
      user
    else
      _ -> Password.dummy_verify()
    end
  end

  @spec new_bid :: Ecto.Changeset.t()
  def new_bid(), do: Bid.changeset(%Bid{})

  @spec insert_bid(Bid) :: {:ok, Bid} | {:error, Ecto.Changeset.t()}
  def insert_bid(params) do
    %Bid{}
    |> Bid.changeset(params)
    |> @repo.insert()
  end
end
