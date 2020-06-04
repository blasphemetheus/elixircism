defmodule SpaceAge do
  @type planet ::
          :mercury
          | :venus
          | :earth
          | :mars
          | :jupiter
          | :saturn
          | :uranus
          | :neptune

  @earth_seconds_per_year 31557600
  @mercury_seconds_per_year @earth_seconds_per_year * 0.2408467
  @venus_seconds_per_year @earth_seconds_per_year * 0.61519726
  @mars_seconds_per_year @earth_seconds_per_year * 1.8808158
  @jupiter_seconds_per_year @earth_seconds_per_year * 11.862615
  @saturn_seconds_per_year @earth_seconds_per_year * 29.447498
  @uranus_seconds_per_year @earth_seconds_per_year * 84.016846
  @neptune_seconds_per_year @earth_seconds_per_year * 164.79132


  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.

  Given an age in seconds, calculate how old someone would be on:

    Earth: orbital period 365.25 Earth days, or 31557600 seconds
    Mercury: orbital period 0.2408467 Earth years
    Venus: orbital period 0.61519726 Earth years
    Mars: orbital period 1.8808158 Earth years
    Jupiter: orbital period 11.862615 Earth years
    Saturn: orbital period 29.447498 Earth years
    Uranus: orbital period 84.016846 Earth years
    Neptune: orbital period 164.79132 Earth years

So if you were told someone were 1,000,000,000 seconds old,
 you should be able to say that they're 31.69 Earth-years old.
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(planet, seconds) do
    case planet do
      :mercury -> seconds / @mercury_seconds_per_year
      :venus -> seconds / @venus_seconds_per_year
      :earth -> seconds / @earth_seconds_per_year
      :mars -> seconds / @mars_seconds_per_year
      :jupiter -> seconds / @jupiter_seconds_per_year
      :saturn -> seconds / @saturn_seconds_per_year
      :uranus -> seconds / @uranus_seconds_per_year
      :neptune -> seconds / @neptune_seconds_per_year
      true -> 1 / 0
    end
  end
end
