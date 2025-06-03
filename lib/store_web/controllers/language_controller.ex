defmodule Elementary.StoreWeb.LanguageController do
  use Elementary.StoreWeb, :controller

  use Gettext, backend: Elementary.StoreWeb.Gettext
  alias Elementary.StoreWeb.Gettext, as: Gtext

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def set(conn, %{"lang" => lang} = params) do
    redirect_path = Map.get(params, "path", Routes.index_path(conn, :index))

    if Enum.member?(Gtext.known_language_codes(), lang) do
      language_name = Map.get(Gtext.known_languages(), lang)

      conn
      |> Gtext.put_language(lang)
      |> put_session(:locale, lang)
      |> put_flash(
        :info,
        dgettext("language", "Your language has been set to %{language}",
          language: language_name
        )
      )
      |> redirect(to: redirect_path)
    else
      conn
      |> put_flash(
        :error,
        dgettext("language", "Unknown language code %{code}", code: lang)
      )
      |> redirect(to: redirect_path)
    end
  end
end
