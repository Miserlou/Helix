defmodule Helix.Modules.PassthroughModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    IO.inspect(event.value)
    convey_to_targets(String.reverse(event.value), state.targets)
    {:noreply, state}
  end

end
