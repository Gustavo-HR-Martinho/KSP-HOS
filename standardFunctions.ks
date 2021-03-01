// ┌────────────────────────────┐
// │ Standard functions library │
// └────────────────────────────┘

// Log system
declare global function logSystemInit {
    if(exists("0:/logs/" + ship:name + ".txt")){
        deletePath("0:/logs/" + ship:name + ".txt").
    }
    declare global logFile to archive:create("logs/" + ship:name + ".txt").
}
declare global function createLog {
    parameter message.
    logFile:writeLn("T+" + round(missionTime, 0) + " | " + message).
}

// Telemetry system
declare global function telemetryDisplayInit {
    set terminal:width to 38.
    set terminal:height to 11.
    CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").

    clearScreen.
    print("┌────────────────────────────────────┐").
    print("│ Ship name:                         │").
    print("│ Launch state:                      │").
    print("├────────────────────────────────────┤").
    print("│ Target altitude:                   │").
    print("│ Radar altitude:                    │").
    print("├────────────────────────────────────┤").
    print("│ Vertical speed:                    │").
    print("│ Horizontal speed:                  │").
    print("└────────────────────────────────────┘").
}
declare global function telemetryDisplayUpdate {
    parameter launchState.
    parameter stateText.
    parameter targetAlt.

    print "                       " at (13, 1).
    print ship:name at (13, 1).
    print "                    " at (16, 2).
	print stateText[launchState] at (16, 2).
    print "                 " at (19, 4).
    print round(targetAlt, 3) + " m" at (19, 4).
    print "                  " at (18, 5).
	print round(alt:radar, 3) + " m" at (18, 5).
    print "                  " at (18, 7).
    print round(verticalSpeed, 3) + " m/s" at (18, 7).
    print "                " at (20, 8).
	print round(ship:groundspeed, 3) + " m/s" at (20, 8).
}

// Check if it's time to stage
declare global function checkStage {
    parameter safeStage.
    if (stage:liquidfuel < 0.1) {
        if (safeStage) {
            stage.
            wait 0.5.
            stage.
            createLog("standardFunctions: Safe stage").
        }else{
            stage.
            createLog("standardFunctions: Instant stage").
        }
    }
}