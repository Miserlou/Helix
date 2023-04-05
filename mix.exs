defmodule Helix.MixProject do
  use Mix.Project

  @version "0.1.1"
  @repo_url "https://github.com/Miserlou/Helix"

  def project do
    [
      app: :helix,
      version: @version,
      name: "Helix",
      description: "A playground for experiments in self-awareness. WIP.",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      package: package(),
      escript: [main_module: Commandline.CLI]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Helix.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Phoenix
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:phoenix, "~> 1.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.18.0"},
      {:floki, ">= 0.30.0", only: :test},
      # {:phoenix_live_dashboard, "~> 0.5"},
      {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},

      # Helix
      #{:openai, path: "/Users/rjones/Sources/openai.ex"},
      {:openaimt,  "~> 0.3.1"},
      #{:libgraph, "~> 0.7"},
      {:dotx, "~> 0.3.1"},
      {:solid, "~> 0.14"},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:uuid, "~> 1.1.8" },
      {:colour_hash, "~> 1.0.3"},
      #{:bumblebee, "~> 0.2"},
      #{:exla, "~> 0.5.2"},
      #{:nx, "~> 0.5.0"},
      #{:axon, "~> 0.5.0"},
      #{:temp, "~> 0.4"},
      #{:kino, "~> 0.9.0"},
      #{:image, "~> 0.27.0"},
      {:ring_buffer, "~> 0.1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end

  defp package do
    [
      files: ["lib", "priv", "mix.exs", "README.md"],
      maintainers: ["Rich Jones"],
      licenses: ["AGPL"],
      links: %{"GitHub" => @repo_url}
    ]
  end

end
