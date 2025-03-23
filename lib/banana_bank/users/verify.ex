defmodule BananaBank.Users.Verify do
  import Ecto.Query

  alias BananaBank.Repo
  alias BananaBank.Users.User

  def call(%{"email" => email, "password" => password}) do
    case Repo.one(from u in User, where: u.email == ^email) do
      nil -> {:error, :user_not_found}
      user -> verify(user, password)
    end
  end

  defp verify(user, password) do
    case Argon2.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, :unauthorized}
    end
  end
end
