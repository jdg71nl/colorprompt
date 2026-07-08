#!/bin/bash
#= printhint_sed-print-regex-range.sh

cat <<EOF

> sed -n '/^start()/,/^}/p' /etc/init.d/openvpn
start() {
        # If we are re-called by the up.sh script, then we don't actually want
        # to start OpenVPN. We do this so we can "start" ourselves from
        # inactive (from the up.sh script) which then triggers other
        # services to start which depend on us.
        yesno "$IN_BACKGROUND" && return 0

        default_start
}

# what is above magic ??
# d260708 Claude says:
# The construct /^start()/,/^}/p is a sed address range (two addresses separated by a comma)
# The normative definition lives in the sed page of IEEE Std 1003.1 (POSIX.1), section "Shell & Utilities → sed", under "Addresses in sed". Online at:
# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/sed.html

# so:
sed -n '/start_regex/,/end_regex/p' file

# ook:
# https://www.gnu.org/software/sed/manual/sed.html#Range-Addresses-1

EOF

#-eof

