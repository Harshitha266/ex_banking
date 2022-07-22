defmodule ExBankingTest do
  use ExUnit.Case, async: true

  setup do
    user = random_string(10)

    {:ok, user: user}
  end

  describe "Create user with valid user params" do
    test "creates user", %{user: user} do
      assert :ok == ExBanking.create_user(user)
    end
  end

  describe "Createuser with invalid params" do
    test "returns {:error, :wrong_arguments}" do
        assert {:error, :wrong_arguments} == ExBanking.create_user(nil)
    end
  end

  describe "creating user with existing user name" do
    test "returns {:error, :already_exists}", %{user: user} do
      ExBanking.create_user(user)
      assert {:error, :already_exists} == ExBanking.create_user(user)
    end
  end

  describe "deposit new currency" do
    test "returns {:ok, new_balance}", %{user: user} do
      ExBanking.create_user(user)
      assert {:ok, 100} == ExBanking.deposit(user, 100, "rub")
    end
  end

  describe "deposit existing currency" do
    test "returns {:ok, new_balance} where new_balance is currency balance + amount", %{user: user} do
      ExBanking.create_user(user)
      assert {:ok, 10} == ExBanking.deposit(user, 10, "btc")
    end
  end

  describe "deposit currency with non-existing user" do
    test "returns {:error, :user_does_not_exist}" do
      assert {:error, :user_does_not_exist} == ExBanking.deposit("invalid_user", 10, "btc")
    end
  end

  describe "deposit with negative number" do
    test "returns {:error, :wrong_arguments}", %{user: user} do
      ExBanking.create_user(user)
      assert {:error, :wrong_arguments} == ExBanking.deposit(user, -10, "btc")
    end
  end

  describe "deposit invalid currency type" do
    test "returns {:error, :wrong_arguments}", %{user: user} do
      ExBanking.create_user(user)
      assert {:error, :wrong_arguments} == ExBanking.deposit(user, 100, nil)
    end
  end

  describe "deposit with invalid user " do
    test "returns {:error, :wrong_arguments}" do
     assert {:error, :wrong_arguments} == ExBanking.deposit(nil, 100, "btc")
    end
  end


  describe "deposit with request rate limit exceeded" do
    test "returns {:error, :too_many_requests_to_user}", %{user: user} do
      ExBanking.create_user(user, 0)
      assert {:error, :too_many_requests_to_user} == ExBanking.deposit(user, 100, "btc")
    end
  end

  describe "withdraw users balance" do
    test "returns {:ok, new_balance}", %{user: user} do
      ExBanking.create_user(user)
      ExBanking.deposit(user, 100, "btc")
      assert {:ok, 50} == ExBanking.withdraw(user, 50, "btc")
      assert {:ok, 0} == ExBanking.withdraw(user, 50, "btc")
    end
  end

  describe "withdraw higher amount than the user balance " do
    test "returns {:error, :not_enough_money}", %{user: user} do
      ExBanking.create_user(user)
      ExBanking.deposit(user, 100, "btc")
      assert {:error, :not_enough_money} == ExBanking.withdraw(user, 200, "btc")
    end
  end

  describe "withdraw with negative number" do
    test "returns {:error, :wrong_arguments}", %{user: user} do

      ExBanking.create_user(user)
      ExBanking.deposit(user, 100, "btc")
      assert {:error, :wrong_arguments} == ExBanking.withdraw(user, -100, "btc")
    end
  end


  describe "get_balance of a user" do
    test "returns {:ok, balance}", %{user: user} do
      ExBanking.create_user(user)
      ExBanking.deposit(user, 100, "btc")

      assert {:ok, 100} == ExBanking.get_balance(user, "btc")

    end
  end

  describe "get_balance with non existing user" do
    test "returns {:error, :user_does_not_exist}" do
      assert {:error, :user_does_not_exist} == ExBanking.get_balance(nil, "btc")
    end
  end

  describe "#send/4 with valid params and non-existing recipient balance" do
    test "returns {:ok, from_balance, to_balance}" do
      sender = random_string(16)
      receiver = random_string(16)

      ExBanking.create_user(sender)
      ExBanking.create_user(receiver)

      ExBanking.deposit(sender, 100, "rub")
      assert {:ok, 50, 50} == ExBanking.send(sender, receiver, 50, "rub")

    end
  end

  describe "transfer balance from sender to receiver" do
    test "returns {:ok, from_balance, to_balance}" do
      sender = random_string(16)
      receiver = random_string(16)

      ExBanking.create_user(sender)
      ExBanking.create_user(receiver)

      ExBanking.deposit(sender, 100, "btc")
      ExBanking.deposit(receiver, 100, "btc")
      assert {:ok, 50, 150} == ExBanking.send(sender, receiver, 50, "btc")
    end
  end

  describe "send with non-existing sender" do
    test "returns {:error, sender_does_not_exist}", %{user: user} do
      ExBanking.create_user(user)

      assert {:error, :sender_does_not_exist} == ExBanking.send("nil", user, 100, "btc")
    end
  end


  defp random_string(length) do
  :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
