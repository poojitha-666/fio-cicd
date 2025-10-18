#!/bin/bash
set -e

JOB_FILE=/home/poojitha/fio-tests/storage_test.fio
RESULTS_DIR=/home/poojitha/fio-tests/results
mkdir -p $RESULTS_DIR

echo "▶️ Running FIO workloads..."
fio --output=$RESULTS_DIR/fio_output.log $JOB_FILE

echo "✅ FIO completed. Results stored in $RESULTS_DIR"
