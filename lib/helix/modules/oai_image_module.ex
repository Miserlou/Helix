defmodule Helix.Modules.OAIImageModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do

    state = update_input_history(state, event)
    size_x = Map.get(state, :size_x, "256")
    size_y = Map.get(state, :size_y, "256")

    case OpenAI.images_generations(
      [prompt: Map.get(state, :prompt, "dog"), size: "#{size_x}x#{size_y}"],
      [recv_timeout: 10 * 60 * 1000]
    ) do
      {:ok, res} ->
        IO.inspect(res)
        require IEx; IEx.pry()
        output_state = convey_img(Map.get(Enum.at(res.data, 0), "url"), state)
        {:noreply, output_state}
      {:error, :timeout} ->
        # XXX TODO: Handle properly
        IO.inspect("XXX: Timeout error")
        {:noreply, state}
      {:error, e} ->
        IO.inspect("Unexpcected error: " <> Kernel.inspect(e))
        IO.inspect(create_error_event(e, state.id))
        AistudioWeb.Endpoint.broadcast(
          "LiveModule",
          "convey",
          create_error_event(e, state.id)
        )
        {:noreply, state}
    end
  end
end
