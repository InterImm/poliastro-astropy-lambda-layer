#!/bin/bash
set -xv
if [ ! -d python ]
then
    mkdir -p python
fi

PIPINSTALL='pip install numpy scipy astroquery --compile -t python'
PIPINSTALL2='pip install --no-deps poliastro --compile -t python'
STRIPSO='find "python/" -name "*.so" | xargs strip'
RMTESTS='find "python/" -path "python/astropy" -prune -o -name "tests" | xargs rm -rf'
RMCACHE='find "python/" -name "__pycache__" | xargs rm -rf'
PIPINSTALLASTROPY='pip install astropy --compile -t python'
ZIPFILE='zip -r poliastro-layer.zip python'
WORKFLOW="${PIPINSTALL};${PIPINSTALL2};${STRIPSO};${RMTESTS};${RMCACHE};${PIPINSTALLASTROPY};${ZIPFILE}"

echo "==============================="
echo "New folders will be created in:\n${PWD}"
echo "==============================="
echo "Inside requirements.txt:\n$(cat requirements.txt)"
echo "==============================="
echo "Running commands in docker:"
echo "Workflow:\n${WORKFLOW}"
echo "-----------------------------"
docker run --rm -it -v ${PWD}:/var/task lambci/lambda:build-python3.6 \
bash -c "${WORKFLOW}"
