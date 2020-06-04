defmodule SecretHandshake do
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    binarize_secretly(code)
  end

  @spec binarize_secretly(base_ten :: integer) :: integer()
  def binarize_secretly(base_ten) do
    # this is an exercise in obfuscation I guess, I should just use the div/rem
    #  but I figured out how to do it with just bitwise-and
    use Bitwise
      cond do
        # the bitwise and (band) is used to check if the binary value in the 16's digit is filled
        # if it is (not 0), then ... reverse the recursion with the number passed in the
        # same number but with the 16's bit wiped to 0 (use band to do this)
        band(base_ten, 16) != 0 -> :lists.reverse(binarize_secretly(band(base_ten, 0b11101111)))
        base_ten == 0 -> []
        band(base_ten, 1) != 0 -> ["wink"] ++ binarize_secretly(band(base_ten, 0b11111110))
        band(base_ten, 2) != 0 -> ["double blink"] ++ binarize_secretly(band(base_ten, 0b11111101))
        band(base_ten, 4) != 0 -> ["close your eyes"] ++ binarize_secretly(band(base_ten, 0b11111011))
        band(base_ten, 8) != 0 -> ["jump"] ++ binarize_secretly(band(base_ten, 0b11110111))
        true -> []
      end
  end
end
