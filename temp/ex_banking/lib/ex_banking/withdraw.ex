defmodule ExBanking.Withdraw do
  defstruct [:user, :amount, :currency]
  alias __MODULE__
  alias Decimal, as: D
  @precision Application.get_env(:ex_banking, :precision, 2)

  def withdraw(user, amount, currency)
  when is_binary(user)
   and is_number(amount)
   and amount > 0
   and is_binary(currency)
  do
    decimal = amount |> D.new() |> D.round(@precision)
    {:ok, %Withdraw{user: user, amount: decimal, currency: currency}}
  end

  def withdraw(_user, _amount, _currency) do
    {:error, :wrong_arguments}
  end
end
