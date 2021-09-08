defmodule Auction do
  @moduledoc """
  Functions for interacting with Auction DB layer.
  """
  alias Auction.{Repo, Bid, Item, User, Password}
  import Ecto.Query
  @repo Repo

  @spec list_items :: [Item]
  def list_items() do
    @repo.all(Item)
  end

  @spec get_item(integer()) :: Item | nil
  def get_item(id) do
    @repo.get!(Item, id)
  end

  @spec get_item_with_bids(integer) :: Item | nil
  def get_item_with_bids(id) do
    get_item(id)
    |> @repo.preload(bids: from(b in Bid, order_by: [b.inserted_at]))
    |> @repo.preload(bids: [:user])
  end

  @spec get_bids_for_user(User) :: [Bid] | []
  def get_bids_for_user(user) do
    Bid
    |> where([b], b.user_id == ^user.id)
    |> order_by([b], desc: b.inserted_at)
    |> preload(:item)
    |> limit(10)
    |> @repo.all()
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

  @doc """
  Retrieve a user from DB given username and password

  ## Return values

  * `Auction.User` struct: found record
  * `false`: no record found

  Still generates a password hash regardless of whether username is found or not.

  ## Examples

      iex> insert_user(%{username: "test_user", password: "test_password", password_confirmation: "test_password", email_address: "test@example.com"})
      ...> result = authenticate_user("test_user", "test_password")
      ...> match?(%Auction.User{username: "test_user"}, result)


      iex> authenticate_user("no_user", "bad_password")
      false
  """
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
