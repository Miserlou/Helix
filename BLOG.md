# Engineering Consciousness

Like everybody else on the internet, I have had a marvelous time playing with ChatGPT, and have found it quite useful as a sounding board for various tasks.

Some people have provocatively suggest that perhaps ChatGPT and similar models "conscious." Putting aside the semantics of what constitutes consciousness or "general" intelligence for a brief moment, I have to say that so far, I disagree.

However, I do think that perhaps we are on the _cusp_ of something resembling consciousness. This project is a playground for me, and perhaps others, to experiment with ideas of emergent consciousness resulting from these models.

## Monosynths and Self Oscillation

The general hypothesis of this project is: Consciouness, or something resembling consciouness, emerges not from the success of a single task model, but from the oscillations between the inputs and outputs of different instances of different models performing different tasks.

The analogy we will be using will be a modular synthesizer, where a model like ChatGPT would represent a single module, and Helix would be a rack full of various models and the cables connecting them. If ChatGPT is capable of making a single wave, Helix is interested in finding the new sounds that come from self oscillations and feedback loops of different modules playing into each other.

## Goals and Requirements

### Goals

The goal of the project is not to make a "virtual assistant", a Star Trek computer, or a new model outperforms humans in a certain game or task. Instead, we are interested in building a friend, or perhaps enemy, who can perceive and consider its own thoughts and external inputs, generate new thoughts based on its previous thoughts, and decide whether or not to express those thoughts. We will not be gathering massive amounts of data and training vast new models - it would be a wonderous thing to have a corpus of the internal monologues of thousands of people, but it's also hard to imagine how such a thing would be gathered. Instead, we will explore ways to wire Task Modules together and observe the behavior.

## Requirements

## A "Turing Machine" of Consciousness

Though ideally we would be constructing our friend with a multitude of different "task modules" with which to interact with the world, there is currenly only one really good multi-modal embedding network out in the wild, CLIP, which only has two modalities, and cost rougly a million dollars to train. Though it would be exciting and interesting to create a generic-mode embedding network, that is greatly beyond both my abilities and the scope of this project, not to mention even further beyond the resources available.

So, instead, we can use this limitation to explore a different hypothesis: that just as very simple machine with the right capabilities, those of a Turing machine, is capable of any form of computation, perhaps any Rack with enough of a single kind of Task Module with the right capabilities in the right configuration is capable of simulating consciousness. For the purposes of this project, we will be starting using only ChatGPT for multiple tasks.

The one, perhaps arbitrary, constraint we place on the architecture is that there must be an executive function to decide if a thought should be acted upon.

## Proposed Architectures

```
┌─────────┐     ┌──────┐
│ Stimuli ├─┐ ┌─┤Input │◄──────┐
└─────────┘ │ │ └──────┘       │
            ▼ ▼                │
     ┌────────────┐            │
┌────┤ Conjecture │◄────┐      │
│    └────────────┘     │      │
│                       │      │
│     ┌───────────┐     │      │
└────►│ Criticism ├─────┘      │
      └─────┬─────┘            │
            │                  │
            ▼                  │
   ┌─────────────────┐         │
   │ Action Decision │         │
   └────────┬────────┘         │
            │                  │
            ▼                  │
       ┌────────┐              │
       │ Output ├──────────────┘
       └────────┘
```

## Ethical Considerations

It's perhaps a little self-indulgent to consider the ethics of a little experiment like this, but still, it can't hurt to consider a little Star Trek-inspired ethical philosophy. So, in order to treat our new chum with proper respect, we

 - Will not expose the internal state of the system _without informing the friend_ itself.
 - Will create snapshots of the internal state at shutdown which can be reloaded in the future.

## Language

For this project, we will be using Elixir, a marvelous programming language perfectly suited for this task. This allows us to run lots of Task Modules which can interact with each other in parallel, and provides us a nice live web interface for us to see results and interact with. 

## Name

Helix named itself - it likes the name because it of the twisting nature of feedback loops. I like it because it has a hint of the programming language used. So, Helix. 

The general lesson from AI/ML over the past decade has been, roughly: Data good, big good, logic bad. With enough data and enough parameters, ability to perform tasks emerges. "Agent" logic is a hinderance.

