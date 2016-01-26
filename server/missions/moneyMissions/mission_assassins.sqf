// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_assassin.sqf
//	@file Author: AgentRev, [IOCI] Randleman
//	@file Created: 26/01/2016

if (!isServer) exitwith {};
#include "moneyMissionDefines.sqf";

private ["_moneyAmount", "_reward", "_reward2", "_moneyText", "_townName", "_missionPos", "_buildingRadius", "_putOnRoof", "_fillEvenly", "_spawnplace1", "_spawnplace2", "_spawnplace3"];

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
	
	_missionType = "Assassins";
	_moneyAmount = 24000; //value of two mission-rewards
	
	_moneyText = format ["$%1", [_moneyAmount] call fn_numbersText];
	
};

_setupObjects =
{
	_spawnplace1 = _missionPos;
	_spawnplace2 = [(_missionPos select 0) + 10, 0, 0];
	_spawnplace3 = [(_missionPos select 0) - 10, 0, 0];
	
	_aiGroup = createGroup CIVILIAN;
	
	//Assassins:
	_Assassin1 = _aiGroup createUnit ["C_man_polo_1_F", _spawnplace1, [], 0, "None"];
		removeAllWeapons _Assassin1;
		removeAllAssignedItems _Assassin1;
		removeUniform _Assassin1;
		removeVest _Assassin1;
		removeBackpack _Assassin1;
		removeHeadgear _Assassin1;
		removeGoggles _Assassin1;
		_Assassin1 addUniform "U_Rangemaster";  
		_Assassin1 addHeadgear "H_Shemag_olive_hs";
		_Assassin1 addVest "V_PlateCarrier1_blk";
		_Assassin1 addBackpack "B_FieldPack_blk";
		_Assassin1 addWeapon "SMG_02_ARCO_pointg_F";
		_Assassin1 addMagazine "30Rnd_9x21_Mag";
		_Assassin1 addMagazine "30Rnd_9x21_Mag";
		_Assassin1 addMagazine "30Rnd_9x21_Mag";
		_Assassin1 addRating 1e11;
		_Assassin1 spawn refillPrimaryAmmo;
		_Assassin1 call setMissionSkill;
		_Assassin1 addEventHandler ["Killed", server_playerDied];
		
		_Assassin2 = _aiGroup createUnit ["C_man_polo_1_F", _spawnplace2, [], 0, "None"];
		removeAllWeapons _Assassin2;
		removeAllAssignedItems _Assassin2;
		removeUniform _Assassin2;
		removeVest _Assassin2;
		removeBackpack _Assassin2;
		removeHeadgear _Assassin2;
		removeGoggles _Assassin2;
		_Assassin2 addUniform "U_Rangemaster";  
		_Assassin2 addHeadgear "H_Shemag_olive_hs";
		_Assassin2 addVest "V_PlateCarrier1_blk";
		_Assassin2 addBackpack "B_FieldPack_blk";
		_Assassin2 addWeapon "SMG_02_ARCO_pointg_F";
		_Assassin2 addMagazine "30Rnd_9x21_Mag";
		_Assassin2 addMagazine "30Rnd_9x21_Mag";
		_Assassin2 addMagazine "30Rnd_9x21_Mag";
		_Assassin2 addRating 1e11;
		_Assassin2 spawn refillPrimaryAmmo;
		_Assassin2 call setMissionSkill;
		_Assassin2 addEventHandler ["Killed", server_playerDied];
		
		_Assassin3 = _aiGroup createUnit ["C_man_polo_1_F", _spawnplace3, [], 0, "None"];
		removeAllWeapons _Assassin3;
		removeAllAssignedItems _Assassin3;
		removeUniform _Assassin3;
		removeVest _Assassin3;
		removeBackpack _Assassin3;
		removeHeadgear _Assassin3;
		removeGoggles _Assassin3;
		_Assassin3 addUniform "U_Rangemaster";  
		_Assassin3 addHeadgear "H_Shemag_olive_hs";
		_Assassin3 addVest "V_PlateCarrier1_blk";
		_Assassin3 addBackpack "B_FieldPack_blk";
		_Assassin3 addWeapon "SMG_02_ARCO_pointg_F";
		_Assassin3 addMagazine "30Rnd_9x21_Mag";
		_Assassin3 addMagazine "30Rnd_9x21_Mag";
		_Assassin3 addMagazine "30Rnd_9x21_Mag";
		_Assassin3 addRating 1e11;
		_Assassin3 spawn refillPrimaryAmmo;
		_Assassin3 call setMissionSkill;
		_Assassin3 addEventHandler ["Killed", server_playerDied];
		
	_Assassin1 = leader _aiGroup;
	
	// safe until positioning (sometimes placed in walls and they dies)
	_Assassin1 allowDamage false;	
	_Assassin2 allowDamage false;	
	_Assassin3 allowDamage false;	
	
	// move Ass-assins into a building
	[_aiGroup, _missionPos, _buildingRadius, _fillEvenly, _putOnRoof] call moveIntoBuildings;	
	
	// free to kill! :P
	_Assassin1 allowDamage true;																	
	_Assassin2 allowDamage true;
	_Assassin3 allowDamage true;
	
	_aiGroup setCombatMode "RED";
	_aiGroup setBehaviour "COMBAT";
	
	_missionHintText = format ["<br/>Stop the Assassins in<br/><t size='1.35' color='%1'>%2</t><br/><br/>one of 'em holds 2<br/><t color='%1'>files wich are worth %3</t><br/>at the exchangedevice.", moneyMissionColor, _townName, _moneyText];
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
		_reward = createVehicle ["Land_File2_F", _lastPos, [], 5, "None"];
		_reward setPos ([_lastPos, [[0.5 + random 1,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_reward setDir random 360;
		_reward setVariable ["mf_item_id", "missionreward", true];
		
		_reward2 = createVehicle ["Land_File2_F", _lastPos, [], 5, "None"];
		_reward2 setPos ([_lastPos, [[0.5 + random 1,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_reward2 setDir random 360;
		_reward2 setVariable ["mf_item_id", "missionreward", true];
	
	_successHintMessage = "You stopped the assassins, well done!";
};

_this call moneyMissionProcessor;
