class DebuffOn extends UICommonAPI;

var WindowHandle Me;

var TextureHandle DebuffTex;
var AnimTextureHandle DebuffAnim;

var string GlobalBuffName;

function OnRegisterEvent()
{
	RegisterEvent(EV_AbnormalStatusNormalItem);
	RegisterEvent(EV_SystemMessage);
}

function OnLoad()
{
	InitHandles();
	StopAnim(DebuffAnim);
}

function OnHide()
{
	StopAnim(DebuffAnim);
	Me.KillTImer(114);
}

function OnShow()
{
	StartAnim(DebuffAnim);
	Me.SetTimer(114, 3500);
}

function InitHandles()
{
	Me = GetWindowHandle("DebuffOn");
	DebuffTex = GetTextureHandle("DebuffOn.Tex");
	DebuffAnim = GetAnimTextureHandle("DebuffOn.Anim");
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 114:
			Me.KillTImer(114);
			Me.HideWindow();
		break;
	}
}

function OnEvent(int EventID, string param)
{
	switch(EventID)
	{
		case EV_AbnormalStatusNormalItem:
			if (class'UIAPI_CHECKBOX'.static.IsChecked("enableDebuffAlert")) ShowDebuff(param);
		break;
		case EV_SystemMessage:
			if (class'UIAPI_CHECKBOX'.static.IsChecked("enableDebuffAlert")) GetMessage(param);
		break;
	}
}

function ShowDebuff(string param)
{
	local int i;
	local int Max;
	local StatusIconInfo info;

	info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	info.bShow = true;
	info.bEtcItem = false;
	info.bShortItem = false;

	ParseInt(param, "ServerID", info.ServerID);
	ParseInt(param, "Max", Max);

	for (i = 0; i < Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "Description_" $ i, info.Description);
		
		if (IsValidItemID(info.ID))
			if (IsDebuff( info.ID, info.Level))
				if (info.Name == GlobalBuffName)
				{
					GlobalBuffName = "";
					DebuffTex.SetTexture(info.IconName);
					Me.ShowWindow();
				}
	}
}

function GetMessage(string param)
{
	local int MsgID;
	local string DebuffName;

	ParseInt(param, "Index", MsgID);

	//110 - $s1’s effect can be felt.

	if (MsgID == 110)
	{
		ParseString(param, "Param1", DebuffName);
		GlobalBuffName = DebuffName;
	}
}

function StartAnim(AnimTextureHandle handle)
{
	handle.ShowWindow();
	handle.Stop();
	handle.SetLoopCount(-1);
	handle.Play();
}

function StopAnim(AnimTextureHandle handle)
{
	handle.HideWindow();
	handle.Stop();
}