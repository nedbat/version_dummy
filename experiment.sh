pip --version

V1_SHA="da8cfc943a8acb3140349a81e96ea52430bf0e02"
V2_SHA="ca10cfd07afdce20d61249d5a8e306cf64a3b2b5"

cat > show_version.py << EOF_PY
from distutils.sysconfig import get_python_lib
import os, os.path

try:
    import version_dummy
    print("*** Version dummy is {0}, at {1}".format(version_dummy.VERSION, version_dummy.__file__))
except ImportError:
    print("*** Version dummy isn't available")

interesting = [fn for fn in os.listdir(get_python_lib()) if "dummy" in fn]
for fn in interesting:
    fn = os.path.join(get_python_lib(), fn)
    if os.path.isfile(fn):
        with open(fn) as f:
            contents = f.read().strip()
    else:
        contents = os.listdir(fn)
    print("    {0}\n        --> {1}".format(fn, contents))
EOF_PY

echo
echo "==== version_dummy ===="
# This demonstrates https://github.com/pypa/pip/issues/3212
echo "git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
echo "git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
pip uninstall -y version_dummy
python show_version.py
pip uninstall -y version_dummy
python show_version.py

echo
echo "==== version_dummy with mismatched name ===="
echo "git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=versiondummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
echo "git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=versiondummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
pip uninstall -y version_dummy
python show_version.py
pip uninstall -y version_dummy
python show_version.py

echo
echo "==== version_dummy -e ===="
echo "-e git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
echo "-e git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
pip uninstall -y version_dummy
python show_version.py
pip uninstall -y version_dummy
python show_version.py

echo
echo "==== version_dummy with version ===="
echo "git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy==1.0" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
echo "git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy==2.0" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
pip uninstall -y version_dummy
python show_version.py
pip uninstall -y version_dummy
python show_version.py

echo
echo "==== -e then regular without version ===="
echo "-e git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
echo "git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
pip uninstall -y version_dummy
python show_version.py
pip uninstall -y version_dummy
python show_version.py

echo
echo "==== -e then regular with version ===="
echo "-e git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
echo "git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy==2.0" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
pip uninstall -y version_dummy
python show_version.py
pip uninstall -y version_dummy
python show_version.py

echo
echo "==== regular then -e ===="
echo "git+https://github.com/nedbat/version_dummy@$V1_SHA#egg=version_dummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
echo "-e git+https://github.com/nedbat/version_dummy@$V2_SHA#egg=version_dummy" > requirements.txt
pip install -r requirements.txt
python show_version.py
pip freeze | grep dummy
pip uninstall -y version_dummy
python show_version.py
pip uninstall -y version_dummy
python show_version.py

rm requirements.txt show_version.py
