defmodule ExBanking do
  @moduledoc """
  """
  alias ExBanking.{CreateUser, Deposit, Withdraw, Send, GetBalance}
  alias ExBanking.User
  #import ExBanking.CreateUser
  #import ExBanking.{CreateUser, Deposit, Withdraw, Send, GetBalance}

  @type banking_error :: {:error,
    :wrong_arguments                |
    :user_already_exists            |
    :user_does_not_exist            |
    :not_enough_money               |
    :sender_does_not_exist          |
    :receiver_does_not_exist        |
    :too_many_requests_to_user      |
    :too_many_requests_to_sender    |
    :too_many_requests_to_receiver
  }

  @doc """
  Function creates new user in the system with default requests limit.
  New user has zero balance of any currency
  """
  @spec create_user(user :: String.t) :: :ok  | banking_error
  def create_user(user) do
    handle_action(CreateUser.create(user))
  end

  @doc """
  Function creates new user in the system with specified rate limit.
  New user has zero balance of any currency
  """
  @spec create_user(user :: String.t, requests_limit :: integer) :: :ok | banking_error
  def create_user(user, requests_limit) do
    handle_action(CreateUser.create(user, requests_limit))
  end

  @doc """
  Add the user's balance in given currency and returns new_balance of the user in given format
  """
  @spec deposit(user :: String.t, amount :: number, currency :: String.t) :: {:ok, new_balance :: number} | banking_error
  def deposit(user, amount, currency) do
    handle_action(Deposit.deposit(user, amount, currency))
  end

  @doc """
  Subtracts user's balance in given currency and  returns new_balance of the user in given format
  """
  @spec withdraw(user :: String.t, amount :: number, currency :: String.t) :: {:ok, new_balance :: number} | banking_error
  def withdraw(user, amount, currency) do
    handle_action(Withdraw.withdraw(user, amount, currency))
  end

  @doc """
  Returns current balance of the user
  """
  @spec get_balance(user :: String.t, currency :: String.t) :: {:ok, balance :: number} | banking_error
  def get_balance(user, currency) do
    handle_action(GetBalance.get_balance(user, currency))
  end

  @doc """
  Transfers the amount from sender to the receiver and returns balance of from_user and to_user
  """
  @spec send(from_user :: String.t, to_user :: String.t, amount :: number, currency :: String.t) :: {:ok, from_user_balance :: number, to_user_balance :: number} | banking_error
  def send(from_user, to_user, amount, currency) do
    handle_action(Send.send(from_user, to_user, amount, currency))
  end

  defp handle_action({:ok, operation}) do
    User.handle(operation)
  end
  defp handle_action(error) do
    error
  end
end
