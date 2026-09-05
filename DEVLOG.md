# Tearapy development log

## Picking the game back up

Tearapy started as a small game for Cozy Fall Jam 2023. The original build already had the core loop: a customer arrives, asks for a tea through dialogue, the player selects ingredients, and the customer accepts or rejects the result. It also had six customers, three orders per customer, character art, background music, environmental audio, and an ending screen with a restart button.

The project then sat for a while. Work resumed on August 29, 2026 for Improve My Game Jam 46. The goal was to make the existing loop dependable enough to play through, then add the bits that make remembering customers and experimenting with ingredients worthwhile.

## August 29: make customer progression dependable

The first pass replaced the fragile customer state flow with explicit active and inactive customer lists. Each customer keeps their own progression level, while the database tracks the lowest unfinished level across the remaining customers.

The customer rotation now:

- chooses among customers at the current unfinished level;
- falls back to the lowest remaining level when a level has no eligible customers;
- avoids immediately selecting the customer who just finished a round when another choice exists; and
- removes a customer after their third successful order.

Once no active customers remain, the game stops the shop ambience and opens the ending scene. Restarting the game resets customer progress and selected ingredients instead of rebuilding the state through scene-specific shortcuts.

This pass also cleaned up the database API and added typed customer arrays. The early implementation still duplicated `CustomerData` references, which meant a new run could inherit mutated customer state. That was fixed on September 2 by converting the data objects into `Resource` types and deep-cloning the customer templates when a run starts.

## August 31 to September 2: preserve state and remove race conditions

The tea-making screen and the tea shop are separate scenes, so the selected ingredients need to survive the trip between them. The selection state became a small autoload with helper methods for reading names, checking that all three entries are present and distinct, and clearing the selection at the right time. Returning to the tea-making screen now restores the selected slots and disables the matching inventory cards.

Recipe validation also became stricter. The shop checks all clue groups revealed for the current customer. A tea only succeeds if it contains a different ingredient for each revealed clue group. Empty selections, duplicate ingredients, and missing customers fail safely instead of producing an error.

The dialogue and scene transition code received a larger safety pass:

- scene transitions ignore duplicate requests while a dissolve is running;
- customer and dialogue fade tweens are cancelled before a new fade starts;
- generation checks prevent an old fade callback from changing the state of a new customer;
- the shop waits for the fade to finish before evaluating the tea and moving on; and
- input and serve/select buttons are ignored while a transition or customer handoff is in progress.

These guards address the kind of bugs that only appear when the player clicks quickly: overlapping fades, dialogue being cleared by an old callback, duplicate scene changes, and customer handoffs getting stuck halfway through.

The dialogue box also gained green and red feedback states for accepted and rejected teas. Its typewriter speed is now based on the message length, at 30 characters per second, rather than giving every message the same duration. Double-clicking a message reveals it immediately. Replacing or clearing text now cancels its active tween first.

Small presentation fixes landed in the same stretch: a typo and an unnecessary emoji were removed, and the character sprite was flipped so customers face into the shop.

## September 4: add memory and a reason to keep experimenting

The new customer journal records every tea served to the current customer. It shows the customer's portrait and name, then lists each attempt with its three ingredient icons. Accepted attempts use a green panel and check mark; rejected attempts use a red panel and cross. The list scrolls when it grows beyond the notebook, and an empty customer starts with a simple "No teas served yet." message.

The journal opens as a sliding, dimmed overlay. It refreshes after each attempt, blocks the tea-making controls while open, can be closed by clicking outside it, and responds to the cancel action. The notebook state is kept with the current customer and is cleared when a new game resets customer progress.

Ingredient unlocking was added as a separate autoload-backed system. A new run begins with ten ingredients available. Successful rounds create a choice between two locked ingredients, and choosing one adds it to the tea-making inventory. The rejected option receives a short cooldown so it does not immediately appear again. The unlock order covers the remaining twenty ingredients.

The unlock flow also protects the game from a progression softlock. When a customer advances, the unlock choice looks at the next clue. If that clue needs two still-locked ingredients, those two become the offered pair, so either choice leaves the next appearance solvable. The first customer is always the Grumpy Lumberjack, whose opening dialogue teaches the selection and description flow before random customer rotation begins.

The unlock overlay went through a few visual iterations during the jam. It gained a dark outer frame, hover animation, descriptive ingredient card artwork instead of bare icons, and a larger layout that gives the illustrated cards room to read.

The ingredient menu was refactored around reusable `IngredientCard` controls and typed `PropData` resources. Cards now communicate with the tea-making scene through hover, selection, and removal signals. The selected slots use the same control, while locked inventory items remain visible but visibly unavailable. The current card preview is cleared when it is no longer relevant, including when the journal or an unlock overlay takes focus.

## September 5: ship it and polish the rough edges

The project was updated to Godot 4.7 metadata and uses the GL Compatibility renderer. The old import and UID metadata was regenerated so the project opens cleanly in the newer engine.

An itch.io deployment pipeline was added under `.github/workflows/publish-itch.yml`. Pushes to `main` export a headless Web build with Godot 4.7.2, pass the build between jobs as an artifact, install Butler, and publish the result to `zahkros/tearapy:web`. The workflow also cancels overlapping uploads and moves the export templates into the runner's expected directory, fixing the CI image's user-path mismatch.

The last polish pass fixed a customer fading issue by replacing competing sprite/dialogue tweens with one guarded fade operation. Ingredient hover feedback now uses short eased scale and opacity tweens, and selected ingredients play a removal sound. New UI sounds cover the notebook movement, unlock reveal, and ingredient removal. The textbox timing was adjusted again so long and short messages feel consistent.

## Current state

The 2026 version keeps the original cozy tea-shop loop, but it now has a complete progression structure around it:

1. Meet a customer and read their clues.
2. Select three distinct ingredients.
3. Serve the tea and record the result in the journal.
4. Advance the customer, unlock an ingredient after a successful round, and use the new clue on the next visit.
5. Repeat until every customer has completed all three orders.

The important change is not the number of new screens. It is that the game now remembers what the player did and uses that information to guide the next round.
