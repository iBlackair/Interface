class OnScreenDmg extends UICommonAPI;

var WindowHandle Me;
var TextBoxHandle MainDmg, pText;


function OnRegisterEvent ()
{
	RegisterEvent(580);
}

function OnEvent (int a_EventID, string a_Param)
{
  
  switch (a_EventID)
  {
	case 580:
		if ( class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableScreenDmg") )
			HandleSystemMessage(a_Param);
	break;
    default:
    break;
  }
}

function ohshit(string param)
{
	local string gay;
	//local userinfo mi;
	gay = param;
	
	//GetPlayerInfo(mi);
	MainDmg.ShowWindow();
	pText.SetText(gay $ " - end");
	sysDebug("aSD:");
	//MessageBox(gay);
}

function OnLoad ()
{
  if ( CREATE_ON_DEMAND == 0 )
    OnRegisterEvent();
  if ( CREATE_ON_DEMAND == 0 )
    InitHandle();
  else
    InitHandleCOD();
  
  MainDmg.HideWindow();

}

function InitHandle ()
{
	Me = GetHandle("OnScreenDmg");
}

function InitHandleCOD ()
{
	Me = GetWindowHandle("OnScreenDmg");
	MainDmg = GetTextBoxHandle("OnScreenDmg.MainDmg");
	pText = GetTextBoxHandle("OnScreenDmg.paramText");
}


function ShowOnScreenDamage (int Damage, bool isSummoner, Color color,optional int TransferDmg)
{
  local string DmgText, SumDmgText;
  
  //2261    $c1 has done $s3 points of damage to $c2. 
  //1130  	You have dealt $s1 damage to your target and $s2 damage to the servitor.

  if ( !isSummoner )
  {
	  DmgText = string(Damage);
	  SumDmgText = "";
  }
  else
  {
	DmgText = string(Damage);
	SumDmgText = "(" @ string(TransferDmg) @ ")";
  }
	
  MainDmg.ShowWindow();
  MainDmg.SetText(DmgText @ SumDmgText);
  MainDmg.SetTextColor(color);
  Me.KillTimer(7779);
  Me.SetTimer(7779, 2000);
}

function OnTimer(int TimerID)
{
	if (TimerID == 7779)
	{
		Me.KillTimer(7779);
		MainDmg.HideWindow();
		MainDmg.SetText("");
	}
}

function HandleSystemMessage (string a_Param)
{
  local int SystemMsgIndex;
  local int ParamIntSumm;
  local int ParamIntTransfer;
  local int ParamIntPlayer;
  
  local Color DefaultColor;
  local Color Yellow;
  
  DefaultColor.R = 216;
  DefaultColor.G = 216;
  DefaultColor.B = 216;
  
  Yellow.R = 255;
  Yellow.G = 225;
  Yellow.B = 73;

  ParseInt(a_Param,"Index",SystemMsgIndex);
  
  switch (SystemMsgIndex)
  {
    case 2261:
		ParseInt(a_Param,"Param3",ParamIntPlayer);
		ShowOnScreenDamage(ParamIntPlayer, False, DefaultColor);
    break;
	case 1130:
		ParseInt(a_Param,"Param1",ParamIntSumm);
		ParseInt(a_Param,"Param2",ParamIntTransfer);
		ShowOnScreenDamage(ParamIntSumm, True, Yellow,ParamIntTransfer);
    break;
  }
}