defmodule Helix.Modules.LiveInputModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    ui_event(state)
    convey(event.value, state)
    {:noreply, state}
  end

end
