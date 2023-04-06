defmodule Helix.Modules.ConsoleOutputModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    IO.inspect(event.value)
    {:noreply, state}
  end

end
