defmodule Helix.Modules.LiveOutputModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    HelixWeb.Endpoint.broadcast(
      "LiveModule",
      "convey",
      event
    )
    {:noreply, state}
  end

end
