defmodule BananaBank.Helpers.HandleTransaction do
  def call({:ok, _result} = result), do: result
  def call({:error, _operation, reason, _}), do: {:error, reason}
end
