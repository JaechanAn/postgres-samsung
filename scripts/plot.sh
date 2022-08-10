#!/bin/bash

# Parse parameters
for i in "$@"
do
  case $i in
    --gpi=*)
      GPI="${i#*=}"
      shift
      ;;

    --latency-short-file=*)
      LATENCY_SHORT_FILE="${i#*=}"
      shift
      ;;

    --latency-long-file=*)
      LATENCY_LONG_FILE="${i#*=}"
      shift
      ;;

    --temp-file=*)
      TEMP_FILE="${i#*=}"
      shift
      ;;

    --space-file=*)
      SPACE_FILE="${i#*=}"
      shift
      ;;

    --eps-file=*)
      EPS_FILE="${i#*=}"
      shift
      ;;

    *)
      # unknown option
      ;;
  esac
done

gnuplot -c ${GPI} ${EPS_FILE} ${LATENCY_SHORT_FILE} ${LATENCY_LONG_FILE} ${TEMP_FILE} ${SPACE_FILE}
