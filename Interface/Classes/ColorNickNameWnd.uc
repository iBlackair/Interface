class ColorNickNameWnd extends UICommonAPI;

const COLORTABLE_COUNT = 	11;

var WindowHandle 		ME;
var EditBoxHandle		NickNameEditBox;
var ComboBoxHandle		ColorComboBox;
var Color				ColorTable[COLORTABLE_COUNT];
var ButtonHandle			btnOK;
var ButtonHandle			BtnCancel;

var ItemID m_ClickedItemID;

function OnRegisterEvent()
{
	RegisterEvent(EV_ShowChangeNickNameNColor);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		ME = GetHandle("ColorNickNameWnd");
		NickNameEditBox = EditBoxHandle(GetHandle("ColorNickNameWnd.Edit_NickName"));
		ColorComboBox = ComboBoxHandle(GetHandle("ColorNickNameWnd.ColorCombo"));
		btnOK =	ButtonHandle(GetHandle("ColorNickNameWnd.BtnOk"));
		BtnCancel	=ButtonHandle(GetHandle("ColorNickNameWnd.BtnCancel"));

	}
	else
	{
		ME = GetWindowHandle("ColorNickNameWnd");
		NickNameEditBox = GetEditBoxHandle("ColorNickNameWnd.Edit_NickName");
		ColorComboBox = GetComboBoxHandle("ColorNickNameWnd.ColorCombo");
		btnOK =	GetButtonHandle("ColorNickNameWnd.BtnOk");
		BtnCancel	=GetButtonHandle("ColorNickNameWnd.BtnCancel");

	}
	
//	0	�⺻��
	ColorTable[0].A =	255;
	ColorTable[0].R = 	162;
	ColorTable[0].G =	249;
	ColorTable[0].B =	236;
//	0: 	��ũ��
	ColorTable[1].A = 	255;
	ColorTable[1].R =	255;
	ColorTable[1].G =	147;
	ColorTable[1].B =	147;
//	1:	������ũ
	ColorTable[2].A = 	255;
	ColorTable[2].R =	255;
	ColorTable[2].G =	74;
	ColorTable[2].B =	125;
//	2:	���󿻷ο�
	ColorTable[3].A = 	255;
	ColorTable[3].R =	255;
	ColorTable[3].G =	251;
	ColorTable[3].B =	153;
//	3:	���϶�
	ColorTable[4].A = 	255;
	ColorTable[4].R =	240;
	ColorTable[4].G =	155;
	ColorTable[4].B =	253;
//	4:	�ڹ�Ʈ ���̿÷�
	ColorTable[5].A = 	255;
	ColorTable[5].R =	147;
	ColorTable[5].G =	93;
	ColorTable[5].B =	255;
//	5:	��Ʈ�׸�
	ColorTable[6].A = 	255;
	ColorTable[6].R =	162;
	ColorTable[6].G =	255;
	ColorTable[6].B =	0;
//	6:	���۱׸�
	ColorTable[7].A = 	255;
	ColorTable[7].R =	0;
	ColorTable[7].G =	170;
	ColorTable[7].B =	164;
//	7:	���ο� ��Ŀ
	ColorTable[8].A = 	255;
	ColorTable[8].R =	175;
	ColorTable[8].G =	152;
	ColorTable[8].B =	120;
//	8:	���ݷ�
	ColorTable[9].A = 	255;
	ColorTable[9].R =	158;
	ColorTable[9].G =	103;
	ColorTable[9].B =	75;
//	9: 	�ǹ�
	ColorTable[10].A = 	255;
	ColorTable[10].R =	155;
	ColorTable[10].G =	155;
	ColorTable[10].B =	155;

}

function OnChangeEditBox( String strID )
{
	switch( strID )
	{
	case "Edit_NickName":
		btnOK.EnableWindow();
		break;
	}
}



function OnEvent(int EventID, string Param)
{
	switch (EventID)
	{
		case EV_ShowChangeNickNameNColor:
			OnOpenWnd(Param);
		break;
		
	}
}

function OnOpenWnd(string param)
{
	local UserInfo UserInfo;
	local color colNickNameColor;
	local string strNickName;
	local int i;
	local int ColorID;
	
	ParseItemID(param, m_ClickedItemID);
	
	ColorID = 0;
	ColorComboBox.Clear();
	
	for (i=1;i<COLORTABLE_COUNT; i++)
	{
		ColorComboBox.AddStringWithColor(GetSystemString(1750+i), ColorTable[i]);
	}


	ME.ShowWindow();
	NickNameEditBox.SetFocus();
	
	if( GetPlayerInfo( UserInfo ) )
	{
		strNickName = UserInfo.strNickName;
		colNickNameColor = UserInfo.NicknameColor;
		NickNameEditBox.Clear();
		NickNameEditBox.SetString( strNickName);

		for(i=0; i<COLORTABLE_COUNT;i++)
		{
			if (ColorTable[i] == colNickNameColor)
			{
				ColorID=i-1;
				ColorComboBox.SetSelectedNum(ColorID);
				btnOK.DisableWindow();
				break;
			}
		}
	}
	
}

function OnComboboxItemSelected(string ComboboxName, int ID)
{
	local UserInfo UserInfo;
	local color colNickNameColor;
	//~ local string strNickName;
	//~ local int i;
	local int ColorID;
	
	ColorID = 0;
	
	if( GetPlayerInfo( UserInfo ) )
	{
		colNickNameColor = UserInfo.NicknameColor;
		if (ColorTable[ID+1] == colNickNameColor)
		{
			btnOK.DisableWindow();
		}
		else
		{
			btnOK.EnableWindow();
		}
	}
}


function OnClickButton(string ButtonName)
{
	local int SelectedNum;
	switch(ButtonName)
	{
	case "BtnOk":
		if (NickNameEditBox.GetString() != "")
		{
			SelectedNum = ColorComboBox.GetSelectedNum();
			SelectedNum = SelectedNum;
			RequestChangeNicknameNColor(SelectedNum,NickNameEditBox.GetString(), m_ClickedItemID);
			ME.HideWindow();
		}
		break;
	case "BtnCancel":
		ME.HideWindow();
		break;
	}
}
defaultproperties
{
}
