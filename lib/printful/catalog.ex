defmodule Printful.Catalog do
  @moduledoc """
  Handles everything catalog related for Printful.
  """

  alias Printful.Api

  def variant(id) do
    Api.get("/products/variant/" <> to_string(id))
  end
end
