defmodule Helix.Modules.PassthroughModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    IO.inspect(event.value)
    convey(String.reverse(event.value), state)
    {:noreply, state}
  end

end
