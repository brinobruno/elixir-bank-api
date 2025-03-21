defmodule BananaBank.Accounts.TransactionTest do
  use ExUnit.Case

  import Mox
  import Ecto.Query

  alias BananaBank.Repo
  alias BananaBank.Users
  alias BananaBank.Users.User
  alias BananaBank.Accounts
  alias BananaBank.Accounts.Account
  alias BananaBank.Accounts.Transaction
  alias BananaBank.ViaCep.ClientMock

  setup :verify_on_exit!

  @cep "12233170"

  @cep_params %{
    "bairro" => "",
    "cep" => @cep,
    "complemento" => "",
    "ddd" => "28",
    "gia" => "",
    "ibge" => "3202306",
    "localidade" => "Guaçuí",
    "logradouro" => "",
    "siafi" => "5645",
    "uf" => "ES"
  }

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(BananaBank.Repo, {:shared, self()})

    # Set up the mock to return a successful response for the CEP
    stub(ClientMock, :call, fn @cep ->
      {:ok, @cep_params}
    end)

    user_one_params = %{
      "name" => "John Doe",
      "email" => "john@one",
      "password" => "123456",
      "cep" => @cep
    }



    user_two_params = %{
      "name" => "John Doe",
      "email" => "john@two",
      "password" => "123456",
      "cep" => @cep
    }

    {:ok, user_one} = Users.Create.call(user_one_params)
    account_one_params = %{
      "user_id" => user_one.id,
      "balance" => 1000
    }
    Accounts.Create.call(account_one_params)

    {:ok, user_two} = Users.Create.call(user_two_params)
    account_two_params = %{
      "user_id" => user_two.id,
      "balance" => 1000
    }
    Accounts.Create.call(account_two_params)

    :ok
  end

  describe "call/1" do
    test "successfully creates a transaction" do
      accounts = Repo.all(Accounts.Account)

      transaction = Transaction.call(%{
        "from_account_id" => Enum.at(accounts, 0).id,
        "to_account_id" => Enum.at(accounts, 1).id,
        "value" => 100
      })

      result = elem(transaction, 1) |> Map.take([:deposit, :withdraw])

      withdraw = result[:withdraw] |> Map.take([:balance])
      deposit = result[:deposit] |> Map.take([:balance])

      assert withdraw == %{balance: Decimal.new("900")}
      assert deposit == %{balance: Decimal.new("1100")}
    end
  end
end
