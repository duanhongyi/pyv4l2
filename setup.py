#!/usr/bin/env python3

import sys

from glob import glob
from setuptools import setup, find_packages
from setuptools.extension import Extension

from pyv4l2 import __version__


setup(
    name='pyv4l2',
    version=__version__,
    description='Simple, libv4l2 based frame grabber',
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Cython',
        'Programming Language :: C',
        'Topic :: Software Development :: Libraries'
    ],
    author='duanhongyi',
    author_email='dominik.pieczynski@gmail.com',
    url='https://github.com/duanhongyi/pyv4l2',
    license='GNU Lesser General Public License v3 (LGPLv3)',
    setup_requires=['setuptools_cython', 'Cython >= 0.18'],
    extras_require={
        'examples': ['pillow', 'numpy'],
    },
    packages=find_packages(),
    ext_modules=[
        Extension(
            'pyv4l2/camera',
            ["pyv4l2/camera.pyx"],
            libraries=["v4l2", ]
        ),
        Extension(
            'pyv4l2/controls',
            ["pyv4l2/controls.pyx"],
            libraries=["v4l2", ]
        )
    ]
)
