//@file Version: 1.2
//@file Name: init.sqf
//@file Author: MercyfulFate, [IOCI] Randleman
//@file Description: Initialize Missionreward
//@file Argument: the path to the directory holding this file.
private ["_ground_type", "_icon", "_useaction"];


MF_ITEMS_MISSION_REWARD = "missionreward";
MF_ITEMS_MISSION_REWARD_TYPE = "Land_File2_F";
_ground_type = "Land_File2_F";
_icon = "client\icons\take.paa";

_useaction = 	{	
				["Bring this reward to the Exchange Device to get money for.", "Altis Service"] call BIS_fnc_guiMessage;
				false; //must been for the Use.sqf of inventory
				};


mf_items_mission_reward_nearest = {
    _missionreward = objNull;
    _missionrewards = nearestObjects [player, [MF_ITEMS_MISSION_REWARD_TYPE], 5];
    if (count _missionrewards > 0) then {
        _missionreward = _missionrewards select 0;
    };
    _missionreward;
} call mf_compile;

[MF_ITEMS_MISSION_REWARD, "Missionreward", _useaction, _ground_type, _icon, 99] call mf_inventory_create;
