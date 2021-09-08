defmodule AuctionWeb.GlobalHelpers do
  use Timex

  @spec integer_to_currency(integer) :: binary()
  def integer_to_currency(cents) do
    cents
    |> Decimal.div(100)
    |> Decimal.round(2)
    |> (&("$#{&1}")).()
  end

  @spec formatted_datetime(DateTime) :: binary()
  def formatted_datetime(datetime), do: Timex.format!(datetime, "%H:%M %m/%d", :strftime)
end
