# linelength

How long strings should get before overflowing to next line, for text output.

type: [int](../attribute-types/int.md), default: `128`, minimum: `60`

Example, where an 80-character long string (`"a " * 40`) is broken up onto two lines, when printed as [canonical output](/docs/outputs/canon/):


    $ echo 'digraph G { linelength=60; N0 [label="a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a "]; }' | dot -Tcanon
    digraph G {
            graph [linelength=60];
            node [label="\N"];
            N0      [label="a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a \
    a a a a a a a a a a "];
    }


The text overflows when the _label_ reaches the given size.

Despite the `linelength` name, this is the length of the attribute string, _not_ the length of the overall line (which includes the node ID and attribute key).

_Valid on:_

  * Graphs
