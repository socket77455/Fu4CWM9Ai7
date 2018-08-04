#include <a_samp>
#include <a_sampdb>
#include <mysql>
#include <a_http>
#include <required/crashdetect>
#include <required/streamer>
#include <progress>
#include <required/zcmd>
#include <required/sscanf2>
#include <required/explode>
#include <required/fuckCleo>
#include <required/SII>
#include <required/formatex>
#include <required/uf>
#include <required/fixes>
#include <required/acuf>
#include <required/OPA>
#include <required/dldialog>
#include <required/anti_flood>

#include <cnr/cnr_defines>
#include <cnr/cnr_mysqlFunctions>
#include <required/cnr_mysqlresponse>
#include <cnr/cnr_robberyCheckpoints>
#include <cnr/cnr_anticheat>
#include <cnr/cnr_dynamiccps>
#include <cnr/cnr_textdraws>
#include <cnr/cnr_zones>
#include <cnr/cnr_functions>
#include <cnr/cnr_houses>
#include <cnr/cnr_admincommands>
#include <cnr/cnr_policecommands>
#include <cnr/cnr_commands>
#include <cnr/cnr_jail>
#include <cnr/cnr_businesses>
#include <cnr/cnr_animations>
#include <cnr/cnr_courier>
#include <cnr/cnr_courier>
#include <cnr/cnr_gangs>
#include <cnr/cnr_trucking>
#include <cnr/cnr_newMissions>
#include <cnr/cnr_toys>
#include <cnr/cnr_vehicles>
#include <cnr/cnr_dealership>
#include <cnr/vehicle_system>
#include <cnr/cnr_dialogresponse>
#include <cnr/cnr_explosives>
#include <cnr/cnr_moneybag>
#include <cnr/cnr_roadblocks>
#include <cnr/cnr_gates>
#include <cnr/cnr_factionzones>
#include <cnr/cnr_dmevent>
#include <cnr/cnr_medic>
#include <cnr/cnr_glassevent>
#include <cnr/cnr_profiles>
#include <cnr/cnr_vehicleAC>
// Nearest Player System
#include <getnearest>
// END

// Fuel System
forward timer_fuel_lower(); //timer for lowering the fuel value
forward timer_refuel(playerid); //timer to refuel vehicle
new isrefuelling[MAX_PLAYERS] = 0; //bool to check if player is already refuelling
// END

// Death Stadium Spawn Points
new Float:InDMSpawns[][] =
{
	{-1487.2596,1567.2737,1052.5313,307.8384},
	{-1493.8258,1635.5458,1052.5313,273.2461},
	{-1389.1960,1649.8745,1052.5313,185.8044},
	{-1357.2374,1593.2729,1052.5313,84.2860}
};
// END

// Speedo Metter
new Text:RKCNRInfo[MAX_PLAYERS];
new Text:RKCNRInfo1[MAX_PLAYERS];
// END

// Use Me Textdraw
new Text:Textdrawuseme0[MAX_PLAYERS];
// END

// Deat Stadium Head Shot Kill Textdraw
new Text:Textdrawdmhskill0;
new Text:Textdrawdmhskilled0;
// END

forward ServerRobbery();

// Welcome TextDraw Like GTCNR
new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new Text:Textdraw3;
new Text:Textdraw4;
new Text:Textdraw5;
new Text:Textdraw6;
new Text:Textdraw7;
new Text:Textdraw8;
new Text:Textdraw9;
new Text:Textdraw10;
new Text:Textdraw11;
new Text:Textdraw12;
new Text:Textdraw13;
new Text:Textdraw14;
new Text:Textdraw15;
new Text:Textdraw16;
new Text:Textdraw17;
// END Of Welcome TextDraw


// Join Panel Textdraws
new Text:Message;
new MessageStr[170];
new MessageStrl2[170];
new MessageStrl3[170];
new MessageStrl4[170];
new MessageStrl5[170];
new MessageStrl6[170];
// END

// TextDraw Max Players
new Textdraw[MAX_PLAYERS];
// End Of TextDraw Mas Players

// Nearest Player Textdraws
new updatestring[250];
// END


// Speedo Metter
new Float:GetVehicleCurrentHealth[MAX_VEHICLES];

new CarName[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
    "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
    "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
    "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
    "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
    "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
    "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
    "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
    "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
    "Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
    "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
    "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
    "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
    "Blista Compact", "Police Maverick", "Boxvillde", "Benson", "Mesa", "RC Goblin",
    "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
    "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
    "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
    "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
    "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
    "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
    "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
    "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
    "Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratium",
    "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
    "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
    "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car",
    "Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
    "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
    "Tiller", "Utility Trailer"
};
// END

// Text Draw Hidding Timer
forward EndAntiSpawnKill(playerid);
// END

// Textdraw Hiding
forward HideDraw(playerid);
// END

main()
{
	print("\n-----------------------------------");
	print("BGCNR (v2.17) PinEvil Loaded");
	print("------------------------------------\n");
}

// Fuel System
public timer_fuel_lower()
{
	for(new i=0;i<MAX_PLAYERS;i++)
	{
 	if(isrefuelling[i]) continue;
 	
 	switch(GetVehicleModel(GetPlayerVehicleID(i)))
	{
        case 593, 592, 577, 563, 553, 548, 520, 519, 513, 512, 511, 497, 488, 487, 476, 469, 460, 447, 425, 417:
        {
			return 1;
		}
	}
 	
  	new vid = GetPlayerVehicleID(i);
   	if(GetPlayerVehicleSeat(i) == 0)
   	{
	fuel[vid] = fuel[vid] -1;
	if (fuel[vid]<1)
	{
		fuel[vid] = 0; //setting fuel to 0 (else the timer will set it to -1 -2 -3 etc before removing player)
  		RemovePlayerFromVehicle(i); //remove player out of vehicle
    	GameTextForPlayer(i,"~r~OUT OF FUEL",5000,4); //show text
		}
	}
	}
	return 1;
}

public timer_refuel(playerid)
{
	new vid = GetPlayerVehicleID(playerid);
	fuel[vid] = fuel[vid] = 100; //restoring fuel to 100
	isrefuelling[playerid] = 0;//resetting anti-spam thingy
	TogglePlayerControllable(playerid,1); //unfreeze player
	SendClientMessage(playerid,0x20B2AAAA,"Your Vehicle Has Been Refuelled in $100");
}
// END

// Textdraw Hiding
public HideDraw(playerid)
{
	// Fuel Station Textdraws
	TextDrawHideForPlayer(playerid, Textdrawfuelstation0);
	TextDrawHideForPlayer(playerid, Textdrawfuelstation1);
	TextDrawHideForPlayer(playerid, Textdrawfuelstation2);
	TextDrawHideForPlayer(playerid, Textdrawfuelstation3);
	TextDrawHideForPlayer(playerid, Textdrawfuelstation4);
	TextDrawHideForPlayer(playerid, Textdrawfuelstation5);
	// END

	// VCMDS Textdraws
    TextDrawHideForPlayer(playerid, Textdrawvcmds0);
    TextDrawHideForPlayer(playerid, Textdrawvcmds1);
    TextDrawHideForPlayer(playerid, Textdrawvcmds2);
    TextDrawHideForPlayer(playerid, Textdrawvcmds3);
    // END
	return 1;
}
// END

public EndAntiSpawnKill(playerid)
{
    // Lotto Textdraws
	TextDrawHideForAll(Textdrawlottowin0);
    TextDrawHideForAll(Textdrawlottowin1);
    TextDrawHideForAll(Textdrawlotto0);
    TextDrawHideForAll(Textdrawlotto1);
    TextDrawHideForAll(Textdrawlotto2);
	// END

    // Registered Player Textdraws
	TextDrawHideForPlayer(playerid,Textdrawn0);
	TextDrawHideForPlayer(playerid,Textdrawn1);
	TextDrawHideForPlayer(playerid,Textdrawn2);
	TextDrawHideForPlayer(playerid,Textdrawn3);
	TextDrawHideForPlayer(playerid,Textdrawn4);
	TextDrawHideForPlayer(playerid,Textdrawn5);
	// END

    // Death Stadium Headshot Textdraw
	TextDrawHideForPlayer(playerid,Textdrawdmhskill0);
	TextDrawHideForPlayer(playerid,Textdrawdmhskilled0);
	// END

    // Welcome Back Textdraws
    TextDrawHideForPlayer(playerid,Textdrawcb[playerid]);
    // END
    return 1;
}

public ServerRobbery()
{
    for(new i=0; i<MAX_PLAYERS; i++)
	{
	    // Masroor Club Robbery
	    if(ROBBING_MCLUB[i] > 1) // Checking if robbery time is above 1
  		{
    		ROBBING_MCLUB[i] --; // Decreasing time
       		// Showing Textdraw
	  		new timer[128];
	    	format(timer, sizeof(timer), "~r~ROBBERY ~w~IN ~g~PROGRESS ~y~WAIT ~g~%d ~p~SECONDS~n~~w~TO ~g~COMPLETE ~r~ROBBERY", ROBBING_MCLUB[i]);
		    TextDrawSetString(Textdrawuseme0[i], timer);
		    TextDrawShowForPlayer(i, Textdrawuseme0[i]);
		}
		if(ROBBING_MCLUB[i] == 1) // IF the timer reached 1
		{
      		DestroyDynamicObject(playerData[i][playerSafeObj]);
      		ClearAnimations(i);
			RemovePlayerAttachedObject(i, 0);
		    TextDrawHideForPlayer(i,Textdrawuseme0[i]);
		    TogglePlayerControllable(i,true);
			new string[500], pName[MAX_PLAYER_NAME];// Getting player name
			GetPlayerName(i,pName,MAX_PLAYER_NAME);
			ROBBING_MCLUB[i] =0; // Reseting timer
			new mrand =random(35000);
			format(string,sizeof(string),"You Have Successfully Robbed $%s From Masroor's Club.",FormatNumber(mrand));
			SendClientMessage(i,0x20B2AAAA,string);
			format(string,sizeof(string),"{26FF4E}%s (%d) {FFFFFF}Has Sucessfully Robbed From {F81414}Masroor's Club {FFFFFF}And Received {00FF22}$%s",pName,i,FormatNumber(mrand));
			SendClientMessageToAll(-1,string);
			playerGiveMoney(i, mrand);
			SetPlayerWantedLevel(i, GetPlayerWantedLevel(i) + 5);
			return 1;
		}
	    // END
	
  		if(ROBBING_AMMU[i] > 1) // Checking if robbery time is above 1
  		{
    		ROBBING_AMMU[i] --; // Decreasing time
       		// Showing Textdraw
	  		new timer[128];
	    	format(timer, sizeof(timer), "~w~PLEASE ~y~WAIT ~p~UNTIL~n~~r~ROBBERY ~g~COMPLETE: ~r~%d", ROBBING_AMMU[i]);
		    TextDrawSetString(Textdrawuseme0[i], timer);
		    TextDrawShowForPlayer(i, Textdrawuseme0[i]);
		}
		if(ROBBING_AMMU[i] == 1) // IF the timer reached 1
		{
		    TextDrawHideForPlayer(i,Textdrawuseme0[i]);
		    TogglePlayerControllable(i,true);
			new string[500], pName[MAX_PLAYER_NAME];// Getting player name
			GetPlayerName(i,pName,MAX_PLAYER_NAME);
			ROBBING_AMMU[i] =0; // Reseting timer
			new mrand =random(10000);
			format(string,sizeof(string),"You Have Successfully Robbed $%s From The ATM.",FormatNumber(mrand));
			SendClientMessage(i,0x20B2AAAA,string);
			format(string,sizeof(string),"{26FF4E}%s (%d) {FFFFFF}Has Sucessfully Robbed From {F81414}ATM {FFFFFF}And Received {00FF22}$%s",pName,i,FormatNumber(mrand));
			SendClientMessageToAll(-1,string);
			playerGiveMoney(i, mrand);
			SetPlayerWantedLevel(i, GetPlayerWantedLevel(i) + 5);
			return 1;
		}
		// 2
		if(ROBBING_AMMU2[i] > 1) // Checking if robbery time is above 1
		{
    		ROBBING_AMMU2[i] --; // Decreasing time
       		// Showing Textdraw
	  		new timer[128];
	    	format(timer, sizeof(timer), "~w~PLEASE ~y~WAIT ~p~UNTIL~n~~r~ROBBERY ~g~COMPLETE: ~r~%d", ROBBING_AMMU2[i]);
		    TextDrawSetString(Textdrawuseme0[i], timer);
		    TextDrawShowForPlayer(i, Textdrawuseme0[i]);
		}
		if(ROBBING_AMMU2[i] == 1) // IF the timer reached 1
		{
		    TextDrawHideForPlayer(i,Textdrawuseme0[i]);
		    TogglePlayerControllable(i,true);
			new string[500], pName[MAX_PLAYER_NAME];// Getting player name
			GetPlayerName(i,pName,MAX_PLAYER_NAME);
			ROBBING_AMMU2[i] =0; // Reseting timer
			new mrand =random(10000);
			format(string,sizeof(string),"You Have Successfully Robbed $%s From The ATM.",FormatNumber(mrand));
			SendClientMessage(i,0x20B2AAAA,string);
			format(string,sizeof(string),"{26FF4E}%s (%d) {FFFFFF}Has Sucessfully Robbed From {F81414}ATM {FFFFFF}And Received {00FF22}$%s",pName,i,FormatNumber(mrand));
			SendClientMessageToAll(-1,string);
			playerGiveMoney(i, mrand);
			SetPlayerWantedLevel(i, GetPlayerWantedLevel(i) + 5);
			return 1;
		}
		// 3
		if(ROBBING_AMMU3[i] > 1) // Checking if robbery time is above 1
		{
    		ROBBING_AMMU3[i] --; // Decreasing time
       		// Showing Textdraw
	  		new timer[128];
	    	format(timer, sizeof(timer), "~w~PLEASE ~y~WAIT ~p~UNTIL~n~~r~ROBBERY ~g~COMPLETE: ~r~%d", ROBBING_AMMU3[i]);
		    TextDrawSetString(Textdrawuseme0[i], timer);
		    TextDrawShowForPlayer(i, Textdrawuseme0[i]);
		}
		if(ROBBING_AMMU3[i] == 1) // IF the timer reached 1
		{
		    TextDrawHideForPlayer(i,Textdrawuseme0[i]);
		    TogglePlayerControllable(i,true);
			new string[500], pName[MAX_PLAYER_NAME];// Getting player name
			GetPlayerName(i,pName,MAX_PLAYER_NAME);
			ROBBING_AMMU3[i] =0; // Reseting timer
			new mrand =random(10000);
			format(string,sizeof(string),"You Have Successfully Robbed $%s From The ATM.",FormatNumber(mrand));
			SendClientMessage(i,0x20B2AAAA,string);
			format(string,sizeof(string),"{26FF4E}%s (%d) {FFFFFF}Has Sucessfully Robbed From {F81414}ATM {FFFFFF}And Received {00FF22}$%s",pName,i,FormatNumber(mrand));
			SendClientMessageToAll(-1,string);
			playerGiveMoney(i, mrand);
			SetPlayerWantedLevel(i, GetPlayerWantedLevel(i) + 5);
			return 1;
		}
		// 4
		if(ROBBING_AMMU4[i] > 1) // Checking if robbery time is above 1
		{
    		ROBBING_AMMU4[i] --; // Decreasing time
       		// Showing Textdraw
	  		new timer[128];
	    	format(timer, sizeof(timer), "~w~PLEASE ~y~WAIT ~p~UNTIL~n~~r~ROBBERY ~g~COMPLETE: ~r~%d", ROBBING_AMMU4[i]);
		    TextDrawSetString(Textdrawuseme0[i], timer);
		    TextDrawShowForPlayer(i, Textdrawuseme0[i]);
		}
		if(ROBBING_AMMU4[i] == 1) // IF the timer reached 1
		{
		    TextDrawHideForPlayer(i,Textdrawuseme0[i]);
		    TogglePlayerControllable(i,true);
			new string[500], pName[MAX_PLAYER_NAME];// Getting player name
			GetPlayerName(i,pName,MAX_PLAYER_NAME);
			ROBBING_AMMU4[i] =0; // Reseting timer
			new mrand =random(10000);
			format(string,sizeof(string),"You Have Successfully Robbed $%s From The ATM.",FormatNumber(mrand));
			SendClientMessage(i,0x20B2AAAA,string);
			format(string,sizeof(string),"{26FF4E}%s (%d) {FFFFFF}Has Sucessfully Robbed From {F81414}ATM {FFFFFF}And Received {00FF22}$%s",pName,i,FormatNumber(mrand));
			SendClientMessageToAll(-1,string);
			playerGiveMoney(i, mrand);
			SetPlayerWantedLevel(i, GetPlayerWantedLevel(i) + 5);
			return 1;
		}
		// 5
		if(ROBBING_AMMU5[i] > 1) // Checking if robbery time is above 1
		{
			ROBBING_AMMU5[i] --; // Decreasing time
       		// Showing Textdraw
	  		new timer[128];
	    	format(timer, sizeof(timer), "~w~PLEASE ~y~WAIT ~p~UNTIL~n~~r~ROBBERY ~g~COMPLETE: ~r~%d", ROBBING_AMMU5[i]);
		    TextDrawSetString(Textdrawuseme0[i], timer);
		    TextDrawShowForPlayer(i, Textdrawuseme0[i]);
		}
		if(ROBBING_AMMU5[i] == 1) // IF the timer reached 1
		{
		    TextDrawHideForPlayer(i,Textdrawuseme0[i]);
		    TogglePlayerControllable(i,true);
			new string[500], pName[MAX_PLAYER_NAME];// Getting player name
			GetPlayerName(i,pName,MAX_PLAYER_NAME);
			ROBBING_AMMU5[i] =0; // Reseting timer
			new mrand =random(10000);
			format(string,sizeof(string),"You Have Successfully Robbed $%s From The ATM.",FormatNumber(mrand));
			SendClientMessage(i,0x20B2AAAA,string);
			format(string,sizeof(string),"{26FF4E}%s (%d) {FFFFFF}Has Sucessfully Robbed From {F81414}ATM {FFFFFF}And Received {00FF22}$%s",pName,i,FormatNumber(mrand));
			SendClientMessageToAll(-1,string);
			playerGiveMoney(i, mrand);
			SetPlayerWantedLevel(i, GetPlayerWantedLevel(i) + 5);
			return 1;
		}
		// 6
		if(ROBBING_AMMU6[i] > 1) // Checking if robbery time is above 1
		{
    		ROBBING_AMMU6[i] --; // Decreasing time
       		// Showing Textdraw
	  		new timer[128];
	    	format(timer, sizeof(timer), "~w~PLEASE ~y~WAIT ~p~UNTIL~n~~r~ROBBERY ~g~COMPLETE: ~r~%d", ROBBING_AMMU6[i]);
		    TextDrawSetString(Textdrawuseme0[i], timer);
		    TextDrawShowForPlayer(i, Textdrawuseme0[i]);
		}
		if(ROBBING_AMMU6[i] == 1) // IF the timer reached 1
		{
		    TextDrawHideForPlayer(i,Textdrawuseme0[i]);
		    TogglePlayerControllable(i,true);
			new string[500], pName[MAX_PLAYER_NAME];// Getting player name
			GetPlayerName(i,pName,MAX_PLAYER_NAME);
			ROBBING_AMMU6[i] =0; // Reseting timer
			new mrand =random(10000);
			format(string,sizeof(string),"You Have Successfully Robbed $%s From The ATM.",FormatNumber(mrand));
			SendClientMessage(i,0x20B2AAAA,string);
			format(string,sizeof(string),"{26FF4E}%s (%d) {FFFFFF}Has Sucessfully Robbed From {F81414}ATM {FFFFFF}And Received {00FF22}$%s",pName,i,FormatNumber(mrand));
			SendClientMessageToAll(-1,string);
			playerGiveMoney(i, mrand);
			SetPlayerWantedLevel(i, GetPlayerWantedLevel(i) + 5);
			return 1;
		}
		// 7
		if(ROBBING_AMMU7[i] > 1) // Checking if robbery time is above 1
		{
    		ROBBING_AMMU7[i] --; // Decreasing time
       		// Showing Textdraw
	  		new timer[128];
	    	format(timer, sizeof(timer), "~w~PLEASE ~y~WAIT ~p~UNTIL~n~~r~ROBBERY ~g~COMPLETE: ~r~%d", ROBBING_AMMU7[i]);
		    TextDrawSetString(Textdrawuseme0[i], timer);
		    TextDrawShowForPlayer(i, Textdrawuseme0[i]);
		}
		if(ROBBING_AMMU7[i] == 1) // IF the timer reached 1
		{
		    TextDrawHideForPlayer(i,Textdrawuseme0[i]);
		    TogglePlayerControllable(i,true);
			new string[500], pName[MAX_PLAYER_NAME];// Getting player name
			GetPlayerName(i,pName,MAX_PLAYER_NAME);
			ROBBING_AMMU7[i] =0; // Reseting timer
			new mrand =random(10000);
			format(string,sizeof(string),"You Have Successfully Robbed $%s From The ATM.",FormatNumber(mrand));
			SendClientMessage(i,0x20B2AAAA,string);
			format(string,sizeof(string),"{26FF4E}%s (%d) {FFFFFF}Has Sucessfully Robbed From {F81414}ATM {FFFFFF}And Received {00FF22}$%s",pName,i,FormatNumber(mrand));
			SendClientMessageToAll(-1,string);
			playerGiveMoney(i, mrand);
			SetPlayerWantedLevel(i, GetPlayerWantedLevel(i) + 5);
			return 1;
		}
		// 8
		if(ROBBING_AMMU8[i] > 1) // Checking if robbery time is above 1
		{
    		ROBBING_AMMU8[i] --; // Decreasing time
       		// Showing Textdraw
	  		new timer[128];
	    	format(timer, sizeof(timer), "~w~PLEASE ~y~WAIT ~p~UNTIL~n~~r~ROBBERY ~g~COMPLETE: ~r~%d", ROBBING_AMMU8[i]);
		    TextDrawSetString(Textdrawuseme0[i], timer);
		    TextDrawShowForPlayer(i, Textdrawuseme0[i]);
		}
		if(ROBBING_AMMU8[i] == 1) // IF the timer reached 1
		{
		    TextDrawHideForPlayer(i,Textdrawuseme0[i]);
		    TogglePlayerControllable(i,true);
			new string[500], pName[MAX_PLAYER_NAME];// Getting player name
			GetPlayerName(i,pName,MAX_PLAYER_NAME);
			ROBBING_AMMU8[i] =0; // Reseting timer
			new mrand =random(10000);
			format(string,sizeof(string),"You Have Successfully Robbed $%s From The ATM.",FormatNumber(mrand));
			SendClientMessage(i,0x20B2AAAA,string);
			format(string,sizeof(string),"{26FF4E}%s (%d) {FFFFFF}Has Sucessfully Robbed From {F81414}ATM {FFFFFF}And Received {00FF22}$%s",pName,i,FormatNumber(mrand));
			SendClientMessageToAll(-1,string);
			playerGiveMoney(i, mrand);
			SetPlayerWantedLevel(i, GetPlayerWantedLevel(i) + 5);
			return 1;
			}
	}
	return 1;
}

public OnGameModeInit()
{
	// Fuel System
	for(new i=0;i<MAX_VEHICLES;i++)
	{
	    fuel[i] = 100; //sets every car's fuel to 100 in a loop
	}
	SetTimer("timer_fuel_lower",15000,true); //sets the timer to drop the fuel
	// END

	SetTimer("ServerRobbery",1000,1); // Robbery Timer Ticks Every 1 Second
	
    profileStuff();
	connection = mysql_init(LOG_ONLY_ERRORS, 1);
	
 	mysql_connect("127.0.0.1", "port_7774", "dvlopsrszers12", "port_7774", connection, 1);

	// Databases
	//VEHICLEDB = db_open("dbs/Vehicles.db");
	BUSINESSDB = db_open("dbs/Businesses.db");
	HOUSEDB = db_open("dbs/Houses.db");
	GATESDB = db_open("dbs/Gates.db");
	VEHICLESDB = db_open("dbs/newvehicles.db");

	SetGameModeText("Cops and Robbers");
	SendRconCommand("mapname San Fierro");
	
	// Lotto Textdraws
	Textdrawlotto0 = TextDrawCreate(232.000000, 139.125000, "~p~LOTTERY DRAW");
	TextDrawLetterSize(Textdrawlotto0, 0.469500, 1.656874);
	TextDrawAlignment(Textdrawlotto0, 1);
	TextDrawColor(Textdrawlotto0, -2147450625);
	TextDrawSetShadow(Textdrawlotto0, 0);
	TextDrawSetOutline(Textdrawlotto0, 1);
	TextDrawBackgroundColor(Textdrawlotto0, 255);
	TextDrawFont(Textdrawlotto0, 2);
	TextDrawSetProportional(Textdrawlotto0, 1);

	Textdrawlotto1 = TextDrawCreate(221.500000, 159.687500, "BUY YOUR TICKET");
	TextDrawLetterSize(Textdrawlotto1, 0.477999, 1.661249);
	TextDrawAlignment(Textdrawlotto1, 1);
	TextDrawColor(Textdrawlotto1, -1);
	TextDrawSetShadow(Textdrawlotto1, 0);
	TextDrawSetOutline(Textdrawlotto1, 1);
	TextDrawBackgroundColor(Textdrawlotto1, 255);
	TextDrawFont(Textdrawlotto1, 2);
	TextDrawSetProportional(Textdrawlotto1, 1);

	Textdrawlotto2 = TextDrawCreate(130.500000, 178.937500, "~y~TYPE ~g~/LOTTO (1-50) ~y~TO BUY A TICKET");
	TextDrawLetterSize(Textdrawlotto2, 0.467499, 1.661249);
	TextDrawAlignment(Textdrawlotto2, 1);
	TextDrawColor(Textdrawlotto2, -1);
	TextDrawSetShadow(Textdrawlotto2, 0);
	TextDrawSetOutline(Textdrawlotto2, 1);
	TextDrawBackgroundColor(Textdrawlotto2, 255);
	TextDrawFont(Textdrawlotto2, 2);
	TextDrawSetProportional(Textdrawlotto2, 1);

    Textdrawlottowin0 = TextDrawCreate(118.500000, 157.937500, "YOU HAVE WON THE TODAY'S LOTTO");
	TextDrawLetterSize(Textdrawlottowin0, 0.502499, 1.547500);
	TextDrawAlignment(Textdrawlottowin0, 1);
	TextDrawColor(Textdrawlottowin0, -1);
	TextDrawSetShadow(Textdrawlottowin0, 0);
	TextDrawSetOutline(Textdrawlottowin0, 1);
	TextDrawBackgroundColor(Textdrawlottowin0, 255);
	TextDrawFont(Textdrawlottowin0, 2);
	TextDrawSetProportional(Textdrawlottowin0, 1);

	Textdrawlottowin1 = TextDrawCreate(265.500000, 177.187500, "");
	TextDrawLetterSize(Textdrawlottowin1, 0.449999, 1.600000);
	TextDrawAlignment(Textdrawlottowin1, 1);
	TextDrawColor(Textdrawlottowin1, -1);
	TextDrawSetShadow(Textdrawlottowin1, 0);
	TextDrawSetOutline(Textdrawlottowin1, 1);
	TextDrawBackgroundColor(Textdrawlottowin1, 255);
	TextDrawFont(Textdrawlottowin1, 2);
	TextDrawSetProportional(Textdrawlottowin1, 1);
	// END
	
	// Registered Player Textdraws
	Textdrawn0 = TextDrawCreate(158.000000, 137.812500, "WELCOME TO BALOCH GAMING");
	TextDrawLetterSize(Textdrawn0, 0.492999, 1.621874);
	TextDrawAlignment(Textdrawn0, 1);
	TextDrawColor(Textdrawn0, -1);
	TextDrawSetShadow(Textdrawn0, 0);
	TextDrawSetOutline(Textdrawn0, 1);
	TextDrawBackgroundColor(Textdrawn0, 255);
	TextDrawFont(Textdrawn0, 2);
	TextDrawSetProportional(Textdrawn0, 1);

	Textdrawn1 = TextDrawCreate(205.000000, 154.875000, "~b~COPS ~w~AND ~r~ROBBERS");
	TextDrawLetterSize(Textdrawn1, 0.460999, 1.634999);
	TextDrawAlignment(Textdrawn1, 1);
	TextDrawColor(Textdrawn1, -1);
	TextDrawSetShadow(Textdrawn1, 0);
	TextDrawSetOutline(Textdrawn1, 1);
	TextDrawBackgroundColor(Textdrawn1, 255);
	TextDrawFont(Textdrawn1, 2);
	TextDrawSetProportional(Textdrawn1, 1);

	Textdrawn2 = TextDrawCreate(185.500000, 173.250000, "CHECK ~y~/CMDS , ~g~/HELP ,");
	TextDrawLetterSize(Textdrawn2, 0.466499, 1.626249);
	TextDrawAlignment(Textdrawn2, 1);
	TextDrawColor(Textdrawn2, -1);
	TextDrawSetShadow(Textdrawn2, 0);
	TextDrawSetOutline(Textdrawn2, 1);
	TextDrawBackgroundColor(Textdrawn2, 255);
	TextDrawFont(Textdrawn2, 2);
	TextDrawSetProportional(Textdrawn2, 1);

	Textdrawn3 = TextDrawCreate(242.500000, 192.500000, "/ASK AND");
	TextDrawLetterSize(Textdrawn3, 0.449999, 1.600000);
	TextDrawAlignment(Textdrawn3, 1);
	TextDrawColor(Textdrawn3, -5963521);
	TextDrawSetShadow(Textdrawn3, 0);
	TextDrawSetOutline(Textdrawn3, 1);
	TextDrawBackgroundColor(Textdrawn3, 255);
	TextDrawFont(Textdrawn3, 2);
	TextDrawSetProportional(Textdrawn3, 1);

	Textdrawn4 = TextDrawCreate(117.500000, 211.750000, "AND ~p~/GPS ~w~FOR LOCATIONS");
	TextDrawLetterSize(Textdrawn4, 0.449999, 1.600000);
	TextDrawAlignment(Textdrawn4, 1);
	TextDrawColor(Textdrawn4, -1);
	TextDrawSetShadow(Textdrawn4, 0);
	TextDrawSetOutline(Textdrawn4, 1);
	TextDrawBackgroundColor(Textdrawn4, 255);
	TextDrawFont(Textdrawn4, 2);
	TextDrawSetProportional(Textdrawn4, 1);

	Textdrawn5 = TextDrawCreate(160.500000, 231.875000, "AND FOR MORE INFORMATION.");
	TextDrawLetterSize(Textdrawn5, 0.449999, 1.600000);
	TextDrawAlignment(Textdrawn5, 1);
	TextDrawColor(Textdrawn5, -1);
	TextDrawSetShadow(Textdrawn5, 0);
	TextDrawSetOutline(Textdrawn5, 1);
	TextDrawBackgroundColor(Textdrawn5, 255);
	TextDrawFont(Textdrawn5, 2);
	TextDrawSetProportional(Textdrawn5, 1);
	// END
	
	// Death Stadium Head Shot Kill Textdraw
	Textdrawdmhskill0 = TextDrawCreate(312.500000, 185.937500, "");
	TextDrawLetterSize(Textdrawdmhskill0, 0.498499, 1.630625);
	TextDrawAlignment(Textdrawdmhskill0, 2);
	TextDrawColor(Textdrawdmhskill0, -1);
	TextDrawSetShadow(Textdrawdmhskill0, 0);
	TextDrawSetOutline(Textdrawdmhskill0, 1);
	TextDrawBackgroundColor(Textdrawdmhskill0, 255);
	TextDrawFont(Textdrawdmhskill0, 2);
	TextDrawSetProportional(Textdrawdmhskill0, 1);

	Textdrawdmhskilled0 = TextDrawCreate(328.000000, 205.187500, "");
	TextDrawLetterSize(Textdrawdmhskilled0, 0.498500, 1.630625);
	TextDrawAlignment(Textdrawdmhskilled0, 2);
	TextDrawColor(Textdrawdmhskilled0, -1);
	TextDrawSetShadow(Textdrawdmhskilled0, 0);
	TextDrawSetOutline(Textdrawdmhskilled0, 1);
	TextDrawBackgroundColor(Textdrawdmhskilled0, 255);
	TextDrawFont(Textdrawdmhskilled0, 2);
	TextDrawSetProportional(Textdrawdmhskilled0, 1);
	// END
	
	// Join Panel Textdraws
	Message = TextDrawCreate(504.375000, 222.250122,"");
	TextDrawBackgroundColor(Message, 255);
	TextDrawFont(Message, 1);
	TextDrawLetterSize(Message, 0.200000, 0.799999);
	TextDrawColor(Message, -1);
	TextDrawSetOutline(Message, 1);
	TextDrawSetProportional(Message, 1);
	// END
	
	// Welcome TextDraw Same Like GTCNR
	Textdraw0 = TextDrawCreate(641.199951, 300.913330, "usebox");
	TextDrawLetterSize(Textdraw0, 0.000000, 16.110000);
	TextDrawTextSize(Textdraw0, -2.000000, 0.000000);
	TextDrawAlignment(Textdraw0, 1);
	TextDrawColor(Textdraw0, 0);
	TextDrawUseBox(Textdraw0, true);
	TextDrawBoxColor(Textdraw0, 255);
	TextDrawSetShadow(Textdraw0, 0);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawFont(Textdraw0, 0);

	Textdraw1 = TextDrawCreate(641.199951, 1.500000, "usebox");
	TextDrawLetterSize(Textdraw1, 0.000000, 14.865551);
	TextDrawTextSize(Textdraw1, -2.000000, 0.000000);
	TextDrawAlignment(Textdraw1, 1);
	TextDrawColor(Textdraw1, 0);
	TextDrawUseBox(Textdraw1, true);
	TextDrawBoxColor(Textdraw1, 255);
	TextDrawSetShadow(Textdraw1, 0);
	TextDrawSetOutline(Textdraw1, 0);
	TextDrawBackgroundColor(Textdraw1, 255);
	TextDrawFont(Textdraw1, 0);

	Textdraw2 = TextDrawCreate(641.199951, 297.180023, "usebox");
	TextDrawLetterSize(Textdraw2, 0.000000, -0.150738);
	TextDrawTextSize(Textdraw2, -2.000000, 0.000000);
	TextDrawAlignment(Textdraw2, 1);
	TextDrawColor(Textdraw2, 0);
	TextDrawUseBox(Textdraw2, true);
	TextDrawBoxColor(Textdraw2, 65535);
	TextDrawSetShadow(Textdraw2, 0);
	TextDrawSetOutline(Textdraw2, 0);
	TextDrawFont(Textdraw2, 0);

	Textdraw3 = TextDrawCreate(641.199951, 294.940002, "usebox");
	TextDrawLetterSize(Textdraw3, 0.000000, -0.482594);
	TextDrawTextSize(Textdraw3, -2.000000, 0.000000);
	TextDrawAlignment(Textdraw3, 1);
	TextDrawColor(Textdraw3, 0);
	TextDrawUseBox(Textdraw3, true);
	TextDrawBoxColor(Textdraw3, -1);
	TextDrawSetShadow(Textdraw3, 0);
	TextDrawSetOutline(Textdraw3, 0);
	TextDrawFont(Textdraw3, 0);

	Textdraw4 = TextDrawCreate(646.799865, 134.406661, "usebox");
	TextDrawLetterSize(Textdraw4, 0.000000, 0.018146);
	TextDrawTextSize(Textdraw4, -2.000000, 0.000000);
	TextDrawAlignment(Textdraw4, 1);
	TextDrawColor(Textdraw4, 0);
	TextDrawUseBox(Textdraw4, true);
	TextDrawBoxColor(Textdraw4, -16776961);
	TextDrawSetShadow(Textdraw4, 0);
	TextDrawSetOutline(Textdraw4, 0);
	TextDrawFont(Textdraw4, 0);

	Textdraw5 = TextDrawCreate(641.199951, 139.633331, "usebox");
	TextDrawLetterSize(Textdraw5, 0.000000, -0.393702);
	TextDrawTextSize(Textdraw5, -2.000000, 0.000000);
	TextDrawAlignment(Textdraw5, 1);
	TextDrawColor(Textdraw5, 0);
	TextDrawUseBox(Textdraw5, true);
	TextDrawBoxColor(Textdraw5, -65281);
	TextDrawSetShadow(Textdraw5, 0);
	TextDrawSetOutline(Textdraw5, 0);
	TextDrawFont(Textdraw5, 0);

	Textdraw6 = TextDrawCreate(522.000000, 432.326660, "usebox");
	TextDrawLetterSize(Textdraw6, 0.000000, -0.316666);
	TextDrawTextSize(Textdraw6, 115.600006, 0.000000);
	TextDrawAlignment(Textdraw6, 1);
	TextDrawColor(Textdraw6, 0);
	TextDrawUseBox(Textdraw6, true);
	TextDrawBoxColor(Textdraw6, -1);
	TextDrawSetShadow(Textdraw6, 0);
	TextDrawSetOutline(Textdraw6, 0);
	TextDrawFont(Textdraw6, 0);

	Textdraw7 = TextDrawCreate(578.000000, 412.913330, "usebox");
	TextDrawLetterSize(Textdraw7, 0.000000, -0.316666);
	TextDrawTextSize(Textdraw7, 41.200000, 0.000000);
	TextDrawAlignment(Textdraw7, 1);
	TextDrawColor(Textdraw7, 0);
	TextDrawUseBox(Textdraw7, true);
	TextDrawBoxColor(Textdraw7, -16776961);
	TextDrawSetShadow(Textdraw7, 0);
	TextDrawSetOutline(Textdraw7, 0);
	TextDrawFont(Textdraw7, 0);

	Textdraw8 = TextDrawCreate(44.399997, 412.166687, "usebox");
	TextDrawLetterSize(Textdraw8, 0.000000, 3.748512);
	TextDrawTextSize(Textdraw8, 42.799999, 0.000000);
	TextDrawAlignment(Textdraw8, 1);
	TextDrawColor(Textdraw8, 0);
	TextDrawUseBox(Textdraw8, true);
	TextDrawBoxColor(Textdraw8, -16776961);
	TextDrawSetShadow(Textdraw8, 0);
	TextDrawSetOutline(Textdraw8, 0);
	TextDrawFont(Textdraw8, 0);

	Textdraw9 = TextDrawCreate(582.800048, 412.166687, "usebox");
	TextDrawLetterSize(Textdraw9, 0.000000, 3.748512);
	TextDrawTextSize(Textdraw9, 571.599975, 0.000000);
	TextDrawAlignment(Textdraw9, 1);
	TextDrawColor(Textdraw9, 0);
	TextDrawUseBox(Textdraw9, true);
	TextDrawBoxColor(Textdraw9, -16776961);
	TextDrawSetShadow(Textdraw9, 0);
	TextDrawSetOutline(Textdraw9, 0);
	TextDrawFont(Textdraw9, 0);

	Textdraw10 = TextDrawCreate(215.000000, 434.000000, "www.baloch-gaming.ml");
	TextDrawLetterSize(Textdraw10, 0.418499, 1.267501);
	TextDrawAlignment(Textdraw10, 1);
	TextDrawColor(Textdraw10, 16711935);
	TextDrawSetShadow(Textdraw10, 0);
	TextDrawSetOutline(Textdraw10, 1);
	TextDrawBackgroundColor(Textdraw10, 51);
	TextDrawFont(Textdraw10, 2);
	TextDrawSetProportional(Textdraw10, 1);

	TextDrawSetProportional(Textdraw10, 1);
	Textdraw11 = TextDrawCreate(9.199996, 294.193328, "usebox");
	TextDrawLetterSize(Textdraw11, 0.000000, 16.856666);
	TextDrawTextSize(Textdraw11, -2.000000, 0.000000);
	TextDrawAlignment(Textdraw11, 1);
	TextDrawColor(Textdraw11, 0);
	TextDrawUseBox(Textdraw11, true);
	TextDrawBoxColor(Textdraw11, 16711935);
	TextDrawSetShadow(Textdraw11, 0);
	TextDrawSetOutline(Textdraw11, 0);
	TextDrawFont(Textdraw11, 0);

	Textdraw12 = TextDrawCreate(636.399963, 293.446655, "usebox");
	TextDrawLetterSize(Textdraw12, 0.000000, 16.939630);
	TextDrawTextSize(Textdraw12, 634.799987, 0.000000);
	TextDrawAlignment(Textdraw12, 1);
	TextDrawColor(Textdraw12, 0);
	TextDrawUseBox(Textdraw12, true);
	TextDrawBoxColor(Textdraw12, 16711935);
	TextDrawSetShadow(Textdraw12, 0);
	TextDrawSetOutline(Textdraw12, 0);
	TextDrawFont(Textdraw12, 0);

	Textdraw13 = TextDrawCreate(271.500000, 302.750000, "Welcome");
	TextDrawLetterSize(Textdraw13, 0.587000, 1.976249);
	TextDrawAlignment(Textdraw13, 1);
	TextDrawColor(Textdraw13, -65281);
	TextDrawSetShadow(Textdraw13, 0);
	TextDrawSetOutline(Textdraw13, 1);
	TextDrawBackgroundColor(Textdraw13, 255);
	TextDrawFont(Textdraw13, 3);
	TextDrawSetProportional(Textdraw13, 1);

	Textdraw14 = TextDrawCreate(303.125000, 322.583343, "To");
	TextDrawLetterSize(Textdraw14, 0.612000, 1.731249);
	TextDrawAlignment(Textdraw14, 1);
	TextDrawColor(Textdraw14, -5963521);
	TextDrawSetShadow(Textdraw14, 0);
	TextDrawSetOutline(Textdraw14, 1);
	TextDrawBackgroundColor(Textdraw14, 255);
	TextDrawFont(Textdraw14, 3);
	TextDrawSetProportional(Textdraw14, 1);

	Textdraw15 = TextDrawCreate(122.500000, 338.187500, "BALOCH GAMING");
	TextDrawLetterSize(Textdraw15, 0.502499, 2.606251);
	TextDrawAlignment(Textdraw15, 1);
	TextDrawColor(Textdraw15, -1378294017);
	TextDrawSetShadow(Textdraw15, 0);
	TextDrawSetOutline(Textdraw15, 1);
	TextDrawBackgroundColor(Textdraw15, 255);
	TextDrawFont(Textdraw15, 2);
	TextDrawSetProportional(Textdraw15, 1);

	Textdraw16 = TextDrawCreate(290.000000, 337.312500, "~b~COPS ~y~& ~r~ROBBERS");
	TextDrawLetterSize(Textdraw16, 0.597999, 2.684998);
	TextDrawAlignment(Textdraw16, 1);
	TextDrawColor(Textdraw16, -1);
	TextDrawSetShadow(Textdraw16, 0);
	TextDrawSetOutline(Textdraw16, 1);
	TextDrawBackgroundColor(Textdraw16, 51);
	TextDrawFont(Textdraw16, 2);
	TextDrawSetProportional(Textdraw16, 1);

	Textdraw17 = TextDrawCreate(214.500000, 445.812500, "LD_SPAC:white");
	TextDrawLetterSize(Textdraw17, 0.000000, 0.000000);
	TextDrawTextSize(Textdraw17, 209.000000, 3.062500);
	TextDrawAlignment(Textdraw17, 1);
	TextDrawColor(Textdraw17, -2139062017);
	TextDrawSetShadow(Textdraw17, 0);
	TextDrawSetOutline(Textdraw17, 0);
	TextDrawFont(Textdraw17, 4);
	// END
	
	// VCMDS Textdraws
	Textdrawvcmds0 = TextDrawCreate(506.099975, 158.125000, "usebox");
	TextDrawLetterSize(Textdrawvcmds0, 0.000000, 16.988889);
	TextDrawTextSize(Textdrawvcmds0, 140.600036, 0.000000);
	TextDrawAlignment(Textdrawvcmds0, 1);
	TextDrawColor(Textdrawvcmds0, 0);
	TextDrawUseBox(Textdrawvcmds0, true);
	TextDrawBoxColor(Textdrawvcmds0, 102);
	TextDrawSetShadow(Textdrawvcmds0, 0);
	TextDrawSetOutline(Textdrawvcmds0, 0);
	TextDrawFont(Textdrawvcmds0, 0);

	Textdrawvcmds1 = TextDrawCreate(251.899993, 157.193771, "~g~VEHICLES ~y~COMMANDS");
	TextDrawLetterSize(Textdrawvcmds1, 0.449999, 1.600000);
	TextDrawAlignment(Textdrawvcmds1, 1);
	TextDrawColor(Textdrawvcmds1, -1);
	TextDrawSetShadow(Textdrawvcmds1, 1);
	TextDrawSetOutline(Textdrawvcmds1, 0);
	TextDrawBackgroundColor(Textdrawvcmds1, 255);
	TextDrawFont(Textdrawvcmds1, 1);
	TextDrawSetProportional(Textdrawvcmds1, 1);

	Textdrawvcmds2 = TextDrawCreate(320.500000, 182.612518, "~y~/colour1 <colour id> ~w~- Choose The First Colour~n~~y~/colour2 <colour id> ~w~- Choose The Second Colour~n~~y~/lock ~w~- Lock/Unlock Your Vehicle~n~~y~/Park ~w~- Park The Vehicle~n~~y~/myvehicles ~w~-View Your Vehicles~n~~y~/vsell ~w~- To Sell Your Vehicle To Other Players~n~~y~/buyvehicle ~w~-To Purchase Offered Vehicles");
	TextDrawLetterSize(Textdrawvcmds2, 0.309499, 1.031249);
	TextDrawAlignment(Textdrawvcmds2, 2);
	TextDrawColor(Textdrawvcmds2, -1);
	TextDrawSetShadow(Textdrawvcmds2, 0);
	TextDrawSetOutline(Textdrawvcmds2, 1);
	TextDrawBackgroundColor(Textdrawvcmds2, 51);
	TextDrawFont(Textdrawvcmds2, 1);
	TextDrawSetProportional(Textdrawvcmds2, 1);

	Textdrawvcmds3 = TextDrawCreate(246.500000, 296.625000, "PRESS ~y~LMB ~w~TO ~r~CLOSE ~w~THIS ~b~BOX");
	TextDrawLetterSize(Textdrawvcmds3, 0.330500, 0.882500);
	TextDrawAlignment(Textdrawvcmds3, 1);
	TextDrawColor(Textdrawvcmds3, -1);
	TextDrawSetShadow(Textdrawvcmds3, 1);
	TextDrawSetOutline(Textdrawvcmds3, 0);
	TextDrawBackgroundColor(Textdrawvcmds3, 255);
	TextDrawFont(Textdrawvcmds3, 1);
	TextDrawSetProportional(Textdrawvcmds3, 1);
	// END

	// Skydive Pickup
	pickup_chute = CreatePickup(371, 1, -1813.0156, 576.6133, 234.8906, 0);
	
	// Secret Service Pickup
	pickup_ss = CreatePickup(371, 1, -1737.6863, 787.3431, 167.6535, 0);

	// VIP Health Pickup (for all VIPs)
	pickup_vhealth = CreatePickup(1240, 1, 1208.5283, -6.4214, 1001.3281, 80);

	// VIP Armour Pickup (for crim/top VIPs)
	pickup_varmour = CreatePickup(1242, 1, 1217.9944, -6.6420, 1001.3281, 80);

	// Stop stunt rewards
	EnableStuntBonusForAll(0);

	// Use standard CJ anims
	UsePlayerPedAnims();

	// Disable the default interior yellow markers for enter/exit
	DisableInteriorEnterExits();

	// Place robbery checkpoints all around the map
	placeAllCheckpoints();

	// Place the class vehicles all around the map
	placeAllClassCars();
	placeExtraCars();

	// Add the custom objects
	addWorldObjects();

	// Textdraws
	buildTextDraws();

	// Houses
	load_houses();
	
	// Gates
	load_gates();

	// Businesses
	//load_businesses();

	// Vehicles
	//load_oVehicles();
	Load_Vehicles();
	
	// Zones
	load_zones();

	// Flush gangs
	flushGangs();

	// Flush explosives
	flushExplosiveData();

	// Set server weather
	SetWeather(4);

	// Timers
	SetTimer("countMuteTime", 1000, true);
	SetTimer("countRobTime", 1000, true);
	SetTimer("highPing", 2000, true);
	SetTimer("armourCheck", 5000, true); // also caters for DM arena checks
	SetTimer("checkJetpack", 2000, true);
	SetTimer("gameTip", 600000, true);
	SetTimer("vipCheck", 300000, true);
	SetTimer("Zones_Update", 1000, true);
	SetTimer("classCheck", 10000, true);
	SetTimer("autoMoneyBag", 1200000, true);
	SetTimer("swapMOTD", 300000, true);

	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		Zones[i] = TextDrawCreate(86.000000, 320.000000, "_");
		TextDrawBackgroundColor(Zones[i], 255);
		TextDrawFont(Zones[i], 1);
		TextDrawLetterSize(Zones[i], 0.300000, 1.200000);
		TextDrawColor(Zones[i], -1);
		TextDrawSetOutline(Zones[i], 0);
		TextDrawSetProportional(Zones[i], 1);
		TextDrawSetShadow(Zones[i], 1);
		TextDrawUseBox(Zones[i], 0);
		TextDrawAlignment(Zones[i], 2);
	}

	alog[1] = " ";
	alog[2] = " ";
	alog[3] = " ";
	alog[4] = " ";
	alog[5] = " ";
	
	new
		motd1[128] = "~y~Welcome to BGCNR!",
		motd2[128] = "~y~If you need help use /ask!",
		motd3[128] = "~y~Want benefits and much more? check out ~g~/vipfeatures!"
	;
	
	serverInfo[MOTD1] = motd1;
	serverInfo[MOTD2] = motd2;
	serverInfo[MOTD3] = motd3;
	
	serverInfo[enableMOTD] = true;
	SetTimer("swapMOTD", 10000, false);

	drawGamemodeInitTextdraws();

	serverInfo[maxPing] = 1024;
	serverInfo[kickWarp] = 1;
	N11 = 11 * 60;
	gtime = N11 + 59;

	serverInfo[jailblown] = 0;
	serverInfo[moneybagid] = 1;
	serverInfo[rfAnticheat] = 1;
	serverInfo[abAnticheat] = 0;
	serverInfo[carAnticheat] = 1;
	serverInfo[cbAnticheat] = 0; // ANTICBUG DISABLED IF THIS IS SET TO 0
	
	// Set up several player classes
	AddPlayerClass(25, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	0	=	Civilian
	AddPlayerClass(124, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	1	=	Civilian
	AddPlayerClass(190, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	2	=	Civilian
	AddPlayerClass(191, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	3	=	Civilian
	AddPlayerClass(185, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	4	=	Civilian
	AddPlayerClass(13, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	5	=	Civilian
	AddPlayerClass(18, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	6	=	Civilian
	AddPlayerClass(45, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	7	=	Civilian
	AddPlayerClass(66, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	8	=	Civilian
	AddPlayerClass(106, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	9	=	Civilian
	AddPlayerClass(242, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	10	=	Civilian
	AddPlayerClass(261, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	11	=	Civilian
	AddPlayerClass(271, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	12	=	Civilian
	AddPlayerClass(293, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	13	=	Civilian
	AddPlayerClass(296, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	14	=	Civilian
	AddPlayerClass(12, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	15	=   Civilian
	AddPlayerClass(13, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	16	=   Civilian
	AddPlayerClass(31, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	17	=   Civilian
	AddPlayerClass(41, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	18	=   Civilian
	AddPlayerClass(92, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	19	=   Civilian
	AddPlayerClass(105, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	20	=   Civilian
	AddPlayerClass(106, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	21	=   Civilian
	AddPlayerClass(107, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	22	=   Civilian
	AddPlayerClass(108, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	23	=   Civilian
	AddPlayerClass(109, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	24	=   Civilian
	AddPlayerClass(110, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	25	=   Civilian
	AddPlayerClass(115, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	26	=   Civilian
	AddPlayerClass(130, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	27	=   Civilian
	AddPlayerClass(139, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	28	=   Civilian
	AddPlayerClass(195, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	29	=   Civilian
	AddPlayerClass(211, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	30	=   Civilian
	AddPlayerClass(216, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	31	=   Civilian
	AddPlayerClass(215, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	32	=   Civilian
	AddPlayerClass(219, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	33	=   Civilian
	AddPlayerClass(249, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	34	=   Civilian
	AddPlayerClass(259, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	35	=   Civilian

    AddPlayerClass(267, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID     36	=	Police
    AddPlayerClass(266, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID     37	=	Police
    AddPlayerClass(265, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID     38	=	Police
	AddPlayerClass(281, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID     39	=	Police
	AddPlayerClass(280, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	40	=	Police
	AddPlayerClass(282, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	41	=	Police
	AddPlayerClass(283, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	42	=	Police
	AddPlayerClass(284, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	43	=	Police
    AddPlayerClass(93, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);		// Class ID 	44	=	Police

	AddPlayerClass(287, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	45	=   Army
	AddPlayerClass(191, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	46	=   Army

	AddPlayerClass(163, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	47	=   CIA
	AddPlayerClass(164, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	48	=   CIA
	AddPlayerClass(165, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	49	=   CIA
	AddPlayerClass(166, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	50	=   CIA

	AddPlayerClass(285, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	51	=   FBI
	AddPlayerClass(286, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	52	=   FBI

    AddPlayerClass(274, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	53	=   Medic
    AddPlayerClass(275, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	54	=   Medic
    AddPlayerClass(276, -1505.5410, 920.3940, 7.1875, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	55	=   Medic

	AddPlayerClass(165, -1763.6486, 795.1059, 167.6563, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	56	=   Secret Service
	AddPlayerClass(169, -1763.6486, 795.1059, 167.6563, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	57	=   Secret Service
	AddPlayerClass(227, -1763.6486, 795.1059, 167.6563, 90, 0, 0, 0, 0, 0, 0);	// Class ID 	58	=   Secret Service
    
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    // Nearest Player Textdraws
	    Textdrawneap0[i] = TextDrawCreate(613.599182, 374.337249, "usebox");
		TextDrawLetterSize(Textdrawneap0[i], 0.000000, 1.250555);
		TextDrawTextSize(Textdrawneap0[i], 488.199707, 0.000000);
		TextDrawAlignment(Textdrawneap0[i], 1);
		TextDrawColor(Textdrawneap0[i], 0);
		TextDrawUseBox(Textdrawneap0[i], true);
		TextDrawBoxColor(Textdrawneap0[i], 102);
		TextDrawSetShadow(Textdrawneap0[i], 0);
		TextDrawSetOutline(Textdrawneap0[i], 0);
		TextDrawFont(Textdrawneap0[i], 0);

		Textdrawneap1[i] = TextDrawCreate(497.500061, 376.206237, "~g~Nearest ~y~Player ~r~ID:");
		TextDrawLetterSize(Textdrawneap1[i], 0.240399, 0.739436);
		TextDrawAlignment(Textdrawneap1[i], 1);
		TextDrawColor(Textdrawneap1[i], -1);
		TextDrawSetShadow(Textdrawneap1[i], 0);
		TextDrawSetOutline(Textdrawneap1[i], 1);
		TextDrawBackgroundColor(Textdrawneap1[i], 255);
		TextDrawFont(Textdrawneap1[i], 1);
		TextDrawSetProportional(Textdrawneap1[i], 1);

		Textdrawneap2[i] = TextDrawCreate(490.399871, 369.512786, "LD_SPAC:white");
		TextDrawLetterSize(Textdrawneap2[i], 0.000000, 0.000000);
		TextDrawTextSize(Textdrawneap2[i], 121.550010, 2.975000);
		TextDrawAlignment(Textdrawneap2[i], 1);
		TextDrawColor(Textdrawneap2[i], -1523963137);
		TextDrawSetShadow(Textdrawneap2[i], 0);
		TextDrawSetOutline(Textdrawneap2[i], 0);
		TextDrawFont(Textdrawneap2[i], 4);

		Textdrawneap3[i] = TextDrawCreate(490.199890, 387.449920, "LD_SPAC:white");
		TextDrawLetterSize(Textdrawneap3[i], 0.000000, 0.000000);
		TextDrawTextSize(Textdrawneap3[i], 121.750061, 3.281251);
		TextDrawAlignment(Textdrawneap3[i], 1);
		TextDrawColor(Textdrawneap3[i], 65535);
		TextDrawSetShadow(Textdrawneap3[i], 0);
		TextDrawSetOutline(Textdrawneap3[i], 0);
		TextDrawFont(Textdrawneap3[i], 4);
		// END
    
	    // Speedot Metter Textdraws
		RKCNRInfo[i] = TextDrawCreate(6.000000, 438.812500, "");
		TextDrawLetterSize(RKCNRInfo[i], 0.200999, 0.821249);
		TextDrawAlignment(RKCNRInfo[i], 1);
		TextDrawColor(RKCNRInfo[i], -1);
		TextDrawSetShadow(RKCNRInfo[i], 0);
		TextDrawSetOutline(RKCNRInfo[i], 1);
		TextDrawBackgroundColor(RKCNRInfo[i], 255);
		TextDrawFont(RKCNRInfo[i], 1);
		TextDrawSetProportional(RKCNRInfo[i], 1);
		// END

		// Speedot Metter Black Box
		RKCNRInfo1[i] = TextDrawCreate(644.000000, 439.875000, "usebox");
		TextDrawLetterSize(RKCNRInfo1[i], 0.000000, 5.806947);
		TextDrawTextSize(RKCNRInfo1[i], -2.000000, 0.000000);
		TextDrawAlignment(RKCNRInfo1[i], 1);
		TextDrawColor(RKCNRInfo1[i], 0);
		TextDrawUseBox(RKCNRInfo1[i], true);
		TextDrawBoxColor(RKCNRInfo1[i], 102);
		TextDrawSetShadow(RKCNRInfo1[i], 0);
		TextDrawSetOutline(RKCNRInfo1[i], 0);
		TextDrawFont(RKCNRInfo1[i], 0);
		// END
	
		// Use Me Textdraw
		Textdrawuseme0[i] = TextDrawCreate(317.249633, 155.837448, "");
		TextDrawLetterSize(Textdrawuseme0[i], 0.449999, 1.600000);
		TextDrawAlignment(Textdrawuseme0[i], 2);
		TextDrawColor(Textdrawuseme0[i], -1);
		TextDrawSetShadow(Textdrawuseme0[i], 0);
		TextDrawSetOutline(Textdrawuseme0[i], 1);
		TextDrawBackgroundColor(Textdrawuseme0[i], 255);
		TextDrawFont(Textdrawuseme0[i], 2);
		TextDrawSetProportional(Textdrawuseme0[i], 1);
		// END
		
		// Welcome Back Textdraws
		Textdrawcb[i] = TextDrawCreate(314.000000, 150.062500, "");
		TextDrawLetterSize(Textdrawcb[i], 0.449999, 1.600000);
		TextDrawAlignment(Textdrawcb[i], 2);
		TextDrawColor(Textdrawcb[i], -1);
		TextDrawSetShadow(Textdrawcb[i], 0);
		TextDrawSetOutline(Textdrawcb[i], 1);
		TextDrawBackgroundColor(Textdrawcb[i], 255);
		TextDrawFont(Textdrawcb[i], 2);
		TextDrawSetProportional(Textdrawcb[i], 1);
		// END
	}

	return 1;
}


public OnGameModeExit()
{
	// Stats Saving
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i) && playerData[i][playerLoggedIn])
		{
			savePlayerStats(i);
		}
	}
	// END

	mysql_close(connection);
    db_close(VEHICLESDB);
    db_close(HOUSEDB);
    
	return 1;
}

forward OnIncomingConnection( playerid, ip_address[ ], port );
public OnIncomingConnection( playerid, ip_address[ ], port ) {
    SendRconCommand( "reloadbans" );
}

forward OnPlayerFloodControl(playerid, iCount, iTimeSpan);
public OnPlayerFloodControl(playerid, iCount, iTimeSpan) {
    if(iCount > 4 && iTimeSpan < 8000) {
        Ban(playerid);
    }
}

public OnPlayerRequestClass(playerid, classid)
{
    // Welcome TextDraws
	TextDrawShowForPlayer(playerid, Textdraw0);
	TextDrawShowForPlayer(playerid, Textdraw1);
	TextDrawShowForPlayer(playerid, Textdraw2);
	TextDrawShowForPlayer(playerid, Textdraw3);
	TextDrawShowForPlayer(playerid, Textdraw4);
	TextDrawShowForPlayer(playerid, Textdraw5);
	TextDrawShowForPlayer(playerid, Textdraw6);
	TextDrawShowForPlayer(playerid, Textdraw7);
	TextDrawShowForPlayer(playerid, Textdraw8);
	TextDrawShowForPlayer(playerid, Textdraw9);
	TextDrawShowForPlayer(playerid, Textdraw10);
	TextDrawShowForPlayer(playerid, Textdraw11);
	TextDrawShowForPlayer(playerid, Textdraw12);
	TextDrawShowForPlayer(playerid, Textdraw13);
	TextDrawShowForPlayer(playerid, Textdraw14);
	TextDrawShowForPlayer(playerid, Textdraw15);
	TextDrawShowForPlayer(playerid, Textdraw16);
	TextDrawShowForPlayer(playerid, Textdraw17);
	// END

	if (playerData[playerid][isInDM])
	{
		playerData[playerid][isInDM] = false;
		playerData[playerid][isInEvent] = false;

		for (new i=0; i<MAX_PLAYERS; i++)
		{
			if(playerData[i][isInDM])
			{
				new dmLeave[100];
				format(dmLeave, sizeof(dmLeave), "{26FF4E}%s (%i) {FFFFFF}left the arena.", playerData[playerid][playerNamee], playerid);
				SendClientMessage(i, COLOR_WHITE, dmLeave);
			}
		}
	}
	
	playerData[playerid][selectingClass] = true;
    TextDrawHideForPlayer(playerid, Text:URLTD);
    PlayerTextDrawSetString(playerid, playerData[playerid][wantedStars], " ");

	if(playerData[playerid][playerBanned] != 1)
	{

		ClearAnimations(playerid);
		ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Rob", 1, 1, 0, 0, 0, 0, 1);
		ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_LOOP", 4.0, 1, 0, 0, 0, -1);
		ClearAnimations(playerid);
		
		switch(classid)
		{
		    // Civilian classes
		    case 0 .. 35:
		    {
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][2], "~w~Civilian Class");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][3], "Cruise around San Fierro with your dick out, maybe.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][4], "Commit crimes to earn XP and rule the streets.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][7], " ");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][6], "0 XP REQUIRED");
				
				playerData[playerid][playerClass] = CLASS_CIVILIAN;
				SetPlayerColor(playerid, CLASS_CIVILIAN_COLOUR);

				SetPlayerPos(playerid, -1532.0754, 687.7472, 133.0514);
				SetPlayerFacingAngle(playerid, 198.5548);
				SetPlayerCameraPos(playerid, -1528.4701, 681.3049, 133.2051);
				SetPlayerCameraLookAt(playerid, -1532.0754, 687.7472, 133.0514);
		    }

		    // Police classes
		    case 36 .. 44:
		    {
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][2], "Police Class");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][3], "Bring criminals to justice using an array of tools.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][4], "Hunt down and arrest criminals for cash and XP.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][7], " ");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][6], "50 XP REQUIRED");
				
				playerData[playerid][playerClass] = CLASS_POLICE;
				SetPlayerColor(playerid, CLASS_POLICE_COLOUR);

				SetPlayerPos(playerid, -1587.0164, 721.8500, -4.9063);
				SetPlayerFacingAngle(playerid, 239.8802);
				SetPlayerCameraPos(playerid, -1581.4075, 718.5963, -5.2422);
				SetPlayerCameraLookAt(playerid, -1587.0164, 721.8500, -4.9063);
		    }

			// Army class
		    case 45, 46:
		    {
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][2], "~p~Army Class");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][3], "Don't feel man enough? Join the Army!");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][4], "Access powerful weaponry & machinery");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][7], "to kill those criminal bastards.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][6], "20,000 XP REQUIRED");

				playerData[playerid][playerClass] = CLASS_ARMY;
				SetPlayerColor(playerid, CLASS_ARMY_COLOUR);

				SetPlayerPos(playerid, -1403.1262, 490.1483, 18.2294);
				SetPlayerFacingAngle(playerid, 77.3216);
				SetPlayerCameraPos(playerid, -1408.0873, 491.7008, 18.2294);
				SetPlayerCameraLookAt(playerid, -1403.1262, 490.1483, 18.2294);
			}

			// CIA class
		    case 47 .. 50:
		    {
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][2], "Central Intelligence Agency");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][3], "Bring criminals to justice using an array of tools.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][4], "Gain the ability to locate and EMP criminals.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][7], " ");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][6], "10,000 XP REQUIRED");
				
				playerData[playerid][playerClass] = CLASS_CIA;
				SetPlayerColor(playerid, CLASS_CIA_COLOUR);

				SetPlayerPos(playerid, -2439.5608, 503.9104, 29.9403);
				SetPlayerFacingAngle(playerid, 108.6551);
				SetPlayerCameraPos(playerid, -2445.3594, 501.9529, 30.0897);
				SetPlayerCameraLookAt(playerid, -2439.5608, 503.9104, 29.9403);
			}

			// FBI class
		    case 51, 52:
		    {
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][2], "Federal Bureau of Investigation");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][3], "Bring criminals to justice using an array of tools.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][4], "Gain the ability to force entry to any property that");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][7], "isn't highly secure.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][6], "5,000 XP REQUIRED");
				
				playerData[playerid][playerClass] = CLASS_FBI;
				SetPlayerColor(playerid, CLASS_FBI_COLOUR);

				SetPlayerPos(playerid, -2439.5608, 503.9104, 29.9403);
				SetPlayerFacingAngle(playerid, 108.6551);
				SetPlayerCameraPos(playerid, -2445.3594, 501.9529, 30.0897);
				SetPlayerCameraLookAt(playerid, -2439.5608, 503.9104, 29.9403);
			}

			// Medic class
		    case 53 .. 55:
		    {
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][2], "~p~Medic Class");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][3], "Heal player injuries or cure their STDs");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][4], "for cash and XP.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][7], " ");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][6], "0 XP REQUIRED");
				
				SetPlayerColor(playerid, CLASS_MEDIC_COLOUR);
				playerData[playerid][playerClass] = CLASS_MEDIC;

				SetPlayerPos(playerid, -2644.3481, 618.6160, 14.4531);
				SetPlayerFacingAngle(playerid, 236.1596);
				SetPlayerCameraPos(playerid, -2637.7776, 614.2100, 14.453);
				SetPlayerCameraLookAt(playerid, -2644.3481, 618.6160, 14.4531);
			}

			// Secret Service Class
		    case 56 .. 58:
		    {
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][2], "San Fierro Secret Service");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][3], "Bring criminals to justice using an array of tools.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][4], "Become incognito and hide in the shadows.");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][7], " ");
				PlayerTextDrawSetString(playerid, playerData[playerid][classSelect][6], "VIP MEMBERSHIP REQUIRED");
				
				SetPlayerColor(playerid, CLASS_SECRETSERVICE_COLOUR);
				playerData[playerid][playerClass] = CLASS_SECRETSERVICE;

				SetPlayerPos(playerid, -1763.6486, 795.1059, 167.6563);
				SetPlayerFacingAngle(playerid, 37.2926);
				SetPlayerCameraPos(playerid, -1767.7225, 800.5792, 167.6563);
				SetPlayerCameraLookAt(playerid, -1763.6486, 795.1059, 167.6563);
			}
		}
 	}
 	
	PlayerTextDrawShow(playerid, playerData[playerid][classSelect][0]);
	PlayerTextDrawShow(playerid, playerData[playerid][classSelect][1]);
	PlayerTextDrawShow(playerid, playerData[playerid][classSelect][2]);
	PlayerTextDrawShow(playerid, playerData[playerid][classSelect][3]);
	PlayerTextDrawShow(playerid, playerData[playerid][classSelect][4]);
	PlayerTextDrawShow(playerid, playerData[playerid][classSelect][5]);
	PlayerTextDrawShow(playerid, playerData[playerid][classSelect][6]);
	PlayerTextDrawShow(playerid, playerData[playerid][classSelect][7]);

	return 1;
}

public OnPlayerConnect(playerid)
{
    	// Nearest Player Textdraws
    TextDrawShowForPlayer(playerid, Textdrawneap0[playerid]);
    TextDrawShowForPlayer(playerid, Textdrawneap1[playerid]);
    TextDrawShowForPlayer(playerid, Textdrawneap2[playerid]);
    TextDrawShowForPlayer(playerid, Textdrawneap3[playerid]);
    // END

    // Death Stadium System
    InDMS[playerid] =  0;
    // END

    // Join Panel
    new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
    
	format(MessageStrl6, 170, MessageStrl5);
	format(MessageStrl5, 170, MessageStrl4);
	format(MessageStrl4, 170, MessageStrl3);
    format(MessageStrl3, 170, MessageStrl2);
    format(MessageStrl2, 170, MessageStr);
    format(MessageStr,sizeof MessageStr,"~g~Join: ~w~%s (%d)", PlayerName, playerid);
    new STR[510];
    format(STR, sizeof(STR), "%s~n~%s~n~%s~n~%s~n~%s", MessageStrl5, MessageStrl4,MessageStrl3, MessageStrl2, MessageStr);
    TextDrawSetString(Message, STR);
    TextDrawShowForPlayer(playerid, Message);
	// END
	
	SendClientMessage(playerid, -1, "{EE5555}___________________________________________________________________________________");
	SendClientMessage(playerid, -1, "{A9C4E4}Welcome To Baloch Gaming {4545F2}Cops {FFFFFF}And {F81414}Robbers, {CCCC00}Version: {00FF22}v1.2.17");
	SendClientMessage(playerid, -1, "{EE5555}WARNING: {A9C4E4}The content and concept on this server is explicit as with GTA SA.!");
	SendClientMessage(playerid, -1, "{CCCC00}Visit Our server Website {F81414}www.baloch-gaming.ml{CCCC00} and forum For more {00FF22}information{CCCC00} about server..");
	SendClientMessage(playerid, -1, "{EE5555}___________________________________________________________________________________");

    new ConnIP[16];
	GetPlayerIp(playerid,ConnIP,16);
	new compare_IP[16];
	new number_IP = 0;
	for(new i=0; i<MAX_PLAYERS; i++) {
		if(IsPlayerConnected(i)) {
		    GetPlayerIp(i,compare_IP,16);
		    if(!strcmp(compare_IP,ConnIP)) number_IP++;
		}
	}
	if((GetTickCount() - Join_Stamp) < Time_Limit)
	    exceed=1;
	else
	    exceed=0;
 	if(strcmp(ban_s, ConnIP, false) == 0 && exceed == 1 )
 	{
 	    Same_IP++;
 	    if(Same_IP > SAME_IP_CONNECT)
 	    {
	   		Ban(playerid);
 			Same_IP=0;
 	    }
 	}
 	else
 	{
 		Same_IP=0;
	}
	if(number_IP > IP_LIMIT)
	    Kick(playerid);
	GetStampIP(playerid);
	
    ac_OnPlayerConnect(playerid);
    
	PreloadAnimLib(playerid,"BOMBER");
	PreloadAnimLib(playerid,"RAPPING");
    PreloadAnimLib(playerid,"SHOP");
	PreloadAnimLib(playerid,"BEACH");
    PreloadAnimLib(playerid,"SMOKING");
	PreloadAnimLib(playerid,"FOOD");
    PreloadAnimLib(playerid,"ON_LOOKERS");
	PreloadAnimLib(playerid,"DEALER");
    PreloadAnimLib(playerid,"CRACK");
	PreloadAnimLib(playerid,"CARRY");
    PreloadAnimLib(playerid,"COP_AMBIENT");
	PreloadAnimLib(playerid,"PARK");
    PreloadAnimLib(playerid,"INT_HOUSE");
	PreloadAnimLib(playerid,"PED");
    PreloadAnimLib(playerid,"MISC");
	PreloadAnimLib(playerid,"OTB");
    PreloadAnimLib(playerid,"BD_Fire");
	PreloadAnimLib(playerid,"BENCHPRESS");
    PreloadAnimLib(playerid,"KISSING");
	PreloadAnimLib(playerid,"BSKTBALL");
    PreloadAnimLib(playerid,"MEDIC");
	PreloadAnimLib(playerid,"SWORD");
    PreloadAnimLib(playerid,"POLICE");
	PreloadAnimLib(playerid,"SUNBATHE");
    PreloadAnimLib(playerid,"FAT");
	PreloadAnimLib(playerid,"WUZI");
    PreloadAnimLib(playerid,"SWEET");
	PreloadAnimLib(playerid,"ROB_BANK");
    PreloadAnimLib(playerid,"GANGS");
	PreloadAnimLib(playerid,"RIOT");
    PreloadAnimLib(playerid,"GYMNASIUM");
	PreloadAnimLib(playerid,"CAR");
    PreloadAnimLib(playerid,"CAR_CHAT");
	PreloadAnimLib(playerid,"GRAVEYARD");
    PreloadAnimLib(playerid,"POOL");
    
    
	for(new i= 0; i < 47; i++)
	{
		PlayerWeapons[playerid][i] = false;
	}

    SetPlayerColor(playerid, 0xFFFFFFFF);
	ApplyAnimation(playerid, "ROB_BANK", "CAT_Safe_Rob", 1, 1, 0, 0, 0, 0, 1);
	ClearAnimations(playerid);
	TogglePlayerSpectating(playerid, true);
	ResetPlayerWeapons(playerid);

	// Setup local variables
    new query[200], ban_query[200], playerName[24], playersName[24], playersIP[16];
    GetPlayerName(playerid, playerName, 24);

	format(query, sizeof(query), "SELECT `playerName` FROM `playerdata` WHERE playerName = '%s' LIMIT 1", playerName);
    mysql_query(query, MYSQL_RESULT_CHECK, playerid, connection);

	GetPlayerName(playerid, playersName, sizeof(playersName));
	GetPlayerIp(playerid, playersIP, sizeof(playersIP));

	// Ban-checking system
	format(ban_query, sizeof(ban_query), "SELECT * FROM `playerbans` WHERE `player_banned` = '%s' OR `player_ip` = '%s' LIMIT 1", playersName, playersIP);
    mysql_query(ban_query, MYSQL_QUERY_BANNED, playerid, connection);

	clearWorldObjects(playerid);
	loadMapIcons(playerid);

	playerData[playerid][CheckSpeed] = SetTimerEx("speedCheck", 2000, true, "i", playerid);

	// Easter
	//TextDrawHideForPlayer(playerid, easterSunday);
	
	// Rapid fire
	playerData[playerid][shotTime] = 0;
 	playerData[playerid][shot] = 0;
 	playerData[playerid][shotWarnings] = 0;

	// Car warp
	playerData[playerid][ctpImmune] = true;
	playerData[playerid][abImmune] = true;
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    // Death Stadium System
    InDMS[playerid]=0;
    // END

    // Join Panel
    new PlayerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
    
	format(MessageStrl6, 170, MessageStrl5);
	format(MessageStrl5, 170, MessageStrl4);
	format(MessageStrl4, 170, MessageStrl3);
    format(MessageStrl3, 170, MessageStrl2);
    format(MessageStrl2, 170, MessageStr);
    switch(reason)
    {
            case 0: format(MessageStr,sizeof MessageStr,"~y~Time: ~w~%s (%d)", PlayerName, playerid);
            case 1: format(MessageStr,sizeof MessageStr,"~r~Quit: ~w~%s (%d)", PlayerName, playerid);
            case 2: format(MessageStr,sizeof MessageStr,"~p~Kick: ~w~%s (%d)", PlayerName, playerid);
    }
    new STR[510];
    format(STR, sizeof(STR), "%s~n~%s~n~%s~n~%s~n~%s", MessageStrl5, MessageStrl4,MessageStrl3, MessageStrl2, MessageStr);
    TextDrawSetString(Message, STR);
	// END

    SetPlayerColor(playerid, 0xFFFFFFFF);
	if(playerData[playerid][playerLoggedIn])
    {
        savePlayerStats(playerid);
    }

	if(reason == 1) // Manual game-quit.
	{
		new administratorAlert[128];

		if(playerData[playerid][playerIsTazed])
		{
			format(administratorAlert, sizeof(administratorAlert), "{C73E3E}[AVOID-DETECTION] {FFFFFF}%s (%i) quit the game while tazed.", playerData[playerid][playerNamee], playerid);
			adminchat(COLOR_WHITE, administratorAlert);
		}
		else if(playerData[playerid][playerIsCuffed])
		{
			format(administratorAlert, sizeof(administratorAlert), "{C73E3E}[AVOID-DETECTION] {FFFFFF}%s (%i) quit the game while cuffed.", playerData[playerid][playerNamee], playerid);
			adminchat(COLOR_WHITE, administratorAlert);
		}
		else if(playerData[playerid][playerIsTied])
		{
			format(administratorAlert, sizeof(administratorAlert), "{C73E3E}[AVOID-DETECTION] {FFFFFF}%s (%i) quit the game while tied.", playerData[playerid][playerNamee], playerid);
			adminchat(COLOR_WHITE, administratorAlert);
		}
	}

	if(playerData[playerid][playerGangID] != INVALID_GANG_ID)
	{
		cmd_g(playerid, "leave");
	}

	ClearStats(playerid);
	removePlayerRoadblocks(playerid);
	destroyPlayersExplosives(playerid);

	// Delete labels
	Delete3DTextLabel(playerData[playerid][playerAdminLabel]);

	// Destroy timers
	KillTimer(playerData[playerid][unfreezeTimer]);
	KillTimer(playerData[playerid][arrestTimer]);
	KillTimer(playerData[playerid][untieTimer]);
	KillTimer(playerData[playerid][uncuffTimer]);
	KillTimer(playerData[playerid][recuffTimer]);
	KillTimer(playerData[playerid][retazeTimer]);
	KillTimer(playerData[playerid][fixTimer]);
	KillTimer(playerData[playerid][nosTimer]);
	KillTimer(playerData[playerid][mechREMPTimer]);
	KillTimer(playerData[playerid][reactivateRapeStatus]);
	KillTimer(playerData[playerid][reactivateRobStatus]);
	KillTimer(playerData[playerid][hcpTimer]);
	KillTimer(playerData[playerid][courierTimer]);
	KillTimer(playerData[playerid][playerCanKidnap]);
	KillTimer(playerData[playerid][rapedTimer]);
	KillTimer(playerData[playerid][jailTimer]);
	KillTimer(playerData[playerid][spawnPlayerTimer]);
	KillTimer(playerData[playerid][truckExitTimer]);
	KillTimer(playerData[playerid][breakCuffsTimer]);
	KillTimer(playerData[playerid][achieveTimer]);
	KillTimer(playerData[playerid][spamTimer]);
	KillTimer(playerData[playerid][CheckSpeed]);
	KillTimer(playerData[playerid][retruckTimer]);
	KillTimer(playerData[playerid][saveStatsTimer]);
	KillTimer(playerData[playerid][rehealTimer]);
	KillTimer(playerData[playerid][recureTimer]);
	KillTimer(playerData[playerid][breakinTimer]);
	KillTimer(playerData[playerid][houseTimer]);
	
	playerData[playerid][shotTime] = 0;
 	playerData[playerid][shot] = 0;
 	playerData[playerid][shotWarnings] = 0;

	// Reset weapons for next player
	ResetPlayerWeapons(playerid);
    SendDeathMessage(INVALID_PLAYER_ID, playerid, 201);
    
    // Vehicles
 	/*for(new v = 0; v < MAX_SCRIPT_VEHICLES; v++)
	{
		if (oVehicle[v][vehicle_id] != -1)
		{
			if(!strcmp(oVehicle[v][vehicle_owner], playerData[playerid][playerNamee], true))
			{
				DestroyVehicle(oVehicle[v][vehicle_sid]);
			}
		}
	}*/
	
	for(new i; i < MAX_SAVED_VEHICLES; i++)
	{
	    if(VehicleInfo[i][vOwner] != playerData[playerid][actualID]) continue;
	    DestroyVehicle(VehicleInfo[i][vehicleID]);
	    VehicleInfo[i][vehicleID] = INVALID_VEHICLE_ID;
	}

	return 1;
}

public OnPlayerAirbreak(playerid)
{
	ac_AirBrake(playerid);
    return 1;
}

public OnVehicleSpawn(vehicleid)
{
	if (!vWarped[vehicleid][Spawned])
	{
		new Float: oldPos[4];

		GetVehiclePos(vehicleid, oldPos[0], oldPos[1], oldPos[2]);
		GetVehicleZAngle(vehicleid, oldPos[3]);

	    vWarped[vehicleid][theVehicle] = vehicleid;
		vWarped[vehicleid][vehiclePositionX] = oldPos[0];
		vWarped[vehicleid][vehiclePositionY] = oldPos[1];
		vWarped[vehicleid][vehiclePositionZ] = oldPos[2];
		vWarped[vehicleid][vehiclePositionA] = oldPos[3];

	 	vWarped[vehicleid][Spawned] = true;
 	}

	vWarped[vehicleid][Spawning] = false;
	vWarped[vehicleid][wasOccupied] = false;
	
	for(new i; i < MAX_SAVED_VEHICLES; i++)
	{
		if (vehicleid != VehicleInfo[i][vehicleID]) continue;

		ModVehicle(VehicleInfo[i][vehicleID]);
		ChangeVehiclePaintjob(VehicleInfo[i][vehicleID], VehicleInfo[i][vPaintjob]);
		
		print("Modded");

		break;
	}
	
    return 1;
}

forward OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{

	
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	if(!playerData[playerid][playerLoggedIn])
	{
        SendClientMessage(playerid, 0xFF0000FF, "You're not logged in, you must be logged in to spawn.");
		return 0;
	}

	switch(playerData[playerid][playerClass])
	{
  		case CLASS_POLICE:
    	{
      		if (playerData[playerid][playerXP] < 50)
      		{
		        SendClientMessage(playerid, COLOR_RED, "You must have 50 XP to join this class.");
			    return 0;
      		}
			if (playerData[playerid][playerWantedLevel] >= 1)
			{
		        SendClientMessage(playerid, COLOR_RED, "You cannot spawn as a LEO with a civilian wanted level!");
			    return 0;
			}
			if (playerData[playerid][playerCopBanned] == 1)
			{
		        SendClientMessage(playerid, COLOR_RED, "You're cop banned!");
			    return 0;
			}
		}

  		case CLASS_ARMY:
    	{
    	    if (playerData[playerid][playerXP] < 20000)
    	    {
		        SendClientMessage(playerid, COLOR_RED, "You must have 20,000 XP to join this class.");
			    return 0;
			}
			if (playerData[playerid][playerWantedLevel] >= 1)
			{
		        SendClientMessage(playerid, COLOR_RED, "You cannot spawn as a LEO with a civilian wanted level!");
			    return 0;
			}
			if (playerData[playerid][playerArmyBanned] == 1)
			{
		        SendClientMessage(playerid, COLOR_RED, "You're army banned!");
			    return 0;
			}
		}

  		case CLASS_CIA:
    	{
    	    if (playerData[playerid][playerXP] < 10000)
    	    {
		        SendClientMessage(playerid, COLOR_RED, "You must have 10,000 XP to join this class.");
			    return 0;
			}
			if (playerData[playerid][playerWantedLevel] >= 1)
			{
		        SendClientMessage(playerid, COLOR_RED, "You cannot spawn as a LEO with a civilian wanted level!");
			    return 0;
			}
			if (playerData[playerid][playerCopBanned] == 1)
			{
		        SendClientMessage(playerid, COLOR_RED, "You are cop banned!");
			    return 0;
			}
		}

  		case CLASS_FBI:
    	{
    	    if (playerData[playerid][playerXP] < 5000)
    	    {
		        SendClientMessage(playerid, COLOR_RED, "You must have 5,000 XP to join this class.");
			    return 0;
			}
			if (playerData[playerid][playerWantedLevel] >= 1)
			{
		        SendClientMessage(playerid, COLOR_RED, "You cannot spawn as a LEO with a civilian wanted level!");
			    return 0;
			}
			if (playerData[playerid][playerCopBanned] == 1)
			{
		        SendClientMessage(playerid, COLOR_RED, "You are cop banned!");
			    return 0;
			}
		}
		
  		case CLASS_SECRETSERVICE:
    	{
    	    if (playerData[playerid][playerVIPLevel] < 1)
    	    {
		        SendClientMessage(playerid, COLOR_RED, "You must be at-least Standard VIP to use this class.");
			    return 0;
			}
			if (playerData[playerid][playerWantedLevel] >= 1)
			{
		        SendClientMessage(playerid, COLOR_RED, "You cannot spawn as a LEO with a civilian wanted level!");
			    return 0;
			}
			if (playerData[playerid][playerCopBanned] == 1)
			{
		        SendClientMessage(playerid, COLOR_RED, "You are cop banned!");
			    return 0;
			}
		}
	}

	return 1;
}

public OnPlayerSpawn(playerid)
{
    // Death Stadium System
	if(InDMS[playerid] == 1)
	{
	    // START
	    
	    // No team during DM
		SetPlayerTeam(playerid, NO_TEAM);
		playerData[playerid][isInDM] = true; // Prevent scores etc - also respawn
		playerData[playerid][isInEvent] = true;
		playerData[playerid][adminWeapon] = true; // Prevent anti-cheat kick
		TextDrawShowForPlayer(playerid, dmBox[0]);
		TextDrawShowForPlayer(playerid, dmBox[1]);
		TextDrawShowForPlayer(playerid, dmBox[2]);
		TextDrawShowForPlayer(playerid, dmBox[3]);
		TextDrawShowForPlayer(playerid, dmBox[4]);
		TextDrawShowForPlayer(playerid, dmBox[5]);
		TextDrawShowForPlayer(playerid, dmBox[6]);
		PlayerTextDrawShow(playerid, playerData[playerid][dmArena][0]);
		PlayerTextDrawShow(playerid, playerData[playerid][dmArena][1]);
		PlayerTextDrawShow(playerid, playerData[playerid][dmArena][2]);
		PlayerTextDrawShow(playerid, playerData[playerid][dmArena][3]);
		dmStats(playerid);
    	playerData[playerid][hasSpawned] = true;
	    playerData[playerid][playerDied] = false;
	    // END
	    ResetPlayerWeapons(playerid);
	    SetPlayerVirtualWorld(playerid,326);
		SetPlayerInterior(playerid,14);
		GivePlayerWeaponEx(playerid, 26, 200);
		GivePlayerWeaponEx(playerid, 9, 1);
		GivePlayerWeaponEx(playerid, 24, 500);
		GivePlayerWeaponEx(playerid, 28, 500);
		GivePlayerWeaponEx(playerid, 31, 500);
		GivePlayerWeaponEx(playerid, 34, 500);
		SetPlayerHealth(playerid, 100.0);
		new Random = random(sizeof(InDMSpawns));
		SetPlayerPos(playerid, InDMSpawns[Random][0], InDMSpawns[Random][1], InDMSpawns[Random][2]);
		SetPlayerFacingAngle(playerid, InDMSpawns[Random][3]);
		InDMS[playerid]=1;
		return 1;
	}
	// END

    // Welcome TextDraw Same Like GTCNR
    TextDrawHideForPlayer(playerid, Textdraw0);
    TextDrawHideForPlayer(playerid, Textdraw1);
    TextDrawHideForPlayer(playerid, Textdraw2);
    TextDrawHideForPlayer(playerid, Textdraw3);
    TextDrawHideForPlayer(playerid, Textdraw4);
    TextDrawHideForPlayer(playerid, Textdraw5);
    TextDrawHideForPlayer(playerid, Textdraw6);
    TextDrawHideForPlayer(playerid, Textdraw7);
    TextDrawHideForPlayer(playerid, Textdraw8);
    TextDrawHideForPlayer(playerid, Textdraw9);
    TextDrawHideForPlayer(playerid, Textdraw10);
    TextDrawHideForPlayer(playerid, Textdraw11);
    TextDrawHideForPlayer(playerid, Textdraw12);
    TextDrawHideForPlayer(playerid, Textdraw13);
    TextDrawHideForPlayer(playerid, Textdraw14);
    TextDrawHideForPlayer(playerid, Textdraw15);
    TextDrawHideForPlayer(playerid, Textdraw16);
    TextDrawHideForPlayer(playerid, Textdraw17);
    //End Of Welcome TextDraw

	TextDrawHideForPlayer(playerid, vSpawns[0]);
	TextDrawHideForPlayer(playerid, vSpawns[1]);
	
	
	// Car teleport
	playerData[playerid][ctpImmune] = true;
	playerData[playerid][abImmune] = true;
	
	// Mask
	playerData[playerid][mask] = false;
	
	// Apply custom skin
    if (playerData[playerid][playerCustomSkin] != -1)
    {
        SetPlayerSkin(playerid, playerData[playerid][playerCustomSkin]);
	}
	
	if (playerData[playerid][hasBackpack])
	{
	    SetPlayerAttachedObject( playerid, 9, 371, 1, 0.048503, -0.112052, -0.021527, 356.659484, 85.123565, 0.000000, 0.919283, 1.000000, 1.000000 ); // gun_para - aest 44
	}
	
	if (playerData[playerid][hasParrot])
	{
	    SetPlayerAttachedObject( playerid, 8, 19078, 3, -0.025633, 0.071474, -0.042353, 152.483703, 170.041259, 353.874603, 1.000000, 1.000000, 1.000000 ); // TheParrot1 - aest 5
	}
	
	TextDrawHideForPlayer(playerid, bankTD);
	PlayerTextDrawHide(playerid, playerData[playerid][classSelect][0]);
	PlayerTextDrawHide(playerid, playerData[playerid][classSelect][1]);
	PlayerTextDrawHide(playerid, playerData[playerid][classSelect][2]);
	PlayerTextDrawHide(playerid, playerData[playerid][classSelect][3]);
	PlayerTextDrawHide(playerid, playerData[playerid][classSelect][4]);
	PlayerTextDrawHide(playerid, playerData[playerid][classSelect][5]);
	PlayerTextDrawHide(playerid, playerData[playerid][classSelect][6]);
	PlayerTextDrawHide(playerid, playerData[playerid][classSelect][7]);
	
	TextDrawHideForPlayer(playerid, dmBox[0]);
	TextDrawHideForPlayer(playerid, dmBox[1]);
	TextDrawHideForPlayer(playerid, dmBox[2]);
	TextDrawHideForPlayer(playerid, dmBox[3]);
	TextDrawHideForPlayer(playerid, dmBox[4]);
	TextDrawHideForPlayer(playerid, dmBox[5]);
	TextDrawHideForPlayer(playerid, dmBox[6]);
	
	PlayerTextDrawHide(playerid, playerData[playerid][dmArena][0]);
	PlayerTextDrawHide(playerid, playerData[playerid][dmArena][1]);
	PlayerTextDrawHide(playerid, playerData[playerid][dmArena][2]);
	PlayerTextDrawHide(playerid, playerData[playerid][dmArena][3]);

	if(playerData[playerid][playerLoggedIn])
	{
		if(playerData[playerid][playerIsSpectating])
		{
			// Fix for weapons with unlimited ammo not working correctly after specoff
		    ResetPlayerWeapons(playerid);
		    
			for (new i = 0; i < 13; i++)
			{
				if(playerData[playerid][previousWeapons][i])
				{
					GivePlayerWeaponEx(playerid, playerData[playerid][previousWeapons][i], playerData[playerid][previousAmmoLots][i]);
				}
			}

			SetPlayerVirtualWorld(playerid, playerData[playerid][previousVirtualWorld]);
			SetPlayerInterior(playerid, playerData[playerid][previousInteriorWorld]);

			SetPlayerPos(playerid, playerData[playerid][previousX], playerData[playerid][previousY], playerData[playerid][previousZ]);

			SetPlayerHealth(playerid, playerData[playerid][previousHealth]);
			SetPlayerArmour(playerid, playerData[playerid][previousArmour]);

			// Disable admin duty
			if(playerData[playerid][playerAdminDuty])
			{
			    SendClientMessage(playerid, 0xFF0000FF, "You're now an off duty administrator.");
				playerData[playerid][playerAdminDuty] = false;
				SetPlayerHealth(playerid, 100);
				newPlayerColour(playerid);
				TextDrawHideForPlayer(playerid, Text:AdminDuty);
				Delete3DTextLabel(playerData[playerid][playerAdminLabel]);
			}

			playerData[playerid][playerIsSpectating] = false;
		}
		else
		{
		    if (!playerData[playerid][hasSpawned])
		    {
		        if (!playerData[playerid][isInDM])
		        {
					// Reset some vars
					playerData[playerid][hasSpawned] = true;
			        SetPlayerVirtualWorld(playerid, 0);
					SetPlayerInterior(playerid, 0);
					ResetPlayerWeapons(playerid);
					SetPlayerHealth(playerid, 100.0);
					playerData[playerid][playerLastTicket] = -1;
					playerData[playerid][pEnterHouse] = true;
					playerData[playerid][pEnterBusiness] = true;
					playerData[playerid][selectingClass] = false;
			        playerData[playerid][canUseCommands] = true;
					playerData[playerid][canBreakCuffs] = true;
					playerData[playerid][adminWeapon] = false;
					playerData[playerid][playerIsCuffed] = false;
					playerData[playerid][canBreakIn] = true;
					playerData[playerid][isInEvent] = false;

					// Show textdraws
					TextDrawShowForPlayer(playerid, Text:URLTD);
					TextDrawShowForPlayer(playerid, Text:MOTDTD);

					// Untie on spawn
					if (playerData[playerid][playerIsTied])
					{
						playerData[playerid][playerIsTied] = false;
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
						KillTimer(playerData[playerid][untieTimer]);
						
						// Delete the kidnapped label
						if (playerData[playerid][kidnappedLabel])
						{
							Delete3DTextLabel(playerData[playerid][kidnappedLabel]);
						}
					}

					// Apply custom skin
			        if (playerData[playerid][playerCustomSkin] != -1)
			        {
			            SendClientMessage(playerid, 0x33AA33AA, "You have spawned with a custom skin. Type /resetskin to remove the custom skin.");
			            SetPlayerSkin(playerid, playerData[playerid][playerCustomSkin]);
					}

					switch(playerData[playerid][playerClass])
					{

				  		case CLASS_CIVILIAN:
				    	{
			   				SetPlayerColor(playerid, CLASS_CIVILIAN_COLOUR);
				     		SetPlayerWantedLevel(playerid, playerData[playerid][playerWantedLevel]);
				     		SetPlayerTeam(playerid, NO_TEAM);

							newPlayerColour(playerid);
							playerData[playerid][playerCanRape] = true;
							playerData[playerid][playerCanRob] = true;

							switch(playerData[playerid][playerJob])
							{
								case -1:
								{
									new jobList[500];
									format(jobList, sizeof(jobList), "%s\n{D87C3E}Kidnapper {FFFFFF}- Kidnap players for a ransom and XP.", jobList);
									format(jobList, sizeof(jobList), "%s\n{D87C3E}Mechanic {FFFFFF}- Upgrade or repair player vehicles.", jobList);
									format(jobList, sizeof(jobList), "%s\n{D87C3E}Gun Dealer {FFFFFF}- Sell weapons to players for cash.", jobList);
									format(jobList, sizeof(jobList), "%s\n{D87C3E}Rapist {FFFFFF}- Rape players and give them STDs.", jobList);
									format(jobList, sizeof(jobList), "%s\n{D87C3E}Hitman {FFFFFF}Complete hit contracts for cash.", jobList);
                                    format(jobList, sizeof(jobList), "%s\n{D87C3E}Drug Dealer {FFFFFF}Sell weed to players for cash.", jobList);
                                    format(jobList, sizeof(jobList), "%s\n{D87C3E}Terrorist {FFFFFF}- Blow up the jail cells / bank.", jobList);
                                    
									ShowPlayerDialog(playerid, DIALOG_JOBSELECT, DIALOG_STYLE_LIST, "Job Selection", jobList, "Choose", "Close");
								}
								case JOB_MECHANIC:
								{
									playerData[playerid][playerCanRepair] = true;
									playerData[playerid][playerCanFlip] = true;
									playerData[playerid][playerCanNOS] = true;
									playerData[playerid][playerCanREMP] = true;

						     		// weapons
									GivePlayerWeaponEx(playerid, 22, 250); // Pistol
									GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
									GivePlayerWeaponEx(playerid, 30, 250); // AK47
									GivePlayerWeaponEx(playerid, 5, 1); // Bat

									SendClientMessage(playerid, 0x20B2AAAA, "Use /mech to see a list of available commands.");
								}
								case JOB_KIDNAPPER:
								{
									playerData[playerid][playerCanKidnap] = true;

						     		// weapons
									GivePlayerWeaponEx(playerid, 22, 250); // Pistol
									GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
									GivePlayerWeaponEx(playerid, 30, 250); // AK47
									GivePlayerWeaponEx(playerid, 5, 1); // Bat

									SendClientMessage(playerid, 0x20B2AAAA, "Tie players and /kidnap them to earn XP and even a ransom!");
								}
								case JOB_HITMAN:
								{
									// Disable tracker
									PlayerTextDrawHide(playerid, PlayerText:playerData[playerid][playerTracker]);
									playerData[playerid][playerIsTracking] = false;
									KillTimer(playerData[playerid][playerHitmanTrackerTimer]);

						     		// weapons
									GivePlayerWeaponEx(playerid, 22, 250); // Pistol
									GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
									GivePlayerWeaponEx(playerid, 30, 250); // AK47
									GivePlayerWeaponEx(playerid, 5, 1); // Bat

									SendClientMessage(playerid, 0x20B2AAAA, "Use /track to track players on the /hitlist");
								}
								case JOB_PROSTITUTE: // Prostitute
								{
									playerData[playerid][playerJob] = JOB_PROSTITUTE;

						     		// weapons
									GivePlayerWeaponEx(playerid, 22, 250); // Pistol
									GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
									GivePlayerWeaponEx(playerid, 30, 250); // AK47
									GivePlayerWeaponEx(playerid, 5, 1); // Bat
								}
								case JOB_WEAPONDEALER:
								{
						     		// weapons
									GivePlayerWeaponEx(playerid, 22, 250); // Pistol
									GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
									GivePlayerWeaponEx(playerid, 30, 250); // AK47
									GivePlayerWeaponEx(playerid, 5, 1); // Bat

									SendClientMessage(playerid, 0x20B2AAAA, "Use /sellgun to offer weapons to players.");
								}
								case JOB_DRUGDEALER:
								{
						     		// weapons
									GivePlayerWeaponEx(playerid, 22, 250); // Pistol
									GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
									GivePlayerWeaponEx(playerid, 30, 250); // AK47
									GivePlayerWeaponEx(playerid, 5, 1); // Bat

									SendClientMessage(playerid, 0x20B2AAAA, "Use /sellweed while in an ice cream truck to sell drugs to players.");
								}
								case JOB_RAPIST:
								{
						     		// weapons
						     		GivePlayerWeaponEx(playerid, 10, 1); // Dildo
									GivePlayerWeaponEx(playerid, 22, 250); // Pistol
									GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
									GivePlayerWeaponEx(playerid, 30, 250); // AK47
									GivePlayerWeaponEx(playerid, 5, 1); // Bat

									SendClientMessage(playerid, 0x20B2AAAA, "Use /rape to infect players with an STD.");
								}
								case JOB_TERRORIST:
								{
						     		// weapons
									GivePlayerWeaponEx(playerid, 22, 250); // Pistol
									GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
									GivePlayerWeaponEx(playerid, 30, 250); // AK47
									GivePlayerWeaponEx(playerid, 5, 1); // Bat
								}
							}
						}

					    case CLASS_MEDIC:
					    {
					        newPlayerColour(playerid);
			                SendClientMessage(playerid, 0x20B2AAAA, "Use /cure to remove STDs from players and /heal to give health to a player.");

			                KillTimer(playerData[playerid][rehealTimer]);
			                KillTimer(playerData[playerid][recureTimer]);

			                playerData[playerid][canHeal] = true;
			                playerData[playerid][canCure] = true;

		                	SetPlayerTeam(playerid, NO_TEAM);
					    }

						case CLASS_POLICE:
				  		{
				  		    PlayerTextDrawSetString(playerid, playerData[playerid][wantedStars], " ");

				  		    if(playerData[playerid][playerCopTutorial] != 1)
				  		    {
				  		        SetPlayerVirtualWorld(playerid, 2);
								SetPlayerCameraPos(playerid, -1581.7755, 749.6948, 30.6389);
								SetPlayerCameraLookAt(playerid, -1605.5656, 717.6979, 11.9861);

								// Part 1 of the tutorial
								new string[600];
								format(string, sizeof(string), "%s{98B0CD}Police Classes \n", string);
			 					format(string, sizeof(string), "%s{FFFFFF}Playing as a law enforcement officer on this server is similar to other CNR game modes.\n", string);
			 					format(string, sizeof(string), "%s{FFFFFF}For those who aren't familiar with the commands, please see /commands after this tutorial\n", string);
			 					format(string, sizeof(string), "%s{FFFFFF}has concluded. This tutorial will act as a simple guide on how to act whilst playing as a cop.\n\n", string);

			 					format(string, sizeof(string), "%s{FFFFFF}There are 4 LEO classes. These include cop, CIA, FBI and army, \nthough army has seperate rules.", string);
			 					format(string, sizeof(string), "%s{FFFFFF}Each class requires an increased amount of XP,\nwhich can be seen when trying to spawn to a class.\n", string);

								ShowPlayerDialog(playerid, POLICE_TUTORIAL_1, DIALOG_STYLE_MSGBOX, "Police Tutorial - Introduction", string, "Next", "");
				  		    }

				    	    SetPlayerColor(playerid, CLASS_POLICE_COLOUR);
					        SetPlayerWantedLevel(playerid, 0);
					        playerData[playerid][playerCanTaze] = true;
					        playerData[playerid][playerCanArrest] = true;
			         	    playerData[playerid][playerCanCuff] = true;

			         	    // weapons
			         	    GivePlayerWeaponEx(playerid, 3, 1); // Night stick
			         	    GivePlayerWeaponEx(playerid, 22, 250); // Pistol
			         	    GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
			         	    GivePlayerWeaponEx(playerid, 30, 250); // M4
			         	    GivePlayerWeaponEx(playerid, 41, 250); // Spray

							SetPlayerTeam(playerid, TEAM_LEO);
				    	}

						case CLASS_ARMY:
						{
							SetPlayerColor(playerid, CLASS_ARMY_COLOUR);
							SetPlayerWantedLevel(playerid, 0);
					        playerData[playerid][playerCanTaze] = true;
					        playerData[playerid][playerCanArrest] = true;
			         	    playerData[playerid][playerCanCuff] = true;

			         	    // weapons
			         	    GivePlayerWeaponEx(playerid, 3, 1); // Night stick
			         	    GivePlayerWeaponEx(playerid, 22, 250); // Pistol
			         	    GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
			         	    GivePlayerWeaponEx(playerid, 31, 250); // M4
			         	    GivePlayerWeaponEx(playerid, 16, 5); // Grenades
			         	    GivePlayerWeaponEx(playerid, 41, 250); // Spray

							SetPlayerTeam(playerid, TEAM_LEO);
						}

						case CLASS_FBI:
						{
							SetPlayerColor(playerid, CLASS_FBI_COLOUR);
							SetPlayerWantedLevel(playerid, 0);
					        playerData[playerid][playerCanTaze] = true;
					        playerData[playerid][playerCanArrest] = true;
			         	    playerData[playerid][playerCanCuff] = true;

			         	    // weapons
			         	    GivePlayerWeaponEx(playerid, 3, 1); // Night stick
			         	    GivePlayerWeaponEx(playerid, 22, 250); // Pistol
			         	    GivePlayerWeaponEx(playerid, 25, 250); // Shotgun
			         	    GivePlayerWeaponEx(playerid, 31, 250); // M4
			         	    GivePlayerWeaponEx(playerid, 41, 250); // Spray

							SetPlayerTeam(playerid, TEAM_LEO);
						}

						case CLASS_CIA:
						{
							SetPlayerColor(playerid, CLASS_CIA_COLOUR);
							SetPlayerWantedLevel(playerid, 0);
					        playerData[playerid][playerCanTaze] = true;
					        playerData[playerid][playerCanArrest] = true;
			         	    playerData[playerid][playerCanCuff] = true;
			         	    playerData[playerid][playerCanEMP] = true;

			         	    // weapons
			         	    GivePlayerWeaponEx(playerid, 27, 250); // Shotgun
			         	    GivePlayerWeaponEx(playerid, 31, 250); // M4
			         	    GivePlayerWeaponEx(playerid, 23, 250); // Silenced Pistol
			         	    GivePlayerWeaponEx(playerid, 41, 250); // Spray

							SetPlayerTeam(playerid, TEAM_LEO);
						}

						case CLASS_SECRETSERVICE:
						{
							SetPlayerColor(playerid, CLASS_SECRETSERVICE_COLOUR);
							SetPlayerWantedLevel(playerid, 0);
					        playerData[playerid][playerCanTaze] = true;
					        playerData[playerid][playerCanArrest] = true;
			         	    playerData[playerid][playerCanCuff] = true;
			         	    playerData[playerid][playerCanEMP] = true;

			         	    // weapons
			         	    GivePlayerWeaponEx(playerid, 27, 250); // Shotgun
			         	    GivePlayerWeaponEx(playerid, 31, 250); // M4
			         	    GivePlayerWeaponEx(playerid, 23, 250); // Silenced Pistol
			         	    GivePlayerWeaponEx(playerid, 41, 250); // Spray

							SetPlayerTeam(playerid, TEAM_LEO);
						}

			  		}

			  		// Check if the player should be jailed
			  		if (playerData[playerid][playerJailTime] > 0)
			  		{
			  		    // Send player back to jail
			            new MsgAll[255], Name[24];
			            GetPlayerName(playerid, Name, sizeof(Name));
			            sendPlayerJail(playerid, playerData[playerid][playerJailTime], playerid, 0);

			            for(new p; p < MAX_PLAYERS; p++)
			            {
			                new pName[24];
			                GetPlayerName(p, pName, sizeof(pName));

			                if(!strcmp(pName, Name))
			                {
			                    SendClientMessage(p, 0x33AA33AA, "You have been returned to jail [Sentence Incomplete]");
			                }
			                else
			                {
			                    format(MsgAll, sizeof(MsgAll), "{26FF4E}%s (%i) {FFFFFF}Has Been Returned To {FF0000}Jail {6AEE39}[Sentence Incomplete]", Name, playerid);
			                    SendClientMessage(p, COLOR_WHITE, MsgAll);
			                }
						}
			    	}
			    	else
			    	{
			    	    if (playerData[playerid][spawnHouse] != -1)
			    	    {
							SpawnInHouse(playerid);
			    	    }
			    	    else
			    	    {
							new Float:bX, Float:bY, Float:bZ, Float:bA;

							switch(playerData[playerid][playerClass])
							{
							    case CLASS_CIVILIAN:
							    {
							   	 	new rand = random(10);

									switch(rand)
									{
									    case 0: // Downtown
									    {
											bX = -1753.0121;
											bY = 959.8522;
											bZ = 24.8828;
											bA = 178.4489;
										}
										case 1: // Financial (previously Jizzy's)
										{
											bX = -1885.1152;
											bY = 826.8466;
											bZ = 35.1728;
											bA = 45.0794;
										}
										case 2: // Queens
										{
											bX = -2515.1592;
											bY = -25.7249;
											bZ = 25.6172;
											bA = 270.9635;
										}
										case 3: // Train Station
										{
											bX = -1969.24512;
											bY = 137.7370;
											bZ = 27.6875;
											bA = 89.5652;
										}
										case 4: // Wang Cars
										{
											bX = -1955.7535;
											bY = 294.0610;
											bZ = 41.0471;
											bA = 177.5892;
										}
										case 5: // Downtown
										{
											bX = -1753.0121;
											bY = 959.8522;
											bZ = 24.8828;
											bA = 178.4489;
										}
										case 6: // New Burger Shot
										{
											bX = -1737.5981;
											bY = 1088.2644;
											bZ = 45.4453;
											bA = 92.5431;
										}
										case 7: // Opposite Hotel
										{
										    bX = -1761.2441;
										    bY = 886.1064;
											bZ = 25.0859;
											bA = 1.1142;
										}
										case 8: // New Ammunation
										{
										    bX = -2012.8955;
										    bY = 889.6754;
											bZ = 45.4453;
											bA = 270.7117;
										}
										case 9: // Mini games
										{
										    bX = -1559.0730;
										    bY = 1183.0647;
											bZ = 7.1875;
											bA = 91.3203;
										}
									}
							    }

								case CLASS_MEDIC:
								{
									new rand = random(2);

									switch (rand)
									{
									    case 0:
									    {
							   	 			bX = -2656.0061;
							   	 			bY = 635.7116;
							   	 			bZ = 14.4531;
							   	 			bA = 183.0843;
										}

										case 1:
										{
							   	 			bX = -1992.5721;
							   	 			bY = 1041.8290;
							   	 			bZ = 55.7122;
							   	 			bA = 290.5727;
										}
									}
								}

							    case CLASS_POLICE:
							    {
					      			bX = -1587.1221;
					  				bY = 721.9797;
									bZ = -4.9063;
									bA = 213.6375;
							    }

							    case CLASS_FBI:
							    {
					      			bX = -2428.3577;
					  				bY = 502.9266;
									bZ = 30.0781;
									bA = 20.7292;
								}

							    case CLASS_CIA:
							    {
					      			bX = -2428.3577;
					  				bY = 502.9266;
									bZ = 30.0781;
									bA = 20.7292;
								}

							    case CLASS_ARMY:
							    {
					      			bX = -1605.8867;
					  				bY = 285.6808;
									bZ = 7.1875;
									bA = 7.2846;
								}

							    case CLASS_SECRETSERVICE:
							    {
					      			bX = -1757.6335;
					  				bY = 786.7766;
									bZ = 167.6563;
									bA = 269.0399;
								}
							}

					  		SetPlayerPos(playerid, bX, bY, bZ);
					  		SetPlayerFacingAngle(playerid, bA);
						}
					}

					// Remove player from gang when swapping from civi to leo
					if(playerData[playerid][playerClass] != CLASS_CIVILIAN && playerData[playerid][playerGangID] != INVALID_GANG_ID)
					{
						cmd_g(playerid, "leave");
					}

					// Disable admin duty on spawn
					if(playerData[playerid][playerAdminDuty])
					{
					    SendClientMessage(playerid, 0xFF0000FF, "You're now an off duty administrator.");
						playerData[playerid][playerAdminDuty] = false;
						SetPlayerHealth(playerid, 100);
						newPlayerColour(playerid);
						TextDrawHideForPlayer(playerid, Text:AdminDuty);
						Delete3DTextLabel(playerData[playerid][playerAdminLabel]);
					}

					if (playerData[playerid][playerVIPLevel] >= 2)
					{
						if (playerData[playerid][playerVIPLevel] == 2)
						{
					    	SetPlayerArmour(playerid, 50); // Silver
						}
						else
						{
						    SetPlayerArmour(playerid, 99); // Gold
						}
					}

					if (playerData[playerid][playerVIPLevel] >= 2)
					{
					    if (playerData[playerid][vipWeapon] == 0)
					    {
					        SendClientMessage(playerid, 0xFF0000FF, "You haven't selected a spawn weapon, to do so type /vipweapon");
						}
						else
						{
						    switch(playerData[playerid][vipWeapon])
						    {
								case 24: // Deagle
								{
									GivePlayerWeaponEx(playerid, 24, 99999);
									playerData[playerid][vipWeapon] = 24;
								}
								case 31: // M4
								{
									GivePlayerWeaponEx(playerid, 31, 99999);
									playerData[playerid][vipWeapon] = 31;
								}
								case 34: // Sniper
								{
									GivePlayerWeaponEx(playerid, 34, 99999);
									playerData[playerid][vipWeapon] = 34;
								}
								case 26: // Sawnoff
								{
									GivePlayerWeaponEx(playerid, 26, 99999);
									playerData[playerid][vipWeapon] = 26;
								}
								case 9: // Chainsaw
								{
									GivePlayerWeaponEx(playerid, 9, 1);
									playerData[playerid][vipWeapon] = 9;
								}
								case 29: // MP5
								{
									GivePlayerWeaponEx(playerid, 29, 99999);
									playerData[playerid][vipWeapon] = 29;
								}
								case 27: // Combat Shotgun
								{
									GivePlayerWeaponEx(playerid, 27, 99999);
									playerData[playerid][vipWeapon] = 27;
								}
							}
						}
					}

					// Not dead
					playerData[playerid][playerDied] = false;

					// Double XP textdraw
					if(serverInfo[doubleXP])
					{
					    TextDrawShowForPlayer(playerid, doubleXPTD);
					}
					
					// Weapon Skills
					if (playerData[playerid][weaponSkill] == 1)
					{
                        SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 999);
					}
					else
					{
					    SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 0);
					}

					// Easter
					if(serverInfo[huntOn] == 5)
					{
					    TextDrawShowForPlayer(playerid, easterSunday);
					    PlayerTextDrawShow(playerid, playerData[playerid][Eggs][0]);
					    PlayerTextDrawShow(playerid, playerData[playerid][Eggs][1]);
					    PlayerTextDrawShow(playerid, playerData[playerid][Eggs][2]);
					}
					
					// XMAS
					
					if(serverInfo[presentOn] == 5)
					{
					    TextDrawShowForPlayer(playerid, xmasDay);
					}

					// Remove some labels
					Delete3DTextLabel(playerData[playerid][weedLabel]);

					// Anti-spawn kill
					if (playerData[playerid][playerJailTime] < 1)
					{
						SetPlayerHealth(playerid, 5000.0);
						playerData[playerid][spawnLabel] = Create3DTextLabel("JUST SPAWNED", 0xFFDC2EFF, 30.0, 40.0, 50.0, 60.0, -1, 1);
		        		Attach3DTextLabelToPlayer(playerData[playerid][spawnLabel], playerid, 0.0, 0.0, 0.4);
		        		SetTimerEx("AntiSpawnkill", 5000, 0, "i", playerid);
					}

	        		// Money
	        		ResetPlayerMoney(playerid);
	        		GivePlayerMoney(playerid, playerData[playerid][playerMoney]);

	        		// Trucking
					playerData[playerid][canTruck] = true;
					KillTimer(playerData[playerid][retruckTimer]);
				}
				else // is in a dm event
				{
					SetPlayerHealth(playerid, 10000.0);
					Delete3DTextLabel(playerData[playerid][spawnLabel]);
					playerData[playerid][spawnLabel] = Create3DTextLabel("SPAWN PROTECTED", 0xFFDC2EFF, 30.0, 40.0, 50.0, 40.0, 0);
	        		Attach3DTextLabelToPlayer(playerData[playerid][spawnLabel], playerid, 0.0, 0.0, 0.4);
	        		SetTimerEx("AntiSpawnkill", 1500, 0, "i", playerid);
				    
					new randSpawn = random(8);
					switch(randSpawn)
					{
						case 0:
						{
							SetPlayerPos(playerid, -1129.8909, 1057.5424, 1346.4141);
						}
						case 1:
						{
							SetPlayerPos(playerid, -974.1805, 1077.0630, 1344.9895);
						}
						case 2:
						{
							SetPlayerPos(playerid, -997.8885, 1096.0400, 1342.6517);
						}
						case 3:
						{
							SetPlayerPos(playerid, -1036.1115, 1024.3964, 1343.3551);
						}
						case 4:
						{
							SetPlayerPos(playerid, -1075.6144, 1032.7413, 1342.7317);
						}
						case 5:
						{
							SetPlayerPos(playerid, -1085.2362, 1053.7657, 1343.3536);
						}
						case 6:
						{
							SetPlayerPos(playerid, -1101.0815, 1084.6434, 1341.8438);
						}
						case 7:
						{
							SetPlayerPos(playerid, -1093.1536, 1058.8173, 1341.3516);
						}
					}
					
					// No team during DM
					SetPlayerTeam(playerid, NO_TEAM);
					
					SetPlayerInterior(playerid, 10);
					SetPlayerVirtualWorld(playerid, 169);

					playerData[playerid][isInDM] = true; // Prevent scores etc - also respawn
					playerData[playerid][isInEvent] = true;
					playerData[playerid][adminWeapon] = true; // Prevent anti-cheat kick
					GivePlayerWeaponEx(playerid, 31, 50000);

					TextDrawShowForPlayer(playerid, dmBox[0]);
					TextDrawShowForPlayer(playerid, dmBox[1]);
					TextDrawShowForPlayer(playerid, dmBox[2]);
					TextDrawShowForPlayer(playerid, dmBox[3]);
					TextDrawShowForPlayer(playerid, dmBox[4]);
					TextDrawShowForPlayer(playerid, dmBox[5]);
					TextDrawShowForPlayer(playerid, dmBox[6]);
					
					PlayerTextDrawShow(playerid, playerData[playerid][dmArena][0]);
					PlayerTextDrawShow(playerid, playerData[playerid][dmArena][1]);
					PlayerTextDrawShow(playerid, playerData[playerid][dmArena][2]);
					PlayerTextDrawShow(playerid, playerData[playerid][dmArena][3]);
					
					dmStats(playerid);
					
					SendClientMessage(playerid, 0x33AA33AA, "You've respawned into the DM event type /leavedm to leave the arena.");

				    newPlayerColour(playerid);
				    playerData[playerid][hasSpawned] = true;
				    playerData[playerid][playerDied] = false;
				}
			}
		}
	}
	else // Must login before spawning
	{
        SendClientMessage(playerid, 0xFF0000FF, "You cannot spawn without logging in!");
	    return 0;
	}

	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    // Death Stadium System
	if(InDMS[playerid] == 1)
	{
		if(playerData[killerid][playerClass] == CLASS_CIVILIAN)
		{
        // Showing GameText To Killer Player
        new kill[250];
        format(kill, sizeof(kill), "~p~KILLED ~b~%s (%d)", playerData[playerid][playerNamee], playerid);
		GameTextForPlayer(killerid, kill ,3000,3);
        // END
        playerData[killerid][dmKills]++;
  		playerData[killerid][dmStreak]++;
    	dmStats(killerid);
        // Showing GameText To Killed Player
        new killed[250];
        format(killed, sizeof(killed), "~r~KILLED BY ~b~%s ~n~(%d)", playerData[killerid][playerNamee], killerid);
		GameTextForPlayer(playerid, killed ,3000,3);
        // END

	    SetPlayerWantedLevel(killerid, playerData[killerid][playerWantedLevel] + 0);
		InDMS[playerid]=1;
  		return 1;
  		}
	}
	// END

    playerData[playerid][hasSpawned] = false;
	playerData[playerid][ctpImmune] = true;
	playerData[playerid][abImmune] = true;
    
    // Easter
    PlayerTextDrawHide(playerid, playerData[playerid][Eggs][0]);
    PlayerTextDrawHide(playerid, playerData[playerid][Eggs][1]);
    PlayerTextDrawHide(playerid, playerData[playerid][Eggs][2]);
    
    
    if (playerData[playerid][isInDM])
    {
		playerData[playerid][hasSpawned] = false;
		playerData[playerid][suicide] = false;
		
		if (killerid != INVALID_PLAYER_ID)
		{
		    playerData[killerid][dmKills]++;
		    playerData[killerid][dmStreak]++;
		    dmStats(killerid);
		    
			new randDeath = random(21), randomDeath[200];
			switch(randDeath)
			{
			    case 0:
			    {
					format(randomDeath, sizeof(randomDeath), "eliminated");
				}
				case 1:
				{
				    format(randomDeath, sizeof(randomDeath), "fucked up");
				}
				case 2:
				{
				    format(randomDeath, sizeof(randomDeath), "raped");
				}
				case 3:
				{
				    format(randomDeath, sizeof(randomDeath), "put some lead into");
				}
				case 4:
				{
				    format(randomDeath, sizeof(randomDeath), "gave a lead tattoo to");
				}
				case 5:
				{
				    format(randomDeath, sizeof(randomDeath), "delivered some bullets to");
				}
	  			case 6:
				{
				    format(randomDeath, sizeof(randomDeath), "said hello to");
				}
	  			case 7:
				{
				    format(randomDeath, sizeof(randomDeath), "delivered some bullets first class to");
				}
	  			case 8:
				{
				    format(randomDeath, sizeof(randomDeath), "slayed");
				}
	  			case 9:
				{
				    format(randomDeath, sizeof(randomDeath), "mortalized");
				}
	  			case 10:
				{
				    format(randomDeath, sizeof(randomDeath), "dropped");
				}
	  			case 11:
				{
				    format(randomDeath, sizeof(randomDeath), "pwn3d");
				}
	  			case 12:
				{
				    format(randomDeath, sizeof(randomDeath), "unleashed the pain on");
				}
	  			case 13:
				{
				    format(randomDeath, sizeof(randomDeath), "avada kedavra'd");
				}
	  			case 14:
				{
				    format(randomDeath, sizeof(randomDeath), "humiliated");
				}
	  			case 15:
				{
				    format(randomDeath, sizeof(randomDeath), "broke");
				}
	  			case 16:
				{
				    format(randomDeath, sizeof(randomDeath), "popped");
				}
	  			case 17:
				{
				    format(randomDeath, sizeof(randomDeath), "sends their regards to");
				}
	  			case 18:
				{
				    format(randomDeath, sizeof(randomDeath), "now owns");
				}
	  			case 19:
				{
				    format(randomDeath, sizeof(randomDeath), "used a classified move on");
				}
	  			case 20:
				{
				    format(randomDeath, sizeof(randomDeath), "ended");
				}
			}

			for (new i=0; i<MAX_PLAYERS; i++)
			{
				if(playerData[i][isInDM])
				{
					new dmKill[100];
					format(dmKill, sizeof(dmKill), "{FAAC58}%s (%i) {FFFFFF}%s {FAAC58}%s (%i)", playerData[killerid][playerNamee], killerid, randomDeath, playerData[playerid][playerNamee], playerid);
					SendClientMessage(i, COLOR_WHITE, dmKill);
				}
			}
		}
		
	    playerData[playerid][dmDeaths]++;
	    playerData[playerid][dmStreak] = 0;
		KillTimer(playerData[playerid][streakTimer]);
		disableStreak(playerid);
	    dmStats(playerid);
    }
    else
    {
		if(!playerData[playerid][playerDied])
		{
			new vid = GetPlayerVehicleID(killerid);

	        if (killerid != INVALID_PLAYER_ID && GetPlayerWeapon(killerid) != reason && reason != 54 && reason != 50 && reason != 53 && !playerData[playerid][suicide] && GetVehicleModel(vid) != 520 && GetVehicleModel(vid) != 447)
	        {
	            if (reason == 49 && IsPlayerInAnyVehicle(killerid))
	            {
					return 1;
				}

	            else if (reason == 51 && IsPlayerInAnyVehicle(playerid))
	            {
					return 1;
				}
				
				else
				{
					new string[600];

					format(string, sizeof(string), "%s{98B0CD}Invalid Death Detected \n", string);
					format(string, sizeof(string), "%s{FFFFFF}The server does not recognise the reason for your death. \n", string);
					format(string, sizeof(string), "%s{FFFFFF}To prevent stat loss, we have an anti-fake kill system in place. \n\n", string);
					format(string, sizeof(string), "%s{FFFFFF}If you have respawned at the bank with no weapons, click respawn. \n\n", string);

					ShowPlayerDialog(playerid, DIALOG_FORCE_RESPAWN, DIALOG_STYLE_MSGBOX, "", string, "RESPAWN", "CANCEL");
					
					return 0;
				}
	        }

		    SendDeathMessage(killerid, playerid, reason);

		    if(playerData[playerid][playerLoggedIn])
			{
			    if(playerData[playerid][isInEvent])
			    {
			        playerData[playerid][isInEvent] = false;
			        playerData[playerid][hasSpawned] = false;
			        newPlayerColour(playerid);
		 			playerData[playerid][playerDeaths]++;
			    	playerData[playerid][playerWantedLevel] = 0;
			    	SetPlayerWantedLevel(playerid, 0);
			    	playerData[playerid][hasSTD] = false;
			    	KillTimer(playerData[playerid][rapedTimer]);
				}
				else
				{
			        if(IsPlayerConnected(killerid))
			        {
			            if(playerData[killerid][playerLoggedIn])
			            {
			                playerData[killerid][playerKills] = playerData[killerid][playerKills] + 1;
							playerData[killerid][playerScore] = playerData[killerid][playerScore] + 1;
							SetPlayerScore(killerid, playerData[killerid][playerScore]);

							playerGiveXP(playerid, 5);

							if (playerData[killerid][playerKills] == 1)
							{
							    disableAchieve(killerid);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve1]);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve2]);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve3]);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve4]);

								PlayerTextDrawSetString(killerid, playerData[killerid][Achieve3], "First Kill");
								PlayerTextDrawSetString(killerid, playerData[killerid][Achieve4], "You killed your first victim. Well done.");
								PlayerPlaySound(killerid, 1183 ,0.0, 0.0, 0.0);

								playerData[playerid][achieveTimer] = SetTimerEx("disableAchieve", 8000, false, "i", killerid);

								// XP/SCORE AWARD
								playerGiveXP(playerid, 50);
								playerData[playerid][playerScore] = playerData[playerid][playerScore] + 2;
								SetPlayerScore(playerid, playerData[playerid][playerScore]);
							}
							else if (playerData[killerid][playerKills] == 50)
							{
							    disableAchieve(killerid);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve1]);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve2]);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve3]);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve4]);

								PlayerTextDrawSetString(killerid, playerData[killerid][Achieve3], "San Fierro Killer");
								PlayerTextDrawSetString(killerid, playerData[killerid][Achieve4], "You've killed 50 players! Nice!");
								PlayerPlaySound(killerid, 1183 ,0.0, 0.0, 0.0);

								playerData[playerid][achieveTimer] = SetTimerEx("disableAchieve", 8000, false, "i", killerid);

								// XP/SCORE AWARD
								playerGiveXP(playerid, 50);
								playerData[playerid][playerScore] = playerData[playerid][playerScore] + 2;
								SetPlayerScore(playerid, playerData[playerid][playerScore]);
							}
							else if (playerData[killerid][playerKills] == 500)
							{
							    disableAchieve(killerid);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve1]);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve2]);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve3]);
								PlayerTextDrawShow(killerid, playerData[killerid][Achieve4]);

								PlayerTextDrawSetString(killerid, playerData[killerid][Achieve3], "Mass Murderer");
								PlayerTextDrawSetString(killerid, playerData[killerid][Achieve4], "500 kills attained. You require medical assistance.");
								PlayerPlaySound(killerid, 1183 ,0.0, 0.0, 0.0);

								playerData[playerid][achieveTimer] = SetTimerEx("disableAchieve", 8000, false, "i", killerid);

								// XP/SCORE AWARD
								playerGiveXP(playerid, 50);
								playerData[playerid][playerScore] = playerData[playerid][playerScore] + 2;
								SetPlayerScore(playerid, playerData[playerid][playerScore]);
							}

							if(playerData[killerid][playerClass] == CLASS_CIVILIAN || playerData[killerid][playerClass] == CLASS_MEDIC)
							{
								new message[500];
								playerData[killerid][playerWantedLevel] = playerData[killerid][playerWantedLevel] + 12;
								SetPlayerWantedLevel(killerid, playerData[killerid][playerWantedLevel] + 12);
								format(message, sizeof(message), "Commited A Crime: Murder, Killed %s (%i)", playerData[playerid][playerNamee], playerid, playerData[killerid][playerWantedLevel]);
								SendClientMessage(killerid, 0xFF0000FF, message);
								sendWantedMessage(killerid, 12);
								newPlayerColour(killerid);

								if(playerData[killerid][playerJob] == JOB_HITMAN && playerData[killerid][playerClass] != CLASS_MEDIC)
								{
									if(playerData[playerid][playerHitValue] > 0)
									{
									    playerData[killerid][hitsCompleted] = playerData[killerid][hitsCompleted] + 1;
										playerGiveMoney(killerid, playerData[playerid][playerHitValue]);
										format(message, sizeof(message), "{00FF22}%s (%i) {FFFFFF}Has Completed {F81414}Hit Contract {FFFFFF}On {00FF22}%s (%i) {FFFFFF}And earnt {00FF22}$%s", playerData[killerid][playerNamee], killerid, playerData[playerid][playerNamee], playerid, FormatNumber(playerData[playerid][playerHitValue]));
										SendClientMessageToAll(COLOR_WHITE, message);

										new loggingString[256];
										format(loggingString, sizeof(loggingString), "%s completed the contract on %s for %d.", playerData[killerid][playerNamee], playerData[playerid][playerNamee], playerData[playerid][playerHitValue]);
										writeInLog("contractLog.html", loggingString);

										playerData[playerid][playerHitValue] = 0;

										if (playerData[killerid][hitsCompleted] == 1)
										{
										    disableAchieve(killerid);
											PlayerTextDrawShow(killerid, playerData[killerid][Achieve1]);
											PlayerTextDrawShow(killerid, playerData[killerid][Achieve2]);
											PlayerTextDrawShow(killerid, playerData[killerid][Achieve3]);
											PlayerTextDrawShow(killerid, playerData[killerid][Achieve4]);

											PlayerTextDrawSetString(killerid, playerData[killerid][Achieve3], "Contract Killer");
											PlayerTextDrawSetString(killerid, playerData[killerid][Achieve4], "You completed your first hit contract!");
											PlayerPlaySound(killerid, 1183 ,0.0, 0.0, 0.0);

											playerData[playerid][achieveTimer] = SetTimerEx("disableAchieve", 8000, false, "i", killerid);

											// XP/SCORE AWARD
											playerGiveXP(playerid, 50);
											playerData[playerid][playerScore] = playerData[playerid][playerScore] + 2;
											SetPlayerScore(playerid, playerData[playerid][playerScore]);
										}

										if (playerData[killerid][hitsCompleted] == 20)
										{
										    disableAchieve(killerid);
											PlayerTextDrawShow(killerid, playerData[killerid][Achieve1]);
											PlayerTextDrawShow(killerid, playerData[killerid][Achieve2]);
											PlayerTextDrawShow(killerid, playerData[killerid][Achieve3]);
											PlayerTextDrawShow(killerid, playerData[killerid][Achieve4]);

											PlayerTextDrawSetString(killerid, playerData[killerid][Achieve3], "Professional Hitman");
											PlayerTextDrawSetString(killerid, playerData[killerid][Achieve4], "You completed 20 hit contracts!");
											PlayerPlaySound(killerid, 1183 ,0.0, 0.0, 0.0);

											playerData[playerid][achieveTimer] = SetTimerEx("disableAchieve", 8000, false, "i", killerid);

											// XP/SCORE AWARD
											playerGiveXP(playerid, 50);
											playerData[playerid][playerScore] = playerData[playerid][playerScore] + 2;
											SetPlayerScore(playerid, playerData[playerid][playerScore]);
										}
									}
								}

								playerData[killerid][playerLastKill] = GetTickCount();
				           	}

							if(playerData[playerid][playerClass] == CLASS_CIVILIAN || playerData[playerid][playerClass] == CLASS_MEDIC)
							{
							    newPlayerColour(playerid);
							}

				           	if(playerData[killerid][playerClass] == CLASS_POLICE || playerData[killerid][playerClass] == CLASS_ARMY || playerData[killerid][playerClass] == CLASS_CIA || playerData[killerid][playerClass] == CLASS_FBI || playerData[killerid][playerClass] == CLASS_SECRETSERVICE)
				           	{
				           	    if(playerData[playerid][playerWantedLevel] == 0)
								{
									if (!playerData[playerid][suicide])
									{
										if (playerData[killerid][playerClass] == CLASS_POLICE || playerData[killerid][playerClass] == CLASS_FBI || playerData[killerid][playerClass] == CLASS_CIA || playerData[killerid][playerClass] == CLASS_SECRETSERVICE)
										{
										    playerData[killerid][innocentKills]++;

										    if (playerData[killerid][innocentKills] > 2)
										    {
										        playerGiveMoney(killerid, -5000);
											}

										    if (playerData[killerid][innocentKills] == 5)
										    {
										        // Cop class ban

												ForceClassSelection(killerid);
												TogglePlayerSpectating(killerid, true);
												TogglePlayerSpectating(killerid, false);

										        playerData[killerid][playerCopBanned] = 1;

	  								        }
											else
											{
											    SetPlayerHealth(killerid, 0.0);
											}

											print("cop");
										}

										if (playerData[killerid][playerClass] == CLASS_ARMY)
										{
										    playerData[killerid][aInnocentKills]++;
										    playerGiveMoney(killerid, -5000);

										    if (playerData[killerid][aInnocentKills] == 3)
										    {
										        // Army class ban

												ForceClassSelection(killerid);
												TogglePlayerSpectating(killerid, true);
												TogglePlayerSpectating(killerid, false);

										        playerData[killerid][playerArmyBanned] = 1;

											}
											else
											{
											    SetPlayerHealth(killerid, 0.0);
											}

											print("army");
										}

										closeDialogs(killerid);

										PlayerTextDrawShow(killerid, playerData[killerid][InnocentKill1]);
										PlayerTextDrawShow(killerid, playerData[killerid][InnocentKill2]);
										PlayerTextDrawShow(killerid, playerData[killerid][InnocentKill3]);
										PlayerTextDrawShow(killerid, playerData[killerid][InnocentKill4]);
										PlayerTextDrawShow(killerid, playerData[killerid][InnocentKill5]);
										PlayerTextDrawShow(killerid, playerData[killerid][InnocentKill6]);
										PlayerTextDrawShow(killerid, playerData[killerid][InnocentKill7]);
										PlayerTextDrawShow(killerid, playerData[killerid][InnocentKill8]);
									}
				           	    }
				           	    else if(playerData[playerid][playerWantedLevel] > 0)
				           	    {
									new message[128], earnings;
									earnings = (playerData[playerid][playerWantedLevel] * 200);
									format(message, sizeof(message), "You killed %s (%i) who had a wanted level of %i, you earned $%s!", playerData[playerid][playerNamee], playerid, playerData[playerid][playerWantedLevel], FormatNumber(earnings));
				           	        SendClientMessage(killerid, 0x33AA33AA, message);
									playerGiveMoney(killerid, earnings);

									playerGiveXP(killerid, 5);
									playerData[killerid][copKills] = playerData[killerid][copKills] + 1;

									new loggingString[256];
									format(loggingString, sizeof(loggingString), "%s killed %s for %d.", playerData[killerid][playerNamee], playerData[playerid][playerNamee], earnings);
									writeInLog("copKillLog.html", loggingString);
				           	    }
				           	}
						}
					}

					if(playerData[playerid][iscourier])
					{
						SendClientMessage(playerid, 0xFF0000FF, "You died, the mission was cancelled.");
						playerData[playerid][iscourier] = false;
						playerData[playerid][playerCourierLevel] = 0;
						DisablePlayerCheckpoint(playerid);
					}

					if (playerData[playerid][truckingStatus] > 0)
					{
						return cmd_canceltrucking(playerid, "");
					}

					if (playerData[playerid][forkliftStatus] > 0)
					{
						return cmd_cancelforklift(playerid, "");
					}

					if (playerData[playerid][busStatus] > 0)
					{
						return cmd_cancelroute(playerid, "");
					}

					playerData[playerid][playerDeaths]++;
					playerData[playerid][playerDied] = true;
			    	playerData[playerid][playerWantedLevel] = 0;
			    	SetPlayerWantedLevel(playerid, 0);
			    	playerData[playerid][hasSTD] = false;
		            KillTimer(playerData[playerid][rapedTimer]);
		            KillTimer(playerData[playerid][uncuffTimer]);
					playerData[playerid][playerIsTied] = false;
					SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
					KillTimer(playerData[playerid][untieTimer]);
					playerData[playerid][hasSpawned] = false;
					playerData[playerid][suicide] = false;

					if (!playerData[playerid][healthInsurance])
					{
						taxplayer(playerid);
					}
			    }
		    }
		}
	}
	
	return 1;
}

public OnPlayerText(playerid, text[])
{
	// Fuel Station Responses
	
	// Refueling
	if(text[0] == '1' && Textdraw[playerid] == 0)
	{
	if(IsPlayerInRangeOfPoint(playerid,1.0,-1675.9982,413.3128,7.1797))
	{
	if(!IsPlayerInAnyVehicle(playerid))
 	{
	SendClientMessage(playerid,0xFF0000FF,"You Need To Be on A Vehicle To Perform This Task.");
	return false;
	}
	if(playerData[playerid][playerMoney] > 100)
	{
	playerGiveMoney(playerid, -100);
	//
	SetCameraBehindPlayer(playerid);
 	TogglePlayerControllable(playerid,0);
  	isrefuelling[playerid] = 1;
  	GameTextForPlayer(playerid,"~r~REFUELLING PLEASE WAIT",4500,3);
    SetTimerEx("timer_refuel",4500,false,"i",playerid); //setting refueltimer
	//
	}else SendClientMessage(playerid, 0xFF0000FF, "You Don't Have Enough Money To Complete This Task.");
    return false;
	}
	}
	// Repairing
	if(text[0] == '2' && Textdraw[playerid] == 0)
	{
	if(IsPlayerInRangeOfPoint(playerid,1.0,-1675.9982,413.3128,7.1797))
	{
	if(!IsPlayerInAnyVehicle(playerid))
 	{
	SendClientMessage(playerid,0xFF0000FF,"You Need To Be on A Vehicle To Perform This Task.");
	return false;
	}
	if(playerData[playerid][playerMoney] > 150)
	{
	playerGiveMoney(playerid,-150);
	new VehicleID = GetPlayerVehicleID(playerid);
	RepairVehicle(VehicleID);
	SetVehicleHealth(VehicleID, 1000);
	SendClientMessage(playerid,0x20B2AAAA,"Your Vehicle Has Been Repair in $500");
	}else SendClientMessage(playerid, 0xFF0000FF, "You Don't Have Enough Money To Complete This Task.");
    return false;
	}
	}
	// Removing Neons
	if(text[0] == '3' && Textdraw[playerid] == 0)
	{
	if(IsPlayerInRangeOfPoint(playerid,1.0,-1675.9982,413.3128,7.1797))
	{
	if(!IsPlayerInAnyVehicle(playerid))
 	{
	SendClientMessage(playerid,0xFF0000FF,"You Need To Be on A Vehicle To Perform This Task.");
	return false;
	}
	if(playerData[playerid][playerMoney] > 200)
	{
	playerGiveMoney(playerid,-200);
	// Removing Neons
	DestroyObject(GetPVarInt(playerid, "neon"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon1"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon2"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon3"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon4"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon5"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon6"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon7"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon8"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon9"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon10"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon11"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon12"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "neon13"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "interior"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "interior1"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "back"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "back1"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "front"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "front1"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "undercover"));
	DeletePVar(playerid, "Status");
	DestroyObject(GetPVarInt(playerid, "undercover1"));
	DeletePVar(playerid, "Status");
	// Removed All Neons
	SendClientMessage(playerid,0x20B2AAAA,"Neons Sussessfully Removed From Your Vehicle in $200");
	}else SendClientMessage(playerid, 0xFF0000FF, "You Don't Have Enough Money To Complete This Task.");
    return false;
	}
	}
	// END

	if(playerData[playerid][playerLoggedIn])
	{
	    if(text[0] == '@' && playerData[playerid][playerLevel] >= 1)
		{
	 	    new string[128];
	 		GetPlayerName(playerid, string, sizeof(string));
	        format(string, sizeof(string), "{FF00FF}[Admin Chat] {FFFFFF}%s: %s", string, text[1]);
			adminchat(COLOR_WHITE, string);
	        return 0;
	    }
	    else if(text[0] == '#' && playerData[playerid][playerHelper] == 1)
		{
	 	    new string[128];
	 		GetPlayerName(playerid, string, sizeof(string));
	        format(string, sizeof(string), "{A5DF00}[Helper Chat] {FFFFFF}%s: %s", string, text[1]);
			helperchat(COLOR_WHITE, string);
	        return 0;
	    }
	    else
	    {
			if (playerData[playerid][playerMuteTime] != 0)
			{
			    new message[128];
				format(message, sizeof(message), "You are muted for another %i seconds and cannot talk!", playerData[playerid][playerMuteTime]);
				SendClientMessage(playerid, 0xFF0000FF, message);
				return 0;
			}
			else
			{
			    if (FindIP(text))
			    {
		            SendClientMessage(playerid, 0xFF0000FF, "Advert detected! If this occurs frequently, you will be kicked.");
		            playerData[playerid][adDetected]++;

		            if (playerData[playerid][adDetected] == 2)
		            {
		                // Kick
		                KickWithMessage(playerid, "You have been kicked for advertising.");
		            }

		            return 0;
				}
			    if (playerData[playerid][messageCount] != 3)
			    {
					new chat[400], color[20];

					switch(playerData[playerid][playerClass])
					{
						case 0, 6:
						{
							if(playerData[playerid][playerWantedLevel] == 0)
							{
								if (playerData[playerid][vipColour])
								{
									color = "58D3F7";
								}
								else
								{
									if(playerData[playerid][playerClass] == CLASS_MEDIC)
									{
										// Medic Colour
									    color = "F78181";
									}
									else
									{
										// White Wanted Level
										color = "FFFFFF";
									}
								}
							}

							if (playerData[playerid][playerWantedLevel] >= 1)
							{
								// Yellow Wanted Level
								color = "FFEC41";
							}

							if(playerData[playerid][playerWantedLevel] >= 6)
							{
								// Orange Wanted Level
								color = "FF0000";
							}
							
							if(playerData[playerid][playerWantedLevel] >= 12)
							{
								// Red Wanted Level
							    color = "FF0000";
							}

						}

						case 1: // Police
						{
							if (playerData[playerid][vipColour])
							{
								color = "58D3F7";
							}
							else
							{
								color = "4545F2";
							}
						}
						case 2: // FBI
						{
							if (playerData[playerid][vipColour])
							{
								color = "58D3F7";
							}
							else
							{
								color = "4545F2";
							}
						}
						case 3: // CIA
						{
							if (playerData[playerid][vipColour])
							{
								color = "58D3F7";
							}
							else
							{
								color = "FFFFFF";
							}
						}
						case 4: // Army
						{
							if (playerData[playerid][vipColour])
							{
								color = "556B2F";
							}
							else
							{
								color = "4A6A29";
							}
						}
						case 7: // Secret Service
						{
							if (playerData[playerid][vipColour])
							{
								color = "58D3F7";
							}
							else
							{
								color = "E694CA";
							}
						}
					}
					//
					if(InDMS[playerid] == 1)
					{
		   				color = "5ADE8B";
  					}
					//
					if (playerData[playerid][playerAdminDuty]) // Admin On Duty
					{
					    color = "FF00FF";
					}
					
					if (playerData[playerid][useAdminName])
					{
					    format(chat, sizeof(chat),"{%s}%s: {FFFFFF}%s", color, playerData[playerid][tempAdminName], text);
					}
					else
					{
						format(chat, sizeof(chat),"{%s}%s: {FFFFFF}%s", color, playerData[playerid][playerNamee], text);
					}
					
					SendClientMessageToAll(COLOR_WHITE, chat);

					playerData[playerid][messageCount]++;
					KillTimer(playerData[playerid][spamTimer]);
					playerData[playerid][spamTimer] = SetTimerEx("StopSpam", 3000, false, "i", playerid);
				}
				else
				{
				    SendClientMessage(playerid, 0xFF0000FF, "Please wait a moment before sending another message.");
				}
		    }
		}
	}
	return 0;
}

stock adminchat(color, const msg[])
{
    for (new i=0; i<MAX_PLAYERS; i++)
    {
        if (playerData[i][playerLevel] >= 1)
	    {
	        SendClientMessage(i, color, msg);
	    }
    }
}

stock helperchat(color, const msg[])
{
    for (new i=0; i<MAX_PLAYERS; i++)
    {
        if (playerData[i][playerHelper] == 1)
	    {
	        SendClientMessage(i, color, msg);
	    }
    }
}

stock policechat(color, const msg[])
{
    for (new i=0; i<MAX_PLAYERS; i++)
    {
        if (playerData[i][playerClass] == CLASS_POLICE  || playerData[i][playerClass] == CLASS_ARMY || playerData[i][playerClass] == CLASS_CIA || playerData[i][playerClass] == CLASS_FBI)
	    {
	        SendClientMessage(i, color, msg);
	    }
    }
}

public OnPlayerCommandReceived(playerid, cmdtext[])
{
    if(playerData[playerid][canUseCommands] || playerData[playerid][playerLevel] >= 1)
    {
		if(playerData[playerid][hasSpawned] || playerData[playerid][playerLevel] >= 1)
		{
		    playerData[playerid][canUseCommands] = false;
		    playerData[playerid][commandTimer] = SetTimerEx("command", 1020, false, "i", playerid);

			new loggingString[256];
			format(loggingString, sizeof(loggingString), "%s used command: %s", playerData[playerid][playerNamee], cmdtext);
			writeInLog("commandLog.html", loggingString);

		    return 1;
		}
		else
		{
		    SendClientMessage(playerid, 0xFF0000FF, "You cannot use commands while you're not spawned.");
	        return 0;
		}
	}
	else
	{
 		SendClientMessage(playerid, 0xFF0000FF, "Please wait before using another command.");
 		return 0;
	}
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success){
    if (!success) return SendClientMessage(playerid, 0xFF0000FF, "Unknown command. Type /cmds for a list of commands or /help for guides.");
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    ac_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
    
	if(playerData[playerid][playerPreviousVehicles][0] && playerData[playerid][playerPreviousVehicles][1] && playerData[playerid][playerPreviousVehicles][2])
	{
		new totalTime =

		(playerData[playerid][playerPreviousVehicles][2] - playerData[playerid][playerPreviousVehicles][1]) +
		(playerData[playerid][playerPreviousVehicles][1] - playerData[playerid][playerPreviousVehicles][0]) +
		(playerData[playerid][playerPreviousVehicles][0] - GetTickCount());

		if(totalTime < 2000)
		{
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i) && playerData[i][playerLevel] >= 1)
				{
					new message[200];
					format(message, sizeof(message), "[CHEAT REPORT] %s (%i) is suspected of car warping.", playerData[playerid][playerNamee], playerid);
					SendClientMessage(i, 0xFF40FFFF, message);
				}
			}

			KickWithMessage(playerid, "You have been kicked due to car warping.");
		}
	}

	if (playerData[playerid][truckingStatus] > 0)
	{
	    if(GetVehicleModel(vehicleid) == 515 || GetVehicleModel(vehicleid) == 414)
	    {
			// Player re-entered truck
            KillTimer(playerData[playerid][truckExitTimer]);

			PlayerTextDrawSetString(playerid, playerData[playerid][playerTruckingWaitTD], " ");
			PlayerTextDrawSetString(playerid, playerData[playerid][playerTruckingTD], " ");
			playerData[playerid][truckCounter] = 10;
		}
	}

	if(playerData[playerid][playerPreviousVehicles][1])
	{
		playerData[playerid][playerPreviousVehicles][1] = playerData[playerid][playerPreviousVehicles][2];
	}

	if(playerData[playerid][playerPreviousVehicles][0])
	{
		playerData[playerid][playerPreviousVehicles][0] = playerData[playerid][playerPreviousVehicles][1];
	}

	playerData[playerid][playerPreviousVehicles][0] = GetTickCount();
	playerData[playerid][playerLastVehicleID] = vehicleid;
	
	//enterVehicle(playerid, playerData[playerid][actualID], vehicleid);

    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(playerData[playerid][iscourier])
	{
		// Cancel the job
		SendClientMessage(playerid, 0xFF0000FF, "You left your vehicle, mission cancelled.");
		playerData[playerid][iscourier] = false;
		playerData[playerid][playerCourierLevel] = 0;
		RemovePlayerMapIcon(playerid, 90);
		DestroyDynamicRaceCP(playerData[playerid][playerLastCourierCP]);
		TextDrawHideForPlayer(playerid, TDCourier2);
		TextDrawHideForPlayer(playerid, TDCourier);
		KillTimer(playerData[playerid][courierTimer]);
		TogglePlayerControllable(playerid, 1);
		DisablePlayerCheckpoint(playerid);
		KillTimer(playerData[playerid][courierDistance]);
		PlayerTextDrawSetString(playerid, playerData[playerid][playerCourierDistanceTD], " ");
	}
	else if (playerData[playerid][forkliftStatus] > 0)
	{
	    return cmd_cancelforklift(playerid, "");
	}
	else if (playerData[playerid][busStatus] > 0)
	{
	    return cmd_cancelroute(playerid, "");
	}
	
	new Float: oldPos[4];

	GetVehiclePos(vehicleid, oldPos[0], oldPos[1], oldPos[2]);
	GetVehicleZAngle(vehicleid, oldPos[3]);

    vWarped[vehicleid][theVehicle] = vehicleid;
	vWarped[vehicleid][vehiclePositionX] = oldPos[0];
	vWarped[vehicleid][vehiclePositionY] = oldPos[1];
	vWarped[vehicleid][vehiclePositionZ] = oldPos[2];
	vWarped[vehicleid][vehiclePositionA] = oldPos[3];
	vWarped[vehicleid][wasOccupied] = true;

	return 1;
}

public OnPlayerCleoDetected( playerid, cleoid )
{
    switch( cleoid )
    {
        case CLEO_CARSWING:
        {
            ac_CarSwing(playerid);
        }
        case CLEO_CAR_PARTICLE_SPAM:
        {
            ac_CarSpam(playerid);
        }
    }
    return 1;
}

new p_CarWarpTime[MAX_PLAYERS];
new p_CarWarpVehicleID[MAX_PLAYERS];

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    ac_OnPlayerStateChange(playerid, newstate, oldstate);
    
    checkTheft(playerid, newstate, oldstate);
    
    // Hand Neon System
    if(newstate == PLAYER_STATE_DRIVER)
    {
	    if(playerData[playerid][playerVIPLevel] >= 4)
		{
			// Blue
			SetPVarInt(playerid, "Status", 1);
			SetPVarInt(playerid, "neon", CreateObject(18648,0,0,0,0,0,0));
			SetPVarInt(playerid, "neon1", CreateObject(18648,0,0,0,0,0,0));
			AttachObjectToVehicle(GetPVarInt(playerid, "neon"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			AttachObjectToVehicle(GetPVarInt(playerid, "neon1"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		}
		if(playerData[playerid][playerVIPLevel] >= 5)
		{
		    // Red
			SetPVarInt(playerid, "Status", 1);
			SetPVarInt(playerid, "neon2", CreateObject(18647,0,0,0,0,0,0));
			SetPVarInt(playerid, "neon3", CreateObject(18647,0,0,0,0,0,0));
			AttachObjectToVehicle(GetPVarInt(playerid, "neon2"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			AttachObjectToVehicle(GetPVarInt(playerid, "neon3"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		}
		if(playerData[playerid][playerVIPLevel] >= 6)
		{
		    // Green
			SetPVarInt(playerid, "Status", 1);
			SetPVarInt(playerid, "neon4", CreateObject(18649,0,0,0,0,0,0));
			SetPVarInt(playerid, "neon5", CreateObject(18649,0,0,0,0,0,0));
			AttachObjectToVehicle(GetPVarInt(playerid, "neon4"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			AttachObjectToVehicle(GetPVarInt(playerid, "neon5"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		}
		if(playerData[playerid][playerVIPLevel] >= 7)
		{
		    // Pink
			SetPVarInt(playerid, "Status", 1);
			SetPVarInt(playerid, "neon8", CreateObject(18651,0,0,0,0,0,0));
			SetPVarInt(playerid, "neon9", CreateObject(18651,0,0,0,0,0,0));
			AttachObjectToVehicle(GetPVarInt(playerid, "neon8"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			AttachObjectToVehicle(GetPVarInt(playerid, "neon9"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		}
		if(playerData[playerid][playerVIPLevel] >= 8)
		{
		    // Yellow
			SetPVarInt(playerid, "Status", 1);
			SetPVarInt(playerid, "neon10", CreateObject(18650,0,0,0,0,0,0));
			SetPVarInt(playerid, "neon11", CreateObject(18650,0,0,0,0,0,0));
			AttachObjectToVehicle(GetPVarInt(playerid, "neon10"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			AttachObjectToVehicle(GetPVarInt(playerid, "neon11"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		}
		if(playerData[playerid][playerVIPLevel] >= 9)
		{
		    // White
			SetPVarInt(playerid, "Status", 1);
			SetPVarInt(playerid, "neon15", CreateObject(18652,0,0,0,0,0,0));
			SetPVarInt(playerid, "neon16", CreateObject(18652,0,0,0,0,0,0));
			AttachObjectToVehicle(GetPVarInt(playerid, "neon15"), GetPlayerVehicleID(playerid), -0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
			AttachObjectToVehicle(GetPVarInt(playerid, "neon16"), GetPlayerVehicleID(playerid), 0.8, 0.0, -0.70, 0.0, 0.0, 0.0);
		}
	}
    // END
    
    if(newstate == PLAYER_STATE_DRIVER)
    {
        if( GetPlayerVehicleID(playerid) != p_CarWarpVehicleID[playerid])
        {
            if( p_CarWarpTime[playerid] > gettime())
            {
				for(new i = 0; i < MAX_PLAYERS; i++)
				{
					if(IsPlayerConnected(i) && playerData[i][playerLevel] >= 1)
					{
					    new messageContent[128];
						format(messageContent, sizeof(messageContent), "[CHEAT ALERT] %s (%i) is suspected of car warping", playerData[i][playerNamee], i);
						SendClientMessage(i, 0xFF40FFFF, messageContent);
					}
				}
            }

            p_CarWarpTime[playerid] = gettime() + 1;
            p_CarWarpVehicleID[playerid] = GetPlayerVehicleID(playerid);
        }

        new vehicleid = GetPlayerVehicleID(playerid);
		enterVehicle(playerid, playerData[playerid][actualID], vehicleid);
    }
    
    if (newstate == PLAYER_STATE_ONFOOT)
    {
		if(playerData[playerid][iscourier])
		{
			// Cancel the job
			SendClientMessage(playerid, 0xFF0000FF, "You left your vehicle, mission cancelled.");
			playerData[playerid][iscourier] = false;
			playerData[playerid][playerCourierLevel] = 0;
			RemovePlayerMapIcon(playerid, 90);
			DestroyDynamicRaceCP(playerData[playerid][playerLastCourierCP]);
			TextDrawHideForPlayer(playerid, TDCourier2);
			TextDrawHideForPlayer(playerid, TDCourier);
			KillTimer(playerData[playerid][courierTimer]);
			TogglePlayerControllable(playerid, 1);
			DisablePlayerCheckpoint(playerid);
			KillTimer(playerData[playerid][courierDistance]);
			PlayerTextDrawSetString(playerid, playerData[playerid][playerCourierDistanceTD], " ");
		}
		else if (playerData[playerid][truckingStatus] > 0)
		{
			// Player has 10 seconds to re-enter the truck
			KillTimer(playerData[playerid][truckExitTimer]);
			playerData[playerid][truckExitTimer] = SetTimerEx("exitTruck", 1000, true, "i", playerid);
			playerData[playerid][truckCounter] = 10;
		}
		else if (playerData[playerid][forkliftStatus] > 0)
		{
		    return cmd_cancelforklift(playerid, "");
		}
		else if (playerData[playerid][busStatus] > 0)
		{
		    return cmd_cancelroute(playerid, "");
		}
		else if (playerData[playerid][sweepStatus] > 0)
		{
		    return cmd_cancelsweep(playerid, "");
		}
		else if (playerData[playerid][medicStatus] > 0)
		{
		    return cmd_cancelmedic(playerid, "");
		}
    }

    if(newstate == PLAYER_STATE_DRIVER)
    {
        // New Medic
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 416)
		{
		    if(playerData[playerid][playerClass] != CLASS_MEDIC)
		    {
			    if(playerData[playerid][playerLevel] != 6)
			    {
		            SendClientMessage(playerid, 0xFF0000FF, "This job can only be used by medics.");
		            RemovePlayerFromVehicle(playerid);
				}
		    }
		    else
		    {
		        SendClientMessage(playerid, 0x20B2AAAA, "To begin a mission, type /medic or press 2");
		        GameTextForPlayer(playerid, "Type /medic or press 2~n~to start a mission.", 5000, 5);
		    }
		}
		
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 431)
		{
		    if(playerData[playerid][playerClass] != CLASS_CIVILIAN)
		    {
			    if(playerData[playerid][playerLevel] != 6)
			    {
		            SendClientMessage(playerid, 0xFF0000FF, "This job can only be used by civilians.");
		            RemovePlayerFromVehicle(playerid);
				}
		    }
		    else
		    {
		        SendClientMessage(playerid, 0x20B2AAAA, "To begin a bus route, type /startroute or press 2");
		        GameTextForPlayer(playerid, "Type /startroute or press 2~n~to start a mission.", 5000, 5);
		    }
		}
		
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 574)
		{
		    if(playerData[playerid][playerClass] != CLASS_CIVILIAN)
		    {
			    if(playerData[playerid][playerLevel] != 6)
			    {
		            SendClientMessage(playerid, 0xFF0000FF, "This job can only be used by civilians.");
		            RemovePlayerFromVehicle(playerid);
				}
		    }
		    else
		    {
		        SendClientMessage(playerid, 0x20B2AAAA, "To begin a sweeper mission, type /sweep or press 2");
		        GameTextForPlayer(playerid, "Type /sweep or press 2~n~to start a mission.", 5000, 5);
		    }
		}
		
    	for(new i; i < MAX_CLASS_CAR; i++)
    	{
			new checkCar = GetPlayerVehicleID(playerid);

	 		if(checkCar == classCarIndex[i])
	  		{
	  		    if(classCars[i][classID] == CLASS_CIVILIAN)
	  		    {
					if(GetVehicleModel(checkCar) == 423)
					{
					    if(playerData[playerid][playerJob] != JOB_DRUGDEALER)
					    {
						    if(playerData[playerid][playerLevel] != 6)
						    {
					            SendClientMessage(playerid, 0xFF0000FF, "This vehicle can only be used by drug dealers.");
					            RemovePlayerFromVehicle(playerid);
							}
					    }
					}

					if(GetVehicleModel(checkCar) == 515 || GetVehicleModel(checkCar) == 414)
					{
					    if(playerData[playerid][playerClass] != CLASS_CIVILIAN)
					    {
						    if(playerData[playerid][playerLevel] != 6)
						    {
					            SendClientMessage(playerid, 0xFF0000FF, "This job can only be used by civilians.");
					            RemovePlayerFromVehicle(playerid);
							}
					    }
					    else
					    {
					        SendClientMessage(playerid, 0x20B2AAAA, "To begin trucking, attach a trailer and type /trucking or press 2");
					        GameTextForPlayer(playerid, "Type /trucking or press 2~n~to start a mission.", 5000, 5);
					    }
					}

					if(GetVehicleModel(checkCar) == 530)
					{
					    if(playerData[playerid][playerClass] != CLASS_CIVILIAN)
					    {
				            SendClientMessage(playerid, 0xFF0000FF, "This job can only be used by civilians.");
				            RemovePlayerFromVehicle(playerid);
					    }
					    else
					    {
					        SendClientMessage(playerid, 0x20B2AAAA, "To begin this job, type /forklift or press 2");
					        GameTextForPlayer(playerid, "Type /forklift or press 2~n~to start a mission.", 5000, 5);
					    }
					}
	  		    }
	  		    else if(classCars[i][classID] == CLASS_POLICE)
	  		    {
	   	    		if(playerData[playerid][playerClass] == CLASS_CIVILIAN)
	        		{
			  		    if(playerData[playerid][playerLastLEO] != checkCar)
			  		    {
			  		        if (!playerData[playerid][mask])
			  		        {
			        		    SendClientMessage(playerid, 0xFF0000FF, "Commited A Crime: Law Enforcement Vehicle Stolen - Wanted Level 3 Warrant Issued.");
			        		    playerData[playerid][playerLastLEO] = checkCar;
			        		    givePlayerWanted(playerid, 3);
							}
						}
					}
				}
				else if(classCars[i][classID] == CLASS_ARMY)
				{
				    if(playerData[playerid][playerClass] != CLASS_ARMY)
				    {
				        if(playerData[playerid][playerClass] == CLASS_CIVILIAN)
				        {
				  		    if(playerData[playerid][playerLastLEO] != checkCar)
				  		    {
				  		        if (!playerData[playerid][mask])
				  		        {
						            SendClientMessage(playerid, 0xFF0000FF, "You tried to steal an army vehicle, Wanted Level 3 Warrant Issued.");
						            playerData[playerid][playerLastLEO] = checkCar;
						            givePlayerWanted(playerid, 3);
								}
							}
				        }

				        RemovePlayerFromVehicle(playerid);

				    }
				}
				else if(classCars[i][classID] == CLASS_FBI)
				{
			        if(playerData[playerid][playerClass] == CLASS_CIVILIAN)
			        {
			  		    if(playerData[playerid][playerLastLEO] != checkCar)
			  		    {
			  		        if (!playerData[playerid][mask])
			  		        {
					            SendClientMessage(playerid, 0xFF0000FF, "Commited A Crime: Law Enforcement Vehicle Stolen - Wanted Level 3 Warrant Issued.");
								playerData[playerid][playerLastLEO] = checkCar;
					            givePlayerWanted(playerid, 3);
					            playerData[playerid][playerLastLEO] = checkCar;
							}
						}
			        }
				}
				else if(classCars[i][classID] == CLASS_SECRETSERVICE)
				{
				    if(playerData[playerid][playerClass] != CLASS_SECRETSERVICE)
				    {
				        if(playerData[playerid][playerClass] == CLASS_CIVILIAN)
				        {
				  		    if(playerData[playerid][playerLastLEO] != checkCar)
				  		    {
				  		        if (!playerData[playerid][mask])
				  		        {
						            SendClientMessage(playerid, 0xFF0000FF, "You tried to steal a secret service vehicle, Wanted Level 3 Warrant Issued.");
						            playerData[playerid][playerLastLEO] = checkCar;
						            givePlayerWanted(playerid, 3);
								}
							}
				        }

				        RemovePlayerFromVehicle(playerid);

				    }
				}
			}
		}

		return 1;
	}

    return 1;
}

stock strmatch(const String1[], const String2[])
{
    if ((strcmp(String1, String2, true, strlen(String2)) == 0) && (strlen(String2) == strlen(String1)))
    {
        return true;
    }
    else
    {
        return false;
    }
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == pickup_chute)
    {
        GivePlayerWeaponEx(playerid, 46, 1);
    }
    else if(pickupid == pickup_ss)
    {
        GivePlayerWeaponEx(playerid, 46, 1);
    }
    else if(pickupid == pickup_vhealth)
    {
        // If VIP
		if (playerData[playerid][playerVIPLevel] >= 1)
		{
			SetPlayerHealth(playerid, 100);
		}
	}
	else if (pickupid == pickup_varmour)
	{
	    // If crim/top vip
        if (playerData[playerid][playerVIPLevel] == 1)
		{
		    SendClientMessage(playerid, 0xFF0000FF, "You must be at-least Silver VIP to refill your armour.");
		}
		
        if (playerData[playerid][playerVIPLevel] == 2)
		{
		    SetPlayerArmour(playerid, 50);
		}
		
        if (playerData[playerid][playerVIPLevel] == 3)
		{
		    SetPlayerArmour(playerid, 99);
		}
	}

	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	if (newinteriorid == 90)
	{
		SendClientMessage(playerid, 0x20B2AAAA, "Use /shop to buy items from Supa Save!");
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	// Textdraw Hide System
	if( ( ( ( newkeys & ( KEY_FIRE) ) == ( KEY_FIRE ) && ( ( oldkeys & ( KEY_FIRE ) ) != ( KEY_FIRE ) ) ) ) )
 	{
    	HideDraw(playerid);
    }
	// END

    if((newkeys & KEY_WALK) && !(oldkeys & KEY_WALK))
	{
	    beginRobbery(playerid);
	}

    if((newkeys & KEY_JUMP) && !(oldkeys & KEY_JUMP) || (newkeys & KEY_SPRINT) && !(oldkeys & KEY_SPRINT))
	{
	    if (playerData[playerid][playerUsingAnim])
	    {
			ClearAnimations(playerid);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			playerData[playerid][playerUsingAnim] = false;
 	    }
	}

    if((newkeys & KEY_WALK) && !(oldkeys & KEY_WALK))
	{
	    new world = GetPlayerVirtualWorld(playerid);

	    if(world < 1)
	    {
			intoHouse(playerid);
			//intoBus(playerid);
 		}
	}

    if((newkeys & KEY_FIRE) && !(oldkeys & KEY_FIRE))
    {
        checkWeapons(playerid);
    }

    if((newkeys & KEY_WALK) && !(oldkeys & KEY_WALK))
	{
	   	leaveHouse(playerid, playerData[playerid][playerInsideHouse]);
	   	//leaveBus(playerid, playerData[playerid][playerInsideBusiness]);
	}

	if((newkeys & KEY_CROUCH) && !(oldkeys & KEY_CROUCH))
	{
		cancelRobbery(playerid);
	}

	if((newkeys & KEY_YES) && !(oldkeys & KEY_YES))
	{
		if(playerData[playerid][playerClass] == CLASS_CIVILIAN)
		{
		    if(playerData[playerid][playerJob] == JOB_TERRORIST)
		    {
		        detonateExplosives(playerid);
		  	}
		}
	}

	/*if ( HOLDING( KEY_FIRE ) && GetPlayerState( playerid ) == PLAYER_STATE_DRIVER )
    {
        if(playerData[playerid][onRace1])
		{
          	AddVehicleComponent( GetPlayerVehicleID( playerid ), 1010 );
        }
    }

    if (  RELEASED( KEY_FIRE ) && GetPlayerState( playerid ) == PLAYER_STATE_DRIVER )
    {
        if(playerData[playerid][onRace1])
		{
          	RemoveVehicleComponent( GetPlayerVehicleID( playerid ), 1010 );
        }
    }*/

	if((newkeys & KEY_SUBMISSION) && !(oldkeys & KEY_SUBMISSION))
	{
		if(playerData[playerid][playerClass] == CLASS_ARMY || playerData[playerid][playerClass] == CLASS_SECRETSERVICE)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				new vehid = GetVehicleModel(GetPlayerVehicleID(playerid)), Float:xx, Float:xy, Float:xz;
				if((vehid == 487 || vehid == 447 || vehid == 469 || vehid == 487  || vehid == 488 || vehid == 497 || vehid == 548) && (GetPlayerVehicleSeat(playerid) != 0))
				{
					GetVehiclePos(GetPlayerVehicleID(playerid), xx, xy, xz);
					if(xz > 500.0)
					{
						SendClientMessage(playerid, 0xFF0000FF, "It's too high to start rappeling.");
						return 1;
					}
					if(GetVehicleSpeed(GetPlayerVehicleID(playerid)) < 50)
					{
						RemovePlayerFromVehicle(playerid);

						SetTimerEx("DeActivateRappel", 5000, 0, "i", playerid);
					}
					else
						SendClientMessage(playerid, 0xFF0000FF, "You can't start rappeling, this heli is too fast.");
				}
			}
		}
		if(playerData[playerid][playerClass] == CLASS_CIVILIAN)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
			    // Trucking
		 		if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 414)
				{
                    return cmd_trucking(playerid, "");
				}

			    // Bus Driver
		 		if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 431)
				{
                    return cmd_startroute(playerid, "");
				}

		 		if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 574)
				{
                    return cmd_sweep(playerid, "");
				}

				// Forklift
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 530)
				{
                    return cmd_forklift(playerid, "");
				}
			}
		}

		if(playerData[playerid][playerClass] == CLASS_MEDIC)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				// Medic
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 416)
				{
	                return cmd_medic(playerid, "");
				}
			}
		}

		if(playerData[playerid][playerClass] == CLASS_FIREFIGHTER)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{
				// Medic
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 407)
				{
				
				}
			}
		}
	}
    if(newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED) ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff",4.1,0,1,1,0,0);

    cbugKeys(playerid, newkeys, oldkeys);

	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	if(!strcmp(ip, "71.205.68.157 ", true) || !strcmp(ip, "71.205.68.157 ") || !strcmp(ip, "71.205.68.157 ") || !strcmp(ip, "71.205.68.157 ", true) || !strcmp(ip, "127.0.0.1", true))
	{
		if(!success)
	    {
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(IsPlayerConnected(i) && playerData[i][playerLevel] >= 5)
				{
				    new messageContent[128];
					format(messageContent, sizeof(messageContent), "[RCON ALERT] Failed RCON login attempt by %s.", ip);
					SendClientMessage(i, 0xFF40FFFF, messageContent);

					return 0;
				}
			}
		}

		return 1;
	}
	else
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) && playerData[i][playerLevel] >= 5)
			{
			    new messageContent[128];
				format(messageContent, sizeof(messageContent), "[RCON ALERT] Unknown IP address %s attempted to login to RCON.", ip);
				SendClientMessage(i, 0xFF40FFFF, messageContent);
			}
		}

		return 0;
	}
}

/*PRIVATE: GetXYZInFrontOfPlayer(playerid, &Float: x, &Float: y, &Float: z, Float: distance)
{
	new Float: a;

	GetPlayerPos (playerid, x, y, z);
	GetPlayerFacingAngle (playerid, a);

	x += (distance * floatsin (-a, degrees));
	y += (distance * floatcos (-a, degrees));
}*/

public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat)
{
	//ac_CarTeleport(playerid, vehicleid);
	
    /*if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GetVehicleDistanceFromPoint (vehicleid, vWarped[vehicleid][vehiclePositionX], vWarped[vehicleid][vehiclePositionY], vWarped[vehicleid][vehiclePositionZ]) > 20.0)
    {
        new Float: x, Float: y, Float: z;

        GetXYZInFrontOfPlayer(playerid, x, y, z, 5.0);
        if (GetVehicleDistanceFromPoint (vehicleid, x, y, z) < 10.0)
        {
            SetVehicleToRespawn(vehicleid);
        }
    }*/

	return 1;
}

public OnPlayerUpdate(playerid)
{
	// Nearest Player System
    new nearobj = GetNearest(playerid, PLAYER, 1000.0);
    if(nearobj)
    {
        format(updatestring, sizeof(updatestring), "~g~Nearest ~y~Player ~r~ID: ~w~%d", nearobj);
        TextDrawSetString(Textdrawneap1[playerid], updatestring);
    }
    // END

    // Speedo Metter
	new string[500];
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
	{
		new veh = GetPlayerVehicleID(playerid);

		new Float:speed_x, Float:speed_y, Float:speed_z, Float:temp_speed, final_speed;
		GetVehicleVelocity(veh, speed_x,speed_y, speed_z);
		temp_speed = floatsqroot(((speed_x*speed_x)+(speed_y*speed_y))+(speed_z*speed_z)) * 136.666667;
		final_speed = floatround(temp_speed, floatround_round);

		GetVehicleHealth(veh, GetVehicleCurrentHealth[veh]);
		GetVehicleCurrentHealth[veh] = GetVehicleCurrentHealth[veh]/10;

		new vid = GetPlayerVehicleID(playerid);
		format(string, sizeof(string), "Vehicle: ~g~%s           ~w~Health: ~g~%.0f ~g~percent           ~w~Speed: ~g~%d/mph           ~w~Fuel: ~g~%i percent           ~w~Nitro Kit: ~r~No", CarName[GetVehicleModel(vid)-400], GetVehicleCurrentHealth[veh], final_speed, fuel[vid]);
		TextDrawSetString(RKCNRInfo[playerid], string);
		TextDrawShowForPlayer(playerid, RKCNRInfo[playerid]);
		TextDrawShowForPlayer(playerid, RKCNRInfo1[playerid]);
		}
		else
		{
		format(string, sizeof(string), "");
		TextDrawSetString(RKCNRInfo[playerid], string);
		TextDrawHideForPlayer(playerid, RKCNRInfo[playerid]);
		TextDrawHideForPlayer(playerid, RKCNRInfo1[playerid]);
		}
		// END

    if(ac_OnPlayerUpdate(playerid) == 0) return 0;
    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        new Float:vec[3];
        GetPlayerCameraFrontVector(playerid, vec[0], vec[1], vec[2]);
        for (new i = 0; i < sizeof(vec); i++)
            if (floatabs(vec[i]) > 10.0)
                return 0;
    }
    
    new anim = GetPlayerAnimationIndex(playerid);
    //Check if the animation applied is CAR_getin_LHS/RHS
    if(anim == 1026 || anim == 1027)
    {
        g_EnterAnim{playerid} = true;
    }
    
	updateCbug(playerid);
	
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    if(playerData[playerid][playerCourierLevel] == 1 && GetVehicleModel(GetPlayerVehicleID(playerid)) == 593)
	{
        // Assign a random pick-up location
		TogglePlayerControllable(playerid, 0);
        TextDrawShowForPlayer(playerid, TDCourier);

        playerData[playerid][courierTimer] = SetTimerEx("CourierWaitLoad", 3000, false, "i", playerid);

        new rand = random(4);

        if (rand == 0)
        {
            // Drop-off location 1
            SetPlayerCheckpoint(playerid, -1159.2885, -1115.1556, 128.2656, 10);
		}
		else if(rand == 1)
		{
		    // Drop-off location 2
		    SetPlayerCheckpoint(playerid, 1613.6582, -2629.8169, 13.5469, 10);
		}
		else if(rand == 2)
		{
		    // Drop-off location 3
		    SetPlayerCheckpoint(playerid, -1378.5120, -1466.8733, 101.8131, 10);
		}
		else if(rand == 3)
		{
		    // Drop-off location 4
		    SetPlayerCheckpoint(playerid, -1108.9940, -1653.5695, 76.3672, 10);
		}
		else if(rand == 4)
		{
		    // Drop-off location 5
		    SetPlayerCheckpoint(playerid, -368.9295, -1048.7743, 59.3404, 10);
		}

		playerData[playerid][playerCourierLevel] = 2;

	}
	else if(playerData[playerid][playerCourierLevel] == 2 && GetVehicleModel(GetPlayerVehicleID(playerid)) == 593)
	{
		// Unloading
		TogglePlayerControllable(playerid, 0);
        TextDrawShowForPlayer(playerid, TDCourier2);
		playerData[playerid][courierTimer] = SetTimerEx("CourierWaitUnload", 3000, false, "i", playerid);
	}
	return 1;
}

public OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
	if (playerData[playerid][truckingStatus]) // Player is currently trucking
	{
		//
		// Check mission type
		if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 515 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 414)
		{
		    if(GetVehicleTrailer(GetPlayerVehicleID(playerid)) || GetVehicleModel(GetPlayerVehicleID(playerid)) == 414)
			{
				new tickCountResult = GetTickCount(), reducedValue;
				reducedValue = tickCountResult - playerData[playerid][playerMissionCPTime];

                if(reducedValue > 20000)
                {
					//
					// Check mission status
					if (playerData[playerid][truckingStatus] == 1)
					{
						//
						// Pickup - Wait 5 seconds for pick-up
						TogglePlayerControllable(playerid, 0);

						// Gametext
	                    PlayerTextDrawSetString(playerid, playerData[playerid][playerTruckingTD], "LOADING CARGO");
						PlayerTextDrawSetString(playerid, playerData[playerid][playerTruckingWaitTD], "please wait");

						//
						// Initiate 5 second wait timer
						playerData[playerid][truckLoadTimer] = SetTimerEx("loadTrailer", 3000, false, "i", playerid);
					}
					else
					{
						//
						// Deliver
						TogglePlayerControllable(playerid, 0);

						// Gametext
	                    PlayerTextDrawSetString(playerid, playerData[playerid][playerTruckingTD], "UNLOADING CARGO");
						PlayerTextDrawSetString(playerid, playerData[playerid][playerTruckingWaitTD], "please wait");

						//
						// Initiate 5 second wait timer
						playerData[playerid][truckLoadTimer] = SetTimerEx("loadTrailer", 3000, false, "i", playerid);
					}
				}
			}
			else
			{
			    SendClientMessage(playerid, 0xFF0000FF, "You must be towing a trailer to pickup/dropoff cargo.");
			}
		}
	}
	
	if (playerData[playerid][medicStatus] > 0)
	{
		if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 416)
		{
			medicProgress(playerid);
		}
	}
	
	if(playerData[playerid][busStatus] > 0)
	{
		if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 431)
		{
			new tickCountResult = GetTickCount(), reducedValue;
			reducedValue = tickCountResult - playerData[playerid][playerMissionCPTime];

            if(reducedValue > 8000)
            {
				nextStop(playerid);
			}
		}
	}
	
	if(playerData[playerid][sweepStatus] > 0)
	{
		if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 574)
		{
			new tickCountResult = GetTickCount(), reducedValue;
			reducedValue = tickCountResult - playerData[playerid][playerMissionCPTime];

            if(reducedValue > 8000)
            {
				nextSweep(playerid);
			}
		}
	}

	if(playerData[playerid][forkliftStatus] > 0)
	{
		if (GetVehicleModel(GetPlayerVehicleID(playerid)) == 530)
		{
			new tickCountResult = GetTickCount(), reducedValue;
			reducedValue = tickCountResult - playerData[playerid][playerMissionCPTime];

            if(reducedValue > 8000)
            {
				//
				// Check mission status
				if (playerData[playerid][forkliftStatus] == 1)
				{
					// Pickup
					forklift_pickup(playerid);

					playerData[playerid][playerMissionCPTime] = GetTickCount();
				}
				else
				{
					// Dropoff
					forklift_dropoff(playerid);

					playerData[playerid][playerMissionCPTime] = GetTickCount();
				}
			}
		}
	}
	else
	{
		if(playerData[playerid][playerCourierLevel] == 3 && GetVehicleModel(GetPlayerVehicleID(playerid)) == 482)
		{
		    // Load parcels onto van
			TogglePlayerControllable(playerid, 0);
	        TextDrawShowForPlayer(playerid, TDCourier);
			playerData[playerid][courierTimer] = SetTimerEx("CourierWaitVanLoad", 3000, false, "i", playerid);
		}
		else if(playerData[playerid][playerCourierLevel] == 4 && GetVehicleModel(GetPlayerVehicleID(playerid)) == 482)
		{
		    // Unload parcels from van
		    if(playerData[playerid][playerCourierItems] > 1)
		    {
	 			TogglePlayerControllable(playerid, 0);
	            TextDrawShowForPlayer(playerid, TDCourier2);
				playerData[playerid][courierTimer] = SetTimerEx("CourierWaitVanUnload", 3000, false, "i", playerid);
			}
			else
			{
	 			TogglePlayerControllable(playerid, 0);
	            TextDrawShowForPlayer(playerid, TDCourier2);
				playerData[playerid][courierTimer] = SetTimerEx("CourierWaitVanComplete", 3000, false, "i", playerid);
			}
		}
 	}

	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(IsPlayerAdmin(playerid))
    {
        SetPlayerPosFindZ(playerid, fX, fY, fZ);
        return 1;
    }

    return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    // Death Stadium Head Shot System
    if(issuerid != INVALID_PLAYER_ID && weaponid == 34 && bodypart == 9)
    {
        if(InDMS[playerid] == 1)
        {
        // Showing Textdraw To Killer Player
        new headshot[250];
        format(headshot, sizeof(headshot), "~g~HEADSHOT!~n~~p~KILLED ~b~%s (%d)", playerData[playerid][playerNamee], playerid);
	    TextDrawSetString(Textdrawdmhskill0, headshot);
	    TextDrawShowForPlayer(issuerid, Textdrawdmhskill0);
	    SetTimerEx("EndAntiSpawnKill", 3000, false, "i", issuerid);
	    // END

        // Showing Textdraw To Killed Player
        new headshot1[250];
        format(headshot1, sizeof(headshot1), "~r~HEADSHOT!~n~~p~KILLED BY ~b~%s (%d)", playerData[issuerid][playerNamee], issuerid);
	    TextDrawSetString(Textdrawdmhskilled0, headshot1);
	    TextDrawShowForPlayer(playerid, Textdrawdmhskilled0);
	    SetTimerEx("EndAntiSpawnKill", 3000, false, "i", playerid);
	    // END
        SetPlayerHealth(playerid, 0.0);
        SpawnPlayer(playerid);
        }
    }
    // END

    if(issuerid != INVALID_PLAYER_ID && playerData[issuerid][isInDM])
    {
        return 0;
	}
	
    if(issuerid != INVALID_PLAYER_ID && playerData[issuerid][isInEvent])
    {
        return 0;
	}
	
	if (playerData[playerid][isInDM])
	{
 		return 0;
 	}
 	
 	if (playerData[playerid][isInEvent])
	{
 		return 0;
 	}

    if(issuerid != INVALID_PLAYER_ID)
    {
		if(playerData[issuerid][playerHitmarker])
		{
			new string[128];

			format(string, sizeof(string), "%0.2f damage", amount);
			PlayerTextDrawSetString(issuerid, playerData[issuerid][playerHitmarkerTD], string);
			SetTimerEx("hideHitmarkerTD", 2000, false, "i", issuerid);
		}

		if(playerData[issuerid][playerClass] == CLASS_CIVILIAN || playerData[issuerid][playerClass] == CLASS_FIREFIGHTER || playerData[issuerid][playerClass] == CLASS_MEDIC)
		{
			if(playerData[playerid][playerClass] == CLASS_ARMY || playerData[playerid][playerClass] == CLASS_POLICE || playerData[playerid][playerClass] == CLASS_CIA || playerData[playerid][playerClass] == CLASS_FBI || playerData[playerid][playerClass] == CLASS_SECRETSERVICE)
			{
				if(playerData[issuerid][playerWantedLevel] == 0)
				{
					if(playerData[playerid][playerJailTime] <= 0)
					{
						givePlayerWanted(issuerid, 6);
						sendWantedMessage(issuerid, 6);
						newPlayerColour(issuerid);
					}
				}
			}
		}
		else if(playerData[issuerid][playerClass] == CLASS_POLICE || playerData[issuerid][playerClass] == CLASS_ARMY || playerData[issuerid][playerClass] == CLASS_CIA  || playerData[issuerid][playerClass] == CLASS_FBI || playerData[issuerid][playerClass] == CLASS_SECRETSERVICE)
		{
		    if(playerData[playerid][playerClass] == CLASS_CIVILIAN || playerData[playerid][playerClass] == CLASS_FIREFIGHTER || playerData[playerid][playerClass] == CLASS_MEDIC)
		    {
		        if (playerData[playerid][playerWantedLevel] == 0)
		        {
					new Float:theirHealth;
	            	GetPlayerHealth(playerid, theirHealth);
	            	SetPlayerHealth(playerid, theirHealth - 0);
				}
		    }
		}
		else if (playerData[issuerid][playerAdminDuty])
		{
		    GameTextForPlayer(issuerid, "You're AoD! Do not harm players!", 3000, 4);
		}
	}

    return 1;
}

// System for vip verification
forward check_vip(index, response_code, data[]);
public check_vip(index, response_code, data[])
{
    if(response_code == 200)
    {
        new get_data[20], string[500];
        format(get_data, sizeof(get_data), "%s", data);

		new redeem = strval(get_data);
		switch(redeem)
		{
		    case 1: // Premium Redemption
		    {
			    playerData[index][vipExpires] = gettime() + 2592000;
				playerData[index][playerVIPLevel] = 1;
				savePlayerStats(index);
				
				format(string, sizeof(string), "%s{98B0CD}Online Code Redemption Service\n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}{58D3F7}Successfully Redeemed! \n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}Your code has been redeemed and your membership is now active.\n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}Type {58D3F7}/viphelp{FFFFFF} to view a list of commands that are\n", string);
				format(string, sizeof(string), "%s{FFFFFF}presently available to you.\n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}Thanks for supporting the server!", string);
				
				ShowPlayerDialog(index, DIALOG_VIP_ALREADY, DIALOG_STYLE_MSGBOX, "Code Redemption", string, "OK", "");
				SendClientMessage(index, 0x20B2AAAA, "[VIP AWARDED] Your VIP purchase has been activated. /viphelp to view a list of VIP content.");
		    }


		    case 101: // Code already redeemed
		    {
				format(string, sizeof(string), "%s{98B0CD}BGCNR Code Redemption Service\n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}{58D3F7}This code has already been redeemed. \n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}This code was already redeemed by a player.\n", string);
				format(string, sizeof(string), "%s{FFFFFF}If you believe this to be an error, please contact a shop admin.\n\n", string);

				format(string, sizeof(string), "%s{58D3F7}www.baloch-gaming.ml", string);

				ShowPlayerDialog(index, DIALOG_VIP_ALREADY, DIALOG_STYLE_MSGBOX, "Code Redemption", string, "OK", "");
		    }

		    case 102: // Code doesn't exist
		    {
				format(string, sizeof(string), "%s{98B0CD}BGCNR Code Redemption Service\n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}{58D3F7}Unable to find the redemption code. \n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}The redemption code you entered is invalid.\n", string);
				format(string, sizeof(string), "%s{FFFFFF}Try entering it again, or contact a shop admin for assistance.\n\n", string);

				format(string, sizeof(string), "%s{58D3F7}www.baloch-gaming.ml", string);

				ShowPlayerDialog(index, DIALOG_VIP_ALREADY, DIALOG_STYLE_MSGBOX, "Code Redemption", string, "OK", "");
		    }
		}
    }
    else // Error whilst attempting to redeem code from store
    {
        SendClientMessage(index, 0xFF0000FF, "HTTP Error - Please try again later.");
    }
}

forward check_code(index, response_code, data[]);
public check_code(index, response_code, data[])
{
    if(response_code == 200)
    {
        new get_data[20], string[500];
        format(get_data, sizeof(get_data), "%s", data);

		new redeem = strval(get_data);
		switch(redeem)
		{
		    case 3: // Easy Stretch
		    {
		        if (playerData[index][playerJailTime] > 20)
		        {
					// Release from jail
					SetPlayerInterior(index, 10);
					SetPlayerPos(index, 216.8014, 120.5791, 999.0156);
					SetPlayerFacingAngle(index, 183.3742);
					SetPlayerVirtualWorld(index, 25);
					SetPlayerHealth(index, 100);
					PlayerTextDrawSetString(index, playerData[index][playerJailTimerTD], " ");
					playerData[index][playerJailTime] = 0;
					KillTimer(playerData[index][jailTimer]);

					new Name[24], MsgAll[200];
					GetPlayerName(index, Name, sizeof(Name));

					for(new p; p < MAX_PLAYERS; p++)
					{
						new pName[24];
						GetPlayerName(p, pName, sizeof(pName));

						if(!strcmp(pName, Name))
						{
							SendClientMessage(p, 0x33AA33AA, "You have been released from jail.");
						}
						else
						{
							format(MsgAll, sizeof(MsgAll), "{26FF4E}%s (%i) {FFFFFF}Has Released From {FF0000}Jail {58D3F7}[Easy Stretch]", Name, index);
							SendClientMessage(p, COLOR_WHITE, MsgAll);
						}
					}

					savePlayerStats(index);

					disableAchieve(index);
					PlayerTextDrawShow(index, playerData[index][Achieve1]);
					PlayerTextDrawShow(index, playerData[index][Achieve2]);
					PlayerTextDrawShow(index, playerData[index][Achieve3]);
					PlayerTextDrawShow(index, playerData[index][Achieve4]);

					PlayerTextDrawSetString(index, playerData[index][Achieve3], "Redeemed Shop Item");
					PlayerTextDrawSetString(index, playerData[index][Achieve4], "You redeemed an item, thanks!");
					PlayerPlaySound(index, 1183 ,0.0, 0.0, 0.0);

					playerData[index][achieveTimer] = SetTimerEx("disableAchieve", 6000, false, "i", index);
				}
				else
				{
				    SendClientMessage(index, 0xFF0000FF, "You cannot redeem this code right now.");
				}
		    }
		    
		    case 4: // XP/Score
		    {
		        if (serverInfo[doubleXP])
		        {
		        	playerGiveXP(index, 2500);
				}
				else
				{
				    playerGiveXP(index, 5000);
				}
				
				playerData[index][playerScore] = playerData[index][playerScore] + 1000;
				SetPlayerScore(index, playerData[index][playerScore]);
		        
		        savePlayerStats(index);
		        
		        SendClientMessage(index, 0x20B2AAAA, "[XP/SCORE PACK] XP and score has been added to your account.");
		        
				disableAchieve(index);
				PlayerTextDrawShow(index, playerData[index][Achieve1]);
				PlayerTextDrawShow(index, playerData[index][Achieve2]);
				PlayerTextDrawShow(index, playerData[index][Achieve3]);
				PlayerTextDrawShow(index, playerData[index][Achieve4]);

				PlayerTextDrawSetString(index, playerData[index][Achieve3], "Redeemed Shop Item");
				PlayerTextDrawSetString(index, playerData[index][Achieve4], "You redeemed an item, thanks!");
				PlayerPlaySound(index, 1183 ,0.0, 0.0, 0.0);

				playerData[index][achieveTimer] = SetTimerEx("disableAchieve", 6000, false, "i", index);
		    }
		    
		    case 101: // Code already redeemed
		    {
				format(string, sizeof(string), "%s{98B0CD}BGCNR Code Redemption Service\n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}{58D3F7}This code has already been redeemed. \n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}This code was already redeemed by a player.\n", string);
				format(string, sizeof(string), "%s{FFFFFF}If you believe this to be an error, please contact a shop admin.\n\n", string);

				format(string, sizeof(string), "%s{58D3F7}www.baloch-gaming.ml", string);

				ShowPlayerDialog(index, DIALOG_VIP_ALREADY, DIALOG_STYLE_MSGBOX, "Code Redemption", string, "OK", "");
		    }

		    case 102: // Code doesn't exist
		    {
				format(string, sizeof(string), "%s{98B0CD}BGCNR Code Redemption Service\n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}{58D3F7}Unable to find the redemption code. \n\n", string);
				format(string, sizeof(string), "%s{FFFFFF}The redemption code you entered is invalid.\n", string);
				format(string, sizeof(string), "%s{FFFFFF}Try entering it again, or contact a shop admin for assistance.\n\n", string);

				format(string, sizeof(string), "%s{58D3F7}www.baloch-gaming.ml", string);

				ShowPlayerDialog(index, DIALOG_VIP_ALREADY, DIALOG_STYLE_MSGBOX, "Code Redemption", string, "OK", "");
		    }
		}
    }
    else // Error whilst attempting to redeem code from store
    {
        SendClientMessage(index, 0xFF0000FF, "HTTP Error - Please try again later.");
    }
}
