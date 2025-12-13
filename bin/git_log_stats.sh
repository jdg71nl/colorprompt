#!/bin/bash

#: # git log --no-merges --date=iso --pretty=format:'%ad, %h, %s' --shortstat
#: # gives:
#: 
#: 2025-11-24 12:32:50 +0100, f891502, [0.7.1] {0} <jdbl_models> mini-update: prevent send MQTT for iob:aio changes, only iob:dio and config_rcom.
#:  2 files changed, 16 insertions(+), 3 deletions(-)
#: 
#: 2025-11-21 01:11:29 +0100, b39c89a, [0.7.0] {1} <jdbl_models> next item in RCOM: now changes in config_rcom.model correctly sends MQTT msg to MCS-Server, also IO-board Signal changes are send correctly.
#:  6 files changed, 447 insertions(+), 503 deletions(-)
#: 
#: 2025-11-20 23:39:20 +0100, f3b00d8, [0.6.30] {4} <web_ui> trying to fix /web/admin/SettingsPage bug where Save button does not disappear while API update works: very frustration many hours and repeating sessions ... suspect: Vue reactivity and fuck-hard to troubleshoot.
#:  11 files changed, 418 insertions(+), 221 deletions(-)
#: 
#: 2025-11-19 23:09:24 +0100, 3e01ef3, [0.6.29] {1} <system> add conversion tool urlencoded<>JSON for analysis Devantech IO-board ETH484-B config: deploy/convert_urlencoded_to_json.js deploy/convert_json_to_urlencoded.js .
#:  7 files changed, 1342 insertions(+), 1 deletion(-)
#: 
#: 2025-11-17 22:46:54 +0100, 4237771, [0.6.28] {2} <multiple> feature PSOM:textlines-v2/displaytext done and well tested.
#:  6 files changed, 139 insertions(+), 30 deletions(-)

git log --no-merges --diff-filter=DCRMAT --oneline --shortstat --date=iso --pretty=format:'%ad, %h, %s' 

#-eof

