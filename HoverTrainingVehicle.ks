createLog("Main script: Executed").
set launchStateText to list("Pre launch", "Launch", "Ascending", "Altitude hold", "Descending", "Landing", "Pos landing").
// ┌─────────────────────┐
// │ Main launch profile │
// │ 0 - Pre launch      │
// │ 1 - Launch          │
// │ 2 - Ascending       │
// │ 3 - Altitude hold   │
// │ 4 - Descending      │
// │ 5 - Landing         │
// │ 6 - Pos landing     │
// └─────────────────────┘
declare launchState to 0.

// Constants
declare vehicleHeight to alt:radar.

// Static telemetry
telemetryDisplayInit().

// Command lock
declare mainSteering to heading(0, 90, 0).
declare mainThrottle to 0.
lock steering to mainSteering.
lock throttle to mainThrottle.

// Test settings
declare hoverDuration to 10.
declare hoverAltitude to 100.
declare initialLandingAltitude to 1 + vehicleHeight.

// Clock initiators
declare landingInitiator to true.
declare hoverInitiator to true.

// PID settings
declare proportionalGain to 30.
declare integralGain to 0.1.
declare derivativeGain to 30.
set hoverPIDcontroller to PIDLOOP(proportionalGain, integralGain, derivativeGain, 0, 1).

// Main launch LOOP
until false {
    // Dynamic telemetry update
    telemetryDisplayUpdate(launchState, launchStateText, hoverAltitude).

    // Stage separations check
    checkStage(true).

    // PID update
    set hoverPIDcontroller:setpoint to hoverAltitude + 0.2.
    set mainThrottle to hoverPIDcontroller:update(time:seconds, alt:radar).

    // Stages
    if (launchState = 0) {
        // Controls setup
        set mainSteering to heading(0, 90, 0).
        RCS on.
        SAS off.

        // Next launch state handling procedure
        set launchState to launchState + 1.
        createLog("Main Script: Pre launch setup complete").

    }else if (launchState = 1) {
        stage. // LAUNCH!!!
        // Next launch state handling procedure
        set launchState to launchState + 1.
        createLog("Main Script: Liftoff complete, ascending...").

    }else if (launchState = 2) {
        // Next state condition
        if(alt:radar >= hoverAltitude){
            // Next launch state handling procedure
            set launchState to launchState + 1.
            createLog("Main Script: Target altitude reached, holding altitude").
        }

    }else if (launchState = 3) {
        // Hover clock startup
        if(hoverInitiator){
            set hoverTimeInit to round(missionTime, 1).
            set hoverInitiator to false. 
        }

        // Next state condition
        if((round(missionTime, 1) - hoverTimeInit) >= hoverDuration){
            // Next launch state handling procedure
            set launchState to launchState + 1.
            createLog("Main Script: Hover complete, descending...").
        }

    }else if (launchState = 4) {   
        // Landing altitude hold
        set hoverAltitude to initialLandingAltitude.

        // Landing clock startup
        if(landingInitiator){
            set landingTimeInit to round(missionTime, 1).
            set landingInitiator to false. 
        }

        // Next state condition
        if((round(missionTime, 1) - landingTimeInit) >= 5){
            // Next launch state handling procedure
            set launchState to launchState + 1.
            createLog("Main Script: Descent complete, landing...").
        }

    }else if (launchState = 5) {
        // Final landing altitude
        set hoverAltitude to 0 + vehicleHeight.

        // Next state condition
        if(alt:radar < 1 + vehicleHeight){
            // Next launch state handling procedure
            set launchState to launchState + 1.
            createLog("Main Script: Landing complete, shutting down...").
        }
    }else if (launchState = 6) {
        set mainThrottle to 0.
        RCS off.
        unlock steering.
        unlock throttle.
    }
    wait 0.001.
}
