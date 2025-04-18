class CancelCtrlWnd extends UICommonAPI;

var WindowHandle Me;
var TextureHandle tex1, tex2, tex3, tex4, tex5, tex6, tex7;
var ItemID iInfo[7];

var bool isCastedCancel;

var int counter;

var array<string> buffNames;

var AbnormalStatusWnd script_abn;
var OlympiadDmgWnd script_oly;

function OnRegisterEvent() 
{
	RegisterEvent(EV_ReceiveMagicSkillUse);
	RegisterEvent( EV_SystemMessage );
	RegisterEvent( EV_OlympiadBuffInfo );
}

function OnLoad()
{
    InitHandle();
    OnRegisterEvent();
	ResetTextures();
	script_abn = AbnormalStatusWnd (GetScript("AbnormalStatusWnd"));
	script_oly = OlympiadDmgWnd (GetScript("OlympiadDmgWnd"));
	isCastedCancel = false;
	buffNames.Length = 7;
	//Me.SetAnchor("CancelCtrlWnd", "Center", "Center", 0 , -650);
}

function InitHandle() 
{
    Me = GetWindowHandle("CancelCtrlWnd");
    tex1 = GetTextureHandle("CancelCtrlWnd.c_buff1");
    tex2 = GetTextureHandle("CancelCtrlWnd.c_buff2");
    tex3 = GetTextureHandle("CancelCtrlWnd.c_buff3");
    tex4 = GetTextureHandle("CancelCtrlWnd.c_buff4");
    tex5 = GetTextureHandle("CancelCtrlWnd.c_buff5");
    tex6 = GetTextureHandle("CancelCtrlWnd.c_buff6");
    tex7 = GetTextureHandle("CancelCtrlWnd.c_buff7");
}

function ResetTextures()
{
	tex1.SetTexture("");
	tex2.SetTexture("");
	tex3.SetTexture("");
	tex4.SetTexture("");
	tex5.SetTexture("");
	tex6.SetTexture("");
	tex7.SetTexture("");
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y) {

	if (a_WindowHandle == tex1)
	{
		UseSkill( iInfo[6], 1);
		//AddSystemMessageString("UseSkill 1");
	} else if (a_WindowHandle == tex2)
	{
		UseSkill( iInfo[5], 1);
		//AddSystemMessageString("UseSkill 2");
	} else if (a_WindowHandle == tex3)
	{
		UseSkill( iInfo[4], 1);
		//AddSystemMessageString("UseSkill 3");
	} else if (a_WindowHandle == tex4)
	{
		UseSkill( iInfo[3], 1);
		//AddSystemMessageString("UseSkill 4");
	} else if (a_WindowHandle == tex5)
	{
		UseSkill( iInfo[2], 1);
		//AddSystemMessageString("UseSkill 5");
	} else if (a_WindowHandle == tex6)
	{
		UseSkill( iInfo[1], 1);
		//AddSystemMessageString("UseSkill 6");
	} else if (a_WindowHandle == tex7)
	{
		UseSkill( iInfo[0], 1);
		//AddSystemMessageString("UseSkill 7");
	} 
}

function HandleReceiveMagicSkillUse (string a_Param)
{
	  local int AttackerID;
	  local int DefenderID;
	  local int SkillID;
	  local int SkillLevel;
	  local float SkillHitTime;
	  local UserInfo PlayerInfo;
	  local UserInfo AttackerInfo;
	  local UserInfo DefenderInfo;
	  local SkillInfo UsedSkillInfo;
	  local int SkillHitTime_ms;

	  ParseInt(a_Param,"AttackerID",AttackerID);
	  ParseInt(a_Param,"DefenderID",DefenderID);
	  ParseInt(a_Param,"SkillID",SkillID);
	  ParseInt(a_Param,"SkillLevel",SkillLevel);
	  ParseFloat(a_Param,"SkillHitTime",SkillHitTime);
	  if ( SkillHitTime > 0 )
	  {
		SkillHitTime_ms = int(SkillHitTime * 1000) + 300;
	  } else {
		SkillHitTime_ms = 100;
	  }
	  
	  GetUserInfo(AttackerID,AttackerInfo);
	  GetUserInfo(DefenderID,DefenderInfo);
	  GetPlayerInfo(PlayerInfo);
	  GetSkillInfo(SkillID,SkillLevel,UsedSkillInfo);
	  
	  if (  !IsNotDisplaySkill(SkillID) && (PlayerInfo.nID != AttackerID) && (PlayerInfo.nID == DefenderID) )
	  {
			if ( (SkillID == 1056) || (SkillID == 5682) || (SkillID == 342) || (SkillID == 1440) )
			{
				//AddSystemMessageString("Cancel/ToD/Panthera/Steal");
				//Me.ShowWindow();
				ResetTextures();
				isCastedCancel = true;
				Me.SetTimer(20100, SkillHitTime_ms + 500);
			}
			
			if (SkillID == 6094)
			{
				//AddSystemMessageString("PvP Weap Casted");
				//Me.ShowWindow();
				ResetTextures();
				isCastedCancel = true;
				Me.SetTimer(20101, SkillHitTime_ms + 500);
			}
			
			if ( (SkillID == 1350) || (SkillID == 1351) || (SkillID == 1344) || (SkillID == 1345) )
			{
				
				//AddSystemMessageString("Bane Casted");
				//Me.ShowWindow();
				ResetTextures();
				isCastedCancel = true;
				Me.SetTimer(20100, SkillHitTime_ms + 500);
			}
			
			if ( (SkillID == 1359) || (SkillID == 1361) || (SkillID == 1358) || (SkillID == 1360) )
			{
				
				//AddSystemMessageString("Block WW/Shield Casted");
				//Me.ShowWindow();
				ResetTextures();
				isCastedCancel = true;
				Me.SetTimer(20100, SkillHitTime_ms + 500);
			}
	  }
	  
	  if (  !IsNotDisplaySkill(SkillID) && (PlayerInfo.nID != AttackerID) )
	  {
			if ( (SkillID == 762) || (SkillID == 8332) || (SkillID == 8331) )
			{
				ResetTextures();
				//AddSystemMessageString("Insane Crusher Casted");
				isCastedCancel = true;
				Me.SetTimer(20102, SkillHitTime_ms + 500);
			}
	  }
}

function OnTimer(int TimerID)
{
	local int i,j;
	
	for (j = 0; j < 3; j++)
		if (TimerID == 20100 + j)
		{
			Me.SetTimer(20103 + j, 7000); //Window's disappear delay
			//AddSystemMessageString("Counter: "$counter);
			isCastedCancel = false;
			counter = 0;
			for (i = 0; i < 7; i++)
				buffNames[i] = "";
			Me.KillTimer(20100 + j);
		}
	for (j = 0; j < 3; j++)
		if (TimerID == 20103 + j)
		{
			Me.HideWindow();
			Me.KillTimer(20103 + j);
		}
}

function OnEvent(int Event_ID, String param) 
{
	if (Event_ID == EV_ReceiveMagicSkillUse && class'UIAPI_CHECKBOX'.static.IsChecked( "FlexOptionWnd.showCanceledOly" ))
	{
		if (script_oly.AtOly)
			HandleReceiveMagicSkillUse (param);    
	}
    else if (Event_ID == EV_ReceiveMagicSkillUse && class'UIAPI_CHECKBOX'.static.IsChecked( "FlexOptionWnd.showCanceled" ))
    	HandleReceiveMagicSkillUse (param);
	else if (Event_ID == EV_SystemMessage && class'UIAPI_CHECKBOX'.static.IsChecked( "FlexOptionWnd.showCanceledOly"))
	{
		if (script_oly.AtOly)
			HandleSystemMessage(param);
	}
	else if (Event_ID == EV_SystemMessage && class'UIAPI_CHECKBOX'.static.IsChecked( "FlexOptionWnd.showCanceled" ))
    	HandleSystemMessage (param);
}

function HandleSystemMessage(string param)
{
    local int msg_idx;
	local string buffName;
	local Color MsgColor;
	
	MsgColor.R = 175;
	MsgColor.G = 125;
	MsgColor.B = 50;

    ParseInt(param, "Index", msg_idx);
	
	if (msg_idx == 749) //Buff off
	{
		ParseString(param, "Param1", buffName);
		if (isCastedCancel && counter == 0)
		{
			buffNames[6] = buffName;
			counter++;
			//AddSystemMessageString("Buff after cancel: "$buffNames[6]);
			tex1.SetAnchor("CancelCtrlWnd", "TopCenter", "TopCenter", 0 , 0);
		} else
		if (isCastedCancel && counter == 1)
		{
			buffNames[5] = buffName;
			counter++;
			//AddSystemMessageString("Buff after cancel: "$buffNames[5]);
			tex1.SetAnchor("CancelCtrlWnd", "TopCenter", "TopCenter", -21 , 0);
		} else
		if (isCastedCancel && counter == 2)
		{
			buffNames[4] = buffName;
			counter++;
			//AddSystemMessageString("Buff after cancel: "$buffNames[4]);
			tex1.SetAnchor("CancelCtrlWnd", "TopCenter", "TopCenter", -42 , 0);
		} else
		if (isCastedCancel && counter == 3)
		{
			buffNames[3] = buffName;
			counter++;
			//AddSystemMessageString("Buff after cancel: "$buffNames[3]);
			tex1.SetAnchor("CancelCtrlWnd", "TopCenter", "TopCenter", -63 , 0);
		} else
		if (isCastedCancel && counter == 4)
		{
			buffNames[2] = buffName;
			counter++;
			//AddSystemMessageString("Buff after cancel: "$buffNames[2]);
			tex1.SetAnchor("CancelCtrlWnd", "TopCenter", "TopCenter", -84 , 0);
		} else
		if (isCastedCancel && counter == 5)
		{
			buffNames[1] = buffName;
			counter++;
			//AddSystemMessageString("Buff after cancel: "$buffNames[1]);
			tex1.SetAnchor("CancelCtrlWnd", "TopCenter", "TopCenter", -105 , 0);
		} else
		if (isCastedCancel && counter == 6)
		{
			buffNames[0] = buffName;
			counter++;
			//AddSystemMessageString("Buff after cancel: "$buffNames[0]);
			tex1.SetAnchor("CancelCtrlWnd", "TopCenter", "TopCenter", -126 , 0);
		}
	}
}


defaultproperties
{
}
