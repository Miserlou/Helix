defmodule Helix.Modules.BBTextModule do

  use Helix.Modules.Module
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, event}, state) do

    state = update_input_history(state, event)
    prompt = update_prompt(state)
    :timer.sleep(String.to_integer(Map.get(state, :delay, "0")))

    {:ok, gpt2} = Bumblebee.load_model({:hf, "gpt2"})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "gpt2"})

    serving = Bumblebee.Text.generation(gpt2, tokenizer, max_new_tokens: 100)

    res = Nx.Serving.run(serving, prompt)

    output_state = convey(Enum.at(res.results, 0).text, state)
    {:noreply, output_state}

  end
end
