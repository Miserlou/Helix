defmodule Helix.Modules.PrintModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    ui_event(state)
    IO.inspect(event.value)
    {:noreply, state}
  end

end
