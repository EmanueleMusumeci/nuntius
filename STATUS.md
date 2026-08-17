# STATUS

Handoff file — same convention as `semkit/STATUS.md`: update after every
substantial advance so work can move between agents/sessions without losing
the thread.

**Last updated:** 2026-08-17 · this repo is a fresh scaffold, first commit
pending.

## Now

Nothing in flight beyond the scaffold itself:
- `semkit/` submodule pinned to `734f982` (the commit currently deployed in
  production, before the semkit/nuntius split).
- `overlay/patches/` is empty — zero corrections needed yet.
- No client-specific (OMIWORLD-only) code has been written in this repo yet.

**Next step:** decide what actually moves. `semkit/` today still contains the
*entire* OMIWORLD application, unsplit — routes, migrations, deployment files,
everything — because it's simply the renamed original repo. Nothing has been
categorized into "reusable → stays in semkit" vs. "client-specific → moves
here" yet. That categorization is deliberately not done in this pass; do it
incrementally as work touches each area.

## Known temporary state

- **This repo currently lives at `/home/emanuele/omiworld/nuntius-new/`** on
  droplet-midmain — not `nuntius/`, to avoid colliding with the pre-existing
  checkout at that path (which holds semkit's content under the old directory
  name). Will be renamed to `nuntius/` once the cutover below happens.
- **Production is unaffected.** `/home/emanuele/omiworld/compose.yml` still
  builds from `/home/emanuele/omiworld/nuntius/` (semkit's content, old
  directory name, `origin` now correctly pointed at `semkit.git` as of
  2026-08-17). This new repo is not yet wired into deployment.

## Blocked / known issues

None — this is pure scaffolding, nothing to be blocked on yet.

## Deferred (not this pass)

1. **Cutover**: rename `/home/emanuele/omiworld/nuntius/` → `semkit/` on disk,
   rename `nuntius-new/` → `nuntius/`, rewire `compose.yml`'s build context,
   and actually build/deploy from this repo instead of the direct semkit
   checkout.
2. **Splitting existing code** between semkit (reusable) and nuntius
   (OMIWORLD-specific) — see `semkit/ARCHITECTURE.md` for what currently
   exists, all of it still inside semkit.
3. CI/CD for this repo.
4. A real overlay patch — none has been needed yet.

## How to run

```bash
ssh root@100.85.38.88                              # droplet-midmain
cd /home/emanuele/omiworld/nuntius-new
sudo -u emanuele git submodule status
scripts/apply-overlay.sh
```
