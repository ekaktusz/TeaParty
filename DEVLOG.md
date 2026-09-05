# Tearapy development log

## Picking the game back up

Tearapy started as a small game for Cozy Fall Jam 2023. Since we had limited development effort, the original game focused on arts, atmosphere and less so on the actual game mechanics. It also fitted the team of jam.

### The original game
The original build already had the core loop wit everything required for a playthorugh:
- a customer arrives, asks for a tea through dialogue
- the player selects ingredients, and the customer accepts or rejects the result. 

It also had six customers, three orders per customer, character art, background music, environmental audio, etc. Music SFX and most of the art was created by our team directly.

The project then sat for a while. Since we liked the idea of this jam we looked through of our previous projects and this seemed like a great candidate. 
Work resumed on August 29, 2026. 

### Our main goals for this iteration
- Fix existing bugs (some was related to the core loop with the memory game part of this, we had broken end screen, background music loop problems, performance issues etc.) 
- Add some small additional features (small because we still had a limited time)
    - A journal to track the customer's prevoious order
    - A progression / ingredient unlock system which makes the core loop more rewarding, and the ingeridient selection less overwhelming at the start
- Refreshing some of the lower quality AI assisted art. When we started to work on this we used some AI tools for the art for some of the ingredients (only for ingredients, everything else is human made). Since our relationship with AI has changed since we wanted to update all art / assets to human made.
## What changed technically

- Migrated the project to Godot 4.7 with the GL Compatibility renderer.
- Fixed a correct end game mechanic and the game can be restarted.
- Fixed the core memory game logic.
- Added stronger visual clues wether a customer liked or not the tea.
- Added a customer journal in the tea-making scene. It records every served tea with ingredient icons and an accepted or rejected result, and opens as a modal notebook overlay.
- Added ingredient progression. The player starts with ten ingredients, then chooses one of two unlocks after successful rounds. Unlock pairs protect the next required clue, avoiding progression softlocks.
- Refactored the code serveral places to improve the performance.
- Resized assets for smaller export size. (80+% asset size reduction)
- A lot of small improvements. (smoother visuals, more SFX, animations etc.)

## What's next?
- Since our artists had limited time in this iteration we had no time for the art updates. We still think this would be incredibly important, so we plan do it ASAP when we'll have more time.