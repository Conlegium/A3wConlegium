// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: exchangeMissionProcessor.sqf
//	@file Author: [IOCI] Randleman

#define MISSION_PROC_TYPE_NAME "Altis"
#define MISSION_PROC_TYPE_NAME_2 "Service"
#define MISSION_PROC_TIMEOUT (["A3W_exchangeMissionTimeout", 30*60] call getPublicVar)
#define MISSION_PROC_COLOR_DEFINE exchangeMissionColor

#include "exchangeMissions\exchangeMissionDefines.sqf"
#include "missionProcessor.sqf";
