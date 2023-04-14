defmodule Helix.Modules.VariableBooleanModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    ui_event(state)
    state = update_input_history(state, event)

    sets = String.split(Map.get(state, :Toggle, ""), ",")
    source = String.replace(event.source_id, "_" <> state.graph_id, "")

    cond do
      Enum.member?(sets, source) ->
        # Update and Convey Value
        new_state = %{state | default: to_s(!to_bool(state.default))}
        {:noreply, convey(new_state.default, new_state)}

      true ->
        # Convey Value
        {:noreply, convey(state.default, state)}

    end
  end

  defp to_bool(s) do
    if s == "true" do
      true
    else
      false
    end
  end

  defp to_s(b) do
    if b == true do
      "true"
    else
      "false"
    end
  end

end
