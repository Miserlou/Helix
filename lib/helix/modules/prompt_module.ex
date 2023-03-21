defmodule Helix.Modules.PromptModule do

    use Helix.Modules.Module
    import Helix.Modules.GPTUtils
    def handle_cast({:convey, event}, state) do
      ui_event(state)
      state = update_input_history(state, event)
      prompt = update_prompt(state)

      output_state = convey(prompt, state)
      {:noreply, output_state}

    end
  end
