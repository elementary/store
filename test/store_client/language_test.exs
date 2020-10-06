defmodule Elementary.StoreClient.LanguageTest do
  use ExUnit.Case
  use Elementary.StoreClient.BrowserCase

  feature "can set the language from the language page", %{session: session} do
    session
    |> visit("/")
    |> assert_langauge("en")
    |> visit("/language")
    |> click(Query.text("日本語"))
    |> assert_langauge("ja")
  end

  feature "can set the language from query string", %{session: session} do
    session
    |> visit("/?locale=ja")
    |> assert_langauge("ja")
  end

  defp assert_langauge(session, lang) do
    find(session, Query.css("html"), fn element ->
      assert Element.attr(element, "lang") == lang
    end)
  end
end
