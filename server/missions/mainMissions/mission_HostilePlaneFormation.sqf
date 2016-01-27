// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: mission_HostilePlaneFormation.sqf
//	@file Author: JoSchaap, AgentRev, [K-TTT] Razor, [IOCI] Randleman

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf"

private ["_planeChoices", "_convoyVeh", "_veh1", "_veh2", "_veh3", "_createVehicle", "_vehicles", "_leader", "_speedMode", "_waypoint", "_vehicleName", "_vehicleName2", "_numWaypoints", "_box1", "_box2", "_box3", "_reward", "_reward2", "_reward3"];

_setupVars =
{
	_missionType = "Hostile Planes";
	_locationsArray = nil; // locations are generated on the fly from towns
};

_setupObjects =
{
	_missionPos = markerPos (((call cityList) call BIS_fnc_selectRandom) select 0);

	_planeChoices =
	[
		["O_Plane_CAS_02_F", "I_Plane_Fighter_03_CAS_F"],
		["I_Plane_Fighter_03_AA_F", "O_Plane_CAS_02_F"],
		["I_Plane_Fighter_03_CAS_F", "I_Plane_Fighter_03_AA_F"]
	];

	if (missionDifficultyHard) then
	{
		(_planeChoices select 0) set [0, "B_Plane_CAS_01_F"];
		(_planeChoices select 1) set [0, "I_Plane_Fighter_03_CAS_F"];
		(_planeChoices select 2) set [0, "O_Plane_CAS_02_F"];
	};

	_convoyVeh = _planeChoices call BIS_fnc_selectRandom;

	_veh1 = _convoyVeh select 0;
	_veh2 = _convoyVeh select 1;
	_veh3 = _convoyVeh select 1;

	_createVehicle =
	{
		private ["_type", "_position", "_direction", "_vehicle", "_soldier"];

		_type = _this select 0;
		_position = _this select 1;
		_direction = _this select 2;

		_vehicle = createVehicle [_type, _position, [], 0, "FLY"];
		_vehicle setVariable ["R3F_LOG_disabled", true, true];
		_vel = [velocity _vehicle, -(_direction)] call BIS_fnc_rotateVector2D; // Added to make it fly
		_vehicle setDir _direction;
		_vehicle setVelocity _vel; // Added to make it fly
		_vehicle setVariable [call vChecksum, true, false];
		_aiGroup addVehicle _vehicle;
		[_vehicle] call vehicleSetup;

		// add a driver/pilot/captain to the vehicle
		_soldier = [_aiGroup, _position] call createRandomPilot;
		_soldier moveInDriver _vehicle;
		
		// remove flares because it overpowers AI planes
		if (_type isKindOf "Air") then
		{
			{
				if (["CMFlare", _x] call fn_findString != -1) then
				{
					_vehicle removeMagazinesTurret [_x, [-1]];
				};
			} forEach getArray (configFile >> "CfgVehicles" >> _type >> "magazines");
		};
		
		[_vehicle, _aiGroup] spawn checkMissionVehicleLock;
		_vehicle
	};

	_aiGroup = createGroup CIVILIAN;

	_vehicles =
	[
		[_veh1, _missionPos vectorAdd ([[random 50, 0, 0], random 360] call BIS_fnc_rotateVector2D), 0] call _createVehicle,
		[_veh2, _missionPos vectorAdd ([[random 50, 0, 0], random 360] call BIS_fnc_rotateVector2D), 0] call _createVehicle,
		[_veh3, _missionPos vectorAdd ([[random 50, 0, 0], random 360] call BIS_fnc_rotateVector2D), 0] call _createVehicle
	];

	_leader = effectiveCommander (_vehicles select 0);
	_aiGroup selectLeader _leader;

	_aiGroup setCombatMode "RED"; //"GREEN"; // units will defend themselves
	_aiGroup setBehaviour "COMBAT"; //"SAFE"; // units feel safe until they spot an enemy or get into contact
	_aiGroup setFormation "VEE";

	_speedMode = if (missionDifficultyHard) then { "NORMAL" } else { "LIMITED" };

	_aiGroup setSpeedMode _speedMode;

	// behaviour on waypoints
	{
		_waypoint = _aiGroup addWaypoint [markerPos (_x select 0), 0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointCompletionRadius 50;
		_waypoint setWaypointCombatMode "RED"; //"GREEN";
		_waypoint setWaypointBehaviour "COMBAT"; //"SAFE";
		_waypoint setWaypointFormation "VEE";
		_waypoint setWaypointSpeed _speedMode;
	} forEach ((call cityList) call BIS_fnc_arrayShuffle);

	_missionPos = getPosATL leader _aiGroup;

	_missionPicture = getText (configFile >> "CfgVehicles" >> _veh1 >> "picture");
	_vehicleName = getText (configFile >> "CfgVehicles" >> _veh1 >> "displayName");
	_vehicleName2 = getText (configFile >> "CfgVehicles" >> _veh2 >> "displayName");

	_missionHintText = format ["A formation of armed planes<br/>containing a<br/><t color='%3'>%1</t><br/>and two<br/><t color='%3'>%2</t><br/>are patrolling the island. Destroy them and recover their cargo!", _vehicleName, _vehicleName2, mainMissionColor];

	_numWaypoints = count waypoints _aiGroup;
};

_waitUntilMarkerPos = {getPosATL _leader};
_waitUntilExec = nil;
_waitUntilCondition = {currentWaypoint _aiGroup >= _numWaypoints};

_failedExec = nil;

// _vehicles are automatically deleted or unlocked in missionProcessor depending on the outcome

_successExec =
{
	// Mission completed

	_box1 = createVehicle ["Box_NATO_Wps_F", _lastPos, [], 5, "None"];
	_box1 setDir random 360;
	[_box1, "mission_USSpecial"] call fn_refillbox;

	_box2 = createVehicle ["Box_East_Wps_F", _lastPos, [], 5, "None"];
	_box2 setDir random 360;
	[_box2, "mission_USLaunchers"] call fn_refillbox;

	_box3 = createVehicle ["Box_IND_WpsSpecial_F", _lastPos, [], 5, "None"];
	_box3 setDir random 360;
	[_box3, "mission_Main_A3snipers"] call fn_refillbox;
	
	//spawn MissionReward
		_reward = createVehicle ["Land_File2_F", _lastPos, [], 5, "None"];
		_reward setPos ([_lastPos, [[0.5 + random 3,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_reward setDir random 360;
		_reward setVariable ["mf_item_id", "missionreward", true];
		
	//spawn MissionReward2
		_reward2 = createVehicle ["Land_File2_F", _lastPos, [], 5, "None"];
		_reward2 setPos ([_lastPos, [[0.5 + random 4,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_reward2 setDir random 360;
		_reward2 setVariable ["mf_item_id", "missionreward", true];
	
//spawn MissionReward3
		_reward3 = createVehicle ["Land_File2_F", _lastPos, [], 5, "None"];
		_reward3 setPos ([_lastPos, [[0.5 + random 5,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_reward3 setDir random 360;
		_reward3 setVariable ["mf_item_id", "missionreward", true];
		
	_successHintMessage = "The sky is clear again, the enemy patrol was taken out! Ammo crates have fallen near the wreck.";
};

_this call mainMissionProcessor;
