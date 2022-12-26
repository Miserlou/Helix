defmodule Helix.Modules.AwaitModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do

    # If have new input from all sources, convey
    # Else, only update local state

    state = update_input_history(state, event)
    remaining = for {k, v} <- state.input_sources, v == nil, do: k
    if length(remaining) == 0 do
      history = generate_history(state)
      {:noreply, convey(history, state)}
    else
      {:noreply, state}
    end
  end

end
