defmodule Elementary.Store.Shipping.Rate do
  @moduledoc """
  A shipping rate quote.
  """

  @enforce_keys [:id]

  @estimate_regex ~r/^(.+)\((.*)\)$/

  defstruct [
    :id,
    :name,
    :estimate,
    :price
  ]

  @doc """
  Converts some Printful API data to an `Elementary.Store.Shipping.Rate`
  struct.
  """
  def from_printful(shipping) do
    ext = extract_estimate(shipping.name)
    {price, _} = Float.parse(shipping.rate)

    struct(__MODULE__,
      id: shipping.id,
      name: ext.name,
      estimate: ext.estimate,
      price: price
    )
  end

  defp extract_estimate(raw) do
    raw_formatted = format_string(raw)

    if Regex.match?(@estimate_regex, raw_formatted) do
      [_full, name, estimate] = Regex.run(@estimate_regex, raw_formatted)
      %{name: format_string(name), estimate: format_string(estimate)}
    else
      %{name: format_string(raw), estimate: nil}
    end
  end

  defp format_string(str) do
    str
    |> String.replace("–", "-")
    |> String.replace("Estimated delivery:", "")
    |> String.trim()
  end
end
