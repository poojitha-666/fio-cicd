#!/bin/bash
set -e

RESULTS_DIR=/tmp/fio_results
JOB_FILE=/tmp/fio_jobs/storage_test.fio

mkdir -p $RESULTS_DIR

echo "▶️ Running FIO workloads on Ubuntu..."
fio --output=$RESULTS_DIR/fio_output.log $JOB_FILE

echo "✅ FIO completed. Results stored in $RESULTS_DIR"
