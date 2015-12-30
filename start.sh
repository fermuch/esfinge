#!/bin/bash
function usage(){
  echo -e './start.sh'
  echo -e ''
  echo -e '\t-h --help'
  echo -e '\t-t --tests'
  echo -e '\t-p --production'
}

VELOCITY=0
PRODUCTION=""

while [ "$1" != "" ]; do
  PARAM=`echo $1 | awk -F= '{print $1}'`
  VALUE=`echo $1 | awk -F= '{print $2}'`
  case $PARAM in
    -h | --help)
      usage
      exit
      ;;
    -t | --tests)
      VELOCITY=1
      ;;
    -p | --production)
      PRODUCTION="--production"
      ;;
    *)
      echo "ERROR: unknown parameter \"$PARAM\""
      usage
      exit 1
      ;;
  esac
  shift
done


echo -e "\e]0;Meteor Server\007"
ulimit -n 10000
# to solve bug with old tests not being deleted
TESTS_DIR='packages/tests-proxy/'
if [[ -d "${TESTS_DIR}" && ! -L "${TESTS_DIR}" ]] ; then
  rm -r ${TESTS_DIR}
fi

env BIND_IP="0.0.0.0" JASMINE_BROWSER=PhantomJS ALLOWED_ORIGIN="*" VELOCITY=$VELOCITY meteor run $PRODUCTION --settings settings.json
