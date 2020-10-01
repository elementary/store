defmodule Elementary.StoreWeb.Gettext do
  @moduledoc """
  A module providing Internationalization with a gettext-based API.

  By using [Gettext](https://hexdocs.pm/gettext),
  your module gains a set of macros for translations, for example:

      import Elementary.StoreWeb.Gettext

      # Simple translation
      gettext("Here is the string to translate")

      # Plural translation
      ngettext("Here is the string to translate",
               "Here are the strings to translate",
               3)

      # Domain-based translation
      dgettext("errors", "Here is the error message to translate")

  See the [Gettext Docs](https://hexdocs.pm/gettext) for detailed usage.
  """
  use Gettext, otp_app: :store

  @doc """
  Returns the default language code set by the code configuration.
  """
  def default_language_code() do
    :store
    |> Application.get_env(__MODULE__)
    |> Keyword.get(:default_locale, "en")
  end

  @doc """
  Gets the language code saved for the user's session.
  """
  def get_language(conn, default \\ nil) do
    Map.get(conn.private, :lang, default)
  end

  @doc """
  Returns a list of known languages
  """
  def known_languages() do
    :store
    |> Application.get_env(Elementary.StoreWeb.Gettext)
    |> Keyword.get(:locales, [])
    |> Map.take(known_language_codes())
  end

  @doc """
  Returns a list of known language codes.
  """
  def known_language_codes() do
    Gettext.known_locales(__MODULE__)
  end

  @doc """
  Sets the language code for a user and sets their session to persist it across
  refreshes.
  """
  def put_language(conn, nil), do: conn

  def put_language(conn, code) do
    Gettext.put_locale(code)
    Plug.Conn.put_private(conn, :lang, code)
  end
end
