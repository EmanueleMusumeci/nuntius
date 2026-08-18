# STATUS

Handoff file — same convention as `semkit/STATUS.md`: update after every
substantial advance so work can move between agents/sessions without losing
the thread.

**Last updated:** 2026-08-18 · HEAD `c730cf9`, pushed to `origin/main`
(`git@github.com:EmanueleMusumeci/nuntius.git`). `semkit` submodule pinned to
`f34c63e`.

## Now

First real config area (guardrails) is done end-to-end and proves the
pattern; four more identified areas remain unstarted (newsletter,
translation, sources, portal branding — same three-tier pattern each time).
No client-specific *code* has moved into this repo yet, only client
*configuration* (`config/guardrails/client.yaml`).

**Next step:** pick the next area — newsletter has the most duplication
(the "OMI editor" persona prompt hardcoded independently in 3 places in
semkit) — and repeat: universal Jinja2 prompt(s) + `chatbot/config.py`
loading in semkit, real values in `nuntius/config/<area>/client.yaml` here.

## Done recently

- **Guardrails split** — `config/guardrails/client.yaml` here holds the real
  OMI values (org name, 28-term topic list, audience, reject categories),
  extracted from what used to be hardcoded directly in semkit source. Semkit
  side: `f34c63e`+`83cdf0e`+`c2d3a4b` (see `semkit/STATUS.md`).
- Submodule pin bumped `734f982` → `f34c63e`.

## Known temporary state (unchanged from scaffold)

- **This repo lives at `/home/emanuele/omiworld/nuntius-new/`** on
  droplet-midmain — not `nuntius/`, still avoiding collision with the
  pre-existing checkout at that path (semkit's content, old directory name).
- **Production is unaffected and unchanged.** Still deploys from
  `/home/emanuele/omiworld/nuntius/` directly — pre-split code, and now also
  pre-guardrails-refactor. This repo is not wired into deployment.
- **Pushing to GitHub needs a workaround.** The droplet has no deploy key for
  this repo (only for `semkit`) — `git push` from the droplet fails with
  "denied to deploy key." Current workaround: `git bundle create --all`,
  download it, clone locally, push from a machine with full account SSH
  access. A deploy key would fix this properly but that's a GitHub security
  setting change, out of scope to do unattended.

## Blocked / known issues

None specific to this repo. See `semkit/STATUS.md` for the guardrails-area
follow-ups (production hasn't picked up the split yet; corpus/scraping issues
predate all of this and are unrelated).

## Deferred (not started)

1. **Cutover**: rename `/home/emanuele/omiworld/nuntius/` → `semkit/` on disk,
   rename `nuntius-new/` → `nuntius/`, rewire `compose.yml`'s build context,
   actually deploy from this repo. Still fully deferred — no production risk
   from any of the work so far.
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

## How to run

```bash
ssh emanuele@100.85.38.88          # droplet-midmain — root SSH is broken,
                                     # see semkit/STATUS.md; use emanuele
cd /home/emanuele/omiworld/nuntius-new
git submodule status
git -C semkit log -1 --oneline
```
