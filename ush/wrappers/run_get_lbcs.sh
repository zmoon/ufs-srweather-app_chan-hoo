#!/bin/sh
export GLOBAL_VAR_DEFNS_FP="${EXPTDIR}/var_defns.sh"
set -x
source ${GLOBAL_VAR_DEFNS_FP}
export CDATE=${DATE_FIRST_CYCL}
export CYCLE_DIR=${EXPTDIR}/${CDATE}

# get the LBCS files
export ICS_OR_LBCS="LBCS"
export EXTRN_MDL_NAME=${EXTRN_MDL_NAME_LBCS}
${JOBSdir}/JREGIONAL_GET_EXTRN_MDL_FILES
