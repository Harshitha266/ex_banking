defmodule ExBanking.GetBalance do
  defstruct [:user, :currency]
  alias __MODULE__

  def get_balance(user, currency) when is_binary(user) and is_binary(currency) do
    {:ok, %GetBalance{user: user, currency: currency}}
  end

  def get_balance(_user, _currency) do
    {:error, :user_does_not_exist}
  end
end
