defmodule Helix.Modules.PassthroughModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    IO.inspect(event.value)
    {:noreply, convey(event.value, state)}
  end

end
