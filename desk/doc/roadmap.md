# Roadmap

* Longest-path + tightening + balance instead of full network simplex;
  piecewise-cubic corridor splines instead of box-constrained fitting;
  clusters constrain ordering and draw bounding boxes but don't get
  recursive layout. All three sit behind interfaces designed for the
  full replacements.

* Within-rank order can differ from dot's at equal crossing quality
  (independent mincross tie-breaks); `ratio` is decoded but has no
  geometry effect.

* preserve changes to node positions in SVG
