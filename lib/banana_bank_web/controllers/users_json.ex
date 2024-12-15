defmodule BananaBankWeb.UsersJSON do
  def create(%{user: user}) do
    %{
      message: "User created successfully",
      data: user
    }
  end

  def delete(%{user: user}), do: %{message: "User deleted successfully"}

  def get(%{user: user}), do: %{data: user}

  def update(%{user: user}) do
    %{
      message: "User updated successfully",
      data: user
    }
  end
end
