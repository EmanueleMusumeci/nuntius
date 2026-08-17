# nuntius

Client-specific configuration and deployment for OMIWORLD, built on top of
**semkit** — a redistributable modular library, pulled in here as a pinned git
submodule.

## The split

- **`semkit/`** (submodule) — the redistributable modular library. Anything
  reusable, not tied to OMIWORLD or any one client, is developed **directly in
  semkit**, as semkit's own commits, in semkit's own working copy — not through
  this repo. It has its own complete doc set: `semkit/CLAUDE.md`,
  `semkit/STATUS.md`, `semkit/ARCHITECTURE.md`.
- **This repo (nuntius)** — everything client-specific: OMIWORLD's own
  configuration, deployment, and any code that only makes sense for this one
  deployment. Developed directly here, going forward.
- **`overlay/`** — a patch queue for the narrow case of "semkit's *currently
  pinned* commit has a behavior we need to correct, but we're not ready to
  commit that fix into semkit itself" (semkit is mid-negotiation as Background
  IP for another client, so its history needs to stay clean and independently
  attributable). See `overlay/CLAUDE.md` for the mechanism. Never edit files
  inside `semkit/` directly — that breaks the pristine-pinned-reference
  property the negotiation depends on.

## Rule of thumb

Before writing code, ask: *would this be useful outside OMIWORLD?* Yes → it
belongs in semkit, as a semkit commit. No → it belongs here, in nuntius.

## Current state

Freshly scaffolded (see `STATUS.md`). No client-specific code has been written
here yet — today this repo is just the submodule pin + the (currently empty)
overlay mechanism. `semkit/` still contains the entire, unsplit OMIWORLD
application as it existed before this split was decided; nothing has been
extracted from it yet.

## Working here

```
git clone --recurse-submodules git@github.com:EmanueleMusumeci/nuntius.git
# or, if already cloned:
git submodule update --init

scripts/apply-overlay.sh   # materializes semkit + any overlay patches into build/semkit/
```
