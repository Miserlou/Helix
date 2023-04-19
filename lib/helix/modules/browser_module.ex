defmodule Helix.Modules.BrowserModule do

  use Helix.Modules.Module
  alias Playwright

  # def init(state) do
  #   Process.send_after(self(), :start, String.to_integer(state.delay))
  #   {:ok, state}
  # end

  # def handle_info(:start, state) do
  #   ui_event(state)
  #   convey("Start #{:os.system_time(:millisecond)}" , state)
  #   {:noreply, state}
  # end

  def handle_cast({:convey, _event}, state) do
    ui_event(state)

    {:ok, browser} = Playwright.launch(:chromium)
    page =
      browser |> Playwright.Browser.new_page()

    page
      |> Playwright.Page.goto("http://example.com")

    page
      |> Playwright.Page.title()
      |> IO.puts()

    browser
      |> Playwright.Browser.close()

    {:noreply, state}
  end

end
