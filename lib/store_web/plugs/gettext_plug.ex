defmodule Elementary.StoreWeb.GettextPlug do
  @moduledoc """
  This modules reads the lang query parameter and the accept-language header to
  determine the user's language by default.
  """

  alias Elementary.StoreWeb.Gettext, as: Gtext

  def init(_), do: nil

  def call(%{query_params: %{"locale" => locale}} = conn, _) do
    lang_code =
      [locale]
      |> ensure_language_fallbacks()
      |> Enum.find(&Enum.member?(Gtext.known_language_codes(), &1))

    Gtext.put_language(conn, lang_code)
  end

  def call(%{cookies: %{"locale" => locale}} = conn, _) do
    lang_code =
      [locale]
      |> ensure_language_fallbacks()
      |> Enum.find(&Enum.member?(Gtext.known_language_codes(), &1))

    Gtext.put_language(conn, lang_code)
  end

  def call(conn, _) do
    lang_code =
      conn
      |> extract_accept_language()
      |> Enum.reject(&is_nil/1)
      |> ensure_language_fallbacks()
      |> Enum.find(&Enum.member?(Gtext.known_language_codes(), &1))

    Gtext.put_language(conn, lang_code)
  end

  defp extract_accept_language(conn) do
    case Plug.Conn.get_req_header(conn, "accept-language") do
      [value | _] ->
        value
        |> String.split(",")
        |> Enum.map(&parse_accept_language/1)
        |> Enum.sort(&(&1.quality > &2.quality))
        |> Enum.map(& &1.tag)

      _ ->
        []
    end
  end

  defp parse_accept_language(string) do
    captures = Regex.named_captures(~r/^\s?(?<tag>[\w\-]+)(?:;q=(?<quality>[\d\.]+))?$/i, string)

    quality =
      case Float.parse(captures["quality"] || "1.0") do
        {val, _} -> val
        _ -> 1.0
      end

    %{tag: captures["tag"], quality: quality}
  end

  defp ensure_language_fallbacks(tags) do
    Enum.flat_map(tags, fn tag ->
      [language | _] = String.split(tag, "-")
      if Enum.member?(tags, language), do: [tag], else: [tag, language]
    end)
  end
end
