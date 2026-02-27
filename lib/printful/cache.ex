defmodule Printful.Cache do
  @moduledoc """
  A Tesla middleware to cache successful get requests
  """

  use Nebulex.Cache,
    otp_app: :store,
    adapter: Nebulex.Adapters.Local

  def call(%{method: :get} = env, next, _opts) do
    case env |> cache_key |> get!() do
      nil -> call_cached(env, next)
      result -> {:ok, result}
    end
  end

  def call(env, next, _opts), do: Tesla.run(env, next)

  defp call_cached(env, next) do
    env
    |> Tesla.run(next)
    |> call_cached_set(env)
  end

  defp call_cached_set(res, env) do
    case res do
      {:ok, %{status: status} = res_env} when status in 200..299 ->
        with :ok <- env |> cache_key() |> put(res_env) do
          {:ok, res_env}
        end

      res ->
        res
    end
  end

  defp cache_key(%Tesla.Env{url: url, query: query}), do: Tesla.build_url(url, query)
end
