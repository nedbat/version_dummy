from distutils.core import setup

setup(
    name="version_dummy",
    version="4.0",
    author="Ned Batchelder",
    author_email="ned@nedbatchelder.com",
    url="http://nedbatchelder.com",
    packages=["version_dummy"],
    entry_points={
        'call_me': [
            'one = version_dummy:one',
            'two = version_dummy:two',
        ],
    },
)
