defmodule Helix.Modules.POSTModule do

  use Helix.Modules.Module
  alias HTTPoison

  def handle_cast({:convey, event}, state) do
    ui_event(state)
    HTTPoison.post(Map.get(state, :url, ""),
      "{\"value\": \"#{event.value}\"}",
      [{"Content-Type", "application/json"}]
    )
    {:noreply, state}
  end

end
