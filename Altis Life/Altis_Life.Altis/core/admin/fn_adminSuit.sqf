/*
Author: Larry Lancelot
*/
private ["_suit","_action"];
if (FETCH_CONST(life_gigadmin863) < 1) exitWith {closeDialog 0};
switch (FETCH_CONST(life_gigadmin863) do {
    case 1: {_suit = "U_B_Soldier_VR"};
    case 2: {_suit = "U_O_Soldier_VR"};
    case 3: {_suit = "U_I_Soldier_VR"};
    case 4: {_suit = "U_C_Soldier_VR"};
    default: {_suit = "U_C_Soldier_VR"};
};
if (life_adminSuit) then {
    {player removeAction _x} forEach admin_actions;
    player removeUniform;
    player setVariable ["adminSuit",false,true];
    life_adminSuit = false;
    player allowDamage true;
    //Give default loadout per side
        switch (playerSide) do {
            case west: {
                [] call life_fnc_copLoadout;
            };

            case civilian: {
                [] call life_fnc_civLoadout;
            };

            case independent: {
                [] call life_fnc_medicLoadout;
            };
        };
    hint "Admin suit is now gone";
} else {
    _action = [
        "Admin suit",
        "This will remove your current uniform",
        "STR_Global_Yes",
        "STR_Global_No"
    ] call BIS_fnc_guiMessage;
    if (_action) then {
        player removeUniform;
        player addUniform _suit;
        [0,format ["%1 has entered admin mode",profileName]] remoteExecCall ["life_fnc_broadcast",RCLIENT];
        player setVariable ["adminSuit",true,true];
        life_adminSuit = true;
        player allowDamage false;

        if (FETCH_CONST(life_gigadmin863) < 2) then {
        //Actions
        admin_actions = [player addAction["<t color='#FF0000'>Heal/Repair Target</t>",{cursorTarget setDamage 0;}]];
            admin_actions = admin_actions + [player addAction["<t color='#FF0000'>Impound Target</t>",{_vehicle = cursorTarget; [_vehicle,true,player] remoteExec ["TON_fnc_vehicleStore",RSERV];}]];
            admin_actions = admin_actions + [player addAction["<t color='#FF0000'>Get Keys Target</t>",{_vehicle = cursorTarget;life_vehicles pushBack _vehicle;}]];
            admin_actions = admin_actions + [player addAction["<t color='#FF0000'>Get Vehicle Owners</t>",{_vehicle = cursorTarget;[_vehicle] spawn life_fnc_searchVehAction;}]];
            admin_actions = admin_actions + [player addAction["<t color='#FF0000'>Refuel Target</t>",{_vehicle = cursorTarget; _vehicle setFuel 1;}]];
            admin_actions = admin_actions + [player addAction["<t color='#FF0000'>Get Target Name</t>",{hint format["%1", typeOf cursorObject]; diag_log (typeOf cursorObject);copyToClipboard (typeOf cursorObject);}]];
        };
    } else {
        hint "Action aborted";
    };
};