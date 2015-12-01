#!/bin/bash

V1_SHA="da8cfc943a8acb3140349a81e96ea52430bf0e02"
V2_SHA="ca10cfd07afdce20d61249d5a8e306cf64a3b2b5"
V3_SHA="313d158a266db3ef27724d9c9c3e145b4f9f6b5e"
V4_SHA="9c283a84843a7cb15782afe580bbc4737af69ab5"
V4_001_SHA="1c6e5d38d857cfb3b9a949baeb670f686728b750"

cat > show_version.py << EOF_PY
from distutils.sysconfig import get_python_lib
import glob, os, os.path, pkg_resources, sys

def show_glob(*parts):
    for fn in glob.glob(os.path.join(*parts)):
        if os.path.isfile(fn):
            with open(fn) as f:
                contents = f.read().strip()
                contents = "| "+"\n            | ".join(contents.splitlines())
        else:
            contents = os.listdir(fn)
        print("    {0}\n        --> {1}".format(fn, contents))

try:
    import version_dummy
    print("*** Version dummy is {0}, at {1}".format(version_dummy.VERSION, version_dummy.__file__))
except ImportError:
    print("*** Version dummy isn't available")
else:
    entrypoints = list(pkg_resources.iter_entry_points('call_me'))
    for ep in entrypoints:
        print("Entry point {0!r}: returns {1!r}".format(ep, ep.load()()))

show_glob(get_python_lib(), "*dummy*")
show_glob(sys.prefix, "src", "*")
EOF_PY

install_and_show() {
    echo "requirements.txt:"
    cat requirements.txt
    pip install -r requirements.txt
    python show_version.py
    pip freeze | grep dummy
}

uninstall_and_show() {
    pip uninstall -y version_dummy
    python show_version.py
    pip uninstall -y version_dummy
    python show_version.py
}

experiment() {
    echo
    echo "$1"
    virtualenv venv
    . venv/bin/activate
    pip --version
    echo "$2" > requirements.txt
    install_and_show
    echo "$3" > requirements.txt
    install_and_show
    uninstall_and_show
    rm -rf venv
}

experiment "==== version_dummy ====" \
    "git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy" \
    "git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy"

experiment "==== version_dummy with mismatched name ====" \
    "git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=versiondummy" \
    "git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=versiondummy"

experiment "==== version_dummy -e ====" \
    "-e git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy" \
    "-e git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy"

experiment "==== version_dummy with version ====" \
    "git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy==1.0" \
    "git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy==2.0"

experiment "==== -e then regular without version ====" \
    "-e git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy" \
    "git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy"

experiment "==== -e then regular with version ====" \
    "-e git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy" \
    "git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy==2.0"

experiment "==== regular then -e ====" \
    "git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy" \
    "-e git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy"

experiment "==== entry points with -e ====" \
    "-e git+https://github.com/nedbat/version_dummy@$V3_SHA#egg=version_dummy" \
    "-e git+https://github.com/nedbat/version_dummy@$V4_SHA#egg=version_dummy"

experiment "==== new sha, dummy version ====" \
    "-e git+https://github.com/nedbat/version_dummy@$V4_SHA#egg=version_dummy==4.0" \
    "git+https://github.com/nedbat/version_dummy@$V4_001_SHA#egg=version_dummy==0.0"

rm requirements.txt show_version.py
