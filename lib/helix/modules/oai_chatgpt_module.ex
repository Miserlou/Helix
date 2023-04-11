defmodule Helix.Modules.OAIChatGPTModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do

    ui_event(state)
    state = update_input_history(state, event)

    custom_config = %{
      api_key: Map.get(state, :OAI_API_KEY, "oai_REPLACE_ME")
    }

    case OpenAI.chat_completion(
      custom_config,
      model: Map.get(state, :model, "gpt-3.5-turbo"),
      messages: generate_messages(state, event),
      max_tokens: get_state(state, :max_tokens, "1024"),
      temperature: get_state(state, :temperature, "0.1"),
      max_tokens: get_state(state, :max_tokens, "1024"),
      stop: get_state(state, :stop, "")
    )
    do
      {:ok, res} ->
        value = extract_chat_result(res)
        updated_state = Map.put(state, :chat_history, get_state(state, :chat_history, []) ++ [%{role: "user", content: event.value}, %{role: "assistant", content: value}])
        output_state = convey(value, updated_state)
        {:noreply, output_state}
      {:error, :timeout} ->
        broadcast_error(state, Kernel.inspect("OpenAI API Timeout"))
        {:noreply, state}
      {:error, e} ->
        IO.inspect("Unexpcected error: " <> Kernel.inspect(e))
        IO.inspect(create_error_event(e, state.id))
        broadcast_error(state, Kernel.inspect(e))
        {:noreply, state}
    end
  end

  def generate_messages(state, event) do

    system_message = get_state(state, :system_message, "You are an assistant. You answer questions.")
    messages = [ %{role: "system", content: system_message}]
    messages = messages ++ get_state(state, :chat_history, [])
    messages = messages ++ [%{role: "user", content: event.value}]
    messages

  end

end
