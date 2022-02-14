#!/bin/bash

############################################################
## Script to build RRFS-CMAQ                              ##
## Components:                                            ##
## - regional workflow, UFS_UTILS, UPP                    ##
## - arl_nexus, fv3gfs_aqm, gefs2clbcs, upp_post_stat     ##
## - GSI, JEDI (only for DA)                              ##
############################################################

set -eu

if [[ $(uname -s) == Darwin ]]; then
  readonly MYDIR=$(cd "$(dirname "$(greadlink -f -n "${BASH_SOURCE[0]}" )" )" && pwd -P)
else
  readonly MYDIR=$(cd "$(dirname "$(readlink -f -n "${BASH_SOURCE[0]}" )" )" && pwd -P)
fi

###########################################################
## User specific parameters                              ##
###########################################################
##
## DA option ("NO" or "YES")
##    NO: hera, wcoss_dell_p3
##    YES: hera
##
DA_opt="NO"
##
## Compiler
##
export COMPILER="intel"
##
###########################################################

# Check out the external components for RRFS
echo "... Checking out the common external components: regional workflow, UFS_UTILS, UPP ..."
./manage_externals/checkout_externals -e comp_conf/COMMON/Externals.cfg
echo "... Checking out the RRFS-CMAQ components: arl_nexus,fv3gfs_aqm, gefs2clbcs, upp_post_stat ..."
./manage_externals/checkout_externals -e comp_conf/RRFS-CMAQ/Externals.cfg
if [[ ${DA_opt} == "YES" ]]; then
  echo "... Checking out the DA components: GSI, JEDI ..."
  ./manage_externals/checkout_externals -e comp_conf/RRFS-CMAQ-DA/Externals.cfg
fi

# Build the external components for RRFS-CMAQ
echo "... Building UFS_UTILS ..."
cd ${MYDIR}/comp_conf/COMMON/build_scripts/
./build_UFS_UTILS.sh
echo "... Building UPP ..."
./build_UPP.sh
echo "... Building arl_nexus ..."
cd ${MYDIR}/comp_conf/RRFS-CMAQ/build_scripts/
./build_arl_nexus.sh
echo "... Building fv3gfs_aqm ..."
./build_fv3gfs_aqm.sh
echo "... Building gefs2clbc ..."
./build_gefs2clbc.sh
if [[ ${DA_opt} == "YES" ]]; then
  echo "... Building GSI ..."
  cd ${MYDIR}/comp_conf/RRFS-CMAQ-DA/build_scripts/
  ./build_GSI.sh
  echo "... Building JEDI ..."
  ./build_JEDI.sh
fi
