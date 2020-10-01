defmodule Elementary.StoreClient.BrowserCase do
  @moduledoc """
  This module defines the test case to be used by
  tests for the browser.

  Such tests rely on `Wallaby` and also import other functionality
  to make it easier to query HTML documents and interact with them.
  """

  use ExUnit.CaseTemplate

  import Wallaby.{Browser, Query}

  using do
    quote do
      use Wallaby.Feature

      import Plug.Conn

      import Elementary.StoreClient.BrowserCase

      import Wallaby.Query,
        only: [
          css: 2,
          text_field: 1,
          button: 1,
          link: 1,
          link: 2
        ]
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Elementary.Store.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Elementary.Store.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
