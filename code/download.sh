#!/bin/tcsh
setenv PATH /opt/homebrew/bin:/bin:/usr/local/bin:/usr/bin:/Developer/usr/bin:/usr/local/texlive/current/bin/universal-darwin:/Developer/usr/sbin:/sbin:/usr/sbin:/usr/local/sbin:/usr/libexec:/usr/X11R6/bin:/usr/texbin:/Library/MySQL/bin:/Users/jackman:/Users/jackman/depot_tools
cd "/Volumes/GoogleDrive/Shared drives/C200 TEAM: ANALYTICS/Polling/simon_jackman/results/code"
R CMD BATCH --no-save download_verbose.R
