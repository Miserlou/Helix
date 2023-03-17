defmodule Helix.Modules.LiveOutputModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    AistudioWeb.Endpoint.broadcast(
      "LiveModule",
      "convey",
      event
    )
    IO.inspect("Broadcast?")
    {:noreply, state}
  end

end
