#! /usr/bin/env bash
set -e

export GUNICORN_CONF=${GUNICORN_CONF:-./gunicorn_conf.py}

if [[ -z "${OPAL_BROADCAST_URI}" && "${UVICORN_NUM_WORKERS}" != "1" ]]; then
  echo "OPAL_BROADCAST_URI must be set when having multiple workers"
  exit 1
fi

prefix=""
# Start Gunicorn
if [[ -z "${OPAL_ENABLE_DATADOG_APM}" && "${OPAL_ENABLE_DATADOG_APM}" = "true" ]]; then
	prefix=ddtrace-run
fi
exec $prefix gunicorn -b 0.0.0.0:${UVICORN_PORT} -k uvicorn.workers.UvicornWorker --workers=${UVICORN_NUM_WORKERS} -c ${GUNICORN_CONF} ${UVICORN_ASGI_APP} -t 60000
