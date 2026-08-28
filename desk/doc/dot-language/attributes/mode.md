# mode

Technique for optimizing the layout

type: [string](../attribute-types/string.md), default: `major`

[neato](/docs/layouts/neato/) supports modes:

  * `mode="major"`: `neato` uses stress majorization1.
  * `mode="KK"`: `neato` uses the Kamada-Kawai2 version of the gradient descent method. `KK` is sometimes appreciably faster for small (number of nodes < 100) graphs. A significant disadvantage is that `KK` may cycle.
  * `mode="sgd"`: `neato` uses a version of the Stochastic Gradient Descent3 method. `sgd`'s advantage is faster and more reliable convergence than both the previous methods, while `sgd`'s disadvantage is that it runs in a fixed number of iterations and may require larger values of [maxiter](maxiter.md) in some graphs.



There are two experimental modes in `neato`:

  * `mode="hier"`, which adds a top-down directionality similar to the layout used in `dot`, and
  * `mode="ipsep"`, which allows the graph to specify minimum vertical and horizontal distances between nodes. (See the [sep](sep.md) attribute.)



* * *

  1. [Gansner, E.R., Koren, Y., North, S. (2005). Graph Drawing by Stress Majorization. In: Pach, J. (eds) Graph Drawing. GD 2004. Lecture Notes in Computer Science, vol 3383. Springer, Berlin, Heidelberg.](/documentation/GKN04.pdf) ↩︎

  2. [Tomihisa Kamada, Satoru Kawai, An algorithm for drawing general undirected graphs, Information Processing Letters, Volume 31, Issue 1, 1989, Pages 7-15.](https://doi.org/10.1016%2F0020-0190%2889%2990102-6) ↩︎

  3. [J. X. Zheng, S. Pawar and D. F. M. Goodman, "Graph Drawing by Stochastic Gradient Descent," in IEEE Transactions on Visualization and Computer Graphics, vol. 25, no. 9, pp. 2738-2748, 1 Sept. 2019, doi: 10.1109/TVCG.2018.2859997.](https://ieeexplore.ieee.org/document/8419285) ↩︎




_Valid on:_

  * Graphs



**Note:** [neato](/docs/layouts/neato/) only.
