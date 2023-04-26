defmodule Helix.Modules.GPTModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils
  def handle_cast({:convey, event}, state) do
    ui_event(state)
    state = update_input_history(state, event)
    prompt = event.value
    :timer.sleep(String.to_integer(Map.get(state, :delay, "0")))

    config = %{
      api_key: Map.get(state, :OAI_API_KEY, "oai_REPLACE_ME")
    }

    case OpenAI.completions(
      config,
      Map.get(state, :model, "text-ada-001"), #"text-davinci-003"),
      prompt: prompt,
      max_tokens: get_state(state, :max_tokens, "1024"),
      temperature: get_state(state, :temperature, "0.1"),
      top_p: get_state(state, :top_p, "1"),
      # frequency_penalty: get_state(state, :frequency_penalty, "0"),
      # presence_penalty: get_state(state, :presence_penalty, "0"),
      stop: get_state(state, :stop, "")
    ) do
      {:ok, res} ->
        value = extract_result(res)
        output_state = convey(value, state)
        {:noreply, output_state}
      {:error, :timeout} ->
        broadcast_error(state, Kernel.inspect("OpenAI API Timeout"))
        {:noreply, state}
      {:error, e} ->
        IO.inspect("Unexpected error: " <> Kernel.inspect(e))
        broadcast_error(state, Kernel.inspect(e))
        {:noreply, state}
    end
  end
end
