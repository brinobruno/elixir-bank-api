defmodule BananaBank.Accounts.Create do
  import Ecto.Query

  alias BananaBank.Accounts.Account
  alias BananaBank.Users.User
  alias BananaBank.Repo

  def call(params) do
    user = Repo.one(from u in User, where: u.id == ^params["user_id"])

    case user do
      nil ->
        # Creates an empty changeset
        changeset = Ecto.Changeset.change(%Account{})
        {:error, Ecto.Changeset.add_error(changeset, :user_id, "User not found")}

      _user ->
        params
        |> Account.changeset()
        |> Repo.insert()
    end
  end
end
