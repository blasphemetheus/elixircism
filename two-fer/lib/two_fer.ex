defmodule TwoFer do
  @prefix "One for "
  @suffix ", one for me"
  @default_name "you"
  @doc """
  Two-fer or 2-fer is short for two for one. One for you and one for me.
  """
  @spec two_fer(String.t()) :: String.t()
  def two_fer(name) when is_binary(name) do
    @prefix <> name <> @suffix
  end

  def two_fer() do
    @prefix <> @default_name <> @suffix
  end
end
