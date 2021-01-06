defmodule Mix.Tasks.Printful.Analytics.Monthly do
  @moduledoc "Gives stats on the monthly sales in Printful from the store"
  @shortdoc "Gives stats on the monthly sales in Printful from the store"

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
    |> Enum.group_by(&date_to_month/1)
    |> Enum.sort_by(&elem(&1, 0), {:asc, Date})
    |> Enum.each(fn {date, orders} ->
      cost = cost_sum(orders, :printful_price)
      price = cost_sum(orders, :customer_pays)
      profit = cost_sum(orders, :profit)

      Mix.shell().info("#{Date.to_string(date)}")
      Mix.shell().info("Cost: #{cost}")
      Mix.shell().info("Price: #{price}")
      Mix.shell().info("Profit: #{profit}")
      Mix.shell().info("")
    end)
  end

  def date_to_month(%{created: unix_time}) do
    unix_time
    |> DateTime.to_date()
    |> Date.beginning_of_month()
  end

  def cost_sum(orders, key) do
    orders
    |> Enum.map(&Map.get(&1, :pricing_breakdown, %{}))
    |> Enum.map(&Enum.at(&1, 0, %{}))
    |> Enum.map(&Map.get(&1, key, "0"))
    |> Enum.map(fn price ->
      if price == nil do
        0
      else
        {number, _remaining} = Float.parse(price)
        number
      end
    end)
    |> Enum.sum()
  end
end
