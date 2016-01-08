// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_RewardExchange.sqf
//	@file Author: [IOCI] Randleman

if (!isServer) exitwith {};
#include "exchangeMissionDefines.sqf";

private ["_exchangeObject"];

_setupVars =
{
	_missionType = "Exchange Device";
	_locationsArray = MissionSpawnMarkers;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;
	
	_exchangeObject = createVehicle ["Land_Device_assembled_F", _missionPos, [], 5, "None"];
	_exchangeObject setDir random 360;

	_missionHintText = format ["<br/>has dropped at the marker.<br/>The <t color='%1'>Mission Reward File</t><br/>could be exchanged here!", exchangeMissionColor]
};

_ignoreAiDeaths = true;

_failedExec =
{
	// Mission failed
	deleteVehicle _exchangeObject;
	_failedHintTitle = "Altis Service";
	_failedHintMessage = format ["The device got picked up to<br/><t color='%1'>refill money</t>!<br/>It will be dropped<br/>soon as possible again!", exchangeMissionColor]
};

_successExec =
{
	// Mission complete
	//this mission never get succeed , it should just spawn the missionreward exchange device sometimes :P
};

_this call exchangeMissionProcessor;
