defmodule Printful.Store do
  @moduledoc """
  Handles everything Printful store related
  """

  alias Printful.Api

  def products() do
    Api.get("/store/products", status: "synced", limit: 100)
  end

  def product(product_id) do
    Api.get("/store/products/" <> to_string(product_id))
  end

  def variants(product_id) do
    Api.get("/store/products/" <> to_string(product_id))
  end

  def variant(variant_id) do
    Api.get("/store/variants/" <> to_string(variant_id))
  end
end
