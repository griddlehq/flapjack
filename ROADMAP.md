# Flapjack — Roadmap

**Last updated:** 2026-05-23
**Status ledger policy:** This file is a routing page only. Canonical product status is maintained in [`engine/docs2/FEATURES.md`](engine/docs2/FEATURES.md).

## Implemented

Implemented status/history is canonical in [`engine/docs2/FEATURES.md#completed-work-archive`](engine/docs2/FEATURES.md#completed-work-archive) and [`engine/docs2/FEATURES.md#public-sync-lineage-ledger-canonical`](engine/docs2/FEATURES.md#public-sync-lineage-ledger-canonical).

Use this file only to route open work; do not duplicate launch/status narration here.
## Open / Not Yet Implemented

Open routing details live here; status/history remains canonical in [`engine/docs2/FEATURES.md`](engine/docs2/FEATURES.md).

| # | Work Item | Status | Routing |
|---|-----------|--------|---------|
| RF-1 | Search HA ownership/freshness design gate | Open | Keep design-gated until owner, generation/term, replica freshness, restart recovery, and split-brain contracts have one tested source of truth. |
| RF-2 | Durable analytics rollup writer/query planner | Open | Rollup foundation is merged; writer + planner + certified-coverage retention deletion remain open. |
| RF-3 | OpenAPI snapshot follow-through | Open | Re-run focused OpenAPI snapshot validation at current `main` and refresh `engine/docs2/openapi.json` if needed. |
| RF-4 | Runbooks iteration | Open | Continue refining `engine/docs2/3_IMPLEMENTATION/OPERATIONS.md` from incident learnings. |
| OSS-1 | OSS polish wave open follow-ups (may23_fjc_139pm batch) | 🔶 Open | See the `OSS polish wave: lanes A–F` lineage in [`engine/docs2/FEATURES.md#public-sync-lineage-ledger-canonical`](engine/docs2/FEATURES.md#public-sync-lineage-ledger-canonical); private execution detail remains in `chats/icg/may23_fjc_139pm_1_w0_orchestration.md` in the dev repo only. |
## Open-Source Launch Planning

For launch sequencing and current status, use:

- [`engine/docs2/FEATURES.md#recommended-execution-order`](engine/docs2/FEATURES.md#recommended-execution-order)
- [`engine/docs2/FEATURES.md#current-production-readiness-state`](engine/docs2/FEATURES.md#current-production-readiness-state)
- [`engine/docs2/1_STRATEGY/HIGHEST_PRIORITY.md`](engine/docs2/1_STRATEGY/HIGHEST_PRIORITY.md)

## Confidence-Completeness Planning

For the next engineering block after the closed launch gate, use:

- [`engine/docs2/FEATURES.md#recommended-execution-order`](engine/docs2/FEATURES.md#recommended-execution-order)
- [`engine/docs2/1_STRATEGY/HIGHEST_PRIORITY.md`](engine/docs2/1_STRATEGY/HIGHEST_PRIORITY.md)
- [`PRIORITIES.md`](PRIORITIES.md)

Detailed working checklists and proof-pack session notes may exist in the private dev repo, but public routing docs should resolve entirely within the synced public tree.

## Archive

When this list grows stale or too large, move completed items to `roadmap-history/YYYY-QN.md`.
