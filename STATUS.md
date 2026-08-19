# STATUS

Handoff file — same convention as `semkit/STATUS.md`: update after every
substantial advance so work can move between agents/sessions without losing
the thread.

**Last updated:** 2026-08-19 · HEAD `84a6c21`, pushed to `origin/main`
(`git@github.com:EmanueleMusumeci/nuntius.git`). `semkit` submodule pinned to
`dfd2c1e`.

## Now

First real config area (guardrails) is done end-to-end, verified through an
actual production Docker build (not just unit tests) — see `semkit/STATUS.md`
for the full verification trail. Four more identified areas remain unstarted
(newsletter, translation, sources, portal branding — same three-tier pattern
each time). No client-specific *code* has moved into this repo yet, only
client *configuration* (`config/guardrails/client.yaml`).

**Next step:** pick the next area — newsletter has the most duplication (the
"OMI editor" persona prompt hardcoded independently in 3 places in semkit).
Separately: `/home/emanuele/omiworld/compose.yml` now points
`SEMKIT_CONFIG_DIR` at this repo's `config/` and mounts it into the webapp
container — a built image already reflects this (2026-08-19), just not
deployed. `docker compose up -d webapp` from `/home/emanuele/omiworld/`
whenever you want it live.

## Done recently

- **Guardrails split** — `config/guardrails/client.yaml` here holds the real
  OMI values (org name, 28-term topic list, audience, reject categories),
  extracted from what used to be hardcoded directly in semkit source.
- Submodule pin bumped `734f982` → `f34c63e` → `dfd2c1e` (packaging +
  error-handling fixes, found by actually building and running the image —
  see `semkit/STATUS.md`).
- **Production `compose.yml` wired up** (not part of this repo — see below):
  `SEMKIT_CONFIG_DIR: /app/client-config` env var + a `volumes:` mount of
  `./nuntius-new/config` into the webapp container, validated with
  `docker compose config` and a real `docker compose build webapp`.

## Known temporary state (unchanged from scaffold)

- **This repo lives at `/home/emanuele/omiworld/nuntius-new/`** on
  droplet-midmain — not `nuntius/`, still avoiding collision with the
  pre-existing checkout at that path (semkit's content, old directory name).
  `compose.yml`'s new volume mount references `./nuntius-new/config`
  literally — **that path needs updating if/when the cutover renames this
  directory to `nuntius/`.**
- **Production build context is still the old checkout.** `compose.yml`'s
  `build.context` is still `./nuntius` (the pre-split checkout, itself now
  updated with the guardrails fixes directly — see `semkit/STATUS.md`), not
  this repo. This repo only supplies the *config values* consumed at runtime
  via the volume mount, not the application code itself. That's expected for
  now — the code-side cutover (building from this repo + submodule instead of
  the direct checkout) is still fully deferred, see below.
- **Pushing to GitHub needs a workaround, sometimes.** The droplet has no
  deploy key for this repo (only for `semkit`) — `git push` from the droplet
  fails with "denied to deploy key." Workaround: `git bundle create --all`,
  download, clone locally, push from a machine with full account SSH access.
  (Observed inconsistently — one push attempt from the local machine was
  blocked by an unrelated approval layer, a retry of the identical command
  went through. Not fully understood; the bundle workaround is reliable
  regardless.)

## Blocked / known issues

- **`/home/emanuele/omiworld/` (the actual production stack directory) has no
  version control at all** — not a git repo, just a stray `compose.yml.bak`.
  Today's `compose.yml` edit has no diff history anywhere except
  `semkit/STATUS.md`'s note about it. Worth `git init`-ing at some point.
- See `semkit/STATUS.md` for guardrails-area follow-ups and the corpus/
  scraping issues (unrelated, predate all of this).

## Deferred (not started)

1. **Cutover**: rename `/home/emanuele/omiworld/nuntius/` → `semkit/` on disk,
   rename `nuntius-new/` → `nuntius/` (update `compose.yml`'s volume mount
   path when this happens), rewire `compose.yml`'s build context to this
   repo, actually deploy from it instead of the direct semkit checkout.
2. **Newsletter/translation/sources/portal-branding splits** — same pattern
   as guardrails, one area at a time.
3. **Default neutral theme** (palette + placeholder logo) — a portal/branding
   concern, not started.
4. **Figma MCP frontend work** — separate follow-up, after theme config exists.
5. **Legacy dead-code tree** (`webapp/`, `interfaces/`, `orchestrators/`, etc.
   inside semkit) — stays open per instruction, needs per-component testing
   before deletion.
6. CI/CD for this repo. A real overlay patch (none needed yet — every semkit
   change so far has gone in as a direct commit, not a patch).
7. `git init` the production stack directory (see Blocked above).

## How to run

```bash
ssh emanuele@100.85.38.88          # droplet-midmain — root SSH is broken,
                                     # see semkit/STATUS.md; use emanuele
cd /home/emanuele/omiworld/nuntius-new
git submodule status
git -C semkit log -1 --oneline

# Production build/deploy (from /home/emanuele/omiworld/, not this repo):
docker compose build webapp   # safe, doesn't touch the running container
docker compose up -d webapp   # actually cuts over
```
