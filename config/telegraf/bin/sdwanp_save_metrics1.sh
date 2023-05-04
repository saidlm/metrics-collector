#!/bin/bash
#
# Influxdata Telegraf execd custom execution script
#
# Heavily based on Telegraf's own example file on GitHub:
# https://github.com/influxdata/telegraf/tree/master/plugins/outputs/execd/examples/file
#

### DEBUG
# set -x

###
### PRE-RUN
###

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin/:/usr/local/sbin

### VARIABLES

_arg1=("${@}")

## ARGUMENTS POSITIONING
# 0 - Full path to the results directory
# 1 - Results file name prefix (think index name in Kibana)
# 2 - Number of historical files to keep locally

###
### FUNCTIONS
###

create_metrics_directory1()
{
mkdir -p "${_arg1[0]}" || exit 1
}

###
### LOOPS
###

# Create directory for saving metrics upon start
create_metrics_directory1

while read _line1
do
  # Get current timestamp
  printf -v _timestamp1 '%(%Y%m%d_%H%M%S)T' -1

  # Write Telegraf supplied metrics to the target file
  echo "${_line1}" >> "${_arg1[0]}/${_arg1[1]}_${_timestamp1}.json"

  # Once a while make sure the destination directory exists,
  # create it if not, and delete old metrics files that have not
  # been taken care of by any external application
  if [ $(( $RANDOM % 10 )) -eq 0 ]
  then
     create_metrics_directory1

     _excess_files1=($(find "${_arg1[0]}" -type f -regextype posix-egrep -regex ".*"${_arg1[1]}"_[0-9]{8}_[0-9]{6}\.json$" | sort -n | head -n -"${_arg1[2]}"))
     for _excess_file1 in ${_excess_files1[@]}; do rm ${_excess_file1}; done
  fi
done < /dev/stdin

###
### POST-RUN
###

# EOF
