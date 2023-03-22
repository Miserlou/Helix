defmodule Helix.Modules.IfContainsModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do
    ui_event(state)

    state = update_input_history(state, event)
    value = event.value

    if String.contains?(value, Map.get(state, :decider, "YES")) do
      {:noreply, convey(state.last_input.value, state)}
    else
      {:noreply, convey_alt(state.last_input.value, state, :Else)}
    end
  end

end
