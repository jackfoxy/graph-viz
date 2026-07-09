# The positioned-graph noun

Consumers that want geometry instead of (or besides) SVG set
`want-graph=%.y` and read `graph.result`, a `$graph:graph`
(`sur/graph.hoon`). This is the pipeline's public output noun:
everything the SVG is drawn from, and enough to drive any other
renderer.

## Conventions

- All coordinates are `@rs`, in points (1/72 inch), **y-up**, origin
  at the drawing's lower left. SVG output flips y at codegen; if you
  render this noun yourself, flip (or pass `flip-y`).
- `canvas.scale` is a factor ≤ 1 derived from the graph `size`
  attribute (and `-s`); coordinates are unscaled — apply the factor
  as a final transform, as the SVG does.
- Node indices (`tail`/`head` in edges) are positions in `nodes`,
  which is resolution (creation) order.

## Schema

```hoon
+$  graph
  $:  name=@t                    ::  graph id ('' if anonymous)
      canvas=[size=fpair scale=@rs]
      directed=?
      nodes=(list gnode)
      edges=(list gedge)
      clusters=(list gcluster)
  ==
+$  fpair  [x=@rs y=@rs]
+$  gnode
  $:  name=@t
      center=fpair
      half=fpair                 ::  half-extents: box is center ± half
      shape=@t                   ::  lowercased shape name
      attrs=(map @t @t)          ::  complete resolved attributes
      label=@t                   ::  after \N/\G substitution
      label-at=fpair
  ==
+$  gedge
  $:  tail=@ud                   ::  index into nodes
      head=@ud
      spline=(list fpair)        ::  cubic bezier control runs
      arrows=(list (list fpair)) ::  arrowhead polygons
      label=(unit [text=@t at=fpair])
      attrs=(map @t @t)
  ==
+$  gcluster
  $:  name=@t
      bbox=[ll=fpair ur=fpair]
      label=(unit [text=@t at=fpair])
      attrs=(map @t @t)
  ==
```

## Invariants

- `spline` length is always `3k + 1` for `k ≥ 1` segments: point 0 is
  the start, then each group of three is `[ctrl-1 ctrl-2 endpoint]` —
  exactly SVG's `M ... C ...` structure.
- Spline endpoints lie on the node boundary (box or ellipse
  intersection, or the compass-port attachment). Arrow polygons sit
  on top of the spline end; their first point is the tip.
- Within a rank, node boxes never overlap and their order along the
  within-rank axis is the crossing-reduction order.
- `attrs` maps are complete resolutions: defaults inherited at the
  node/edge's first mention plus explicit attributes, latest-wins,
  including unknown attributes untouched.

## Warnings

`warnings` on the result (unless `quiet`) carries one entry per
unknown attribute name plus any rank-value complaints, as plain
cords.
