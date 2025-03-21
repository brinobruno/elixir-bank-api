defmodule BananaBank.Accounts.Create do
  import Ecto.Query

  alias BananaBank.Accounts.Account
  alias BananaBank.Users.User
  alias BananaBank.Repo

  def call(params) do
    user_id = params["user_id"]

    if is_nil(user_id) do
      changeset = Ecto.Changeset.change(%Account{})
      {:error, Ecto.Changeset.add_error(changeset, :user_id, "User ID is required")}
    else
      user = Repo.one(from u in User, where: u.id == ^user_id)

      case user do
        nil ->
          changeset = Ecto.Changeset.change(%Account{})
          {:error, Ecto.Changeset.add_error(changeset, :user_id, "User not found")}

        _user ->
          params
          |> Account.changeset()
          |> Repo.insert()
      end
    end
  end
end
