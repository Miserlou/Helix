defmodule Helix.Modules.LiveInputModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    convey(event.value, state)
    {:noreply, state}
  end

end
