defmodule Helix.Modules.SampleAndHoldModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do
    ui_event(state)
    state = update_input_history(state, event)

    triggers = String.split(Map.get(state, :Trigger, ""), ",")
    source = String.replace(event.source_id, "_" <> state.graph_id, "")

    if Enum.member?(triggers, source) do
      {:noreply, convey(Map.get(state, :hold, ""), state)}
    else
      {:noreply, Map.put(state, :hold, event.value)}
    end

  end

end
