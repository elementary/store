defmodule Printful.Cache do
  @moduledoc """
  A Tesla middleware to cache successful get requests
  """

  @default_ttl :timer.hours(48)

  def call(%{method: :get} = env, next, _opts) do
    case Cachex.get!(__MODULE__, cache_key(env)) do
      nil -> call_cached(env, next)
      result -> {:ok, result}
    end
  end

  def call(env, next, _opts), do: Tesla.run(env, next)

  def clear() do
    Cachex.clear(__MODULE__)
  end

  defp call_cached(env, next) do
    env
    |> Tesla.run(next)
    |> set_cache(env)
  end

  defp set_cache({:ok, res}, env) do
    Cachex.put(__MODULE__, cache_key(env), res, ttl: @default_ttl)
    {:ok, res}
  end

  defp set_cache(res, _env), do: res

  defp cache_key(%Tesla.Env{url: url, query: query}), do: Tesla.build_url(url, query)
end
