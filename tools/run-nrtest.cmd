::
::  run_nrtest.cmd - Runs numerical regression test
::  
::  Date Created: 1/12/2018
::
::  Author: Michael E. Tryby
::          US EPA - ORD/NRMRL
::
::  Arguments: 
::    1 - nrtest script path
::    2 - test suite path
::    3 - version/build identifier
::

@echo off
setlocal

set NRTEST_SCRIPT_PATH=%~1
set TEST_SUITE_PATH=%~2

set NRTEST_EXECUTE_CMD=python %NRTEST_SCRIPT_PATH%\nrtest execute
set TEST_APP_PATH=apps\swmm-%3.json
set TESTS=tests\examples tests\extran tests\routing tests\user
set TEST_OUTPUT_PATH=benchmark\swmm-%3

set NRTEST_COMPARE_CMD=python %NRTEST_SCRIPT_PATH%\nrtest compare
set REF_OUTPUT_PATH=benchmark\swmm-5112
set RTOL_VALUE=0.01
set ATOL_VALUE=0.00

:: change current directory to test suite
cd %TEST_SUITE_PATH%

:: if present clean test benchmark results
if exist %TEST_OUTPUT_PATH% (
  rmdir /s /q %TEST_OUTPUT_PATH%
)

echo INFO: Creating test benchmark
set NRTEST_COMMAND=%NRTEST_EXECUTE_CMD% %TEST_APP_PATH% %TESTS% -o %TEST_OUTPUT_PATH%
:: if there is an error exit the script with error value 1
%NRTEST_COMMAND% || exit /B 1

echo INFO: Comparing test and ref benchmark
set NRTEST_COMMAND=%NRTEST_COMPARE_CMD% %TEST_OUTPUT_PATH% %REF_OUTPUT_PATH% --rtol %RTOL_VALUE% --atol %ATOL_VALUE% --output benchmark\receipt.json
%NRTEST_COMMAND%
