defmodule Helix.Modules.VariableStringModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    ui_event(state)
    state = update_input_history(state, event)

    sets = String.split(Map.get(state, :Set, ""), ",")
    source = String.replace(event.source_id, "_" <> state.graph_id, "")

    cond do
      Enum.member?(sets, source) ->
        # Update and Convey Value
        new_state = %{state | default: event.value}
        {:noreply, convey(new_state.default, new_state)}

      true ->
        # Convey Value
        {:noreply, convey(state.default, state)}

    end
  end

end
