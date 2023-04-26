defmodule Helix.Modules.ReadabilityModule do

    use Helix.Modules.Module
    alias Readability

    @type html :: binary

    def handle_cast({:convey, event}, state) do
      ui_event(state)

      sets = String.split(Map.get(state, :URL, ""), ",")
      source = String.replace(event.source_id, "_" <> state.graph_id, "")

      cond do
        Enum.member?(sets, source) ->
          # Update and Convey Value
          summary = Readability.summarize(event.value)
          {:noreply, convey(summary.article_text, state)}

        true ->
          # Convey Value
          summary = Readability.summarize(state.url)
          {:noreply, convey(summary.article_text, state)}

      end

    end

  end
