#!/usr/bin/env bash
# *****************************************************************
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2019, 2020. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# *****************************************************************

set -ex

PYTHON_VERSION=$(python -V 2>&1 | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
PACKAGE_PATH=$PREFIX/lib/python${PYTHON_VERSION}/site-packages/

python setup.py install --single-version-externally-managed --record=record.txt
