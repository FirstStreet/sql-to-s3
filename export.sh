#!/bin/bash
HOST=${HOST:-${HOST}}
DB_NAME=${DB_NAME:-${DB_NAME}}
USER=${USER:-${USER}}
PASS=${PASS:-${PASS}}
BUCKET=${BUCKET:-${BUCKET}}
OBJECT_NAME=${OBJECT_NAME:-${OBJECT_NAME}}

if [[ ${OBJECT_NAME} == "" ]]; then
  OBJECT_NAME=$(date +%m%d%Y-%H:%M:%S).sql
fi

echo "Pulling Database from $HOST"
mysqldump --add-drop-table --host=$HOST --user=$USER --password=$PASS $DB_NAME --result-file=$OBJECT_NAME --verbose

echo "Backing up to $BUCKET as $OBJECT_NAME"
aws s3 cp $OBJECT_NAME $BUCKET/$OBJECT_NAME
