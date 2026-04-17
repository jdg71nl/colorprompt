#!/bin/bash
#= docker_priv_registry_add_cert_ca__jbase2.sh

#
BASENAME=`basename $0`
SCRIPT=`realpath $0`             # -s, --strip, --no-symlinks : don't expand symlinks
SCRIPT_PATH=`dirname $SCRIPT`
# echo "SCRIPT='$SCRIPT"            # SCRIPT='/Users/jdg/dev/mern-template/deploy/docker/dc-mongo-52-up.sh
# echo "SCRIPT_PATH='$SCRIPT_PATH"  # SCRIPT_PATH='/Users/jdg/dev/mern-template/deploy/docker
cd $SCRIPT_PATH

# [copy from: get_platform.sh]
[ ! -x /usr/bin/uname ] && echo "# Error: we cannot run /usr/bin/uname ! (we are not on a Unix/Linux platform?) " && exit 1
case "$(/usr/bin/uname -s)" in
  Darwin)
    PLAT='MacOS'
    echo "# (info) detected platform '$PLAT' "
    ;;
  Linux)
    PLAT='Linux'
    echo "# (info) detected platform '$PLAT' "
    ;;
  CYGWIN*|MINGW32*|MSYS*|MINGW*)
    PLAT='Windows'
    echo "# Error: platform '$PLAT' not supported. exit-1 " && exit 1
    ;;
  *)
    PLAT='Unknown'
    echo "# Error: platform '$PLAT' not supported. exit-1 " && exit 1
    ;;
esac

#
if [ "$PLAT" == "Linux" ]; then
  echo "# (info) on Linux we need 'sudo' privs:"
  MY_UID=$(id -u)
  if [ $MY_UID != 0 ]; then
    # $* is a single string, whereas $@ is an actual array.
    echo "# provide your password for 'sudo':" ; sudo "$0" "$@" ; exit 0 ;
  fi
fi

#
DOM_PORT="jbase2.j.j71.nl:5000"

# "Use self-signed certificates"
# "Using this along with basic authentication requires to also trust the certificate into the OS cert store for some versions of docker (see below)"
#
# https://distribution.github.io/distribution/about/insecure/
[ "$PLAT" == "Linux" ] && CA_DIR="/etc/docker/certs.d/$DOM_PORT"
#
# https://docs.docker.com/desktop/troubleshoot-and-support/faqs/macfaqs/
[ "$PLAT" == "MacOS" ] && CA_DIR="$HOME/.docker/certs.d/$DOM_PORT"

#
CA_FILE="$CA_DIR/ca.crt"

#
mkdir -pv $CA_DIR

#: --[CWD=~/prod/registry-docker-repo]--[1776450420 18:27:00 Fri 17-Apr-2026 UTC]--[jdg@jbase2]--[vm/1.9G,os:Debian-12/bookworm,isa:x86_64]------
#: > cat certs/domain.crt 
#: -----BEGIN CERTIFICATE-----
#: MIIGIzCCBAugAwIBAgIUBXr2zS3QabdnoGppAGLVd5kkkF0wDQYJKoZIhvcNAQEL
#: BQAwgZIxCzAJBgNVBAYTAk5MMRMwEQYDVQQIDApTb21lLVN0YXRlMQswCQYDVQQH
#: DAJBRjEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMRgwFgYDVQQD
#: ...

#
cat <<HERE > $CA_FILE
-----BEGIN CERTIFICATE-----
MIIGIzCCBAugAwIBAgIUBXr2zS3QabdnoGppAGLVd5kkkF0wDQYJKoZIhvcNAQEL
BQAwgZIxCzAJBgNVBAYTAk5MMRMwEQYDVQQIDApTb21lLVN0YXRlMQswCQYDVQQH
DAJBRjEhMB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMRgwFgYDVQQD
DA9qYmFzZTIuai5qNzEubmwxJDAiBgkqhkiG9w0BCQEWFWluZm9Ac2lsdnJzZXJ2
aWNlcy5ldTAeFw0yNjA0MTcxODA4NDhaFw0yNzA0MTcxODA4NDhaMIGSMQswCQYD
VQQGEwJOTDETMBEGA1UECAwKU29tZS1TdGF0ZTELMAkGA1UEBwwCQUYxITAfBgNV
BAoMGEludGVybmV0IFdpZGdpdHMgUHR5IEx0ZDEYMBYGA1UEAwwPamJhc2UyLmou
ajcxLm5sMSQwIgYJKoZIhvcNAQkBFhVpbmZvQHNpbHZyc2VydmljZXMuZXUwggIi
MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC2+ESyoEXkN5p+o34ZpJscdmSY
zf3VLhixM+X9OHcKs+67897wdcHV2Z52wWvJ3edTj3O8n9qnuvbRhBQhHzZH8CLI
KbHhBsh4kM6weUrtvOR1wo19kb82TE/+vdV59074Do2HinRd/6JQnmRIkni/rZGk
rwr0e1NKkS9bGrNxmeCuTcrTEH3SXxTCTB4mWlGmk/y5l9ZWOQrg9eZQEW5DjBEk
AV890en7Ux2aeewIpPxoLTgp+qZSrYJ94J6mPWiIFSEcKXBZ+Fldw1Yeup/VYa6X
H0vt6f8zeSXC9Bwkx0Q9B501BCH+iHRYo0k+bxaM/3rXGS30zWvHxwcz+AO1/gH8
MUhQF71jHh/P5l/udewSUR3bzq4G7SLFxLJWXhQmFLiJ/22sHnq7p0odWxb7HlLY
67wCgDreckBhCeXzPNu/9/ddC1KbrbfqsqYyYDQP7RYqZQlCoXDKNnJfXWj63Vil
qWlWoFDtS0/zSxm0KFUvVViExp6+RiyNT+Xqg3aVfCzPcbFK/Qf647xgcPl46+od
EzzUCNI5ItPmyNBd795rEvKJ8Ykn1F344HWlli7hCsQrEGPmBOzoCGEDC1BtLTmt
M/UkbYIjL9c05/I7MsYVp7rvzJogwCmz4la4wHU4aW7G+7J0dXb2AHueCpG/03dj
Pa9lhJMccASPwl4rowIDAQABo28wbTAdBgNVHQ4EFgQUDCzQeeLd/pe+prbR5Wgj
7r6TuP8wHwYDVR0jBBgwFoAUDCzQeeLd/pe+prbR5Wgj7r6TuP8wDwYDVR0TAQH/
BAUwAwEB/zAaBgNVHREEEzARgg9qYmFzZTIuai5qNzEubmwwDQYJKoZIhvcNAQEL
BQADggIBAK3rAetIkmMRj1kYAukvziQ1H4Xyn/34gbyJlGuZv3mL5KoMEqCHW1qR
jI6AXRTv2qQxNNIT3qbknKGFV2ZGWFw2vQ2dukq/c8yeoQXB/CEP4K8O3H0++1Mz
vhkHgVvIAuGYJfuPPPCQak2SPJmoNXxu8N6splGszZ8LVHJNF6IdNmhC1Rn87jok
NyOL4ZriDW+z8t2ZrQVmipUfPGysxXwaQlpOFN+vs5ft53Fme71JhuQBD4DYkPBW
x0H65yW1fu+fxJr8gxLusv1SCJiJ07KI80EhNHL82n0FpmfKKGdu4lqH2R4oEqLG
CZGzERMR/mMVTJLr35pPbud7sxdir6Y5Xu0rWbdpmC/kX2KUBAz8kc8xIOoiRByh
IZFY7L2e6v5A4nqDPFkYP3XzK/rZ4YVuYqeENYKUOiGKu0Sty3duQoI8kRiFlxW8
h/MK4LPA4A3uafTl7wCj1dff1r/4TbanT+Gl+XMibK61XzlxEoJmwHRZQT4qpoyb
wqqOTumsvKlcO3k3Fxmk1wo6C8AX8XQJ94eMkpNO313CInkfgdLLYSYxfAVTV1t5
30b2wrGLo7jfcN7ZR7gAQZevcFZoxU1KdHS76rzfKa9XsZfAOFV6fKM13qG5nNgz
EuqO4Ta4af0156S66XkmVudawKuEEOCr1ywKqJNP0OzCMZ6+GU9T
-----END CERTIFICATE-----
HERE

#-eof

