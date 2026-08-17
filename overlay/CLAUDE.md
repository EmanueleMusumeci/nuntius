# overlay/ — patch queue for semkit

`semkit` (the `semkit/` submodule) must stay pristine and pinned — never edit
files inside it directly. That cleanliness is deliberate: semkit is being
negotiated as Background IP for another client, so its git history needs to
read as an unmodified, independently-attributable upstream at all times.

When a behavior in the *currently pinned* semkit commit needs correcting and
you're not ready (or able, mid-negotiation) to commit the fix into semkit
itself, capture it here as a patch instead.

## Adding a patch

1. Make the fix in a throwaway working copy of `semkit/` (e.g.
   `cp -r semkit /tmp/semkit-wip`, edit there).
2. Generate a unified diff relative to the submodule root:
   ```
   cd /tmp/semkit-wip
   diff -ruN ../semkit-orig . > patch.diff   # or: git diff, if the wip copy is its own git repo
   ```
3. Save it as `overlay/patches/NNN-short-description.patch`, zero-padded,
   incrementing (`001-`, `002-`, ...). Patches apply in lexical order, so the
   number is the order.
4. Run `scripts/apply-overlay.sh` and confirm it applies cleanly.

## Applying

`scripts/apply-overlay.sh` copies semkit's tracked content into a gitignored
`build/semkit/`, then applies every `overlay/patches/*.patch` onto that copy
in order via `patch -p1`. That copy — never the submodule checkout — is what
downstream builds (eventually) consume.

## Retiring a patch

Once a fix lands in semkit itself and the submodule pin is bumped past it,
delete the now-redundant patch file. If `apply-overlay.sh` reports a patch as
already-applied or a no-op, that's usually the signal.

## Current state

Empty. No corrections needed yet — this repo is freshly scaffolded from
semkit's `main` at the commit currently pinned in `.gitmodules`.
