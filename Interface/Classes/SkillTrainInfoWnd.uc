class SkillTrainInfoWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// CONSTc
//////////////////////////////////////////////////////////////////////////////

const OFFSET_X_ICON_TEXTURE=0;
const OFFSET_Y_ICON_TEXTURE=4;
const OFFSET_Y_SECONDLINE = -14;

const OFFSET_Y_MPCONSUME=3;
const OFFSET_Y_CASTRANGE=0;
const OFFSET_Y_SP=120;

var int m_iType;
var int m_iID;
var int m_iLevel;

function OnRegisterEvent()
{
	RegisterEvent( EV_SkillTrainInfoWndShow );
	RegisterEvent( EV_SkillTrainInfoWndHide );
	RegisterEvent( EV_SkillTrainInfoWndAddExtendInfo );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
}

function OnClickButton( string strBtnID )
{
	switch(strBtnID)
	{
	case "btnLearn" :
		OnLearn();
		break;
	case "btnGoBackList" :
		HideWindow("SkillTrainInfoWnd");
		ShowWindowWithFocus("SkillTrainListWnd");
		break;
	}
}

function OnLearn()
{
// �ӽ� - lancelot 2007. 3. 26.
	local int type;
	type=-1;
	
	//switch(m_iType)
	//{
	//case ESTT_NORMAL :
	//case ESTT_FISHING :
	//case ESTT_CLAN :
	//case ESTT_TRANSFORM :
	//case 5:
	//		// �����⽺ų
	//case 6:
	//		//ä����ų
		RequestAcquireSkill(m_iID, m_iLevel, m_iType);
		//case ESTT_SUB_CLAN:
		//RequestAcquireSkillSubClan(m_iID, m_iLevel, m_iType, 0);			// ���� 4��° ���ڷ� ���� ������ �ε����� ���� ��. -lpislhy
		//break;
	//default:
	//	break;
	//}
}


function OnEvent(int Event_ID, string param)
{
	local int iType;

	local string strIconName;
	local string strName;
	local int iID;
	local int iLevel;
	local int iSPConsume;
	local INT64 iEXPConsume;

	local string strDescription;
	local string strOperateType;

	local int iMPConsume;
	local int iCastRange;
	local INT64 iNumOfItem;

	local string strEnchantName;
	local string strEnchantDesc;

	local int iPercent;


	switch(Event_ID)
	{
	case EV_SkillTrainInfoWndShow :
		ParseInt(param, "Type", iType);
		m_iType=iType;
	
		if(m_iType == ESTT_SUB_CLAN) return;		// �����δ� ��ų�̸� ����
		ParseString(param, "strIconName", strIconName); 
		ParseString(param, "strName", strName);
		ParseInt(param, "iID", iID);
		ParseInt(param, "iLevel", iLevel);
		ParseString(param, "strOperateType", strOperateType);
		ParseInt(param, "iMPConsume", iMPConsume);
		ParseInt(param, "iCastRange", iCastRange);
		ParseInt(param, "iSPConsume", iSPConsume);
		ParseString(param, "strDescription", strDescription);
		ParseInt64(param, "iEXPConsume", iEXPConsume);
		ParseString(param, "strEnchantName", strEnchantName);
		ParseString(param, "strEnchantDesc", strEnchantDesc);
		ParseInt(param, "iPercent", iPercent);

		m_iType=iType;
		m_iID=iID;
		m_iLevel=iLevel;

		ShowSkillTrainInfoWnd();
		AddSkillTrainInfo(strIconName, strName, iID, iLevel, strOperateType, iMPConsume, iCastRange, strDescription, iSPConsume, iEXPConsume, strEnchantName, strEnchantDesc, iPercent);
		break;

	case EV_SkillTrainInfoWndAddExtendInfo :
		if(m_iType == ESTT_SUB_CLAN) return;		// �����δ� ��ų�̸� ����
		ParseString(param, "strIconName", strIconName); 
		ParseString(param, "strName", strName);
		ParseINT64(param, "iNumOfItem", iNumOfItem);
		
		AddSkillTrainInfoExtend(strIconName, strName, iNumOfItem);
		ShowNeedItems();
		break;

	case EV_SkillTrainInfoWndHide :
		if(m_iType == ESTT_SUB_CLAN) return;		// �����δ� ��ų�̸� ����
		if(IsShowWindow("SkillTrainInfoWnd"))
			HideWindow("SkillTrainInfoWnd");
		break;
	}
}



// ��ų Ʈ���̴� ������ �ʱ�ȭ ��Ŵ
function ShowSkillTrainInfoWnd()
{
	local int iWindowTitle;
	local int iSPIdx;

	local UserInfo infoPlayer;
	local int iPlayerSP;
	local INT64 iPlayerEXP;

	GetPlayerInfo(infoPlayer);

	switch(m_iType)
	{
	case ESTT_CLAN :
	case ESTT_SUB_CLAN:
		iWindowTitle=1436;
		iSPIdx=1372;
		iPlayerSP=GetClanNameValue(infoPlayer.nClanID);
		break;
	//case ESTT_NORMAL :
	//case ESTT_FISHING :
	default:
		iWindowTitle=477;
		iSPIdx=92;
		iPlayerSP=infoPlayer.nSP;
		iPlayerEXP=infoPlayer.nCurExp;
		break;
	}

	class'UIAPI_WINDOW'.static.SetWindowTitle("SkillTrainInfoWnd", iWindowTitle);					// ���� Ÿ��Ʋ ����
	//SetBackTex("L2UI_CH3.SkillTrainWnd.SkillTrain2");									// 9������� �����ϸ鼭 ����
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtSPString", GetSystemString(iSPIdx));	// SP or ���͸�ġ �۾�
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtSP", iPlayerSP);						// SP or ���͸�ġ

	ShowWindowWithFocus("SkillTrainInfoWnd");
}

function AddSkillTrainInfo(string strIconName, string strName, int iID, int iLevel, string strOperateType, int iMPConsume, int iCastRange, string strDescription, int iSPConsume, INT64 iEXPConsume, string strEnchantName, string strEnchantDesc, int iPercent)
{
	// ������ ������
	class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.texIcon", strIconName);
	// ��ų�̸�
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtName", strName);

	// level ����
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtLevel", iLevel);
	// �۵�Ÿ��
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.txtOperateType", strOperateType);
	// �Ҹ�MP
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtMP", iMPConsume);
	// ��ų���� 
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtDescription", strDescription);

	switch(m_iType)
	{
	case ESTT_CLAN :			// ���ͽ�ų�϶��� �ʿ� ���͸�ġ
	case ESTT_SUB_CLAN:
		class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(1437));
		break;
	//case ESTT_NORMAL :			// �׳��� �ʿ�SP
	//case ESTT_FISHING :
	default:
		class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedSPString", GetSystemString(365));
		break;
	}
	// �ʿ�SP ����
	class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.SubWndNormal.txtNeedSP", iSPConsume);
	
	if(iCastRange>=0)
	{
		// �����ְ�
		ShowWindow("SkillTrainInfoWnd.txtCastRangeString");
		ShowWindow("SkillTrainInfoWnd.txtColoneCastRange");
		ShowWindow("SkillTrainInfoWnd.txtCastRange");
		class'UIAPI_TEXTBOX'.static.SetInt("SkillTrainInfoWnd.txtCastRange", iCastRange);
	}
	else
	{
		// �����ش�
		HideWindow("SkillTrainInfoWnd.txtCastRangeString");
		HideWindow("SkillTrainInfoWnd.txtColoneCastRange");
		HideWindow("SkillTrainInfoWnd.txtCastRange");
	}
}

function AddSkillTrainInfoExtend(string strIconName, string strName, INT64 iNumOfItem)
{
	// ������ ������
	class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon", strIconName);
	// ��ų�̸�
	class'UIAPI_TEXTBOX'.static.SetText("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName", strName$" X "$ Int64ToString(iNUmOfItem));
}

function OnShow()
{
	HideWindow("SkillTrainInfoWnd.SubWndEnchant");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal");
	// �ʿ��� ������ ���� �����ش�
	HideWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
	HideWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
	//~ ShowWindow("SkillTrainInfoWnd.txtColoneCastRange");
}

function ShowNeedItems()
{
	// �����۾����ܰ� �̸�
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.texNeedItemIcon");
	ShowWindow("SkillTrainInfoWnd.SubWndNormal.txtNeedItemName");
}

// 9������� �����ϸ鼭 ����
/*
function SetBackTex(string strFile)
{
	class'UIAPI_TEXTURECTRL'.static.SetTexture("SkillTrainInfoWnd.texBack", strFile);
}
*/
defaultproperties
{
}
