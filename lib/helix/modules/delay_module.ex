defmodule Helix.Modules.DelayModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    ui_event(state)
    Process.sleep(String.to_integer(state.amount))
    {:noreply, convey(event.value, state)}
  end

end
