# nuntius

Client-specific configuration and deployment for OMIWORLD.

Built on [`semkit`](https://github.com/EmanueleMusumeci/semkit), a
redistributable modular library, pulled in here as a pinned git submodule.
Corrections to semkit's behavior that aren't ready to commit upstream go
through `overlay/patches/` instead of touching the submodule directly.

See `CLAUDE.md` for the full split rule and `STATUS.md` for current state.

```bash
git clone --recurse-submodules git@github.com:EmanueleMusumeci/nuntius.git
```
