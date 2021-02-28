defmodule Elementary.Store.Checkout.Address do
  @moduledoc """
  Holds geography information for a user
  """

  use Ecto.Schema

  import Ecto.Changeset

  @address_template [
    [:line1],
    [:line2],
    [:city, :state],
    [:country, :zip]
  ]

  embedded_schema do
    field :line1, :string
    field :line2, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :postal, :string
  end

  def changeset(%__MODULE__{} = address, attrs \\ %{}) do
    address
    |> cast(attrs, [:line1, :line2, :city, :state, :country, :postal])
    |> validate_required([:line1, :country, :postal])
    |> validate_length(:country, is: 2)
  end

  @doc """
  Templates the address to a readable text for printing in html.
  """
  def template(address) do
    @address_template
    |> Enum.map(&line_template(address, &1))
    |> Enum.reject(&(&1 == ""))
  end

  defp line_template(address, fields) do
    fields
    |> Enum.map(&Map.get(address, &1, ""))
    |> Enum.join(" ")
    |> String.replace(~r/\s+/, " ")
    |> String.trim()
  end
end
