#!/bin/bash
#= git_log_stats__sum_CALC_HOURS.sh

# > git_log_stats__changes__average.sh  | head
# 2025-12-13 01:39:47 +0100, 5d90367, GITSTATS:F:1:I:1:D:1, GITCHANGES:2, AVG_LINES_PER_HOUR:0, CALC_HOURS:0, some 
# 2025-12-09 00:49:27 +0100, a0c1d52, GITSTATS:F:2:I:5:D:3, GITCHANGES:8, AVG_LINES_PER_HOUR:0, CALC_HOURS:0, [0.8.7] {0} <web_ui> bug fix in web_ui/src/components/RemContMonComponent.vue . 
# 2025-12-09 00:14:30 +0100, c2faa91, GITSTATS:F:1:I:4:D:0, GITCHANGES:4, AVG_LINES_PER_HOUR:0, CALC_HOURS:0, post-add files belonging to previous commit. 
# 2025-12-09 00:11:54 +0100, c97e3ca, GITSTATS:F:5:I:545:D:1, GITCHANGES:546, AVG_LINES_PER_HOUR:0, CALC_HOURS:3, post-added files belonging to previous commit. 
# 2025-12-09 00:05:03 +0100, 5ad907c, GITSTATS:F:4:I:45:D:5, GITCHANGES:50, AVG_LINES_PER_HOUR:50, CALC_HOURS:1, [0.8.6] {1} <multiple> 1: moved hard-coded config in dimp.js:post_url and dproc.js:run_func_url to site-static-config.json: .sections.dimp|dproc.base_api_url 
# 2025-12-08 13:30:42 +0700, 8b53305, GITSTATS:F:13:I:326:D:9, GITCHANGES:335, AVG_LINES_PER_HOUR:0, CALC_HOURS:2, Updates for dockers Some ip addresses are still hard coded! 
# 2025-11-28 10:38:53 +0100, 4098246, GITSTATS:F:3:I:81:D:2, GITCHANGES:83, AVG_LINES_PER_HOUR:0, CALC_HOURS:0, [0.8.5] {0} <system> update /site-static-config.example.json for new mqtt_mcs = mcs-server-2.dcs-mgt.nl  
# 2025-11-27 22:31:00 +0100, fc36542, GITSTATS:F:2:I:26:D:2, GITCHANGES:28, AVG_LINES_PER_HOUR:28, CALC_HOURS:1, [0.8.4] {1} <jdbl_models> RCOM: add feature 'auto-status/color change door DIO changes' . 
# 2025-11-27 13:52:37 +0100, 70e4344, GITSTATS:F:2:I:84:D:1, GITCHANGES:85, AVG_LINES_PER_HOUR:85, CALC_HOURS:1, [0.8.3] {1} <system> add project/d251127-overview--site-static-config.txt . 
# 2025-11-27 12:40:09 +0100, 23b509f, GITSTATS:F:3:I:36:D:30, GITCHANGES:66, AVG_LINES_PER_HOUR:0, CALC_HOURS:0, [0.8.2] {0} <jdbl_models> bugfix: rename need_notification to need_notification_boolstr 

# git_log_stats__changes__average.sh \

cat \
  | perl -pe 's/^.*CALC_HOURS:(\d+).*$/$1/' \
  | awk '{s+=$0} END {print s}' \

#-eof

