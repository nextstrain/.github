You can run the following command in your local build directory to re-attach to
this AWS Batch job later to see output and download results:

```
nextstrain build --aws-batch --attach ${AWS_BATCH_JOB_ID} .
```

You can also view this job in the [AWS Batch console](https://console.aws.amazon.com/batch/home?region=us-east-1#jobs/detail/${AWS_BATCH_JOB_ID}).
