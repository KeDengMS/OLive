# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
docker run -d -p 6379:6379 redis

npm run --prefix frontend serve &>/dev/null &
cd backend
celery flower -A app.celery --port=5555 &>/dev/null &
celery worker -A app.celery -P gevent &>/dev/null &
cd ..
python ./backend/app.py
pkill -9 -f 'celery worker'
kill -9 `sudo lsof -t -i:8000`
kill -9 `sudo lsof -t -i:5555`
kill -9 `sudo lsof -t -i:6379`