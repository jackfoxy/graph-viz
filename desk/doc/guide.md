# %graph-viz user guide

`%graph-viz` renders [Graphviz DOT](https://graphviz.org/doc/info/lang.html)
text to SVG, entirely in Hoon, using the `dot` layered-layout algorithm
(GKNV93). v1 supports the `dot` engine and SVG output.

## Install

With the desk synced into a pier (e.g. via `|mount` + copying `desk/`
into `zod/graph-viz/`):

```
|commit %graph-viz
|install our %graph-viz
```

## Quick start from the dojo

Render DOT text with the bundled generator:

```
+graph-viz!dot-svg 'digraph {a -> b}'
```

This prints a `result` noun: `[%svg warnings=~ diag=~ svg='<?xml ...' graph=~]`
on success. Errors come back as data, not crashes:

```
+graph-viz!dot-svg 'digraph { a -- b }'
```

prints `[%error [%parse line=1 col=14 msg='syntax error']]` — an
undirected edge in a digraph is a syntax error at the operator.

The full pipeline is also a plain library gate, usable from any agent,
thread, or the dojo:

```
=gviz -build-file /=graph-viz=/lib/gviz/hoon
(run:gviz [%version 0v0])
```

prints `[%version ver=[maj=0 min=1 pat=0]]`.

## The poke protocol

The agent is stateless. Gall pokes only ack or nack, so results ride a
one-shot subscription:

1. The caller subscribes to `/result/[uid]`, where `uid` is a `@uv` the
   caller chooses (e.g. from entropy).
2. The caller pokes `%graph-viz` with mark `%gviz-command` carrying the
   same `uid`.
3. The agent computes, emits one `%fact` with mark `%gviz-result` on
   `/result/[uid]`, then `%kick`s the path. Nothing is retained.

From an agent, step 1 and 2 are two cards:

```hoon
=/  uid  `@uv`eny.bowl
:~  [%pass /gviz/results %agent [our.bowl %graph-viz] %watch /result/(scot %uv uid)]
    :*  %pass  /gviz/poke  %agent  [our.bowl %graph-viz]
        %poke  %gviz-command
        !>([%render uid [%dot %svg ~ ~ %.n %.n %.n %.n] 'digraph {a -> b}'])
    ==
==
```

The result arrives in `+on-agent` as a `%fact` with mark
`%gviz-result`, followed by a `%kick` (which your agent should not
resubscribe on).

Poking without a subscriber on the uid's path is nacked with a tang
explaining the protocol. You can see this from the dojo, since the
dojo poke has no subscription:

```
:graph-viz &gviz-command [%version 0v0]
```

## Commands

See `sur/gviz.hoon` for the exact types.

- `[%render uid opts src]` — parse, lay out, and render `src`.
- `[%version uid]` — implementation version, as `[maj min pat]`.
- `[%plugins uid]` — supported and stubbed engines and formats,
  as `[engine ?]` / `[format ?]` lists (the CLI `-P` analogue).

Render options (`$render-opts`, in order):

| field | CLI analogue | meaning |
|---|---|---|
| `engine` | command name / `-K` | only `%dot` lays out; others → `%unsupported-engine` |
| `format` | `-T` | full enum recognized; only `%svg` accepted |
| `defaults` | `-G` `-N` `-E` (`-A` = all three) | outermost attribute defaults, overridable by the file |
| `scale` | `-s` | input-scale points-per-inch; `` `.~36 `` halves the drawing |
| `flip-y` | `-y` | invert the y axis |
| `quiet` | `-q` | drop warnings from the result |
| `verbose` | `-v` | fill `diag` with per-phase counts |
| `want-graph` | — | also return the positioned-graph noun |

The bunt of `render-opts` — `[%dot %svg ~ ~ %.n %.n %.n %.n]` — is the
plain "just render it" configuration.

## DOT language coverage

The parser accepts the complete DOT grammar: graphs and digraphs,
`strict`, node/edge/attribute/assignment statements, edge chains,
attribute lists with `;`/`,` separators, quoted/unquoted/numeral ids,
`+` string concatenation, all three comment forms, subgraphs (named,
anonymous, nested, and as edge endpoints), `rank=` groups, cluster
naming, ports and compass points, unicode and 8-bit identifiers.

HTML labels (`label=<...>`) and `record`/`Mrecord` shapes are
recognized and rejected as `%unsupported-feature`. See
`doc/reference.md` for attributes, and `doc/post-v1.md` for the gap
list.

## LLM Skills

[Graphviz DOT language reference](https://github.com/jackfoxy/foxy-skills/tree/master/gviz-dot-syntax)

[%graph-viz Gall agent API reference](https://github.com/jackfoxy/foxy-skills/tree/master/gviz-gall-api/)

[Practical recipes and best practices](https://github.com/jackfoxy/foxy-skills/tree/master/gviz-patterns/)
