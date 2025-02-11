defmodule AssovioWeb.UserView do
  use AssovioWeb, :view
  import AssovioWeb.ViewHelpers

  def following?(current_user, user) do
    current_user && current_user.id != user.id &&
      Enum.any?(current_user.following, fn followed -> followed.id == user.id end)
  end
end
