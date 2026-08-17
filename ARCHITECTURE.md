# ARCHITECTURE

This repo is thin today — see `STATUS.md` for why. It currently contributes
exactly two things: a pinned reference to `semkit`, and a mechanism for
patching it without touching it.

## What exists here

```
nuntius/
├── semkit/              # git submodule, pinned to a specific commit — read-only
│                         # in practice; never edit in place (see overlay/CLAUDE.md)
├── overlay/
│   ├── CLAUDE.md         # the patch-queue mechanism
│   └── patches/          # empty
├── scripts/
│   └── apply-overlay.sh  # semkit/ + overlay/patches/*.patch → build/semkit/ (gitignored)
├── CLAUDE.md             # the semkit-vs-nuntius split rule
├── STATUS.md
└── README.md
```

## Where the actual application lives

Everything — the Flask app, the five-database RAG/newsletter/translation/
archive/chat stack, migrations, Docker/compose, tests — is still entirely
inside `semkit/`, described in `semkit/ARCHITECTURE.md`. This repo hasn't
extracted anything from it yet; that's future work, done incrementally.

## Target shape

As client-specific (OMIWORLD-only) pieces get identified, they move to live
directly in this repo — alongside `semkit/`, not inside it. Candidates, once
the split actually happens: production `compose.yml`/`Caddyfile`/`.env`
(currently one level up, at `/home/emanuele/omiworld/`), any OMIWORLD-specific
config or content, deployment automation. Reusable pieces stay in `semkit/`
and get bumped forward via the submodule pin as semkit itself advances.

No timeline for this — it happens as work touches each area, not as a
big-bang migration.
