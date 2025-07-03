#!/usr/bin/env sh
set -e

# Ensure data dir exists
mkdir -p /app/data
chmod -R 777 /app/data

# Marker to run migrations only once per volume
MARKER="/app/data/.initialized"
if [ ! -f "$MARKER" ]; then
  echo "First startup: running migrations"
  python manage.py migrate --noinput
  touch "$MARKER"
else
  echo "Already initialized; skipping migrations."
fi

# Collect static assets
echo "Collecting static files"
python manage.py collectstatic --noinput

# Execute default CMD
exec "$@"
