defmodule Elementary.StoreWeb.HealthController do
  @moduledoc """
  A simple health checking endpoint used for load balancers and kube clusters.
  """

  use Elementary.StoreWeb, :controller

  def index(conn, _params) do
    send_resp(conn, 200, "ok")
  end
end
