#!/usr/bin/env sh
set -e

# Папка для sqlite
mkdir -p /app/data
chmod -R 777 /app/data

# Определяем, используем ли SQLite
if echo "$DATABASE_URL" | grep -q '^sqlite://'; then
  MARKER="/app/data/.initialized_sqlite"
  if [ ! -f "$MARKER" ]; then
    echo "First sqlite startup: running migrations"
    python manage.py migrate --noinput
    touch "$MARKER"
  else
    echo "SQLite already initialized; skipping migrations."
  fi
else
  echo "Non-sqlite DB detected; running migrations"
  python manage.py migrate --noinput
fi

# Collect static files
echo "Collecting static files"
python manage.py collectstatic --noinput

# Передаём управление приложению
exec "$@"