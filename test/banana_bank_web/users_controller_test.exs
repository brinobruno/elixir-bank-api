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
  end
end
