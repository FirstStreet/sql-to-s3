#!/bin/bash
HOST=${HOST:-${HOST}}
DB_NAME=${DB_NAME:-${DB_NAME}}
USER=${USER:-${USER}}
PASS=${PASS:-${PASS}}
BUCKET=${BUCKET:-${BUCKET}}
OBJECT_NAME=${OBJECT_NAME:-${OBJECT_NAME}}

echo "Pulling Database from $HOST"
mysqldump --add-drop-table --host=$HOST --user=$USER --password=$PASS $DB_NAME --result-file=$OBJECT_NAME --verbose

echo "Backing up to $BUCKET as $OBJECT_NAME"
aws s3 cp $OBJECT_NAME $BUCKET/$OBJECT_NAME
