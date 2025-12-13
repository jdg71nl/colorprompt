#!/bin/bash
#= git_log_stats__changes.sh

#: > git_log_stats.sh | head -n20
#: 2025-12-13 01:39:47 +0100, 5d90367, some
#:  1 file changed, 1 insertion(+), 1 deletion(-)
#: 
#: 2025-12-09 00:49:27 +0100, a0c1d52, [0.8.7] {0} <web_ui> bug fix in web_ui/src/components/RemContMonComponent.vue .
#:  2 files changed, 5 insertions(+), 3 deletions(-)
#: 
#: 2025-12-09 00:14:30 +0100, c2faa91, post-add files belonging to previous commit.
#:  1 file changed, 4 insertions(+)
#: 
#: 2025-12-09 00:11:54 +0100, c97e3ca, post-added files belonging to previous commit.
#:  5 files changed, 545 insertions(+), 1 deletion(-)
#: 
#: 2025-12-09 00:05:03 +0100, 5ad907c, [0.8.6] {1} <multiple> 1: moved hard-coded config in dimp.js:post_url and dproc.js:run_func_url to site-static-config.json: .sections.dimp|dproc.base_api_url, 2: added check git-cached to bin/set_version_git_commit.sh to force manual git-add .
#:  4 files changed, 45 insertions(+), 5 deletions(-)
#: 
#: 2025-12-08 13:30:42 +0700, 8b53305, Updates for dockers Some ip addresses are still hard coded!
#:  13 files changed, 326 insertions(+), 9 deletions(-)
#: 
#: 2025-11-28 10:38:53 +0100, 4098246, [0.8.5] {0} <system> update /site-static-config.example.json for new mqtt_mcs = mcs-server-2.dcs-mgt.nl , add /config/ for future singleton use (not done yet).
#:  3 files changed, 81 insertions(+), 2 deletions(-)

# git_log_stats.sh \
#   | grep -v '^$' \
#   | perl -pe 's/{(\d+)[hu]}/{$1}/' \
#   | perl -pe 's/files? changed/file/' \
#   | perl -pe 's/insertions?\(\+\)/insert/' \
#   | perl -pe 's/deletions?\(-\)/delete/' \
#   | perl -pe 's/\s+(\d+) file, (\d+) delete/ $1 file, 0 insert, $2 delete/' \
#   | perl -pe 's/\s+(\d+) file, (\d+) insert$/ $1 file, $2 insert, 0 delete/' \
#   | perl -pe 's/^\s+(\d+)[^\d]+?(\d+)[^\d]+?(\d+)[^\d\n]+$/GITSTATS:F:$1:I:$2:D:$3/' \
#   | awk 'BEGIN{p=""} {if (p ~ /GITSTATS/) {print p ", " $0}}{p=$0}' \ # <== ERROR !!!!!!!!!!!!!!!!!!!!!!
#   | awk -F ':' '{sum=$5+$7; print "GITCHANGES:" sum ", " $0}' \
#   | awk -F ', ' '{print $3 ", " $4 ", " $2 ", " $1 ", " $5}'

git_log_stats.sh \
  | perl -pe 's/{(\d+)[hu]}/{$1}/' \
  | perl -pe 's/files? changed/file/' \
  | perl -pe 's/insertions?\(\+\)/insert/' \
  | perl -pe 's/deletions?\(-\)/delete/' \
  | perl -pe 's/\s+(\d+) file, (\d+) delete/ $1 file, 0 insert, $2 delete/' \
  | perl -pe 's/\s+(\d+) file, (\d+) insert$/ $1 file, $2 insert, 0 delete/' \
  | perl -pe 's/^\s+(\d+)[^\d]+?(\d+)[^\d]+?(\d+)[^\d\n]+$/GITSTATS:F:$1:I:$2:D:$3/' \
  | awk 'BEGIN {p=""} {if (/GITSTATS/) {print $0 ", " p}} {p=$0}' \
  | awk -F ':' '{sum=$5+$7; print "GITCHANGES:" sum ", " $0}' \
  | awk -F ', ' '{print $3 ", " $4 ", " $2 ", " $1 ", " $5}'

#: > git_log_stats__changes.sh | head
#: 2025-12-09 00:49:27 +0100, a0c1d52, GITSTATS:F:1:I:1:D:1, GITCHANGES:2, [0.8.7] {0} <web_ui> bug fix in web_ui/src/components/RemContMonComponent.vue .
#: 2025-12-09 00:14:30 +0100, c2faa91, GITSTATS:F:2:I:5:D:3, GITCHANGES:8, post-add files belonging to previous commit.
#: 2025-12-09 00:11:54 +0100, c97e3ca, GITSTATS:F:1:I:4:D:0, GITCHANGES:4, post-added files belonging to previous commit.
#: 2025-12-09 00:05:03 +0100, 5ad907c, GITSTATS:F:5:I:545:D:1, GITCHANGES:546, [0.8.6] {1} <multiple> 1: moved hard-coded config in dimp.js:post_url and dproc.js:run_func_url to site-static-config.json: .sections.dimp|dproc.base_api_url
#: 2025-12-08 13:30:42 +0700, 8b53305, GITSTATS:F:4:I:45:D:5, GITCHANGES:50, Updates for dockers Some ip addresses are still hard coded!
#: 2025-11-28 10:38:53 +0100, 4098246, GITSTATS:F:13:I:326:D:9, GITCHANGES:335, [0.8.5] {0} <system> update /site-static-config.example.json for new mqtt_mcs = mcs-server-2.dcs-mgt.nl 

#-eof

