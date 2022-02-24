defmodule Auction do
  @moduledoc """
  Provides functions for interacting with the database layer of an Auction
  application.
  In order to keep database concerns separate from the rest of an
  application, these
  functions are provided. Any interaction you need to do with the database
  can be done
  from within these functions. See an individual function’s documentation for
  more
  information and usage examples (like
  `Auction.get_user_by_username_and_password/2`).
  """
  alias Auction.{Repo, Item, User, Password, Bid}
  import Ecto.Query
  @repo Auction.Repo

  def list_items do
    @repo.all(Item)
  end

  def get_item(id) do
    @repo.get!(Item, id)
  end

  def get_item_by(attrs) do
    @repo.get_by(Item, attrs)
  end

  def get_item_with_bids(id) do
    id
    |> get_item()
    |> @repo.preload(bids: from(b in Bid, order_by: [desc: b.inserted_at]))
    |> @repo.preload(bids: [:user])
  end

  def new_item, do: Item.changeset(%Item{})

  def delete_item(%Auction.Item{} = item), do: @repo.delete(item)

  def insert_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> @repo.insert()
  end

  def edit_item(id) do
    get_item(id)
    |> Item.changeset()
  end

  def update_item(%Auction.Item{} = item, updates) do
    item
    |> Item.changeset(updates)
    |> @repo.update()
  end

  def get_user(id), do: @repo.get!(User, id)
  def new_user, do: User.changeset_with_password(%User{})

  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> @repo.insert
  end

  @doc """
  Retrieves a User from the database matching the provided username and password
  # current documentation ...

  ## Examples
    iex> Auction.insert_user(%{username: "geo", password: "example", password_confirmation: "example", email_address: "test@example.com"})
    ...> result = Auction.get_user_by_username_and_password("geo", "example")
    ...> match?(%Auction.User{username: "geo"}, result)
    true
    iex> Auction.get_user_by_username_and_password("no_user", "bad_password")
    false
  """
  def get_user_by_username_and_password(username, password) do
    with user when not is_nil(user) <- @repo.get_by(User, %{username: username}),
         true <- Password.verify_with_hash(password, user.hashed_password) do
      user
    else
      _ -> Password.dummy_verify()
    end
  end

  def insert_bid(params) do
    %Bid{}
    |> Bid.changeset(params)
    |> @repo.insert()
  end

  def new_bid, do: Bid.changeset(%Bid{})

  @spec get_bids_for_user(atom | %{:id => any, optional(any) => any}) :: any
  def get_bids_for_user(user) do
    query =
      from(b in Bid,
        where: b.user_id == ^user.id,
        order_by: [desc: :inserted_at],
        preload: :item,
        limit: 10
      )

    @repo.all(query)
  end
end
