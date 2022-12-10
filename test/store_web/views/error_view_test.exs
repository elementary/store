defmodule Elementary.StoreWeb.ErrorViewTest do
  use Elementary.StoreWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(Elementary.StoreWeb.ErrorView, "404.html", []) =~ "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(Elementary.StoreWeb.ErrorView, "500.html", []) =~
             "There was a server error"
  end
end
