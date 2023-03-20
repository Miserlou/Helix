defmodule Helix.Modules.GETModule do

    use Helix.Modules.Module
    alias HTTPoison

    def handle_cast({:convey, event}, state) do
      ui_event(state)
      res = HTTPoison.get!(Map.get(state, :url, ""))
      convey("#{res.body}", state)
      {:noreply, state}
    end

  end
