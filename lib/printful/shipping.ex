defmodule Printful.Shipping do
  @moduledoc """
  This is for handling shipping information from Printful.
  """

  alias Printful.Api

  def countries() do
    Api.get("/countries")
  end

  def rates(body) do
    Api.post("/shipping/rates", body)
  end
end
