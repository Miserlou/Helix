defmodule Helix.Modules.AwaitModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do

    # If have new input from all sources, convey
    # Else, only update local state

    require IEx;
    IEx.pry()

    # convey(event.value, state)
    # {:noreply, state}
  end

end
