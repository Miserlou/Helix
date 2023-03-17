defmodule Helix.Modules.POSTModule do

  use Helix.Modules.Module
  alias HTTPoison

  def handle_cast({:convey, event}, state) do
    HTTPoison.post(Map.get(state, :url, ""),
      "{\"value\": \"#{event.value}\"}",
      [{"Content-Type", "application/json"}]
    )
    {:noreply, state}
  end

end
