defmodule BananaBank.Users.UserTest do
  use ExUnit.Case, async: true

  import Mox

  alias BananaBank.Users
  alias BananaBank.Users.User
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
    test "successfully creates a user changeset" do
      params = %{
        "name" => "John Doe",
        "email" => "john@doe",
        "password" => "123456",
        "cep" => "29560000"
      }

      response = Users.Create.call(params)

      # assert {:ok, user} = response

      # User.changeset(response)
    end
  end
end
