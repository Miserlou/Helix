defmodule Helix.Modules.CounterModule do

    use Helix.Modules.Module

    def handle_cast({:convey, event}, state) do
      ui_event(state)

      count = String.to_integer(Map.get(state, :initial, 0)) + String.to_integer(Map.get(state, :count_by, 0))
      state = %{state|initial: Kernel.inspect(count)}
      {:noreply, convey(Kernel.inspect(count), state)}

    end

  end
