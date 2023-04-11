defmodule Helix.Modules.SwitchCaseModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do
    ui_event(state)

    state = update_input_history(state, event)
    value = event.value

    one = Map.get(state, :case_one, "")
    two = Map.get(state, :case_two, "")
    three = Map.get(state, :case_three, "")
    four = Map.get(state, :case_four, "")

    case value do
      ^one ->
        {:noreply, convey(state.last_input.value, state)}
      ^two ->
        {:noreply, convey_alt(state.last_input.value, state, :Output2)}
      ^three ->
          {:noreply, convey_alt(state.last_input.value, state, :Output3)}
      ^four ->
        {:noreply, convey_alt(state.last_input.value, state, :Output4)}
      _ ->
        {:noreply, convey_alt(state.last_input.value, state, :OutputElse)}
    end

  end

end
