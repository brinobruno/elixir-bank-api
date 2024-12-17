defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  import Mox

  alias BananaBank.Users
  alias Users.User
  alias BananaBank.ViaCep.ClientMock

  setup :verify_on_exit!

  @cep "12233170"

  @valid_params %{
    "name" => "Bruno",
    "email" => "bruno@bruno.com",
    "password" => "coxinha123",
    "cep" => @cep
  }

  @invalid_params %{
    name: nil,
    email: "bruno@bruno.com",
    password: "coxinha123",
    cep: "12"
  }

  @cep_body %{
    "bairro" => "Bosque dos Eucaliptos",
    "cep" => @cep,
    "complemento" => "",
    "ddd" => "12",
    "estado" => "São Paulo",
    "gia" => "6452",
    "ibge" => "3549904",
    "localidade" => "São José dos Campos",
    "logradouro" => "Rua Sebastiana Monteiro",
    "regiao" => "Sudeste",
    "siafi" => "7099",
    "uf" => "SP",
    "unidade" => ""
  }

  describe "create/2" do
    test "successfully creates an user", %{conn: conn} do
      expect(ClientMock, :call, fn @cep ->
        {:ok, @cep_body}
      end)

      response =
        conn
        |> post(~p"/api/users", @valid_params)
        |> json_response(:created)

      assert %{
               "data" => %{
                 "cep" => @cep,
                 "email" => "bruno@bruno.com",
                 "id" => _id,
                 "name" => "Bruno"
               },
               "message" => "User created successfully"
             } = response
    end

    test "returns an error when attempting to create user with invalid params", %{conn: conn} do
      expect(ClientMock, :call, fn "12" ->
        {:ok, ""}
      end)

      response =
        conn
        |> post(~p"/api/users", @invalid_params)
        |> json_response(:bad_request)

      expected_response = %{
        "errors" => %{"cep" => ["should be 8 character(s)"], "name" => ["can't be blank"]}
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    test "successfully deletes an user", %{conn: conn} do
      expect(ClientMock, :call, fn @cep ->
        {:ok, @cep_body}
      end)

      {:ok, %User{id: id}} = Users.create(@valid_params)

      response =
        conn
        |> delete(~p"/api/users/#{id}")
        |> json_response(:ok)

      expected_response = %{"message" => "User deleted successfully"}

      assert response == expected_response
    end
  end
end
