defmodule Mix.Tasks.Printful.Analytics.Designs do
  @moduledoc "Gives stats on design sales in Printful from the store"
  @shortdoc "Gives stats on design sales in Printful from the store"

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

    Mix.shell().info("#{length(orders)} orders from the store")

    orders
    |> Enum.flat_map(& &1.items)
    |> IO.inspect(label: "product")
    |> Enum.filter(&Map.has_key?(&1, :custom_product))
    |> Enum.group_by(& &1.custom_product.id)
    |> Enum.each(fn {_, items} ->
      Mix.shell().info("#{length(items)} #{hd(items).custom_product.name}")
    end)
  end
end
