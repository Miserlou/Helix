defmodule Helix.Modules.LiveOutputModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    ui_event(state)
    AistudioWeb.Endpoint.broadcast(
      "LiveModule_#{state.graph_id}",
      "convey",
      event
    )
    {:noreply, state}
  end

end
