defmodule Printful.Order do
  @moduledoc """
  This module handles order information from Printful
  """

  alias Printful.Api

  def list(opts \\ [status: "fulfilled", limit: 100]) do
    Api.get("/orders", opts)
  end
end
