defmodule VoteApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string

    timestamps()
  end

  def changeset(user,attrs) do
    user
    |>cast(attrs,[:email, :name])
    |> validate_required([:email, :name])
    |> validate_length(:email, min: 3, max: 125)
  end
end
