//-> Игнорировать пустые строки
//->Игнорировать строки начинающиеся с //
//->Звук при сообщение
//#define DEBUG 
#define DEBUG_LOG 1
#define DEBUG_PLAYER "K64t"
#define PLUGIN_NAME  "Ticker"
#define PLUGIN_VERSION "0.3"

#include "k64t"
#pragma newdecls required
// ConVar
// Global Var
float TickerTimeout = 300.0;
char TickerMsg[512];
public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = "Ticker",
	version = PLUGIN_VERSION,
	url = ""};
//***********************************************
public void OnPluginStart(){
//***********************************************
if (GetTickerLine())
	{
	CreateTimer(TickerTimeout,ShowTicker,INVALID_HANDLE,TIMER_REPEAT);
	HookEvent("round_end",	round_end,	EventHookMode_PostNoCopy);
	#if defined DEBUG		
		AddCommandListener(cmd_ticker,"k_ticker");
	#endif 
	}
else 
	{
	SetFailState("[%s] Error - Unable to get message",PLUGIN_NAME);
	}	
}
//***************************************************
public void round_end(Handle event, char[] name, bool dontBroadcast){GetTickerLine();}
//***************************************************
#if defined DEBUG
//***********************************************
public Action cmd_ticker(int client, const char[] command, int argc){  	
//***********************************************
DebugPrint("k_ticker");
GetTickerLine();
//PrintHintText(client,TickerMsg);
PrintCenterText(client,"%s %s","PrintCenterText",TickerMsg);
PrintHintText(client,"%s %s","PrintHintText",TickerMsg);
PrintToChat(client,TickerMsg);
Handle Msg = CreateKeyValues("msg");
if (Msg==INVALID_HANDLE)
	PrintToChat(client,"Msg==INVALID_HANDLE");
else
	{
	KvSetString(Msg, "title","CreateDialog");
	KvSetColor(Msg, "color", 255, 0, 0,	 255);
	KvSetNum(Msg, "level", 0);
	KvSetNum(Msg, "time", 10);
	//CreateDialog(client, Msg, DialogType_Msg);
	//CreateDialog(client, Msg, DialogType_Text);
	CreateDialog(client, Msg, DialogType_Entry);
	
	}
	
return Plugin_Handled;
}
#endif 
//***********************************************
public Action ShowTicker(Handle timer){
//***********************************************
GetTickerLine();
for (int i = 1; i <= MaxClients; i++)
	{
	if (IsClientInGame(i) && !IsPlayerAlive(i))	
		{
		PrintToChat(i,TickerMsg);
		}		
	}
}
//***********************************************
bool GetTickerLine(){
//***********************************************
Handle FILE=OpenFile("cfg\\Ticker.txt", "r");
bool _GetTickerLine=false;
if (FILE==INVALID_HANDLE)
	{
	LogError("FATAL: Cannot find file Tick.txt");
	}
else
	{
	char Msg[512];
	int StringCount=0;
	while (!IsEndOfFile(FILE) && ReadFileLine(FILE, Msg, sizeof(Msg)))
		{
		TrimString(Msg);	
		if (strlen(Msg)==0) continue; 	
		if (Msg[0]=='/' &&  Msg[1]=='/') continue; 	
		if (Msg[0]==';' ) continue; 	
		StringCount++;
		}		
	StringCount=GetRandomInt(0,StringCount);
	if (StringCount>0)
		{
		if (FileSeek(FILE, 0,SEEK_SET))
			{
			while (!IsEndOfFile(FILE) && ReadFileLine(FILE, Msg, sizeof(Msg)))
				{
				TrimString(Msg);	
				if (strlen(Msg)==0) continue; 	
				if (Msg[0]=='/' &&  Msg[1]=='/') continue; 	
				if (Msg[0]==';' ) continue; 
				StringCount--;				
				if (StringCount==0)
					{
					Format(TickerMsg,sizeof(TickerMsg)+16,"\4%s",Msg);
					_GetTickerLine=true;
					}
				}
			}	
		}			
	CloseHandle(FILE);	
	}
return 	_GetTickerLine;
}

