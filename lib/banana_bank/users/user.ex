defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias BananaBank.Accounts.Account

  @required_params_create [:name, :password, :email, :cep]
  @required_params_update [:name, :email, :cep]

  @derive {Jason.Encoder, only: [:id, :name, :email, :cep]}
  schema "users" do
    field :name, :string
    # not on db, only app
    field :password, :string, virtual: true
    field :password_hash, :string
    field :email, :string
    field :cep, :string
    has_one :account, :Account

    timestamps()
  end

  # struct empty = create
  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params_create)
    |> handle_validation(@required_params_create)
    |> add_password_hash()
  end

  # struct not empty = update
  # may have password, so cast as create
  def changeset(user, params) do
    user
    |> cast(params, @required_params_create)
    |> handle_validation(@required_params_update)
    |> add_password_hash()
  end

  defp handle_validation(changeset, fields) do
    changeset
    |> validate_required(fields)
    |> validate_length(:name, min: 3)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email, name: :unique_users_email)
    |> validate_length(:cep, is: 8)
  end

  defp add_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp add_password_hash(changeset), do: changeset
end
