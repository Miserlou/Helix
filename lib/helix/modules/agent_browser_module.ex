defmodule Helix.Modules.AgentBrowserModule do

  use Helix.Modules.Module
  alias Readability
  alias Playwright
  alias HTTPoison
  alias Floki
  alias URI
  import Helix.Modules.GPTUtils

  def handle_cast({:convey, _event}, state) do
    ui_event(state)

    # url = "https://html.duckduckgo.com/html/?q=technology%20venture%20capitalists%20based%20in%20norway"
    # url = "https://www.stratel.no/"
    # url = "https://www.stratel.no/contact-us"

    # extract_information_if_possible(url, state)
    # links = url_to_links(url, state)
    # link_menu = links_to_menu(links)
    # links_to_follow = chatgpt_choose_from_link_menu(link_menu, state)
    # next_links = links_from_choices(links, links_to_follow)

    url = "https://html.duckduckgo.com/html/?q=" <> URI.encode(state.goal)
    process_url(0, url, state)

    {:noreply, convey_alt("Finished.", state, :Finished)}
  end

  def process_url(depth, url, state) do

    state = Map.put(state, :visited, Map.get(state, :visited, []) ++ [url])
    IO.inspect(state)

    IO.inspect("* Processing URL #{url}")
    IO.inspect("* Extraction")
    extract_information_if_possible(url, state)
    IO.inspect("* Getting Links")
    links = url_to_links(url, state)
    IO.inspect("* Links: #{Kernel.inspect(links)}")
    if links != [] do
      link_menu = links_to_menu(links)
      links_to_follow = chatgpt_choose_from_link_menu(link_menu, state)
      next_links = links_from_choices(links, links_to_follow)
      IO.inspect(next_links)

      if depth <= state.depth do
        Enum.each(next_links, fn link ->
          if link != nil do
            if Enum.member?(state.visited, link.url) do
              IO.inspect("* Skipping #{link.url}")
            else

              if !String.contains?(link.url, "pitchbook.com") do
                process_url(depth + 1, link.url, state)
              end
            end
          end
        end)
      end
    end
  end

  def url_to_links(url, state) do

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        prelinks =
          body
          |> Floki.parse_document!()
          |> Floki.find("a")

        links = Enum.reduce(prelinks, [], fn link, acc ->
          newurl = link |> Floki.attribute("href") |> Enum.at(0)
          text = link |> Floki.text() |> String.strip()

          if text != "" and newurl != nil do
            # DDG Redirects
            newurl = if String.contains?(newurl, "//duckduckgo.com/l/?uddg=") do
              String.split(newurl, "//duckduckgo.com/l/?uddg=") |> Enum.at(1) |> URI.decode
            else
              newurl
            end

            # DDG junk
            newurl = if String.contains?(newurl, "&") do
              String.split(newurl, "&") |> Enum.at(0)
            else
              newurl
            end

            # Relative paths
            newurl = if String.starts_with?(newurl, "/") do
              parsed = URI.new!(url)
              parsed.scheme <> "://" <> parsed.host <> newurl
            else
              newurl
            end

            acc ++ [%{url: newurl, text: text}]
          else
            acc
          end

        end) |> Enum.uniq_by(fn %{text: _t,  url: u} -> u end)

        IO.inspect("Links")

        links
      {:ok, q} ->
        IO.inspect("Q: #{Kernel.inspect(q)}")
        []
      {:error, e} ->
        IO.inspect("URL to links error, #{Kernel.inspect(e)}")
        []
      end
  end

  defp links_to_menu(links) do
    text = links |> Enum.with_index |> Enum.reduce("", fn {%{text: t, url: u}, index}, acc ->
      acc <> Kernel.inspect(index) <> ":\n - URL: #{u}\n - Title: #{t}\n\n"
    end) |> String.slice(0..3500)
    IO.inspect("Menu:")
    IO.puts(text)
    text
  end

  defp links_from_choices(links, choices) do
    Enum.map(choices, &(Enum.at(links, &1)))
  end

  defp extract_information_if_possible(url, state) do

    # XXX This could be fucking better.
    # Mailtos, all span, div, pre, p texts.
    try do
      # XXX: Can't configure timeout in Readability, bleh.
      summary = Readability.summarize(url)
      info = chatgpt_extract_information(summary.title, summary.article_text, state)
      if info != %{} do
        convey(Kernel.inspect(info), state)
      end
    rescue
      e -> nil
    end

  end

  defp chatgpt_choose_from_link_menu(link_menu, state) do

    prompt = """
    You are a robot which communicates only in JSON. You do NOT ever output natural language.
    Of these indexed links, which would you choose to find '#{state.goal}'.
    Answer as a JSON list and ONLY a JSON list of numbers. Do not provide any additional friendlyness. Answer only as a JSON list of numbers. Include a maximum of 5 numbers in the list.
    If cannot answer or have not been provided with any information, that's okay, reply with "[]".

    Good examples:
    [1, 2, 3]
    [6, 22]
    []
    """

    custom_config = %{
      api_key: Map.get(state, :OAI_API_KEY, "oai_REPLACE_ME")
    }

    messages = [ %{role: "system", content: prompt}]
    messages = messages ++ [%{role: "user", content: link_menu}]

    case OpenAI.chat_completion(
      custom_config,
      model: Map.get(state, :model, "gpt-3.5-turbo"),
      messages: messages,
      max_tokens: get_state(state, :max_tokens, "1024"),
      temperature: get_state(state, :temperature, "0.1"),
      max_tokens: get_state(state, :max_tokens, "1024"),
      stop: get_state(state, :stop, "")
    )
    do
      {:ok, res} ->
        res_json = extract_chat_result(res)
        case JSON.decode(res_json) do
          {:ok, res} ->
            res
          {:error, _} ->
            IO.inspect("JSON error.")
            []
        end
      {:error, :timeout} ->
        IO.inspect("Agent Browser Timeout")
        broadcast_error(state, Kernel.inspect("OpenAI API Timeout"))
        []
      {:error, e} ->
        IO.inspect("Unexpcected error: " <> Kernel.inspect(e))
        IO.inspect(create_error_event(e, state.id))
        broadcast_error(state, Kernel.inspect(e))
        []
    end

  end

  defp chatgpt_extract_information(title, text, state) do

    prompt = """
    You are a robot which communicates only in JSON. You do NOT ever output natural language.
    Given this raw text extract and format any #{state.extract} related to #{state.goal}.
    Answer as a JSON object and ONLY as a JSON object. Do not provide any additional friendlyness. Answer only as a JSON object.
    If you cannot find any #{state.extract}, that's okay, reply with "{}".
    """

    content = "Page Title:\n#{title}\nPage Body:\n #{text}"

    custom_config = %{
      api_key: Map.get(state, :OAI_API_KEY, "oai_REPLACE_ME")
    }

    messages = [ %{role: "system", content: prompt}]
    messages = messages ++ [%{role: "user", content: content}]

    case OpenAI.chat_completion(
      custom_config,
      model: Map.get(state, :model, "gpt-3.5-turbo"),
      messages: messages,
      max_tokens: get_state(state, :max_tokens, "1024"),
      temperature: get_state(state, :temperature, "0.1"),
      max_tokens: get_state(state, :max_tokens, "1024"),
      stop: get_state(state, :stop, "")
    )
    do
      {:ok, res} ->
        res_json = extract_chat_result(res)
        case JSON.decode(res_json) do
          {:ok, res} ->
            res
          {:error, _} ->
            IO.inspect("JSON error.")
            %{}
        end
      {:error, :timeout} ->
        IO.inspect("Agent Browser Timeout")
        broadcast_error(state, Kernel.inspect("OpenAI API Timeout"))
        %{}
      {:error, e} ->
        IO.inspect("Unexpcected error: " <> Kernel.inspect(e))
        IO.inspect(create_error_event(e, state.id))
        broadcast_error(state, Kernel.inspect(e))
        %{}
    end

  end

  # defp playwright() do
        # {:ok, browser} = Playwright.launch(:chromium, %{headless: true})
    # page =
    #   browser |> Playwright.Browser.new_page()

    # page
    #   |> Playwright.Page.goto("https://html.duckduckgo.com/html/?q=example")

    # x = page
    #   |> Playwright.Page.text_content("body")

    # require IEx;
    # IEx.pry()

    # browser
    #   |> Playwright.Browser.close()
  # end

end
