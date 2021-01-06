defmodule Mix.Tasks.Printful.Analytics.Products do
  @moduledoc "Gives stats on what products we sell the most in Printful"
  @shortdoc "Gives stats on what products we sell the most in Printful"

  use Mix.Task

  @impl Mix.Task
  def run([]), do: run(["100"])

  def run([number]) do
    Mix.Task.run("app.start")

    orders =
      0..ceil(String.to_integer(number) / 100)
      |> Enum.map(&(&1 * 100))
      |> Enum.map(&Printful.Order.list(status: "fulfilled", limit: 100, offset: &1))
      |> Enum.concat()
      |> Enum.filter(&(&1.external_id != nil and String.starts_with?(&1.external_id, "ch_")))
      |> Enum.map(&Map.put(&1, :created, DateTime.from_unix!(&1.created)))

    Mix.shell().info("#{length(orders)} orders from the store")

    orders
    |> Enum.flat_map(& &1.items)
    |> Enum.group_by(&product_id/1)
    |> Enum.sort_by(&elem(&1, 1), :desc)
    |> Enum.each(fn {_, items} ->
      Mix.shell().info("#{length(items)} #{hd(items).product.name}")
    end)
  end

  def product_id(item) do
    to_string(item.product.product_id) <> "-" <> to_string(item.product.variant_id)
  end
end
