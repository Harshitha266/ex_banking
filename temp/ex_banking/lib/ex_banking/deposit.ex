defmodule ExBanking.Deposit do
  defstruct [:user, :amount, :currency]
  alias __MODULE__
  alias Decimal
  @precision Application.get_env(:ex_banking, :precision, 2)

  def deposit(user, amount, currency)
  when is_binary(user)
   and is_number(amount)
   and amount > 0
   and is_binary(currency)
  do
    decimal = amount |> Decimal.new() |> Decimal.round(@precision)
    {:ok, %Deposit{user: user, amount: decimal, currency: currency}}
  end

  def deposit(_user, _amount, _currency) do
    {:error, :wrong_arguments}
  end
end
