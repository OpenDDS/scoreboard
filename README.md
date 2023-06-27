# OpenDDS scoreboard configuration

These xml files are used to generate the [OpenDDS scoreboard](https://scoreboard.opendds.org/).
Edit one of the xml files in this repository to add or remove a build.

The `build.sh` script builds the scoreboard.
It expects two environment variables to be set:
1. `BUILDLOG_ROOT` - path to the downloaded log files and produced scoreboard.
2. `AUTOBUILD_ROOT` - path to autobuild
