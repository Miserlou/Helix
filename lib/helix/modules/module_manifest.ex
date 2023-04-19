defmodule Helix.Modules.ModuleManifest do
alias Helix.Modules.IfContainsModule
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
      "DelayModule": %{
        "display_name": "Delay",
        "category": "Control",
        "module": "Helix.Modules.DelayModule",
        "options": [
          %{
            "name": "amount",
            "type": "IntegerOption",
            "default": 5000
          },
        ],
        "inputs": [
            "Input"
          ],
        "outputs": [
            "Output"
          ]
      },
      "LiveInputModule": %{
        "display_name": "Console Input",
        "category": "Input / Output",
        "module": "Helix.Modules.LiveInputModule",
        "outputs": [
          "Output"
        ]
      },
      "LiveOutputModule": %{
        "display_name": "Console Output",
        "category": "Input / Output",
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
            "default": "https://webhook.site/"
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
            "default": "https://jsonplaceholder.typicode.com/todos/1"
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
        "display_name": "Text Classifier",
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
      "HFImageModule": %{
        "display_name": "Generate Image",
        "category": "Huggingface",
        "module": "Helix.Modules.HFImageModule",
        "options": [
          %{
            "name": "model",
            "type": "InputOption",
            "default": "CompVis/stable-diffusion-v1-4"
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
            "items": ["text-davinci-003", "text-davinci-002", "text-curie-001", "text-babbage-001", "text-ada-001"]
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
            "max": "1.0",
            "default": "0.9"
          }
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "OAIChatGPTModule": %{
        "display_name": "Chat GPT",
        "category": "OpenAI",
        "module": "Helix.Modules.OAIChatGPTModule",
        "options": [
          %{
            "name": "system_message",
            "type": "TextAreaOption",
            "default": "Your are a friendly assistant. Your job is to be as helpful as possible and perform any tasks assigned to you."
          },
          %{
            "name": "model",
            "type": "SelectOption",
            "default": "gpt-3.5-turbo",
            "items": ["tgpt-3.5-turbo"]
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
            "max": "1.0",
            "default": "0.9"
          }
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "OAIImageModule": %{
        "display_name": "Image Generation",
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
      },
      "IfContainsModule": %{
        "display_name": "If Contains",
        "category": "Logic",
        "module": "Helix.Modules.IfContainsModule",
        "options": [
          %{
            "name": "decider",
            "type": "InputOption",
            "default": "Yes"
          }
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output", "Else"
        ]
      },
      "SwitchCaseModule": %{
        "display_name": "Switch Case",
        "category": "Logic",
        "module": "Helix.Modules.SwitchCaseModule",
        "options": [
          %{
            "name": "case_one",
            "type": "InputOption",
            "default": "Case 1"
          },
          %{
            "name": "case_two",
            "type": "InputOption",
            "default": "Case 2"
          },
          %{
            "name": "case_three",
            "type": "InputOption",
            "default": "Case 3"
          },
          %{
            "name": "case_four",
            "type": "InputOption",
            "default": "Case 4"
          }
        ],
        "inputs": [
          "Input",
        ],
        "outputs": [
          "Output",
          "Output2",
          "Output3",
          "Output4",
          "OutputElse"
        ]
      },
      "JQModule": %{
        "display_name": "JSON (jq)",
        "category": "Text",
        "module": "Helix.Modules.JQModule",
        "options": [
          %{
            "name": "jq",
            "type": "InputOption",
            "default": ".key"
          }
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "CountToModule": %{
        "display_name": "Count To",
        "category": "Utility",
        "module": "Helix.Modules.CountToModule",
        "options": [
          %{
            "name": "initial",
            "type": "IntegerOption",
            "default": 0
          },
          %{
            "name": "count_to",
            "type": "IntegerOption",
            "default": 9
          },
          %{
            "name": "count_by",
            "type": "IntegerOption",
            "default": 1
          },
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "CounterModule": %{
        "display_name": "Counter",
        "category": "Utility",
        "module": "Helix.Modules.Counter",
        "options": [
          %{
            "name": "initial",
            "type": "IntegerOption",
            "default": 0
          },
          %{
            "name": "count_by",
            "type": "IntegerOption",
            "default": 1
          },
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "PassthroughModule": %{
        "display_name": "Passthrough",
        "category": "Utility",
        "module": "Helix.Modules.PassthroughModule",
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "RingBufferModule": %{
        "display_name": "Ring Buffer",
        "category": "Memory",
        "module": "Helix.Modules.RingBufferModule",
        "options": [
          %{
            "name": "size",
            "type": "IntegerOption",
            "default": 10
          }
        ],
        "inputs": [
          "Input"
        ],
        "outputs": [
          "Output"
        ]
      },
      "SampleAndHoldModule": %{
        "display_name": "Sample and Hold",
        "category": "Memory",
        "module": "Helix.Modules.SampleAndHoldModule",
        "inputs": [
          "Input",
          "Trigger",
        ],
        "outputs": [
          "Output"
        ]
      },
      "KeyValueStoreModule": %{
        "display_name": "Key Value Store",
        "category": "Memory",
        "module": "Helix.Modules.KeyValueStoreModule",
        "options": [
          %{
            "name": "JSON",
            "type": "CheckboxOption",
            "default": true
          }
        ],
        "inputs": [
          "Input",
          "Get",
          "GetAll",
        ],
        "outputs": [
          "Output"
        ]
      },
      "VariableBooleanModule": %{
        "display_name": "Boolean",
        "category": "Variables",
        "module": "Helix.Modules.VariableBooleanModule",
        "options": [
          %{
            "name": "default",
            "type": "SelectOption",
            "default": "true",
            "items": ["true", "false"]
          },
        ],
        "inputs": [
          "Input",
          "Toggle"
        ],
        "outputs": [
          "Output"
        ]
      },
      "VariableStringModule": %{
        "display_name": "String",
        "category": "Variables",
        "module": "Helix.Modules.VariableStringModule",
        "options": [
          %{
            "name": "default",
            "type": "InputOption",
            "default": "default"
          },
        ],
        "inputs": [
          "Input",
          "Set"
        ],
        "outputs": [
          "Output"
        ]
      },
      "VariableBooleanRouterModule": %{
        "display_name": "Boolean Router",
        "category": "Variables",
        "module": "Helix.Modules.VariableBooleanRouterModule",
        "options": [
          %{
            "name": "default",
            "type": "SelectOption",
            "default": "true",
            "items": ["true", "false"]
          },
        ],
        "inputs": [
          "Input",
          "Toggle"
        ],
        "outputs": [
          "Output",
          "False"
        ]
      },
      "BrowserModule": %{
        "display_name": "Web Browser",
        "category": "Web",
        "module": "Helix.Modules.BrowserModule",
        "inputs": [
          "Input",
        ],
        "outputs": [
          "Output",
        ]
      },
      "ReadabilityModule": %{
        "display_name": "Readability",
        "category": "Web",
        "module": "Helix.Modules.ReadabilityModule",
        "inputs": [
          "Input",
        ],
        "outputs": [
          "Output",
        ]
      }
    }

  end
end
