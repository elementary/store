defmodule Elementary.Store.Printful do
  @moduledoc """
  A simple HTTP client for Printful
  """

  alias Elementary.Store.Printful.Parser

  def new() do
    config = Application.get_env(:store, __MODULE__)

    middleware = [
      Tesla.Middleware.JSON,
      Tesla.Middleware.Telemetry,
      {Tesla.Middleware.BaseUrl, config[:baseUrl]},
      {Tesla.Middleware.Headers,
       [
         {"Authorization", "Basic #{Base.encode64(config[:api_key])}"}
       ]}
    ]

    Tesla.client(middleware, Application.get_env(:tesla, :adapter))
  end

  def products() do
    query = [status: "synced", limit: 100]

    case Tesla.get(new(), "/store/products", query: query) do
      {:ok, %{status: 200, body: %{"result" => products}}} ->
        new_products =
          products
          |> Enum.filter(&(&1["synced"] !== 0))
          |> Enum.map(&Parser.parse_product/1)

        {:ok, new_products}

      err ->
        err
    end
  end

  def variants(product_id) do
    case Tesla.get(new(), "/store/products" <> product_id) do
      {:ok, %{status: 200, body: %{"result" => variants}}} ->
        new_variants =
          variants
          |> Enum.filter(&(&1["synced"] === true))
          |> Enum.map(&Parser.parse_variants/1)

        {:ok, new_variants}

      err ->
        err
    end
  end
end
