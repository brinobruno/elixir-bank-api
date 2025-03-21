defmodule BananaBank.Users.UserTest do
  use ExUnit.Case, async: true

  import Mox

  alias BananaBank.Users
  alias BananaBank.Users.User
  alias BananaBank.ViaCep.ClientMock
  alias BananaBank.Repo

  setup :verify_on_exit!

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(BananaBank.Repo)

    # Set up the mock to return a successful response for the CEP
    stub(ClientMock, :call, fn "29560000" ->
      {:ok, %{
        "bairro" => "",
        "cep" => "29560-000",
        "complemento" => "",
        "ddd" => "28",
        "gia" => "",
        "ibge" => "3202306",
        "localidade" => "Guaçuí",
        "logradouro" => "",
        "siafi" => "5645",
        "uf" => "ES"
      }}
    end)

    :ok
  end

  describe "call/1" do
    test "successfully creates a user changeset" do
      params = %{
        "name" => "John Doe",
        "email" => "john@doe.com",
        "password" => "123456",
        "cep" => "29560000"
      }

      response = Users.Create.call(params)

      assert {:ok, user} = response
      assert user.name == "John Doe"
      assert user.email == "john@doe.com"
      assert user.cep == "29560000"
      assert is_binary(user.password_hash)
    end

    test "fails to create a user with missing fields" do
      params = %{
        "name" => "John Doe",
        "password" => "123456",
        "cep" => "29560000"
      }

      response = Users.Create.call(params)

      assert {:error, changeset} = response
      assert "can't be blank" in errors_on(changeset).email
    end

    test "fails to create a user with invalid email format" do
      params = %{
        "name" => "John Doe",
        "email" => "invalid-email",
        "password" => "123456",
        "cep" => "29560000"
      }

      response = Users.Create.call(params)

      assert {:error, changeset} = response
      assert "has invalid format" in errors_on(changeset).email
    end
  end

  # Utility function to extract errors from a changeset
  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
  end
end
