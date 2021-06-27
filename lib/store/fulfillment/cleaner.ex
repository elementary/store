defmodule Elementary.Store.Fulfillment.Cleaner do
  @moduledoc """
  Cleans up old draft orders in Printful.
  """

  use GenServer

  import Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    Process.send_after(self(), :refresh, 1000)
    {:ok, opts}
  end

  @impl true
  def handle_info(:refresh, state) do
    do_refresh()

    Process.send_after(self(), :refresh, 6 * 60 * 60 * 1000)
    {:noreply, state}
  end

  defp do_refresh() do
    [status: "draft", limit: 100]
    |> Printful.Order.list()
    |> Enum.filter(&can_delete_order?/1)
    |> Enum.each(&delete_order/1)
  end

  def can_delete_order?(order) do
    created_at = DateTime.from_unix!(order.created)
    deadline = DateTime.utc_now() |> DateTime.add(-1 * 6 * 60 * 60, :second)

    DateTime.compare(created_at, deadline) == :lt
  end

  def delete_order(order) do
    Printful.Order.delete(order.id)
  rescue
    e in Printful.ApiError ->
      Logger.error("Error deleting printful draft order: #{inspect(e)}")
  end
end
