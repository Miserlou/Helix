defmodule Helix.Modules.ModuleManifest do
alias Helix.Modules.StartModule

  def get_manifest() do
    %{
      "AwaitModule": %{
        "display_name": "Await",
        "category": "Control",
        "module": "Helix.Modules.AwaitModule",
        "inputs": [
            "Input"
          ],
        "outputs": [
            "Output"
          ]
      },
      "ClockModule": %{
        "display_name": "Clock",
        "category": "Control",
        "module": "Helix.Modules.ClockModule",
        "options": [
          %{
            "name": "delay",
            "type": "IntegerOption",
            "default": 1000
          },
          %{
            "name": "every",
            "type": "IntegerOption",
            "default": 5000
          },
        ],
        "outputs": [
          "Output"
        ]
      },
      "LiveInputModule": %{
        "display_name": "Console Input",
        "category": "I/O",
        "module": "Helix.Modules.LiveInputModule",
        "outputs": [
          "Output"
        ]
      },
      "LiveOutputModule": %{
        "display_name": "Console Output",
        "category": "I/O",
        "module": "Helix.Modules.LiveOutputModule",
        "inputs": [
          "Input"
        ]
      },
      "PromptModule": %{
        "display_name": "Prompt",
        "category": "Text",
        "module": "Helix.Modules.PromptModule",
        "options": [
          %{
            "name": "prompt",
            "type": "TextAreaOption",
            "default": "{INPUT}"
          }
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "POSTModule": %{
        "display_name": "POST",
        "category": "Web",
        "module": "Helix.Modules.POSTModule",
        "options": [
          %{
            "name": "url",
            "type": "InputOption",
            "default": ""
          },
        ],
        "inputs": [
          "Input"
        ]
      },
      "GETModule": %{
        "display_name": "GET",
        "category": "Web",
        "module": "Helix.Modules.GETModule",
        "options": [
          %{
            "name": "url",
            "type": "InputOption",
            "default": ""
          },
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "StartModule": %{
        "display_name": "Start",
        "category": "Control",
        "module": "Helix.Modules.StartModule",
        "options": [
          %{
            "name": "delay",
            "type": "IntegerOption",
            "default": 1000
          }
        ],
        "outputs": [
          "Output"
        ]
      },
      "HFInferenceModule": %{
        "display_name": "HuggingFace Inference",
        "category": "Huggingface",
        "module": "Helix.Modules.HFInferenceModule",
        "options": [
          %{
            "name": "model",
            "type": "InputOption",
            "default": "distilbert-base-uncased-finetuned-sst-2-english"
          }
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "GPTModule": %{
        "display_name": "Simple GPT",
        "category": "OpenAI",
        "module": "Helix.Modules.GPTModule",
        "options": [
          %{
            "name": "model",
            "type": "SelectOption",
            "default": "text-davinci-003",
            "items": ["text-davinci-003", "text-ada-001"]
          },
          %{
            "name": "max_tokens",
            "type": "IntegerOption",
            "default": "1024",
          },
          %{
            "name": "temperature",
            "type": "SliderOption",
            "min": "0",
            "min": "1.0",
            "default": "0.9"
          },
          %{
            "name": "top_p",
            "type": "SliderOption",
            "min": "0",
            "min": "1.0"
          },
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "OAIImageModule": %{
        "display_name": "OpenAI Image Module",
        "category": "OpenAI",
        "module": "Helix.Modules.OAIImageModule",
        "options": [
          %{
            "name": "size_x",
            "type": "IntegerOption",
            "default": 256
          },
          %{
            "name": "size_y",
            "type": "IntegerOption",
            "default": 256
          },
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      }
    }

  end
end
