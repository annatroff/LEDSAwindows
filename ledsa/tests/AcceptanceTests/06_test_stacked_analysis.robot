*** Settings ***
Resource  global_keywords.resource

Force Tags  analysis  stacked

*** Test Cases ***
Step Stacked Analysis Linear Solver
    Create Stacked Test Data
    Setup Camera Simulation    cam0    0.5
    Setup Camera Simulation    cam1    2.5
    Change Directory    ${WORKDIR}${/}stacked
    Create And Fill Config Stacked    cam0    cam1
    Execute Ledsa    -as
    Plot Stacked Extinction Coefficients    linear
    Check Stacked Extinction Coefficient Results    linear


*** Keywords ***
Create Stacked Test Data
    Log    Creating stacked test data for two cameras at different heights
    Change Directory    ${WORKDIR}
    Create Test Data Stacked

Setup Camera Simulation
    [Arguments]    ${cam_dir}    ${cam_z}
    Log    Setting up camera simulation in ${cam_dir} with camera height z=${cam_z}
    Change Directory    ${WORKDIR}${/}stacked${/}${cam_dir}
    Create And Fill Config For Stacked Cam    ${cam_z}
    Execute Ledsa    -s1
    Execute Ledsa    -s2
    Execute Ledsa    --coordinates
    Execute Ledsa    -s3_fast

Plot Stacked Extinction Coefficients
    [Arguments]    ${solver}
    Log    Plotting stacked extinction coefficients with ${solver} solver
    Change Directory    ${WORKDIR}${/}stacked
    Plot Stacked Input Vs Computed Extinction Coefficients    ${solver}

Check Stacked Extinction Coefficient Results
    [Arguments]    ${solver}
    Log    Checking stacked extinction coefficient results for ${solver} solver
    Check Stacked Results    2    ${solver}
    Check Stacked Results    3    ${solver}
    Check Stacked Results    4    ${solver}

Check Stacked Results
    [Arguments]    ${image_id}    ${solver}
    Log    Checking stacked results for image ${image_id}
    ${rmse} =    Check Stacked Input Vs Computed    ${image_id}    ${solver}
    Stacked Rmse Should Be Small    ${rmse}

Stacked Rmse Should Be Small
    [Arguments]    ${rmse}
    Should Be True    ${rmse} < 0.05
