defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @initial_value 0

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, account} = Agent.start(fn -> @initial_value end)

    account
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(pid) do
    Agent.stop(pid)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(pid) do
    if Process.alive?(pid) do
      Agent.get(pid, &(&1))
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(pid, amount) do
    if Process.alive?(pid) do
      Agent.update(pid, &(&1 + amount))
    else
      {:error, :account_closed}
    end
  end
end
