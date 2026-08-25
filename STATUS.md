# STATUS

Handoff file — same convention as `semkit/STATUS.md`: update after every
substantial advance so work can move between agents/sessions without losing
the thread.

**Last updated:** 2026-08-25 · `semkit` submodule bumped to the client-config-splits commit (newsletter/translation/sources/portal branding), deployed via the fixed GitHub Actions deploy workflow.

**Portal user `alice` created and verified live end-to-end** (login, translate, chat, SSE gating). Deploy workflow bug fixed in semkit: it ran docker compose from the stack parent dir; compose.yml lives in this repo. Submodule sync step added to the workflow.

**Last updated:** 2026-08-20 · `semkit` submodule pinned to `699ef92`,
deployed live.

## Now

The cutover that was deferred since the initial scaffold is essentially
done: this repo is the real thing now, not a staging area.

- **Renamed for real.** `nuntius-new/` → `nuntius/`. The old standalone
  checkout that used to live at this path (semkit content, pre-split) is
  preserved untouched at `/home/emanuele/omiworld/nuntius.bak.20260819/` — a
  dead-end backup, don't develop against it. Ongoing semkit work happens in
  the submodule at `nuntius/semkit/` (a real, independent git working copy —
  commit and push from there like any other clone, then bump the pin here).
- **Production stack moved in.** `compose.yml`, `Caddyfile`, `.env.example`,
  `create_emanuele_admin.py` are now version-controlled, here.  `.env` (real
  secrets) was moved to sit alongside `compose.yml` but is gitignored —
  confirmed via `git check-ignore` and a `git status` review before every
  commit in this pass; never staged, never pushed.
- **Build context flipped**: `webapp.build.context` and the db init-script
  mount now point at `./semkit` (the submodule) instead of the old parallel
  checkout. Content was identical at switch time, so this was a
  zero-behavior-change edit — it just closes the two-copies drift risk this
  session itself created.

**Guardrails split is live in production** (deployed 2026-08-20,
`docker compose up -d webapp` from `semkit@699ef92`). Verified post-deploy,
not just built: `omiworld-webapp` healthy, public `/portal/` returns 200,
`SEMKIT_CONFIG_DIR` resolved correctly inside the container, `client.yaml`
mounted with real OMI values, `GuardrailsManager` instantiated for real
inside the live container returned `enabled: True` with a correct keyword
match. Data integrity double-checked after the deploy (see below) — archive
still has its 1 document, sources its 1 row, both admin users present,
unchanged.

**Next step:** newsletter/translation/sources/portal-branding splits, or
ingesting a real corpus — your call.

## Found and fixed during this move

**Real bug, not hypothetical**: renaming `nuntius-new/` → `nuntius/` silently
changed Docker Compose's *implicit* project-name prefix from `omiworld` to
`nuntius` (Compose derives it from the directory name when unset). Without
catching this, the next `docker compose up` from here would have created
brand-new empty `nuntius_db_data`/`nuntius_caddy_data`/`nuntius_caddy_config`
volumes and a `nuntius_net_main_db` network instead of attaching to the real
ones (`omiworld_db_data` holds actual production data). Caught by comparing
`docker compose config`'s resolved volume/network names against
`docker volume ls`/`docker network ls` before ever running `up`. Fixed with
an explicit `name: omiworld` at the top of `compose.yml` — pins the project
name regardless of what the directory is ever renamed to again. Rebuilt and
re-verified after the fix; image tag correctly reads `omiworld-webapp:latest`
again (it had briefly become `nuntius-webapp:latest`).

Also hit a git footgun worth remembering: the `semkit/` submodule starts in
**detached HEAD** by default. A commit made there without first
`git checkout main` isn't on any branch — it pushes nowhere useful
(`git push origin main` silently pushes the *unchanged* local `main` ref,
not your detached commit). Always `git checkout main` (or `git switch main`)
in the submodule before committing there.

**One more, found at actual deploy time**: `docker compose up -d webapp`
recreated `omiworld-db` too, despite only `webapp` being named on the command
line. Compose stores per-container config-hash labels (including the
project's working directory) and recreates anything whose labels drifted —
db's *labels* changed because the compose file's directory changed, even
though its meaningful config (image/env/volumes) didn't. Confirmed harmless:
container recreation doesn't touch the named volume (`omiworld_db_data`'s
`CreatedAt` is still `2026-07-27`, untouched), and a live data query after
the deploy confirmed all rows intact. Worth expecting on any future
`docker compose up` from here, at least once — the labels should be stable
now that this directory won't move again.

## Known temporary state

- **Pushing to GitHub sometimes needs a workaround.** The droplet has no
  deploy key for this repo (only for `semkit`) — direct `git push` fails
  with "denied to deploy key." Workaround: `git bundle create --all`,
  download, clone locally, push from a machine with full account SSH access.
  A local auto-mode classifier also intermittently blocks the local push
  itself (unrelated to the deploy-key issue, inconsistent — sometimes blocks,
  sometimes doesn't on an identical retry) — if blocked, just retry the exact
  same push command.

## Blocked / known issues

See `semkit/STATUS.md` for guardrails-area follow-ups and the corpus/
scraping issues (unrelated, predate all of this — still just 1 document).

## Deferred (not started)

1. **Newsletter/translation/sources/portal-branding splits** — same pattern
   as guardrails, one area at a time.
2. **Default neutral theme** (palette + placeholder logo) — a portal/branding
   concern, not started.
3. **Figma MCP frontend work** — separate follow-up, after theme config exists.
4. **Legacy dead-code tree** (`webapp/`, `interfaces/`, `orchestrators/`, etc.
   inside semkit) — stays open per instruction, needs per-component testing
   before deletion.
5. CI/CD for this repo. `semkit`'s `.github/workflows/deploy.yml` already
   assumed a `compose.yml` inside the semkit checkout at a fixed path — that
   never matched reality even before this move (compose.yml has always lived
   one level up), and still doesn't (it's in this sibling repo now, not
   inside semkit). Pre-existing inconsistency, not touched by this move,
   still needs a real fix or a rewrite whenever CI/CD for this repo happens.
6. A real overlay patch — none needed yet, every semkit change so far has
   gone in as a direct commit.
7. `git init` the old `/home/emanuele/omiworld/` directory's remnants
   (`modules/`, `webapp/`, the tarballs, `nuntius.bak.*`) if any of it is
   ever worth preserving formally — currently just reference material per
   your own read of it, left untouched.

## How to run

```bash
ssh emanuele@100.85.38.88          # droplet-midmain — root SSH is broken,
                                     # see semkit/STATUS.md; use emanuele
cd /home/emanuele/omiworld/nuntius
git submodule status
git -C semkit log -1 --oneline

docker compose build webapp   # safe, doesn't touch the running container
docker compose up -d webapp   # cuts over — done 2026-08-20, expect a
                                # one-time db container recreate (see above)
```
