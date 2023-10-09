You can run the following command in your local build directory to re-attach to
this AWS Batch job later to see output and download results:

    nextstrain build --aws-batch --attach ${AWS_BATCH_JOB_ID} .

To monitor the job and see the logs but not download results, run:

    nextstrain build --aws-batch --attach ${AWS_BATCH_JOB_ID} --no-download --detach-on-interrupt

To cancel the job, run:

    nextstrain build --aws-batch --attach ${AWS_BATCH_JOB_ID} --cancel

You can also view this job in the [AWS Batch console](https://console.aws.amazon.com/batch/home?region=us-east-1#jobs/detail/${AWS_BATCH_JOB_ID}).
