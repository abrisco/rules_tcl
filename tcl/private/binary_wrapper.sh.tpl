#!/usr/bin/env bash

# --- begin runfiles.bash initialization v3 ---
# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; set +e; f=bazel_tools/tools/bash/runfiles/runfiles.bash
# shellcheck disable=SC1090
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v3 ---

set -euo pipefail

INTERPRETER="$(rlocation "{interpreter}")"
ENTRYPOINT="$(rlocation "{entrypoint}")"
CONFIG="$(rlocation "{config}")"
MAIN="$(rlocation "{main}")"
INIT_TCL="$(rlocation "{init_tcl}")"
TCLLIB_PKG_INDEX="$(rlocation "{tcllib_pkg_index}")"

export TCL_LIBRARY="${INIT_TCL%/*}"
export TCLLIB_LIBRARY="${TCLLIB_PKG_INDEX%/*}"

runfiles_export_envvars

exec \
    "${INTERPRETER}" \
    "${ENTRYPOINT}" \
    "${CONFIG}" \
    "${MAIN}" \
    -- \
    "$@"
