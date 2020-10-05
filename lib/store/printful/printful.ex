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

  def get(url, query \\ []) do
    case Tesla.get(new(), url, query: query) do
      {:ok, %{status: 200, body: %{"result" => result}}} ->
        {:ok, result}

      {:ok, %{body: %{"error" => %{"message" => message}}}} ->
        {:error, message}

      res ->
        res
    end
  end

  def products() do
    cache_block("products", fn ->
      case get("/store/products", status: "synced", limit: 100) do
        {:ok, products} -> {:ok, Parser.parse_product(products)}
        result -> result
      end
    end)
  end

  def product(id) do
    cache_block("product-" <> id, fn ->
      case get("/store/products/" <> id) do
        {:ok, results} -> {:ok, Parser.parse_product_and_variants(results)}
        result -> result
      end
    end)
  end

  def variant(id) do
    cache_block("variant-" <> id, fn ->
      case get("/store/variants/" <> id) do
        {:ok, variant} -> {:ok, Parser.parse_variant(variant)}
        result -> result
      end
    end)
  end

  defp cache_block(key, fun) do
    case Cachex.get(__MODULE__, key) do
      {:ok, nil} -> set_cache_block(key, fun)
      {:ok, result} -> {:ok, result}
    end
  end

  defp set_cache_block(key, fun) do
    case apply(fun, []) do
      {:ok, result} ->
        Cachex.put(__MODULE__, key, result, til: :timer.minutes(5))
        {:ok, result}

      res ->
        res
    end
  end
end
