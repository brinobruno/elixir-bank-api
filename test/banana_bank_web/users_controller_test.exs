defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  alias BananaBank.Users
  alias Users.User

  @valid_params %{
    name: "Bruno",
    email: "bruno@bruno.com",
    password: "coxinha123",
    cep: "12233170"
  }

  @invalid_params %{
    name: nil,
    email: "bruno@bruno.com",
    password: "coxinha123",
    cep: "12"
  }

  describe "create/2" do
    test "successfully creates an user", %{conn: conn} do
      response =
        conn
        |> post(~p"/api/users", @valid_params)
        |> json_response(:created)

      assert %{
               "data" => %{
                 "cep" => "12233170",
                 "email" => "bruno@bruno.com",
                 "id" => _id,
                 "name" => "Bruno"
               },
               "message" => "User created successfully"
             } = response
    end

    test "returns an error when attempting to create user with invalid params", %{conn: conn} do
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
