#!/bin/bash
HOST=${HOST:-${HOST}}
DB=${DB:-${DB}}
USER=${USER:-${USER}}
PASS=${PASS:-${PASS}}
BUCKET=${BUCKET:-${BUCKET}}
OBJECT_NAME=${OBJECT_NAME:-${OBJECT_NAME}}

echo "Pulling Database from $HOST"
mysqldump --add-drop-table --host=$HOST --user=$USER --password=$PASS $DB --result-file=$OBJECT_NAME --verbose

echo "Importing $OBJECT_NAME from $BUCKET to $HOST"
aws s3 cp $BUCKET/$OBJECT_NAME $OBJECT_NAME
mysql --host=$HOST --user=$USER --password=$PASS $OBJECT_NAME < $OBJECT_NAME