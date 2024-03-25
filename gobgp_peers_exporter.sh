#!/bin/bash

DIR=/var/lib/node_exporter/textfile_collector

/usr/bin/gobgp neighbor | awk 'NR>=2' | awk '{if ($4 ~ /Establ/ || $5 ~ /Establ/) {print $1, 0} else {print $1, 1}}' | \
    awk '{print "gobgp_peers_status{ip=\"" $1 "\"}", $2}' > "$DIR/gobgp.prom.$$"
sed -i '1s/^/# HELP gobgp_peers_status Gobgp peers status.\n# TYPE gobgp_peers_status gauge\n/' "$DIR/gobgp.prom.$$"

chown node_exporter:node_exporter "$DIR/gobgp.prom.$$" && mv "$DIR/gobgp.prom.$$" "$DIR/gobgp.prom"
