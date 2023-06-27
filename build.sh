#!/usr/bin/env bash

# Expects the following variables to be defined.
#
# BUILDLOG_ROOT - directory for downloading and producing output
# AUTOBUILD_ROOT - directory containing autobuild

set -u

SCOREBOARD_ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "----- Starting mirror_scoreboard";

if ! [ -d "${BUILDLOG_ROOT}" ]
then
    echo "BUILDLOG_ROOT (${BUILDLOG_DIR}) does not exist"
    exit 1
fi

# Build the main selection page
echo "----- Building Main Index page"
"${AUTOBUILD_ROOT}/scoreboard.pl" -v -i "${SCOREBOARD_ROOT}/index.xml" -d "${BUILDLOG_ROOT}"

# Update the DDS scoreboard
echo "----- Building DDS Build Scoreboard"
xml_file="${SCOREBOARD_ROOT}/dds.xml"
"${AUTOBUILD_ROOT}/scoreboard.pl" -v -t "DDS Build Scoreboard" -f "${xml_file}" -d "${BUILDLOG_ROOT}" -o dds.html -c -k 10

echo "----- Building test matrix for DDS Build Scoreboard"

echo "Building list for dds"
filelist=$(perl "${AUTOBUILD_ROOT}/testmatrix/test-list-extract.pl" -i "${xml_file}")

otraw=/tmp/test_spread.raw
rm -f "${otraw}"

while IFS= read -r filedir
do
    latest="${BUILDLOG_ROOT}/${filedir}/latest.txt"
    if file=$(cut -f 1 -d ' ' "${latest}" 2>/dev/null)
    then
        path="${BUILDLOG_ROOT}/${filedir}/${file}.txt"
        echo "${filedir} ${path}" >> "${otraw}"
    fi
done < <(printf '%s\n' "${filelist}")

(
    cd "${AUTOBUILD_ROOT}/testmatrix"
    python2 GenerateTestMatrix.py 0 "${otraw}" "${BUILDLOG_ROOT}" dds
)

# Copy the style sheet
cp "${AUTOBUILD_ROOT}/testmatrix/matrix.css" "${BUILDLOG_ROOT}/matrix.css"

exit
