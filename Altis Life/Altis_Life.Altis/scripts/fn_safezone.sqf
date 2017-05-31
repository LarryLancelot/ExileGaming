/*
    GrenadeStop v0.8 for ArmA 3 Alpha by Bake (tweaked slightly by Rarek & Latouth)
    
    DESCRIPTION:
    Stops players from throwing grenades in safety zones.
    
    CONFIGURATION:
    Edit the #defines below. The numeric value after the variable name of the marker will define how big the radius is. (Measured in metres)
*/

#define SAFETY_ZONES    [["Rebel_North_Marker", 300], ["Rebel_South_Marker", 150], ["Marker-Variable-Name", 250], ["Marker-Variable-Name", 250]]

     if (isDedicated) exitWith {};
     waitUntil {!isNull player};

switch (playerSide) do
{
	case west:
	{};
	
	case civilian:
	{
		player addEventHandler ["Fired", {
            if ({(_this select 0) distance getMarkerPos (_x select 0) < _x select 1} count SAFETY_ZONES > 0) then
            {
             deleteVehicle (_this select 6);
              
             ["Safezone","You are entering a safezone. There is to be no robbing / killing ",nil,""] call life_fnc_showNotification;
            };
        }];
	};
	
	case independent:
	{
		player addEventHandler ["Fired", {
			if ({(_this select 0) distance getMarkerPos (_x select 0) < _x select 1} count SAFETY_ZONES > 0) then
            {
             deleteVehicle (_this select 6);
            };
        }];
	};
};