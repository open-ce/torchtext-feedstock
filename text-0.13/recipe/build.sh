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

if [[ $build_type == "cuda" ]]
then
  export CMAKE_CUDA_HOST_COMPILER=$GXX
  export CMAKE_CUDA_COMPILER=${CUDA_HOME}/bin/nvcc
  export CMAKE_CUDA_ARCHITECTURES="5.2 6.0 6.1 7.0 7.5 8.0 8.6+PTX"
  export FORCE_CUDA=1

  # Create symlinks of cublas headers into CONDA_PREFIX
  mkdir -p $CONDA_PREFIX/include
  find /usr/include -name cublas*.h -exec ln -s "{}" "$CONDA_PREFIX/include/" ';'
  export CUDA_INCLUDE_PATH="${PREFIX}/include,${CUDA_HOME}/include,${CONDA_PREFIX}/include"
fi

PYTHON_VERSION=$(python -V 2>&1 | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
PACKAGE_PATH=$PREFIX/lib/python${PYTHON_VERSION}/site-packages/

python setup.py install --single-version-externally-managed --record=record.txt
#cmake .
