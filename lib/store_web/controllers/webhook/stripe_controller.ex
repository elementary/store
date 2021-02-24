defmodule Elementary.StoreWeb.Webhook.StripeController do
  use Elementary.StoreWeb, :controller

  alias Elementary.Store.Fulfillment

  require Logger

  def index(conn, _params) do
    payload = conn.assigns[:raw_body]
    secret = Application.get_env(:stripity_stripe, :webhook_secret)

    signature =
      case get_req_header(conn, "stripe-signature") do
        [header] -> header
        _ -> ""
      end

    case Stripe.Webhook.construct_event(payload, signature, secret) do
      {:ok, event} ->
        Task.async(fn -> handle_event(event) end)

        conn
        |> put_status(:ok)
        |> json(%{"status" => "ok"})

      {:error, reason} ->
        Logger.error("Stripe webhook error: #{inspect(reason)}")

        conn
        |> put_status(:bad_request)
        |> json(%{"error" => reason})
    end
  end

  def handle_event(%Stripe.Event{
        type: "checkout.session.completed",
        data: %{object: %{metadata: %{"source" => "elementary/store#v1"}} = checkout_session}
      }) do
    Fulfillment.fulfill_order(checkout_session)
  end

  def handle_event(_event) do
    :ignore
  end
end
