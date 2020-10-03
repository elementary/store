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

      {:ok, %{body: %{"error" => %{"message" => message}}}} ->
        {:error, message}

      res ->
        res
    end
  end

  def product(id) do
    case Tesla.get(new(), "/store/products/" <> id) do
      {:ok, %{status: 200, body: %{"result" => product}}} ->
        new_variants =
          product["sync_variants"]
          |> Enum.filter(&(&1["synced"] !== 0))
          |> Enum.map(&Parser.parse_variants/1)

        new_product =
          product["sync_product"]
          |> Parser.parse_product()
          |> Map.put(:variants, new_variants)

        {:ok, new_product}

      {:ok, %{body: %{"error" => %{"message" => message}}}} ->
        {:error, message}

      res ->
        res
    end
  end
end
