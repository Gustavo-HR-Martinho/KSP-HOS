// ┌─────────────────────────────────────────────┐
// │ BOOT System (Boot Oriented Origin Transfer) │
// │ Mission file transfering system             │
// └─────────────────────────────────────────────┘

// Load and run standard functions
copypath("0:/standardFunctions.ks", "1:/standardFunctions.ks").
runpath("1:/standardFunctions.ks").

// Log system
logSystemInit().
createLog("BOOT System: Executed").

// Load and run main launch script
copypath("0:/" + ship:name + ".ks", "1:/" + ship:name + ".ks").
runpath("1:/" + ship:name).