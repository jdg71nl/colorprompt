#!/bin/bash
#= git_log_stats__changes__average.sh

#: > git_log_stats__changes.sh | head
#: 2025-12-09 00:49:27 +0100, a0c1d52, GITSTATS:F:1:I:1:D:1, GITCHANGES:2, [0.8.7] {0} <web_ui> bug fix in web_ui/src/components/RemContMonComponent.vue .
#: 2025-12-09 00:14:30 +0100, c2faa91, GITSTATS:F:2:I:5:D:3, GITCHANGES:8, post-add files belonging to previous commit.
#: 2025-12-09 00:11:54 +0100, c97e3ca, GITSTATS:F:1:I:4:D:0, GITCHANGES:4, post-added files belonging to previous commit.
#: 2025-12-09 00:05:03 +0100, 5ad907c, GITSTATS:F:5:I:545:D:1, GITCHANGES:546, [0.8.6] {1} <multiple> 1: moved hard-coded config in dimp.js:post_url and dproc.js:run_func_url to site-static-config.json: .sections.dimp|dproc.base_api_url
#: 2025-12-08 13:30:42 +0700, 8b53305, GITSTATS:F:4:I:45:D:5, GITCHANGES:50, Updates for dockers Some ip addresses are still hard coded!
#: 2025-11-28 10:38:53 +0100, 4098246, GITSTATS:F:13:I:326:D:9, GITCHANGES:335, [0.8.5] {0} <system> update /site-static-config.example.json for new mqtt_mcs = mcs-server-2.dcs-mgt.nl 

git_log_stats__changes.sh \
  | git_log_stats__changes__average.pl

# RESULTS:

# #!/bin/bash
# #= analyse_git_log_all.sh
# for DIR in \
#   dcs-bmw-rfid-io-board \
#   dcs-hopeland-python-mqtt-shim \
#   dcs-mcs-client \
#   dcs-mcs-server \
#   dcs-rpi-linuxsrv \
#   ;
# do
#   echo "# processing: $DIR ..."
#   cd $DIR
#   git_log_stats__changes__average.sh > ../git_analyse__$DIR.txt
#   cd -
#   echo
# done
# #-eof

# > tail -n1 git_analyse__dcs-mcs-client.txt 
# ## TOTAL AVERAGE of set(AVG_LINES_PER_HOUR>0) = 191 with COUNT(AVG_LINES_PER_HOUR>0) = 117 .

# > tail -n1 git_analyse__dcs-mcs-server.txt 
# ## TOTAL AVERAGE of set(AVG_LINES_PER_HOUR>0) = 191 with COUNT(AVG_LINES_PER_HOUR>0) = 28 .

# ==> so ... both have the same AVERAGE ?!?!?!?!


#-eof

