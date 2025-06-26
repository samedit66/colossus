#!/usr/bin/env sh
set -e

# Use a persistent volume for your marker
MARKER="/app/data/.initialized"

if [ ! -f "$MARKER" ]; then
  echo "First startup: running migrations"
  python manage.py migrate --noinput
  echo "Migrations complete, creating marker at $MARKER"
  touch "$MARKER"
else
  echo "Already initialized; skipping migrations."
fi

# Hand off to your CMD (e.g. gunicorn)
exec "$@"
