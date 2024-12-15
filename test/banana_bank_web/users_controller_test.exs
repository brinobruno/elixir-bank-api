defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  describe "create" do
    test "successfully creates an user", %{conn: conn} do
      params = %{
        name: "Bruno",
        email: "bruno@bruno.com",
        password: "coxinha123",
        cep: "12233170"
      }

      response =
        conn
        |> post(~p"/api/users", params)
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
      params = %{
        name: nil,
        email: "bruno@bruno.com",
        password: "coxinha123",
        cep: "12"
      }

      response =
        conn
        |> post(~p"/api/users", params)
        |> json_response(:bad_request)

      expected_response = %{
        "errors" => %{"cep" => ["should be 8 character(s)"], "name" => ["can't be blank"]}
      }

      assert response == expected_response
    end
  end
end
