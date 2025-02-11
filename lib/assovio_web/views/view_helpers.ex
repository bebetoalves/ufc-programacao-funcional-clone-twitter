defmodule AssovioWeb.ViewHelpers do
  def format_datetime(datetime) when is_nil(datetime), do: ""

  def format_datetime(datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> Calendar.strftime("%d/%m/%Y %H:%M")
  end
end
