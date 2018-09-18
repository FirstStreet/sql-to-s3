# SQL to S3 (and vice-versa)

This is an image that executes `mysqldump` to provided hosts and sends the .sql file to an S3 bucket. It also supports importing from bucket to host.

**NOTE**: This is a fairly rudimentary implementation that does not have any error handling or validations. The primary purpose of this image functions as a scheduled service on our k8s cluster for automated backups. Use with caution.

## Usage

### Set Env Vars

- HOST=mysql host
- DB_NAME=mysql database name
- USER=mysql username
- PASS=mysql pass
- BUCKET=s3 bucket name (use s3://bucket)
- AWS_ACCESS_KEY_ID=aws access key
- AWS_SECRET_ACCESS_KEY=aws access secret
- AWS_DEFAULT_REGION=aws region (us-east-1, for example)
- OBJECT_NAME=SQL file name (backup.sql, or you can script a timestamp. will be stored and retrieved from s3 as this name. If not provided, a timestamp will be used)

### From host to S3

```
docker run -e HOST=mysql -e DB_NAME=database -e USER=user -e PASS=pass -e BUCKET=s3://bucket -e AWS_ACCESS_KEY_ID=abc123 -e AWS_SECRET_ACCESS_KEY=abc123 -e AWS_DEFAULT_REGION=us-east-1 -e OBJECT_NAME=backup.sql firststreet/sql-to-s3
```


### From S3 to host

Add `--entrypoint /import.sh`.

```
docker run --entrypoint /import.sh -e HOST=mysql -e DB_NAME=database -e USER=user -e PASS=pass -e BUCKET=s3://bucket -e AWS_ACCESS_KEY_ID=abc123 -e AWS_SECRET_ACCESS_KEY=abc123 -e AWS_DEFAULT_REGION=us-east-1 -e OBJECT_NAME=backup.sql firststreet/sql-to-s3
```

## Kubernetes

This is a sample CronJob task that will automatically run at 1AM every morning backing up a MySQL database in a cluster to `<TIMESTAMP>.sql`.

```json
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: sql-backup
spec:
  schedule: "0 1 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: sql-backup
            image: firststreet/sql-to-s3
            env:
            - name: BUCKET
              value: s3://my-bucket
            - name: AWS_ACCESS_KEY_ID
              value: <REPLACE ME>
            - name: AWS_SECRET_ACCESS_KEY
              value: <REPLACE ME>
            - name: DB_NAME
              value: my_database
            - name: AWS_DEFAULT_REGION
              value: us-east-1
            - name: USER
              value: root
            - name: HOST
              value: my-host
            - name: PASS
              valueFrom:
                secretKeyRef:
                  name: mysql-pass
                  key: password
          restartPolicy: OnFailure
```
