defmodule Printful.Order do
  @moduledoc """
  This module handles order information from Printful
  """

  alias Printful.Api

  require Logger

  def list(opts \\ [status: "fulfilled", limit: 100]) do
    Api.get("/orders", opts)
  end

  def get(id) do
    Api.get("/orders/#{id}")
  end

  def create(params) do
    Api.post("/orders", Map.put(params, :confirm, false))
  end

  def estimate(params) do
    Api.post("/orders/estimate-costs", params)
  end

  def delete(id) do
    Api.delete("/orders/#{id}")
  end

  def confirm(id) do
    if Application.get_env(:store, Printful.Api)[:enable_purchasing] do
      Api.post("/orders/#{id}/confirm", %{})
    else
      Logger.warning("Not confirming order #{id} due to printful settings")
    end
  end
end
