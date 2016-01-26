// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_assassin.sqf
//	@file Author: AgentRev, [IOCI] Randleman
//	@file Created: 26/01/2016

if (!isServer) exitwith {};
#include "moneyMissionDefines.sqf";

private ["_moneyAmount", "_reward", "_moneyText", "_townName", "_missionPos", "_buildingRadius", "_putOnRoof", "_fillEvenly", "_dropPos"];

_setupVars =
{
	_locArray = ((call cityList) call BIS_fnc_selectRandom);
	_missionPos = markerPos (_locArray select 0);
	_buildingRadius = _locArray select 1;
	_townName = _locArray select 2;
	
	// reduce radius for larger towns. for example to avoid endless hide and seek in kavala ;)
	_buildingRadius = if (_buildingRadius > 201) then {(_buildingRadius*0.5)} else {_buildingRadius};
	_putOnRoof = false;
	_fillEvenly = true;
	
	_missionType = "Assassin";
	_moneyAmount = 12000;
	
	_moneyText = format ["$%1", [_moneyAmount] call fn_numbersText];
	
};

_setupObjects =
{
	
	_aiGroup = createGroup CIVILIAN; //this "group" is the Assassin only
	_Assassin = _aiGroup createUnit ["C_man_polo_1_F", _missionPos, [], 0, "None"];
		removeAllWeapons _Assassin;
		removeAllAssignedItems _Assassin;
		removeUniform _Assassin;
		removeVest _Assassin;
		removeBackpack _Assassin;
		removeHeadgear _Assassin;
		removeGoggles _Assassin;
		_Assassin addUniform "U_Rangemaster";  
		_Assassin addHeadgear "H_Shemag_olive_hs";
		_Assassin addVest "V_PlateCarrier1_blk";
		_Assassin addBackpack "B_FieldPack_blk";
		_Assassin addWeapon "SMG_02_ARCO_pointg_F";
		_Assassin addMagazine "30Rnd_9x21_Mag";
		_Assassin addMagazine "30Rnd_9x21_Mag";
		_Assassin addMagazine "30Rnd_9x21_Mag";
		_Assassin addRating 1e11;
		_Assassin spawn refillPrimaryAmmo;
		_Assassin call setMissionSkill;
		_Assassin addEventHandler ["Killed", server_playerDied];
		
	_Assassin = leader _aiGroup;
	
	_Assassin allowDamage false;																// safe until positioning (sometimes placed in walls and he dies)
	[_aiGroup, _missionPos, _buildingRadius, _fillEvenly, _putOnRoof] call moveIntoBuildings;	// move Ass-assin into a building
	_Assassin allowDamage true;																	// free to kill! :P
	
	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";
	
	_dropPos = getPosATL _Assassin;
		
	_missionHintText = format ["<br/>Find the Assassin in<br/><t size='1.35' color='%1'>%2</t><br/><br/>He holds a<br/><t color='%1'>file wich is worth %3</t><br/>at the exchangedevice.", moneyMissionColor, _townName, _moneyText];
};

_waitUntilMarkerPos = nil; 
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed

};

_successExec =
{
	// Mission completed
	
	//spawn MissionReward
		_reward = createVehicle ["Land_File2_F", _dropPos, [], 5, "None"];
		_reward setPos ([_dropPos, [[0.1 + random 0.5,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_reward setDir random 360;
		_reward setVariable ["mf_item_id", "missionreward", true];
		
	for "_i" from 1 to 12 do
	{
		_cash = createVehicle ["Land_Money_F", _dropPos, [], 5, "None"];
		_cash setPos ([_dropPos, [[0.1 + random 0.5,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_cash setDir random 360;
		_cash setVariable ["cmoney", _moneyAmount / 12, true];
		_cash setVariable ["owner", "world", true];
	};

	_successHintMessage = "You stopped the assassin, well done!";
};

_this call moneyMissionProcessor;
