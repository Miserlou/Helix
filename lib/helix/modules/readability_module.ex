defmodule Helix.Modules.ReadabilityModule do

    use Helix.Modules.Module
    alias Readability

    @type html :: binary

    def handle_cast({:convey, _event}, state) do
      ui_event(state)

      summary = Readability.summarize("https://www.wired.com/story/openai-ceo-sam-altman-the-age-of-giant-ai-models-is-already-over/")

      {:noreply, convey(summary.article_text, state)}
    end

  end
