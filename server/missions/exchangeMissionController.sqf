// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: exchangeMissionController.sqf
//	@file Author: [IOCI] Randleman

#define MISSION_CTRL_PVAR_LIST ExchangeMissions
#define MISSION_CTRL_TYPE_NAME "Exchange"
#define MISSION_CTRL_FOLDER "exchangeMissions"
#define MISSION_CTRL_DELAY (["A3W_exchangeMissionDelay", 15*60] call getPublicVar)
#define MISSION_CTRL_COLOR_DEFINE exchangeMissionColor

#include "exchangeMissions\exchangeMissionDefines.sqf"
#include "missionController.sqf";
