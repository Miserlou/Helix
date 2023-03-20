defmodule Helix.Modules.ChatGPTModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do
    ui_event(state)

    state = update_input_history(state, event)
    prompt = update_prompt(state)
    :timer.sleep(String.to_integer(Map.get(state, :delay, "0")))

    case OpenAI.chat_completion(
      model: "gpt-3.5-turbo",
      max_tokens: get_state(state, :max_tokens, "1024"),
      temperature: get_state(state, :temperature, "0.1"),
      frequency_penalty: get_state(state, :frequency_penalty, "0"),
      presence_penalty: get_state(state, :presence_penalty, "0"),
      messages: [
            %{role: "system", content: Map.get(state, :system, "")},
            %{role: "user", content: "Who won the world series in 2020?"},
            %{role: "assistant", content: "The Los Angeles Dodgers won the World Series in 2020."},
            %{role: "user", content: "Where was it played?"}
        ]
    ) do
      {:ok, res} ->
        # require IEx; IEx.pry()
        #value = extract_result(res)
        value = Enum.at(res.choices, 0)["message"]["content"]
        output_state = convey(value, state)
        {:noreply, output_state}
      {:error, :timeout} ->
        # XXX TODO: Handle properly
        IO.inspect("XXX: Timeout error")
        {:noreply, state}
      {:error, e} ->
        IO.inspect("Unexpcected error: " <> Kernel.inspect(e))
        {:noreply, state}
    end
  end
end
