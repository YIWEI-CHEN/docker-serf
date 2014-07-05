#!/bin/bash

SERF_HOME=/usr/local/serf
SERF_BIN=$SERF_HOME/bin/serf
SERF_CONFIG_DIR=$SERF_HOME/etc

# if SERF_JOIN_IP env variable set generate a config json for serf
[[ -n $SERF_JOIN_IP ]] && cat > $SERF_CONFIG_DIR/join.json <<EOF
{
  "retry_join" : ["$SERF_JOIN_IP"],
  "retry_interval" : "5s"
}
EOF

# by default only short hostname would be the nodename
# we need FQDN
cat > $SERF_CONFIG_DIR/node.json <<EOF
{
  "node_name" : "$(hostname -f)",
  "bind" : "$(hostname -f)"
}
EOF

# if SERF_ADVERTISE_IP env variable set generate a advertise.json for serf to advertise the given IP
[[ -n $SERF_ADVERTISE_IP ]] && cat > $SERF_CONFIG_DIR/advertise.json <<EOF
{
  "advertise" : "$SERF_ADVERTISE_IP"
}
EOF

$SERF_BIN agent -config-dir $SERF_CONFIG_DIR $@ | tee /var/log/serf.log