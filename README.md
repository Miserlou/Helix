# Helix
## A Playground for Engineering Consciousness

Helix is a framework for engineering consciousness using networks of AI task modules. Think of it like a modular synthesizer for AI.

Read more about the concept [in this blog post]().

## Installation and Basic Usage

**Before you begin, be aware that Helix, left unattended, can eat through OpenAI credits as fast as it can!**

_These instructions assume you have [Elixir installed](https://elixir-lang.org/install.html)._

First, clone this repository and `cd` into it.

Then, install the dependencies:

```
mix deps.get
```

Copy the environment template file:

```
cp .env.tpl .env
```

Next, get your [OpenAI API Keys](https://beta.openai.com/account/api-keys) and put them in `.env`, as well as another configuration settings you want to put.

Run the application with `source .env && mix phx.server`, or use the provided `run.sh` script. The application will now be running at localhost:4000.

### Using the Web Application

_XXX TODO_

## Creating Your Own Graphs

Graphs are described a in DOT format. A very simple GPT feedback graph could be defined like so:

```dot
digraph Daoism{
  Ying [module=GPTModule, prompt=Breathe in."]
  Ying [module=GPTModule, prompt=Breathe out.]

  Ying -> Yang
  Yang -> Ying
}
```

However, DOT is quite limited by itself, so Graph files are actually Liquid templates used to create a DOT file. This makes it much easier to use variable assigns and loops, like so:

```dot
{% assign ying_prompt="Your last thought was #{input}. You breathe in and think: " %}
{% assign yang_prompt="Your last thought was #{input}. You breathe out and think: " %}

digraph Daoism{
  Ying [module=GPTModule, prompt="{{ying_prompt}}"]
  Ying [module=GPTModule, prompt="{{yang_prompt}}"]

  Ying -> Yang
  Yang -> Ying
}
```

Place your graphs in `./priv/graphs`.

## Creating Your Own Modules

Creating a module is very simple. All a module must do is implement `handle_cast({:convey, event}, state)` to receive inputs from other modules, and at the end of that function call `convey(output_value, targets)` to pass a message along.

So, the simplest passthrough module will be:

```elixir
defmodule Helix.Modules.PassthroughModule do

  use Helix.Modules.Module

  def handle_cast({:convey, event}, state) do
    convey(event, state.targets)
    {:noreply, state}
  end

end
```

## Dev TODO

 - Create modified Heex/DOT template format
 - Web Interface
    - Image representations
    - Choose Graph from folder, instantiate 
 - Logging, Saving and Restoring
 - Use DynamicSupervisor
 - More modules: `MixModule`, `ClockModule`, `OutputModule`, `TextInputModule`
 - More modules: `ImageInputModule`, `StableDiffusionModule`, `HuggingFaceModule`, `ImageOutputModule`, `WebSearchModule`, `WebExtractTextModule`, `UnixModule`, `GenModuleModule`, `Await` module.
 - Refactor modules names.. don't need Module
 - Create GitHub pages blog

## Ideas to explore

_XXX TODO_

 - Persistent memory
 - Self-embedding
 - Access to the internet
 - Multi-modal stimuli

## Contributing

Please, feel free to play around with this, but I encourage you to share your feedback, ideas, and experiments. Please use GitHub issues for this.

## License

Rich Jones, 2022+, AGPL.