#!/usr/bin/env bash
# *****************************************************************
# (C) Copyright IBM Corp. 2019, 2021. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************

set -ex

export CXXFLAGS="$(echo ${CXXFLAGS} | sed -e 's/ -std=[^ ]*//')"
export CXXFLAGS="${CXXFLAGS} -D__STDC_FORMAT_MACROS"

if [[ $ppc_arch == "p10" ]]
then
  if [[ -z "${GCC_HOME}" ]];
  then
    echo "Please set GCC_HOME to the install path of gcc-toolset-12"
    exit 1
  else
    export CMAKE_PREFIX_PATH=$PREFIX
    export GCC_AR=$GCC_HOME/bin/ar
    # Removing Anaconda supplied libstdc++.so so that generated libs build against
    # libstdc++.so present on the system provided by gcc-toolset-12
    rm ${PREFIX}/lib/libstdc++.so*
    rm ${BUILD_PREFIX}/lib/libstdc++.so*
  fi
fi

PYTHON_VERSION=$(python -V 2>&1 | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
PACKAGE_PATH=$PREFIX/lib/python${PYTHON_VERSION}/site-packages/
export TORCH_INSTALL_PREFIX=$PACKAGE_PATH/torch/

python setup.py install --single-version-externally-managed --record=record.txt
