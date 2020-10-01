defmodule Elementary.StoreWeb.LanguageView do
  use Elementary.StoreWeb, :view

  def available_languages() do
    Elementary.StoreWeb.Gettext.known_languages()
  end
end
