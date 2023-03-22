defmodule Helix.Modules.CountToModule do

    use Helix.Modules.Module

    def handle_cast({:convey, event}, state) do
      ui_event(state)

      count =  String.to_integer(Map.get(state, :initial, 0))
      count_to = String.to_integer(Map.get(state, :count_to, 9))
      updated_count = count + String.to_integer(Map.get(state, :count_by, 1))

      if updated_count == count_to do
        state = %{state|initial: "0"}
        {:noreply, convey(event.value, state)}
      else
        state = %{state|initial: Kernel.inspect(updated_count)}
        {:noreply, state}
      end
    end

  end
