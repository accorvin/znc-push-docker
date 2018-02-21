#!/bin/bash -fu

set -x

TERM="${TERM:-dumb}"
export TERM

# Show environment
env

# Interactive program require valid input. Which is absent in Openshift.
exec < /dev/zero

# Default configuration
if ! [ -e "$PARAM_WDIR/configs/znc.conf" ]; then
  echo "Use default ZNC configuraion. Consider to change default password."
  mkdir -p "$PARAM_WDIR/configs"
  cp "/etc/$ZNC_DEFAULT_CONFIG" "$PARAM_WDIR/configs/znc.conf"
fi

if ! [ -e "$PARAM_WDIR/znc.pem" ]; then
  echo "Generates a pemfile for use with SSL"
  'znc' '--datadir' "$PARAM_WDIR" '--makepem'
fi

exec 'znc' '--foreground' '--datadir' "$PARAM_WDIR"
