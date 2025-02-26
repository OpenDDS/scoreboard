#!/usr/bin/env bash

# Expects the following variables to be defined.
#
# BUILDLOG_ROOT - directory for downloading and producing output
# AUTOBUILD_ROOT - directory containing autobuild

set -ue

SCOREBOARD_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "----- Starting mirror_scoreboard";

if ! [ -d "${BUILDLOG_ROOT}" ]
then
    echo "BUILDLOG_ROOT (${BUILDLOG_ROOT}) does not exist"
    exit 1
fi

# Build the main selection page
echo "----- Building Main Index page"
"${AUTOBUILD_ROOT}/scoreboard.pl" -v -i "${SCOREBOARD_ROOT}/index.xml" -d "${BUILDLOG_ROOT}"

# Update the DDS scoreboard
TITLE="OpenDDS Build Scoreboard"
echo "----- Building ${TITLE}"
xml_file="${SCOREBOARD_ROOT}/dds.xml"
"${AUTOBUILD_ROOT}/scoreboard.pl" -v -t "${TITLE}" -f "${xml_file}" -d "${BUILDLOG_ROOT}" -o dds.html -c -k 10
echo "----- Building test matrix for ${TITLE}"
"${AUTOBUILD_ROOT}/matrix.py" "${BUILDLOG_ROOT}"

# Update the DDS scoreboard
TITLE="OpenDDS4 Build Scoreboard"
echo "----- Building ${TITLE}"
xml_file="${SCOREBOARD_ROOT}/dds4.xml"
"${AUTOBUILD_ROOT}/scoreboard.pl" -v -t "${TITLE}" -f "${xml_file}" -d "${BUILDLOG_ROOT}" -o dds4.html -c -k 10
echo "----- Building test matrix for ${TITLE}"
"${AUTOBUILD_ROOT}/matrix.py" "${BUILDLOG_ROOT}"
