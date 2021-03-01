defmodule Printful.Tax do
  @moduledoc """
  This module handles tax rates from Printful
  """

  alias Printful.Api

  require Logger

  def get(params) do
    Api.post("/tax/rates", params)
  end
end
