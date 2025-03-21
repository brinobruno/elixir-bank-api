defmodule BananaBank.Accounts.CreateTest do
  use ExUnit.Case, async: true

  import Mox

  alias BananaBank.Users
  alias BananaBank.Accounts
  alias BananaBank.ViaCep.ClientMock

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
    test "successfully creates an account" do
      user_params = %{
        "name" => "John Doe",
        "email" => "john@doe",
        "password" => "123456",
        "cep" => "29560000"
      }

      {:ok, user} = Users.Create.call(user_params)

      account_params = %{
        "user_id" => user.id,
        "balance" => 0
      }

      account_response = Accounts.Create.call(account_params)

      assert {:ok, account} = account_response
      assert account.user_id == user.id
      assert Decimal.to_integer(account.balance) == 0
    end

    test "cannot create an account with user not found" do
      params = %{
        "user_id" => 999999,
        "balance" => 0
      }

      response = Accounts.Create.call(params)

      assert {:error, changeset} = response
      assert %Ecto.Changeset{valid?: false} = changeset
      assert {"User not found", _} = changeset.errors[:user_id]
    end
  end
end
