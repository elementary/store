defmodule Elementary.StoreWeb.LanguageController do
  use Elementary.StoreWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def set(conn, %{"code" => code} = params) do
    Gettext.put_locale(language_code(code))

    redirect_path = Map.get(params, "path", Routes.index_path(conn, :index))
    redirect(conn, to: redirect_path)
  end

  defp language_code(code) do
    if Enum.member?(Elementary.StoreWeb.Gettext.known_language_codes(), code) do
      code
    else
      Elementary.StoreWeb.Gettext.default_language_code()
    end
  end
end
