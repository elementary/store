defmodule Printful.Catalog do
  @moduledoc """
  Handles everything catalog related for Printful.
  """

  alias Printful.{Api, ApiError}

  def variant(id) do
    try do
      {:ok, Api.get("/products/variant/" <> to_string(id))}
    rescue
      e in ApiError -> {:error, e}
    end
  end
end
