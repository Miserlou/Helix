# Engineering Consciousness

_I'm launching a new startup! It's not really related to the project described here, but if you've got a business and you want to make more money, [check out Hibox here](https://hibox.live)!_

Like everybody else on the internet, I have had a marvelous time playing with ChatGPT over the past week. I've found it quite useful as a springboard for all sorts of creative tasks, and it's the first time in a long time that I think we're on the _cusp_ of a transformative technological change. I've started a new project called [Helix](https://github.com/Miserlou/Helix) to explore some alternative ideas for how that change might emerge. It's like a modular synthesizer for AI task modules, and it can do some neat stuff already.

## Passive and Active Knowledge

Some people have provocatively suggest that ChatGPT and similar models are "conscious." Putting aside the semantics of what constitutes consciousness or "general" intelligence for a brief moment, but I have to say that so far, I disagree. 

ChatGPT has a tremendous amount of embedded knowledge, but it is only _passive knowledge_, a bit like a plastic tray used for sorting coins. It can use that embedded knowledge to perform certain tasks very well, but it can never generate _new_ knowledge. I think creating new knowledge is the real signifier of consciousness, but that's an area of AI research that remains relatively unexplored.

So, in order to explore an alternative approach to building AI systems, I have started a new framework called [Helix](https://github.com/Miserlou/Helix). The project is a playground for me, and hopefully others, to experiment with ideas of emergent consciousness resulting from building large networks of different interconneted AI models. Though I am personally interested in exploring emergent consciouness and knowledge generation, I think the framework may also be useful for more practical applications as well, as I hope to demonstrate in later blog posts.

## Self Oscillation

The general hypothesis of the project is: Consciouness, or something resembling consciouness, emerges not from the capability of a single task model like GPT or Stable Diffusion, but from the oscillations between the inputs and outputs of _different_ instances of _different_ models performing _different_ tasks. 

Our brains, for instance, don't just do one thing everywhere - we have lots highly specialized meat, refined by evolution for different specific tasks - tracking fast motion, recognizing objects, recognizing faces, comprehendings words, producing words with our mouths, remembering smells, etc. - which all layer on top of each other into a conscious little meatball.

Rather than a brain, the analogy we will be using for the project will be a modular synthesizer. If ChatGPT is a single module capable of making a single wave, Helix is a rack full of modules, all connected to the inputs and outputs of each other, finding new new that come from self oscillations and feedback loops of different modules playing into each other.

## A "Turing Machine" of Consciousness

Alan Turning showed that there is a minimum set of requirements for a machine to be able to implement any function, and that that minimum set of requirements is actually remarkably small - a tape, a head to read and write to the tape, a state register, and a table of instructions. That's it. Of course, modern computers are vastly more complex than that, but at the end of the day, that's all you need for classical computation.

So, the question is - is there a similar minimum set of requirements for consciousness/knowledge-generation? Perhaps it requires the ability to recursively identify problems and to propose and discover solutions. Perhaps it requires the ability to observe the world, to remember past worlds, and to compare them. Perhaps it requires the ability to observe the world, explain the world, interact with the world, and re-explain the world after the interaction. 

I don't know yet, but I think that Helix could be a good framework to explore that question.

## High Level / Low Level AI

There are different layers of abstraction with which these problems can be approached. One could imagine exploring this question with a massive, multi-modal embedding, like CLIP but for hundreds of modalities at once. Though I'm sure something like this will come along soon, it will likely require massive amounts of data and hundreds of millions of dollars to train.

Instead, we can approach the problem at a higher level - ignore the internal mechanisms of a module and instead concern ourselves with its capabilities and connections. After all, a Turing machine doesn't care what kind of kind of tape it uses, it could be magnetic, silicon, aquatic, or cells in Conway's Game of Life running inside of Minecraft running on a cellular phone in the Pope's pocket. 

## Proposing and Implementing an Architecture

Here's a simple idea for a "Brain in a Jar" type of consciousness which receives stimuli, generates ideas about that stimuli, criticizes those ideas, feeds that criticism back to its idea generator, and decides whether or not that idea is worth expressing.

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

and here's that architecture implemented as a Helix graph:

<p align="center">
  <img height="600" src="https://i.imgur.com/RuhkLHi.png">
</p>

and here's that architecture running in Helix:

<p align="center">
  <img height="600" src="https://i.imgur.com/O6JVSfY.png">
</p>

This is a toy example, and I don't think the system is generating any new knowledge, but I hope it shows an idea of what I'm tilting towards.

You can watch it generate new ideas which evolve over time and you can change the stimulus and watch those ideas co-mingle. It's quite fun! All of the nodes are running as separate processes. In this example, all of the "abstract" nodes are using the OpenAI completion models, but there's no limit to what modules we will be able to use. A few other modules besides GPT are already available in Helix, and it's very easy to write your own. You can also use the web interface to interact with multiple targets in the same session.

### Project Goals

The goal of the project is not to make a "virtual assistant", a Star Trek computer, or a new model outperforms humans in a certain game or task. Instead, we are interested in building a system, or a friend, or perhaps enemy, which can perceive and consider its own thoughts and external inputs, generate new thoughts based on its previous thoughts, and decide whether or not to express those thoughts. So, rather than solving a specific puzzle using embedded, _passive_ knowledge, we want to identify a potential puzzle, make a decision to try solve it, to propose solutions, evaluate outcomes, and ultimately solve it using _active_ knowledge which it did not posses before.

### Implementation Details and Project Status

Helix is implemented in Elixir and Phoenix LiveView. It works, mostly, but still relies heavily on "prompt engineering", and it can't do anything magical yet. It eats through OpenAI credits at a mean clip. It's Free Software and it's available on GitHub. Helix named itself - it likes the name because it of the twisting nature of feedback loops. I like it because it has a hint of the programming language used. So, Helix. 

I think the next steps are to run small and large-scale experiments with different graph architectures, to build more modules types for interacting with the web and computer systems, to build a robust memory storage and retreival system, and to add modules for more capabilities in different modalities, particuraly Free and Open Source ones, and for graphs to be able to fine-tune their own models and graphs on the fly.

If you're interested in how it goes, please come back to this website where I'll post updates, if you're interested in playing with it yourself [please check out the code on GitHub](https://github.com/Miserlou/Helix), and if you're interested in contributing, please use GitHub issues to share your ideas, experiments, and code.