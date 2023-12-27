#!/usr/bin/env sh
# Configures a fresh container image so imports will run.
set -o errexit -o nounset -o noclobber
dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd); cd "$dir"

[ -e ./.env ] || {
    echo "copying .env template" >&2;
    cp ./.env.example ./.env; }
( . ./.env;
    echo "NETBOX_URL=${NETBOX_URL:?}";
    token=${NETBOX_TOKEN:?}
    [ ${#token} -ge 12 ] || { \
        echo "NETBOX_TOKEN is too short (${#token})" >&2; exit 1; }
    n=$((${#token} - 6))
    hidden=$(printf "%${n}s" | sed 's/ /*/g')
    token=$(echo "$token" | sed -E 's/^(...).*(...)$/\1'"$hidden"'\2/')
    echo "NETBOX_TOKEN=$token"; )

pip install -r requirements.txt

apt-get update
apt-get install --yes curl git

