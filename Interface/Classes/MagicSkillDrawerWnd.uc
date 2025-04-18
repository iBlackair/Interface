class MagicSkillDrawerWnd extends UICommonAPI;

const MIN_ENCHANT_LEVEL = 1;
const MAX_ENCHANT_LEVEL = 30;
const SKILL_ENCHANT_NUM = 10;
const ENCHANT_NORMAL = 0;			// ���� ��æƮ
const ENCHANT_SAFETY = 1;			// ������Ƽ ��æƮ
const ENCHANT_UNTRAIN = 2;			// ��æƮ ��Ʈ����
const ENCHANT_ROOT_CHANGE = 3;		// ��æƮ ��Ʈ ü����
const ENCHANT_MATERIAL_NUM = 3;		// ����� ��
const ARROW_NUM = 9;				// ������ ���̿� ���� �ؽ��� ����

const DIALOGID_ResearchClick = 0;

var String m_WindowName;
var WindowHandle Me;
var WindowHandle MagicskillGuideWnd;
var TextureHandle ResearchSkill;
var TextureHandle SelectSkill;
var TextureHandle ResearchSkillArrow_Right;
var TextureHandle ResearchSkillArrow_Left;
var TextureHandle ResearchSkillArrow_Down;
var TextureHandle ResearchSkillArrow_Up;
var ItemWindowHandle ResearchSkillIcon;
var TextureHandle ResearchSkillIconSlotBg;
var TextBoxHandle ResearchSkillTitle;
var TextBoxHandle ResearchSkillName;
var TextBoxHandle ResearchSkillRoot;
var TextBoxHandle ResearchSkillDesc;
var TextBoxHandle ResearchSkillLv;
var TextBoxHandle ResearchSkillRootLv;
var ItemWindowHandle ExpectationSkillIcon;
var TextureHandle ExpectationSkillIconSlotBg;
var TextBoxHandle ExpectationSkillTitle;
var TextBoxHandle ExpectationSkillName;
var TextBoxHandle ExpectationSkillRoot;
var TextBoxHandle ExpectationSkillDesc;
var TextBoxHandle ExpectationSkillLv;
var TextBoxHandle ExpectationSkillRootLv;
var TextBoxHandle SucessProbablity;

var ButtonHandle ResearchRoot_1[SKILL_ENCHANT_NUM];
var ButtonHandle ResearchRoot_2[SKILL_ENCHANT_NUM];
var ButtonHandle ResearchRoot_3[SKILL_ENCHANT_NUM];

var int	ResearchRoot2ID[SKILL_ENCHANT_NUM];
var int ResearchRoot2Level[SKILL_ENCHANT_NUM];
var string ResearchRoot2SkillIconName[SKILL_ENCHANT_NUM];
var string ResearchRoot2SkillName[SKILL_ENCHANT_NUM];

var TextBoxHandle ResearchRootTitle;
var TextureHandle ResearchRootSlotBg;
var CheckBoxHandle SafeEnchant;
var TextBoxHandle EnchantMaterialTitle;
var TextBoxHandle EnchantMaterialName[ENCHANT_MATERIAL_NUM];
var TextBoxHandle EnchantMaterialInfo[ENCHANT_MATERIAL_NUM];
var ItemWindowHandle EnchantMaterialIcon[ENCHANT_MATERIAL_NUM];
var TextureHandle EnchantMaterialIconBg[ENCHANT_MATERIAL_NUM];
var TextBoxHandle ResearchGuideTitle;
var TextBoxHandle ResearchGuideDesc;
var CharacterViewportWindowHandle ObjectViewport;
var ButtonHandle btnGuide;
var ButtonHandle btnResearch;
var ButtonHandle btnClose;
var TextureHandle ResearchSkillBg;
var TextureHandle ExpectationSkillBg;
var TextureHandle ResearchRootBg;
var TextureHandle ResearchMaterialIconBg;
var TextureHandle ResearchGuideBg;
var TextBoxHandle txtMySpStr;
var TextBoxHandle txtMySp;
var TextureHandle MyAdenaIcon;
var TextBoxHandle txtMyAdenaStr;
var TextBoxHandle txtMyAdena;
var AnimTextureHandle EnchantProgressAnim;
var int curEnchantType;
var int EnchantState;	 //���� ���� ���� ��æƮ ��� ����

var TextureHandle ResearchSkill_2[SKILL_ENCHANT_NUM];
var TextureHandle ResearchRoot_Select_1[SKILL_ENCHANT_NUM];
var TextureHandle ResearchRoot_Select_2[SKILL_ENCHANT_NUM];
var TextureHandle ResearchRoot_Select_3[SKILL_ENCHANT_NUM];
var TextureHandle ResearchSkill_UpArrow_2[SKILL_ENCHANT_NUM];
var TextureHandle ResearchSkill_DownArrow_2[SKILL_ENCHANT_NUM];
var TextureHandle ResearchSkill_LeftArrow_2[SKILL_ENCHANT_NUM];
var TextureHandle ResearchSkill_RightArrow_2[SKILL_ENCHANT_NUM];

var TextureHandle ResearchSkill_Right_2[ARROW_NUM];
var TextureHandle ResearchSkill_Left_2[ARROW_NUM];

var CharacterViewportWindowHandle m_hVpAgathion;

var int enableTrain;
var int enableunTrain;
var int ArrowPositionStart;
var int ArrowPositionEnd;

// ���� ������ ��ų ����
var int curSkillID; 
var int curLevel;
// ���� ���� ��æƮ,��Ʈ,��Ʈ���� �ϰ���� ��ų�� ����
var int curWantedSkillID;
var int curWantedLevel;

var int countOfRoutes;

//AUTO_SKILL_ENCHANT_START
var TextureHandle texAuto;
var TextureHandle texSpeed;

var ButtonHandle btnStart;
var ButtonHandle btnStop;

var ComboBoxHandle routeBox;

var EditBoxHandle desiredValue;

var TextBoxHandle txtValue;
var TextBoxHandle txtSpeed;

var SliderCtrlHandle Slider0;

var int TimerDelay;
var int TempCheck;
var int needAdena;
var int needCodex;
var int needMastery;
var int needSP;
var bool isMastery;
var int value;
//AUTO_SKILL_ENCHANT_END


function OnLoad()
{
	m_WindowName="MagicSkillDrawerWnd";
	
	Initialize();
	
	OnLoadAutoEnch();
}

function OnLoadAutoEnch()
{
	texAuto = GetTextureHandle( "MagicSkillDrawerWnd.texAuto" );
	texSpeed = GetTextureHandle( "MagicSkillDrawerWnd.texSpeed" );
	
	btnStart = GetButtonHandle( "MagicSkillDrawerWnd.btnStart" );
	btnStop = GetButtonHandle( "MagicSkillDrawerWnd.btnStop" );
	
	routeBox = GetComboBoxHandle( "MagicSkillDrawerWnd.routesBox" );
	
	desiredValue = GetEditBoxHandle( "MagicSkillDrawerWnd.desiredEnch" );
	
	txtValue = GetTextBoxHandle( "MagicSkillDrawerWnd.txtValue" );
	txtSpeed = GetTextBoxHandle( "MagicSkillDrawerWnd.txtSpeed" );
	
	Slider0 = GetSliderCtrlHandle( "MagicSkillDrawerWnd.Slider0" );
	
	HideAutoEnchItems();
	routeBox.Clear();
	routeBox.SetSelectedNum(0);
	
	TempCheck = -1;
	
	TimerDelay = 250;
	txtSpeed.SetText( string( TimerDelay ) );
}

function int GetSpeedFromSliderTick( int iTick )
{
	local int ReturnSpeed;
	switch( iTick )
	{
	case 0 :
		ReturnSpeed = 250;
		break;
	case 1 :
		ReturnSpeed = 350;
		break;
	case 2 :
		ReturnSpeed = 500;
		break;
	case 3 :
		ReturnSpeed = 750;
		break;
	case 4 :
		ReturnSpeed = 1000;
		break;
	case 5 :
		ReturnSpeed = 1250;
		break;
	case 6 :
		ReturnSpeed = 1500;
		break;
	case 7 :
		ReturnSpeed = 2000;
		break;
	}
	
	return ReturnSpeed;
}

function OnModifyCurrentTickSliderCtrl( string strID, int iCurrentTick )
{
	local int Speed;
	Speed = GetSpeedFromSliderTick( iCurrentTick );
	switch(strID)
	{
	case "Slider0" :
		TimerDelay = Speed;
		txtSpeed.SetText( string( Speed ) );
		break;
	}
}

function OnComboBoxItemSelected (string strID, int Index)
{
	switch (strID)
	{
		case "routesBox":
			OnRootChoose( Index );
		break;
	}
}

function OnRootChoose( int idx )
{
	TempCheck = idx;
		
	OnResearchRoot_2Click( idx );
	ExtraClick2( idx );
}

function ExtraClick2( int id )
{
	if( enableTrain == 1 && enableUnTrain == 0 )
	{
			
			ResetCoverArrow();
			ResetSideArrow();
			SelectSkill.ClearAnchor();
			SelectSkill.SetAnchor( "MagicSkillDrawerWnd", "TopLeft", "TopLeft", 13 + 43 * id, 288 );
			SelectSkill.ShowWindow();
	}
	else
	{
			ResetCoverArrow();
			SelectSkill.ClearAnchor();
			SelectSkill.SetAnchor( "MagicSkillDrawerWnd", "TopLeft", "TopLeft", 13 + 43 * id, 288 );
			SelectSkill.ShowWindow();
			ArrowPositionEnd = id;
			ResetSideArrow();
			DrawArrow ();
	}
}

function ShowAutoEnchItems()
{
	ResearchRootSlotBg.SetWindowSize( 304, 132 );
	
	texAuto.ShowWindow();
	texSpeed.ShowWindow();
	btnStart.ShowWindow();
	routeBox.ShowWindow();
	desiredValue.ShowWindow();
	txtValue.ShowWindow();
	txtSpeed.ShowWindow();
	Slider0.ShowWindow();
}

function HideAutoEnchItems()
{
	ResearchRootSlotBg.SetWindowSize( 431, 132 );
	
	texAuto.HideWindow();
	texSpeed.HideWindow();
	btnStart.HideWindow();
	btnStop.HideWindow();
	routeBox.HideWindow();
	desiredValue.HideWindow();
	txtValue.HideWindow();
	txtSpeed.HideWindow();
	Slider0.HideWindow();
}


function OnRegisterEvent()
{
	RegisterEvent( EV_SkillEnchantInfoWndShow );
	RegisterEvent( EV_SkillEnchantInfoWndAddSkill );
//	RegisterEvent( EV_SkillEnchantInfoWndHide );
	RegisterEvent( EV_SkillEnchantInfoWndAddExtendInfo );
	RegisterEvent( EV_SkillEnchantResult );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}


function Initialize()
{
	local int i;
	Me = GetWindowHandle( m_WindowName );
	MagicskillGuideWnd = GetWindowHandle( "MagicskillGuideWnd");
	ResearchSkill = GetTextureHandle (   m_WindowName$".ResearchSkill"  );
	SelectSkill = GetTextureHandle (   m_WindowName$".SelectSkill"  );
	ResearchSkillArrow_Right = GetTextureHandle (   m_WindowName$".ResearchSkillArrow_Right"  );
	ResearchSkillArrow_Left = GetTextureHandle (   m_WindowName$".ResearchSkillArrow_Left"  );
	ResearchSkillArrow_Down = GetTextureHandle (   m_WindowName$".ResearchSkillArrow_Down"  );
	ResearchSkillArrow_Up = GetTextureHandle (   m_WindowName$".ResearchSkillArrow_Up"  );
	ResearchSkillIcon = GetItemWindowHandle (   m_WindowName$".ResearchSkillIcon"  );
	ResearchSkillIconSlotBg = GetTextureHandle (   m_WindowName$".ResearchSkillIconSlotBg"  );
	ResearchSkillTitle = GetTextBoxHandle (   m_WindowName$".ResearchSkillTitle"  );
	ResearchSkillName = GetTextBoxHandle (   m_WindowName$".ResearchSkillName"  );
	ResearchSkillRoot = GetTextBoxHandle (   m_WindowName$".ResearchSkillRoot"  );
	ResearchSkillDesc = GetTextBoxHandle (   m_WindowName$".ResearchSkillDesc"  );
	ResearchSkillLv = GetTextBoxHandle(   m_WindowName$".ResearchSkillLv"  );
    ResearchSkillRootLv = GetTextBoxHandle(   m_WindowName$".ResearchSkillRootLv"  );
	ExpectationSkillIcon = GetItemWindowHandle (   m_WindowName$".ExpectationSkillIcon"  );
	ExpectationSkillIconSlotBg = GetTextureHandle (   m_WindowName$".ExpectationSkillIconSlotBg"  );
	ExpectationSkillTitle = GetTextBoxHandle (   m_WindowName$".ExpectationSkillTitle"  );
	ExpectationSkillName = GetTextBoxHandle (   m_WindowName$".ExpectationSkillName"  );
	ExpectationSkillRoot = GetTextBoxHandle (   m_WindowName$".ExpectationSkillRoot"  );
	ExpectationSkillDesc = GetTextBoxHandle (   m_WindowName$".ExpectationSkillDesc"  );
	ExpectationSkillLv = GetTextBoxHandle (   m_WindowName$".ExpectationSkillLv"  );
	ExpectationSkillRootLv = GetTextBoxHandle (   m_WindowName$".ExpectationSkillRootLv"  );

	SucessProbablity = GetTextBoxHandle (   m_WindowName$".SucessProbablity"  );
	for (i =0; i < SKILL_ENCHANT_NUM; i++)
	{
		ResearchRoot_1[i] = GetButtonHandle(m_WindowName$".ResearchRoot_1_"$string(i));
		ResearchRoot_2[i] = GetButtonHandle(m_WindowName$".ResearchRoot_2_"$string(i));
		ResearchRoot_3[i] = GetButtonHandle(m_WindowName$".ResearchRoot_3_"$string(i));


		ResearchSkill_2[i] = GetTextureHandle(m_WindowName$".ResearchSkill_2_"$string(i));
		ResearchRoot_Select_1[i] = GetTextureHandle(m_WindowName$".ResearchRoot_Select_1_"$string(i));
		ResearchRoot_Select_2[i] = GetTextureHandle(m_WindowName$".ResearchRoot_Select_2_"$string(i));
		ResearchRoot_Select_3[i] = GetTextureHandle(m_WindowName$".ResearchRoot_Select_3_"$string(i));

		ResearchSkill_UpArrow_2[i] = GetTextureHandle(m_WindowName$".ResearchSkill_UpArrow_2_"$string(i));
		ResearchSkill_DownArrow_2[i] = GetTextureHandle(m_WindowName$".ResearchSkill_DownArrow_2_"$string(i));
		}

	for (i = 0; i < ARROW_NUM ; i++)
	{
		ResearchSkill_Right_2[i] = GetTextureHandle(m_WindowName$".ResearchSkill_Right_2_"$string(i));
		ResearchSkill_Left_2[i] = GetTextureHandle(m_WindowName$".ResearchSkill_Left_2_"$string(i));
		ResearchSkill_LeftArrow_2[i] = GetTextureHandle(m_WindowName$".ResearchSkill_LeftArrow_2_"$string(i));
		ResearchSkill_RightArrow_2[i] = GetTextureHandle(m_WindowName$".ResearchSkill_RightArrow_2_"$string(i));
	}

	ResearchRootTitle = GetTextBoxHandle (   m_WindowName$".ResearchRootTitle"  );
	ResearchRootSlotBg = GetTextureHandle (   m_WindowName$".ResearchRootSlotBg"  );
	SafeEnchant = GetCheckBoxHandle (   m_WindowName$".SafeEnchant"  );

	EnchantMaterialTitle = GetTextBoxHandle (   m_WindowName$".EnchantMaterialTitle"  );
	for (i = 0; i < ENCHANT_MATERIAL_NUM; i++)
	{
		EnchantMaterialName[i] = GetTextBoxHandle (   m_WindowName$".EnchantMaterialName_"$string(i) );
		EnchantMaterialInfo[i] = GetTextBoxHandle (   m_WindowName$".EnchantMaterialInfo_"$string(i) );
		EnchantMaterialIcon[i] = GetItemWindowHandle (   m_WindowName$".EnchantMaterialIcon_"$string(i)  );
		EnchantMaterialIconBg[i] = GetTextureHandle (   m_WindowName$".EnchantMaterialIconBg_"$string(i)  );

	}
	
	ResearchGuideTitle = GetTextBoxHandle (   m_WindowName$".ResearchGuideTitle"  );
	ResearchGuideDesc = GetTextBoxHandle (   m_WindowName$".ResearchGuideDesc"  );
	ObjectViewport = GetCharacterViewportWindowHandle (   m_WindowName$".ObjectViewport"  );
	btnGuide = GetButtonHandle (   m_WindowName$".btnGuide"  );
	btnResearch = GetButtonHandle (   m_WindowName$".btnResearch"  );
	btnClose = GetButtonHandle (   m_WindowName$".btnClose"  );
	ResearchSkillBg = GetTextureHandle (   m_WindowName$".ResearchSkillBg"  );
	ExpectationSkillBg = GetTextureHandle (   m_WindowName$".ExpectationSkillBg"  );
	ResearchRootBg = GetTextureHandle (   m_WindowName$".ResearchRootBg"  );
	ResearchMaterialIconBg = GetTextureHandle (   m_WindowName$".ResearchMaterialIconBg"  );
	ResearchGuideBg = GetTextureHandle (   m_WindowName$".ResearchGuideBg"  );
	txtMySpStr = GetTextBoxHandle (   m_WindowName$".txtMySpStr"  );
	txtMySp = GetTextBoxHandle (   m_WindowName$".txtMySp"  );
	txtMyAdenaStr = GetTextBoxHandle (   m_WindowName$".txtMyAdenaStr"  );
	txtMyAdena = GetTextBoxHandle (   m_WindowName$".txtMyAdena"  );
	MyAdenaIcon = GetTextureHandle (   m_WindowName$".MyAdenaIcon"  );
	EnchantProgressAnim = GetAnimTextureHandle (  m_WindowName$".EnchantProgressAnim"  );

	m_hVpAgathion = GetCharacterViewportWindowHandle(m_WindowName$".agathionViewport");

	EnchantProgressAnim.hidewindow();
	
	btnGuide.HideWindow();
}


function OnDrawerShowFinished()
{
	m_hVpAgathion.ShowNPC(0.5);
}

function HideAgathion()
{
	m_hVpAgathion.HideNPC(0.5);
}


function DrawArrow () //int startPosition, int EndPosition
{
	local int i;
	local int s_P;
	local int e_p;

	s_P = ArrowPositionStart;
	e_p = ArrowPositionEnd;

	if (curLevel > 100)
	{
		if ( ArrowPositionStart < ArrowPositionEnd)
		{
			for (i = s_P; i < e_p; i++)
			{
				ResearchSkill_Right_2[i].ShowWindow();
			}
				ResearchSkill_RightArrow_2[ e_p -1 ].ShowWindow();

		} else if ( ArrowPositionStart > ArrowPositionEnd)
		{
			for (i = e_p; i < s_P; i++)
			{
				ResearchSkill_Left_2[ i ].ShowWindow();
			}
				
				ResearchSkill_LeftArrow_2[ e_p ].ShowWindow();
				
		}
	}

}


function ResetCoverArrow()
{
	local int i;

	for (i=0;i<ARROW_NUM;i++)
	{
		ResearchSkill_Right_2[i].HideWindow();
		ResearchSkill_Left_2[i].HideWindow();
			//ResearchSkill_2[i].HideWindow(); // ��ȭ ����� ���� ���õǾ� �ִ� �������� ����������� �ּ� ó��
	}


}

function ResetSideArrow()
{
	local int i;

	for (i=0;i<SKILL_ENCHANT_NUM;i++)
	{
		ResearchSkill_UpArrow_2[i].HideWindow();
		ResearchSkill_DownArrow_2[i].HideWindow();
	
	}

		for (i = 0; i < ARROW_NUM ; i++)
	{
		ResearchSkill_RightArrow_2[i].HideWindow();
		ResearchSkill_LeftArrow_2[i].HideWindow();
	}
}


function OnClickButton( string Name )
{

	local int		rootID;
	local ItemInfo	infoCheck;
	

	if ( InStr( Name ,"ResearchRoot_1_") > -1 )
	{
		rootID = int(Right(Name, 1));
		OnResearchRoot_1Click(rootID);
	

		
		SelectSkill.ClearAnchor();
		SelectSkill.SetAnchor( "MagicSkillDrawerWnd", "TopLeft", "TopLeft", 13 + 43 * rootID, 245 );
		SelectSkill.ShowWindow();
		
		ResetSideArrow();
		ResetCoverArrow();
		ResearchSkill_UpArrow_2[rootID].ShowWindow();
		


	}
	// //�����ؾ���
	if ( InStr( Name ,"ResearchRoot_2_") > -1 )
	{
		rootID = int(Right(Name, 1));
		OnResearchRoot_2Click(rootID);
		
		if( enableTrain == 1 && enableUnTrain == 0 )
		{
			
			ResetCoverArrow();
			ResetSideArrow();
			SelectSkill.ClearAnchor();
			SelectSkill.SetAnchor( "MagicSkillDrawerWnd", "TopLeft", "TopLeft", 13 + 43 * rootID, 288 );
			SelectSkill.ShowWindow();
			
			

		}else
		{
			ResetCoverArrow();
			SelectSkill.ClearAnchor();
			SelectSkill.SetAnchor( "MagicSkillDrawerWnd", "TopLeft", "TopLeft", 13 + 43 * rootID, 288 );
			SelectSkill.ShowWindow();
			ArrowPositionEnd = rootID;

			ResetSideArrow();
			DrawArrow ();
		}
	
		//ResearchSkill_Right_Test_2_0.ShowWindow();
		//SelectSkill.Showwindow();
		//ResearchSkill.MoveTo(13 + 43 * rootID, 261);
		
	}

	if ( InStr( Name ,"ResearchRoot_3_") > -1 )
	{
		rootID = int(Right(Name, 1));
		OnResearchRoot_3Click(rootID);

	
		SelectSkill.ClearAnchor();

			
		SelectSkill.SetAnchor( "MagicSkillDrawerWnd", "TopLeft", "TopLeft", 13 + 43 * rootID, 331 );
		SelectSkill.ShowWindow();

		ResetSideArrow();
		ResetCoverArrow();
		ResearchSkill_DownArrow_2[rootID].ShowWindow();


		
	//	debug("rootid"$rootID);
	}

	switch( Name )
	{
	
	case "btnGuide":
		OnbtnGuideClick();
		break;
	case "btnResearch":
		OnbtnResearchClick( );
		break;
	case "btnClose":
		OnbtnCloseClick( );
		break;
	case "btnAuto":
		if ( ResearchSkillIcon.GetItem(0, infoCheck) )
		{
			if ( texAuto.IsShowWindow() )
			{
				HideAutoEnchItems();
				tempCheck = -1;
			}
			else
			{
				ShowAutoEnchItems();
			}
		}
		else
		{
			DialogShow( DIALOG_Modalless, DIALOG_OK, "Choose skill to enchant!" );
		}	
		break;
	case "btnStart":
		OnClickStart();
		break;
	case "btnStop":
		OnClickStop();
		break;
	}

}

function OnTimer( int TimerID )
{
	switch ( TimerID )
	{
		case 7776:
		Me.KillTimer(7776);
		if (curLevel != value)
			OnClickStart();
		else
		{
			OnClickStop();
			DialogShow( DIALOG_Modalless, DIALOG_OK, "You've got desired enchant!" );
		}	
		break;
		default:
		break;
	}
}

function OnClickStart()
{
	switch ( CalculateResourses() )
	{
		case 0:
		break;
		case 1:
			OnClickStop();
			DialogShow( DIALOG_Modalless, DIALOG_OK, "Not enough SP!" );
			return;
		break;
		case 2:
			OnClickStop();
			DialogShow( DIALOG_Modalless, DIALOG_OK, "Not enough Adena!" );
			return;
		break;
		case 3:
			OnClickStop();
			DialogShow( DIALOG_Modalless, DIALOG_OK, "Not enough Codex!" );
			return;
		case 4:
			OnClickStop();
			DialogShow( DIALOG_Modalless, DIALOG_OK, "Not enough Mastery!" );
			return;
		break;
	}
	
	if (tempCheck != -1)
	{
		RequestExEnchantSkillInfoDetail(EnchantState, curWantedSkillID, curWantedLevel);
	}

	if (routeBox.GetSelectedNum() < 0)
	{
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Choose enchat route!" );
		return;
	}
	
	value = int( desiredValue.GetString() );
	
	if (value <= 1 || value > 30)
	{
		OnClickStop();
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Choose value between 1 - 30(15)" );
		return;
	}

	value = (routeBox.GetSelectedNum() + 1 ) * 100 + value;
	
	if (curWantedLevel == curLevel)
	{
		OnClickStop();
		DialogShow( DIALOG_Modalless, DIALOG_OK, "You've got max enchant!" );
		return;
	}
	
	if (curWantedLevel != 0 && curLevel != value)
	{
		Me.KillTimer(7776);
		btnStart.HideWindow();
		btnStop.ShowWindow();
		RequestExEnchantSkill(EnchantState, curWantedSkillID, curWantedLevel);
		Me.SetTimer(7776, TimerDelay);
	}
	else if (value < curLevel)
	{
		OnClickStop();
		DialogShow( DIALOG_Modalless, DIALOG_OK, "Value less than current level!" );
	}
	else
	{
		OnClickStop();
		DialogShow( DIALOG_Modalless, DIALOG_OK, "You've got max enchant!" );
	}
		
	
}

function OnClickStop()
{
	btnStart.ShowWindow();
	btnStop.HideWindow();
	Me.KillTimer(7776);
}

function int CalculateResourses()
{
	local int SP, Adena;
	local ItemWindowHandle i_handle;
	local int index_codex, index_mastery;
	local ItemID item_id_codex, item_id_mastery;
	local ItemInfo codexInfo, masteryInfo;
	
	SP = GetUserSP();
	Adena = Int64ToInt(GetAdena());
	
	i_handle = GetItemWindowHandle("InventoryWnd.InventoryItem");
	item_id_codex.ClassID = 6622;
	item_id_mastery.ClassID = 9627;
	
	index_codex = i_handle.Finditem(item_id_codex);
	index_mastery = i_handle.Finditem(item_id_mastery);
	
	i_handle.GetItem(index_codex, codexInfo);
	i_handle.GetItem(index_mastery, masteryInfo);
	
	if (SP < needSP)
		return 1;
	else if (Adena < needAdena)
		return 2;
	else if ( Int64ToInt(codexInfo.ItemNum) < needCodex && !isMastery )
		return 3;
	else if ( Int64ToInt(masteryInfo.ItemNum) < needMastery && isMastery )
		return 4;
	else
		return 0;
}

function int GetUserSP()
{
	local UserInfo infoPlayer;
	local int iPlayerSP;

	GetPlayerInfo(infoPlayer);
	iPlayerSP = infoPlayer.nSP;

	return iPlayerSP;
}

function OnClickCheckBox( String strID)
{

	switch (strID)
	{
	case "SafeEnchant":
//		debug("�ҷ�����?5");
		if (SafeEnchant.IsChecked())
		{
			EnchantState = ENCHANT_SAFETY;
			btnResearch.SetNameText("");
			btnResearch.SetNameText(GetSystemString(2069));
			ResearchGuideDesc.SetText(GetSystemString(2050)); //"��ų ������ ��æƮ�� ���õǾ����ϴ�. ��æƮ ��ư�� �������ּ���."
			RequestExEnchantSkillInfoDetail(ENCHANT_SAFETY, curWantedSkillID, curWantedLevel);
			

	//		curWantedSkillID = infoid;
	//		curWantedLevel = infolevel;

		}
		else
		{
			EnchantState = ENCHANT_NORMAL;
			btnResearch.SetNameText("");
			btnResearch.SetNameText(GetSystemString(2070));
			ResearchGuideDesc.SetText(GetSystemString(2051)); //"��ų ��æƮ�� ���õǾ����ϴ�. ��æƮ ��ư�� �������ּ���."
			RequestExEnchantSkillInfoDetail(ENCHANT_NORMAL, curWantedSkillID, curWantedLevel);
			

	//		curWantedSkillID = infoid;
	//		curWantedLevel = infolevel;
		}
	break;
	}
}



function OnResearchRoot_1Click(int index)
{

	local int infoid;
	local int infolevel;

	infoid = ResearchRoot2ID[index];
	if(enableTrain == 1 && enableUnTrain == 0)
	{
		infolevel = ResearchRoot2Level[index];
	}else
	{
		infolevel = ResearchRoot2Level[index] + 1;
	}

	
	SetAdenaSpInfo();

	
	btnResearch.EnableWindow();
//	ResearchRoot_2[index].GetItem(index,info);
//	debug("�ҷ�����??2");
	SafeEnchant.EnableWindow();
	
	curWantedSkillID = infoid;
	curWantedLevel = infolevel;

	if (SafeEnchant.IsChecked())
	{
		EnchantState = ENCHANT_SAFETY;
		RequestExEnchantSkillInfoDetail(ENCHANT_SAFETY, curWantedSkillID, curWantedLevel);
		btnResearch.SetNameText("");
		btnResearch.SetNameText(GetSystemString(2069));
		ResearchGuideDesc.SetText(GetSystemString(2050));   ///"��ų ������ ��æƮ�� ���õǾ����ϴ�. ��æƮ ��ư�� �������ּ���."


	}
	else
	{
		EnchantState = ENCHANT_NORMAL;
		RequestExEnchantSkillInfoDetail(ENCHANT_NORMAL, curWantedSkillID, curWantedLevel);
		btnResearch.SetNameText("");
		btnResearch.SetNameText(GetSystemString(2070));
		ResearchGuideDesc.SetText(GetSystemString(2051));			///"��ų ��æƮ�� ���õǾ����ϴ�. ��æƮ ��ư�� �������ּ���."

	}
	
}

function OnResearchRoot_2Click(int index)
{
	local int infoid;
	local int infolevel;

	SetAdenaSpInfo();

	//EnchantState = ENCHANT_ROOT_CHANGE;
	infoid = ResearchRoot2ID[index];
	infolevel = ResearchRoot2Level[index];

	SafeEnchant.DisableWindow();
	curWantedSkillID = infoid;
	curWantedLevel = infolevel;

	if( enableTrain == 1 && enableUnTrain == 0 )
	{

			
		if(SafeEnchant.IsChecked())
		{
		EnchantState = ENCHANT_SAFETY;
		RequestExEnchantSkillInfoDetail(ENCHANT_SAFETY, curWantedSkillID, curWantedLevel);
		btnResearch.DisableWindow();
		SucessProbablity.SetText("");
		SucessProbablity.HideWindow();
		}else
		{
		EnchantState = ENCHANT_NORMAL;
		RequestExEnchantSkillInfoDetail(ENCHANT_NORMAL, curWantedSkillID, curWantedLevel);
		btnResearch.DisableWindow();
		SucessProbablity.SetText("");
		SucessProbablity.HideWindow();
		}

	}
	else
	{
		if( curLevel == curWantedLevel )
		{
			if(SafeEnchant.IsChecked())
				{
				EnchantState = ENCHANT_SAFETY;
				RequestExEnchantSkillInfoDetail(ENCHANT_SAFETY, curWantedSkillID, curWantedLevel);
				btnResearch.DisableWindow();
				SucessProbablity.SetText("");
				SucessProbablity.HideWindow();
			}else
				{
				EnchantState = ENCHANT_NORMAL;
				RequestExEnchantSkillInfoDetail(ENCHANT_NORMAL, curWantedSkillID, curWantedLevel);
				btnResearch.DisableWindow();
				SucessProbablity.SetText("");
				SucessProbablity.HideWindow();
				}
			
			EnchantState = ENCHANT_ROOT_CHANGE;
			RequestExEnchantSkillInfoDetail(ENCHANT_ROOT_CHANGE, curWantedSkillID, curWantedLevel);
			btnResearch.DisableWindow();
			SucessProbablity.SetText("");
			SucessProbablity.HideWindow();
			ResearchGuideDesc.SetText("");
			ResearchGuideDesc.SetText(GetSystemString(2203));//"���õ� ��ȭ����� ������ ��ȭ ����Դϴ�. �ٸ� ����� ������ �ּ���."
			//ExpectationSkillDesc.SetText("������ ��ȭ ���");
			

		}else
		{
			EnchantState = ENCHANT_ROOT_CHANGE;
			//	debug("infItem.id"$infItem.id.classid$"infItem.level"$infItem.level);
			RequestExEnchantSkillInfoDetail(ENCHANT_ROOT_CHANGE, curWantedSkillID, curWantedLevel);
			btnResearch.EnableWindow();
			btnResearch.SetNameText(GetSystemString(2068));

			ResearchGuideDesc.SetText(GetSystemString(2052));			//"�����ϰ��� �ϴ� ��Ʈ�� �����ϼ̽��ϴ�. ��Ʈ ü���� ��ư�� ���� �ּ���."
			//ExpectationSkillDesc.SetText("");
			SucessProbablity.SetText("");
			SucessProbablity.HideWindow();
		}
	}
		
	
}

function OnResearchRoot_3Click(int index)
{
	local int infoid;
	local int infolevel;


	txtMySp.SetText(MakeCostString( string(GetUserSP()) ));

	txtMyAdena.SetText(MakeCostString( Int64ToString(GetAdena()) ));
	

	EnchantState = ENCHANT_UNTRAIN;
	infoid = ResearchRoot2ID[index];
	infolevel = ResearchRoot2Level[index] - 1;

	SafeEnchant.DisableWindow();

	btnResearch.EnableWindow();
	curWantedSkillID = infoid;
	curWantedLevel = infolevel;

	RequestExEnchantSkillInfoDetail(ENCHANT_UNTRAIN, infoid, infolevel);
	
	btnResearch.SetNameText(GetSystemString(2067));
	
//	debug("ResearchRoot_2[index].id.classid"$info.id.classid$"ResearchRoot_2[index].id.level"$info.level$"EnchantState"$EnchantState);
	
	ResearchGuideDesc.SetText(GetSystemString(2053));		//"��Ʈ���� ����� ���� �Ǿ����ϴ�. ��Ʈ���� ��ư�� Ŭ���� �ּ���."
	
}

function OnbtnGuideClick()
{
		if (MagicskillGuideWnd.IsShowWindow())
		{
			MagicskillGuideWnd.HideWindow();
		
		}
		else 
		{
			MagicskillGuideWnd.ShowWindow();
			MagicskillGuideWnd.SetFocus();
		}
			

}

function OnbtnResearchClick()
{	
	
	//DialogSetID( DIALOGID_ResearchClick);
	//DialogShow(DIALOG_Modal, DIALOG_OKCancel, GetSystemString( 2054 ) );
	

	SetAdenaSpInfo();
	
	RequestExEnchantSkill(EnchantState, curWantedSkillID, curWantedLevel);
	//m_hVpAgathion.PlayAnimation(0);

}

function OnbtnCloseClick()
{
	local MagicSkillWnd script_a;

	script_a = MagicSkillWnd(GetScript("MagicSkillWnd"));

	script_a.RequestSkillList();

	me.HideWindow();
	HideAgathion();
	SkillInfoClear();
	
	class'UIAPI_WINDOW'.static.HideWindow("SkillEnOpt");
}

function OnEvent(int Event_ID, String param)
{

	switch (Event_ID)
	{
		case EV_SkillEnchantInfoWndShow:
			OnEVSkillEnchantInfoWndShow(param);
			break;
		case EV_SkillEnchantInfoWndAddSkill:
			OnEVSkillEnchantInfoWndAddSkill(param);
			DisableChecks();
			break;
	//	case EV_SkillEnchantInfoWndHide:
	//		OnEVSkillEnchantInfoWndHide(param);
	//		break;
		case EV_SkillEnchantInfoWndAddExtendInfo:
			OnEVSkillEnchantInfoWndAddExtendInfo(param);
			break;
		case EV_SkillEnchantResult:
			OnEVSkillEnchantResult(param);
			break;
		case EV_DialogOK:
			HandleDialogOK();
			break;
		case EV_DialogCancel:
			HandleDialogCancel();
			break;
	}
}

function HandleDialogOK()
{
	if( !DialogIsMine() )
		return;

	switch( DialogGetID() )
	{
		case DIALOGID_ResearchClick:
		
			RequestExEnchantSkill(EnchantState, curWantedSkillID, curWantedLevel);

		break;
	}
	//m_hVpAgathion.PlayAnimation(2);
}

function HandleDialogCancel()
{
	if( !DialogIsMine() )
		return;
}

function OnEVSkillEnchantInfoWndShow(string param)
{

	local int Count;
	local int SkillID;
	local int CurSkillLevel;
	local ItemInfo info;
	
	ParseInt(Param, "EnableTrain", EnableTrain);
	ParseInt(Param, "EnableUntrain", EnableUntrain);
	ParseInt(Param, "Count", Count);
	ParseInt(Param, "SkillID", SkillID);
	ParseInt(Param, "CurSkillLevel", CurSkillLevel);

	debug("enableTrain"@enableTrain@"enableUnTrain"@enableUnTrain);
	info.ID.ClassID = curSkillID;
	info.Level = CurSkillLevel;


		Me.ShowWindow();
		SkillInfoClear();
		SetCurSkillInfo(info);

		SetAdenaSpInfo();
		

	curSkillID = SkillID; 
	curLevel = CurSkillLevel;

	if ( enableTrain == 0 && enableUnTrain == 0)
	{
		
		ResearchGuideDesc.SetText("");
		ResearchGuideDesc.SetText(GetSystemString(2041));
		//ResearchGuideDesc.SetText("��ų ��ȭ�� �Ұ����� ��ų�Դϴ�..");

		SetAdenaSpInfo();
		SucessProbablity.Hidewindow();

	}

	Me.Setfocus();
	
}

function SkillInfoClear() //������ ��ų ������ �� ����� ���
{
	local int i;
	
	ResearchSkillIcon.clear();
	ResearchSkillName.SetText("");
	ResearchSkillRoot.SetText("");
	ResearchSkillDesc.SetText("");
	ResearchSkillLv.SetText("");
	ResearchSkillRootLv.SetText("");	
   

	ExpectationSkillIcon.clear();
	ExpectationSkillName.SetText("");
	ExpectationSkillRoot.SetText("");
	ExpectationSkillDesc.SetText("");
	ExpectationSkillLv.SetText("");
	ExpectationSkillRootLv.SetText("");
	SucessProbablity.SetText("");

	for (i = 0; i < SKILL_ENCHANT_NUM; i++)
	{
		ResearchRoot_1[i].SetNameText("");
		ResearchRoot_1[i].HideWindow();
		ResearchRoot_2[i].SetNameText("");
		ResearchRoot_2[i].HideWindow();
		ResearchRoot_3[i].SetNameText("");
		ResearchRoot_3[i].HideWindow();
		ResearchRoot_Select_1[i].HideWindow();
		ResearchRoot_Select_2[i].HideWindow();
		ResearchRoot_Select_3[i].HideWindow();
		ResearchSkill_2[i].HideWindow();
		ResearchSkill_UpArrow_2[i].HideWindow();
		ResearchSkill_DownArrow_2[i].HideWindow();
		
	}

	for (i = 0; i < ARROW_NUM; i++)
	{
		ResearchSkill_Right_2[i].HideWindow();
		ResearchSkill_Left_2[i].HideWindow();
		
		ResearchSkill_LeftArrow_2[i].HideWindow();
		ResearchSkill_RightArrow_2[i].HideWindow();
	}


	for (i = 0; i < ENCHANT_MATERIAL_NUM; i++)
	{
		EnchantMaterialName[i].SetText("");
		EnchantMaterialInfo[i].SetText("");
		EnchantMaterialIcon[i].clear();
	}
	SelectSkill.HideWindow();
	ResearchGuideDesc.SetText(GetSystemString(2048)$"\\n"$GetSystemString(2049));  //"��ų ������ �����ϰڽ��ϴ�.\n-���� �����ϰ��� �ϴ� ��ų�� ���� �� ��ų�� �Ű� �ּ���."�ý��� �޽����� �ٲ�� ��
//	EnchantProgressAnim.Stop();
	btnResearch.SetNameText(GetSystemString(2070));
	btnResearch.DisableWindow();
	SetAdenaSpInfo();
	txtMySp.SetText("");
	SafeEnchant.SetTitle(GetSystemString(2069));
	SafeEnchant.disableWindow();
	
	curSkillID = 0; 
	curLevel = 0;
	curWantedSkillID = 0;
	curWantedLevel = 0;
	

}

function OnEVSkillEnchantInfoWndAddSkill(string param)
{
	local int iID;
	local ItemID itemID;
	local int iLevel;
	local string strSkillIconName;
	local string strSkillName;

	local string j;
	local string k;
	local int index;

	ParseInt(Param, "iID", iID);
	ParseInt(Param, "iLevel", iLevel);
	ParseString(Param, "strSkillIconName",strSkillIconName);
	ParseString(Param, "strSkillName",strSkillName);
	
	itemID.classID = iID;
	strSkillIconName = class'UIDATA_SKILL'.static.GetEnchantIcon( itemID, iLevel );
	//sysDebug(class'UIDATA_SKILL'.static.GetEnchantName( itemID, iLevel ));
	

	index = iLevel / 100 - 1;
	
	countOfRoutes = index + 1;
	
	if (index == 0)
	{
		routeBox.Clear();
		//sysDebug("CLEARED");
	}
	
	routeBox.AddString(class'UIDATA_SKILL'.static.GetEnchantName( itemID, iLevel ));
	//sysDebug("ADDED " $ class'UIDATA_SKILL'.static.GetEnchantName( itemID, iLevel ));
	
	

//	debug("iLevel:"$iLevel$"index:"$index);

	ResearchRoot2ID[index] = iID;
	
	ResearchRoot2Level[index] = iLevel;
	
	ResearchRoot2SkillIconName[index] = "l2ui_ct1.SkillWnd_DF_Icon_Enchant_"$strSkillIconName;      //������ ���� �ʹ� �� ��ų ��æƮ �������� �������� �����ܸ��� UC���� ����
	ResearchRoot2SkillName[index] = strSkillName;
	
	if(enableTrain == 1 && enableUnTrain == 0)
	{
			j = "+"$ int(iLevel % 100 );
			k = "+"$ int(iLevel % 100 - 1);
			
	}else
	{
			j = "+"$ int(iLevel % 100 + 1);
			k = "+"$ int(iLevel % 100 - 1);
	}
//	itemInfo.iconName = "l2ui_ct1.SkillWnd_DF_Icon_Enchant_"$strSkillIconName; 
																   //��ų �������� ��æƮ ���������� ����
//	debug("iID"$iID$"iLevel"$iLevel$"strSkillIconName"$strSkillIconName$"strSkillName"$strSkillName);
	//debug("�ҷ�����??1");
	SafeEnchant.DisableWindow();

	
	ResearchRoot_2[index].SetTexture(ResearchRoot2SkillIconName[index], ResearchRoot2SkillIconName[index], ResearchRoot2SkillIconName[index]);
	
	if (enableTrain == 0 && enableUnTrain == 1)

	{
		if ( curEnchantType - 1 == index)						//���̻� ��ȭ�� �� ���� LV
	
		{
			ResearchRoot_1[index].Hidewindow();
			ResearchRoot_3[index].ShowWindow();
			ResearchRoot_3[index].SetNameText(k);
			ResetCoverArrow();					// ���� ��ų ����� ��ġ�� ��Ÿ���� �ؽ��� ������ ���⸦ ������� �¿� ȭ��ǥ�� �÷��ַ��� �Ѵ�.
			ResearchSkill_2[0].ClearAnchor();
			ResearchSkill_2[0].SetAnchor( "MagicSkillDrawerWnd", "TopLeft", "TopLeft", 13 + 43 * index, 288 );
			ResearchSkill_2[0].ShowWindow();	// ���� ��ų�� ����� ���϶���Ʈ�� ���� �ش�.
			ArrowPositionStart = index; //ȭ��ǥ�� �����ֱ� ���� ��ŸƮ ������ ��
		}
		
		ResearchRoot_2[index].ShowWindow();
		
		SetAdenaSpInfo();
		SucessProbablity.Hidewindow();

		ResearchGuideDesc.SetText(GetSystemString(2046));			//"��Ʈ���� �ϰ��� �ϴ� ����� ��Ʈ���� ��ư�� ������ �ּ���."

	}
	
	// ��ų ��æ �ѹ��� �ȵ� �κ�

	else if (enableTrain == 1 && enableUnTrain == 0)
	{
	
		ResearchRoot_1[index].Showwindow();
		ResearchRoot_1[index].SetNameText(j);
		ResearchRoot_2[index].ShowWindow();
		ResearchRoot_3[index].HideWindow();
	//	ResearchRoot_3[index].SetNameText(k);				
		SucessProbablity.Hidewindow();
		SetAdenaSpInfo();

		ResearchGuideDesc.SetText(GetSystemString(2047));			//"���� �ϰ��� �ϴ� ��ų�� ���� ��Ͽ��� ������ �ּ���."
		
	}
	else if ( enableTrain == 1 && enableUnTrain == 1)
	{
		if ( curEnchantType - 1 == index)
		{
			ResearchRoot_1[index].Showwindow();
			ResearchRoot_1[index].SetNameText(j);
			ResearchRoot_3[index].SetNameText(k);
			ResearchRoot_3[index].ShowWindow();	
			ResetCoverArrow();					// ���� ��ų ����� ��ġ�� ��Ÿ���� �ؽ��� ������ ���⸦ ������� �¿� ȭ��ǥ�� �÷��ַ��� �Ѵ�.
			ResearchSkill_2[0].ClearAnchor();
			ResearchSkill_2[0].SetAnchor( "MagicSkillDrawerWnd", "TopLeft", "TopLeft", 13 + 43 * index, 288 );
			ResearchSkill_2[0].ShowWindow();	// ���� ��ų�� ����� ���϶���Ʈ�� ���� �ش�.
			ArrowPositionStart = index;
				
				SelectSkill.ClearAnchor();		// ��æƮ �� ��ų�� ������ ���� ��æƮ ��ų�� ������ ���� ������ �׿� ���߾� ȭ��ǥ�� �׷��ش�.
				SelectSkill.SetAnchor( "MagicSkillDrawerWnd", "TopLeft", "TopLeft", 13 + 43 * index, 245 );
				SelectSkill.ShowWindow();
				
				ResetSideArrow();
				ResetCoverArrow();
				ResearchSkill_UpArrow_2[index].ShowWindow();
				OnResearchRoot_1Click(index);

				btnResearch.EnableWindow();
				SafeEnchant.EnableWindow();
				
			
		}
		ResearchRoot_2[index].ShowWindow();
		
		SetAdenaSpInfo();
		SucessProbablity.Hidewindow();

		//ResearchGuideDesc.SetText(GetSystemString(2043));	
		ResearchGuideDesc.SetText(GetSystemString(2043)$GetSystemString(2044)$GetSystemString(2204)); //"��æƮ�� �Ϸ��� ���� ��ư�� ��Ʈ ü������ �Ϸ��� �ٸ� ����� ��Ʈ������ �Ʒ��� ��ư�� ������ ��æƮ�� ���� ������ üũ�� �ϰ� ���� ��ư�� ������ �ּ���."
		//ResearchGuideDesc.SetText("");
		//ResearchGuideDesc.SetText(GetSystemString(2045)@GetSystemString(2046));
		
	}

}

function OnTextureAnimEnd( AnimTextureHandle a_WindowHandle )
{
	EnchantProgressAnim.HideWindow();
	EnchantProgressAnim.Stop();
	EnchantProgressAnim.HideWindow();
	switch ( a_WindowHandle )
	{
		case EnchantProgressAnim:
			break;

	}
}



//function SetSkillLevel()
//{
//	local int i;
//	
//	for (i = 1; i < 9; i++)
//		if (SkillLevel >= i * 100 + 1 && SkillLevel <= i * 100 + 30)
//			SkillLevel = i * 100 + 1;
//}

function OnEVSkillEnchantResult(string param)
{
	local int iSuccess;
	
	ParseInt(param, "success", iSuccess);
	
			//	debug("success:"$iSuccess);
			if (iSuccess == 1)
			{
				m_hVpAgathion.PlayAnimation(2);
				EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Success_00");
				EnchantProgressAnim.ShowWindow();
				EnchantProgressAnim.SetLoopCount( 1 );
				EnchantProgressAnim.Stop();
				EnchantProgressAnim.SetTimes(0.8);
				EnchantProgressAnim.Play();
				Playsound("ItemSound3.enchant_success");

				ResearchGuideDesc.SetText(GetSystemString(2054)$"\\n"$GetSystemString(2055));		//"��ų ��æƮ�� �����Ͽ����ϴ�.\n-��æƮ ��ų�� Lv�� ��� �Ͽ����ϴ�."


			}
			else
			{
				m_hVpAgathion.PlayAnimation(2);
				EnchantProgressAnim.SetTexture("l2ui_ct1.ItemEnchant_DF_Effect_Failed_01");
				EnchantProgressAnim.ShowWindow();
				EnchantProgressAnim.SetLoopCount( 1 );
				EnchantProgressAnim.Stop();
				EnchantProgressAnim.Play();
				Playsound("ItemSound3.enchant_fail");

				ResearchGuideDesc.SetText(GetSystemString(2062)$"\\n"$GetSystemString(2063));		//"��ų ��æƮ�� �����Ͽ����ϴ�.\n-��æƮ ��ų�� �������� ��ų�� �ʱ�ȭ �˴ϴ�.."
	
				
				//Merc's part
				//SetSkillLevel();
			}
	

}



function OnEVSkillEnchantInfoWndAddExtendInfo(string param)
{
	local int SkillID;
	local int Level;
	local int SPConsume;
	local int Percent;
	local int itemclassid[2];
	local string strItemIconName[2];
	local string strItemName[2];
	local string strSkillIconName;
	local string strSkillName;

	local int ItemSort;
	local int ItemNum[2];
	local int i;
	local int adenaID;	//�Ƶ���
	local int haguinID;	//�ϰ����Ǻ�����

	adenaID =0;
	//local int curEnchantState;
		
	ParseInt(Param, "SkillID", SkillID);
	ParseInt(Param, "Level", Level);
	ParseInt(Param, "Percent", Percent);
	
	Parseint(Param, "ItemSort", ItemSort);

	for(i = 0; i < ItemSort; i++ )
	{
		ParseInt(Param, "ItemClassID_"$i, itemclassid[i]);
		ParseString(Param, "strItemIconName_"$i,strItemIconName[i]);
		ParseString(Param, "strItemName_"$i,strItemName[i]);
		ParseInt(Param, "ItemNum_"$i, ItemNum[i]);		
	}

	if (itemclassid[0] == 57)
	{
		adenaID = 0;
		haguinID = itemclassid[1];
	}
	else
	{
		adenaID = 1;
		haguinID = itemclassid[0];
	}
	
	ParseString(Param, "strSkillIconName",strSkillIconName);
	ParseString(Param, "strSkillName",strSkillName);
	ParseInt(Param, "SPConsume", SPConsume);

	SetAfterSkillInfo( EnchantState, SkillID, Level, strSkillIconName, strSkillName );
	SetEnchantConsumeInfo ( haguinID,  ItemNum[haguinID],  strItemIconName[adenaID],  strItemName[adenaID],  ItemNum[adenaID], SPConsume, Percent, EnchantState);
	
	if (haguinID == 6622)
	{
		needCodex = ItemNum[haguinID];
		isMastery = false;
	}
		
	else if (haguinID == 9627)
	{
		needMastery = ItemNum[haguinID];
		isMastery = true;
	}	
	
	needSP = SPConsume;
	needAdena = ItemNum[adenaID];
	
}


// ��ų ���� �� ��ų�� ����
function SetCurSkillInfo (ItemInfo info)
{
	local SkillInfo skillinfo;
	local string i; 
	local string j; 
	
	curSkillID = info.ID.ClassID; 
	curLevel = info.Level;

	GetSkillInfo(curSkillID, curLevel, skillInfo);
	info.Name = skillInfo.SkillName;
	info.Level = skillInfo.SkillLevel;
	info.IconName = class'UIDATA_SKILL'.static.GetIconName( info.ID , info.Level );
	info.Description = skillInfo.SkillDesc;
	info.AdditionalName = skillInfo.EnchantName;
	info.IconPanel = skillInfo.IconPanel;
	info.ItemSubType = int(EShortCutItemType.SCIT_SKILL);
	//skillinfo.EnchantSkillLevel = class'UIDATA_SKILL'.static.GetEnchantSkillLevel( info.ID, info.Level );
	
	i = GetSystemString(88)@skillInfo.EnchantSkillLevel;	// ��æƮ ��ų�� �������� ��ų�� Lv�� ǥ��
	j = GetSystemString(88)@skillInfo.SkillLevel;			// �������� ��ų�� Lv�� ǥ��

	
	
	if ( info.Level < 100)
	{
		curEnchantType = 0;
		
	
		//���� ���� ����
		ResearchSkillName.SetText(skillInfo.SkillName);
		ResearchSkillLv.SetText(j);
		ResearchSkillDesc.SetText(GetSystemString(2040));		//"��æƮ ���� ���� �������� ��ų"
		ResearchSkillRoot.SetText("");
		ResearchSkillRootLv.Hidewindow();
		ResearchSkillIcon.clear( );
		ResearchSkillIcon.AddItem( info );

		SetAdenaSpInfo();
		

	} 
	else if ( info.Level > 100)
	{
		curEnchantType = info.Level / 100;
	
	
		//���� ���� ����
		ResearchSkillName.SetText(skillInfo.SkillName);
		ResearchSkillLv.SetText( i );
		//ResearchSkillDesc.SetText(skillinfo.EnchantDesc);
		ResearchSkillDesc.SetText(GetSystemString(2207)); //"������ ��ȭ ��ų"
		ResearchSkillRoot.SetText(skillinfo.EnchantName);
		ResearchSkillRootLv.SetText("");
		ResearchSkillIcon.clear( );
		ResearchSkillIcon.AddItem( info );

		SetAdenaSpInfo();
	
	}
}

// ��ų ���� �� ��ų ����

function SetAfterSkillInfo (int EnchantState, int SkillID, int Level, string strSkillIconName, string strSkillName )
{
	local SkillInfo skillinfo;
	local ItemInfo info;
	//local string i; 
	//local string j;
	

	info.ID.classID = SkillID;
	info.Level = Level;
	info.IconName = strSkillIconName;
	Info.Name = strSkillName;

	GetSkillInfo(SkillID, Level, skillInfo);
	
	//i = GetSystemString(88)@skillInfo.EnchantSkillLevel;	// ��æƮ ��ų�� �������� ��ų�� Lv�� ǥ��
	//j = GetSystemString(88)@skillInfo.SkillLevel;			// �������� ��ų�� Lv�� ǥ��
	

	if ( EnchantState == 0)
	{
			if ( Level < 100)
			{
				curEnchantType = 0;
					ExpectationSkillName.SetText(strSkillName);
					ExpectationSkillDesc.SetText(skillinfo.EnchantDesc);
					ExpectationSkillRoot.SetText(skillinfo.EnchantName);
					ExpectationSkillLv.SetText(GetSystemString(88)@ String(skillInfo.EnchantSkillLevel));
					//ExpectationSkillLv.SetText(j);
					ExpectationSkillIcon.clear();
					ExpectationSkillIcon.Additem( info );
					ExpectationSkillRootLv.SetText("");
			} 
			else if ( Level > 100)
			{
				curEnchantType = Level / 100;
					ExpectationSkillName.SetText(strSkillName);
					ExpectationSkillDesc.SetText(skillinfo.EnchantDesc);
					ExpectationSkillRoot.SetText(skillinfo.EnchantName);
					ExpectationSkillLv.SetText(GetSystemString(88)@ string(skillInfo.EnchantSkillLevel));
					//ExpectationSkillLv.SetText(i);
					ExpectationSkillIcon.clear();
					ExpectationSkillIcon.Additem( info);
					ExpectationSkillRootLv.SetText("");
			}
	} else if ( EnchantState == 1)
	{
				if ( Level < 100)
			{
				curEnchantType = 0;
					ExpectationSkillName.SetText(strSkillName);
					ExpectationSkillDesc.SetText(skillinfo.EnchantDesc);
					ExpectationSkillRoot.SetText(skillinfo.EnchantName);
					ExpectationSkillLv.SetText(GetSystemString(88)@ String(skillInfo.EnchantSkillLevel));
					//ExpectationSkillLv.SetText(j);
					ExpectationSkillIcon.clear();
					ExpectationSkillIcon.Additem( info );
					ExpectationSkillRootLv.SetText("");
			} 
			else if ( Level > 100)
			{
				curEnchantType = Level / 100;
					ExpectationSkillName.SetText(strSkillName);
					ExpectationSkillDesc.SetText(skillinfo.EnchantDesc);
					ExpectationSkillRoot.SetText(skillinfo.EnchantName);
					ExpectationSkillLv.SetText(GetSystemString(88)@ string(skillInfo.EnchantSkillLevel));
					//ExpectationSkillLv.SetText(i);
					ExpectationSkillIcon.clear();
					ExpectationSkillIcon.Additem( info);
					ExpectationSkillRootLv.SetText("");
			}

	} else if ( EnchantState == 2)
	{
		if ( Level < 100)
			{
				curEnchantType = 0;
					ExpectationSkillName.SetText(strSkillName);
					//ExpectationSkillDesc.SetText(skillinfo.EnchantDesc);
					ExpectationSkillDesc.SetText(GetSystemString(2208));  //��ȭ ������ �⺻ ��ų�� �ǵ�����.
					ExpectationSkillRoot.SetText(skillinfo.EnchantName);
					ExpectationSkillLv.SetText(GetSystemString(88)@ String(skillInfo.EnchantSkillLevel));
					ExpectationSkillIcon.clear();
					ExpectationSkillIcon.Additem( info );
					ExpectationSkillRootLv.SetText("");

			} else if ( Level > 100)
				{
				curEnchantType = Level / 100;
					ExpectationSkillName.SetText(strSkillName);
					//ExpectationSkillDesc.SetText(skillinfo.EnchantDesc);
					ExpectationSkillDesc.SetText(GetSystemString(2209));  //���� ��ȭ �ܰ�� �ǵ�����.
					ExpectationSkillRoot.SetText(skillinfo.EnchantName);
					ExpectationSkillLv.SetText(GetSystemString(88)@ string(skillInfo.EnchantSkillLevel));
					ExpectationSkillIcon.clear();
					ExpectationSkillIcon.Additem( info);
					ExpectationSkillRootLv.SetText("");
				}

	} else if ( EnchantState == 3)
	{
		if ( Level < 100)
			{
				curEnchantType = 0;
					ExpectationSkillName.SetText(strSkillName);
					ExpectationSkillDesc.SetText(skillinfo.EnchantDesc);
					ExpectationSkillRoot.SetText(skillinfo.EnchantName);
					ExpectationSkillLv.SetText(GetSystemString(88)@ String(skillInfo.EnchantSkillLevel));
					//ExpectationSkillLv.SetText(j);
					ExpectationSkillIcon.clear();
					ExpectationSkillIcon.Additem( info );
					ExpectationSkillRootLv.SetText("");

			} else if ( Level > 100)
				{
					if ( curLevel == curWantedLevel )
					{
								curEnchantType = Level / 100;
								ExpectationSkillName.SetText(strSkillName);
								ExpectationSkillDesc.SetText(GetSystemString(2210)); //������ ��ȭ ���. �ٸ� ��� �����ϼ���.
								ExpectationSkillRoot.SetText(skillinfo.EnchantName);
								ExpectationSkillLv.SetText(GetSystemString(88)@ string(skillInfo.EnchantSkillLevel));
								//ExpectationSkillLv.SetText(i);
								ExpectationSkillIcon.clear();
								ExpectationSkillIcon.Additem( info);
								ExpectationSkillRootLv.SetText("");
					} else
					{
								curEnchantType = Level / 100;
								ExpectationSkillName.SetText(strSkillName);
								ExpectationSkillDesc.SetText(skillinfo.EnchantDesc);
								ExpectationSkillRoot.SetText(skillinfo.EnchantName);
								ExpectationSkillLv.SetText(GetSystemString(88)@ string(skillInfo.EnchantSkillLevel));
								//ExpectationSkillLv.SetText(i);
								ExpectationSkillIcon.clear();
								ExpectationSkillIcon.Additem( info);
								ExpectationSkillRootLv.SetText("");

					}
				}

	}
	
}



function SetEnchantConsumeInfo (int haguinClassID, int codexNum, string adenaIconName, string adenaName, int adenaNum, int SPConsume, int Percent, int EnchantState)
{
	local ItemID	haguinID;
	local ItemInfo info_a; //�ϰ���
	local ItemInfo info_b; //�Ƶ���
	local ItemInfo Info_c; //SP
	local int i;

	haguinID.ClassID = haguinClassID;
	class'UIDATA_ITEM'.static.GetItemInfo(haguinID, info_a );

	info_b.IconName = adenaIconName;
	Info_b.Name = adenaName;

	Info_c.IconName = "icon.etc_i.etc_sp_point_i00";
	Info_c.Name = "SP";
	//SetEnchantConsumeInfo ( strItemIconName[0], strItemName[0],  ItemNum[0],  strItemIconName[1],  strItemName[1],  ItemNum[1], SPConsume, Percent, EnchantState);

	
	if ( EnchantState == ENCHANT_NORMAL )
		{
		
			//������ ������ ǥ��
			EnchantMaterialName[0].SetText(info_a.Name);
			EnchantMaterialInfo[0].SetText(GetSystemString(1514)@string(codexNum));
			EnchantMaterialIcon[0].Clear();
			EnchantMaterialIcon[0].Additem(info_a);

			
			//�Ƶ��� ǥ��
			EnchantMaterialName[2].SetText(GetSystemString(2033)@adenaName);
			EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));
			EnchantMaterialIcon[2].Clear();
			EnchantMaterialIcon[2].Additem(Info_b);
			

			//SP ǥ��
			EnchantMaterialName[1].SetText(GetSystemString(365));
			EnchantMaterialInfo[1].SetText(MakeCostString(string(SPConsume)));
			EnchantMaterialIcon[1].Additem(info_c);

			//����Ȯ�� ǥ��
			SucessProbablity.ShowWindow();
			SucessProbablity.SetText("");
			SucessProbablity.SetText(GetSystemString(642)@string(Percent)@GetSystemString(2042));

			SetAdenaSpInfo();
	

		} else if ( EnchantState == ENCHANT_SAFETY )
		{

			//������ ������ ǥ��
			EnchantMaterialName[0].SetText(info_a.Name);
			EnchantMaterialInfo[0].SetText(GetSystemString(1514)@string(codexNum));
			EnchantMaterialIcon[0].Clear();
			EnchantMaterialIcon[0].Additem(info_a);

			//SP ǥ��
			EnchantMaterialName[1].SetText(GetSystemString(365));
			EnchantMaterialInfo[1].SetText(MakeCostString(string(SPConsume)));
			EnchantMaterialIcon[1].Additem(Info_c);
			//�Ƶ��� ǥ��
			EnchantMaterialName[2].SetText(GetSystemstring(2033)@adenaName);
			EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));
			EnchantMaterialIcon[2].Clear();
			EnchantMaterialIcon[2].Additem(Info_b);

			//����Ȯ�� ǥ��
			SucessProbablity.ShowWindow();
			SucessProbablity.SetText("");
			SucessProbablity.SetText(GetSystemString(642)@string(Percent)@GetSystemString(2042) );

			SetAdenaSpInfo();
			

		} else if ( EnchantState == ENCHANT_UNTRAIN)
		{

			//������ ������ ǥ��
			EnchantMaterialName[0].SetText(info_a.Name);
			EnchantMaterialInfo[0].SetText(GetSystemString(1514)@string(codexNum));
			EnchantMaterialIcon[0].Clear();
			EnchantMaterialIcon[0].Additem(info_a);

			//SP ǥ��
			EnchantMaterialName[1].SetText(GetSystemString(1578));
			EnchantMaterialInfo[1].SetText(MakeCostString(string(SPConsume)));
			EnchantMaterialIcon[1].Additem(Info_c);
			
			//�Ƶ��� ǥ��
			EnchantMaterialName[2].SetText(GetSystemstring(2033)@adenaName);
			EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));
			EnchantMaterialIcon[2].Clear();
			EnchantMaterialIcon[2].Additem(Info_b);

			//����Ȯ�� ǥ��
			SucessProbablity.ShowWindow();
			SucessProbablity.SetText("");
			SucessProbablity.SetText(GetSystemString(1577)@GetSystemString(1508)$GetSystemString(1510)@GetSystemString(2042));

			SetAdenaSpInfo();
	

		}else if ( EnchantState == ENCHANT_ROOT_CHANGE)
		{
			if (curLevel == curWantedLevel )
			{
				for (i = 0; i < ENCHANT_MATERIAL_NUM; i++)
					{
						EnchantMaterialName[i].SetText("");
						EnchantMaterialInfo[i].SetText("");
						EnchantMaterialIcon[i].clear();
					}

			} else
			{

			//������ ������ ǥ��
			EnchantMaterialName[0].SetText(info_a.Name);
			EnchantMaterialInfo[0].SetText(GetSystemString(1514)@string(codexNum));
			EnchantMaterialIcon[0].Clear();
			EnchantMaterialIcon[0].Additem(info_a);

			//SP ǥ��
			EnchantMaterialName[1].SetText(GetSystemString(365));
			EnchantMaterialInfo[1].SetText(MakeCostString(string(SPConsume)));
			EnchantMaterialIcon[1].Additem(Info_c);

			//�Ƶ��� ǥ��
			EnchantMaterialName[2].SetText(GetSystemstring(2033)@adenaName);
			EnchantMaterialInfo[2].SetText(MakeCostString(string(adenaNum)));
			EnchantMaterialIcon[2].Clear();
			EnchantMaterialIcon[2].Additem(Info_b);

			SucessProbablity.SetText("");
			SucessProbablity.HideWindow();

			SetAdenaSpInfo();
			}
	
		}
}

function SetAdenaSpInfo()
{
			txtMyAdena.SetText(MakeCostString( Int64ToString(GetAdena()) ));
			txtMyAdena.SetTooltipString( ConvertNumToText(Int64ToString(GetAdena())) );
			txtMySp.SetText(MakeCostString( string(GetUserSP()) ));
			txtMySp.SetTooltipString( ConvertNumToTextNoAdena(string(GetUserSP())) );
			txtMyAdenaStr.SetText(GetSystemString(469));
}

function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	local string dragsrcName;
	local MagicSkillWnd script_a;
	

	script_a = MagicSkillWnd(GetScript("MagicSkillWnd"));
	
	RequestSkillList();
	dragsrcName = Left(a_ItemInfo.DragSrcName,10);

	switch (a_WindowID)
	{		
		case  "ResearchSkillIcon":
			if ((dragsrcName== "PSkillItem" || dragsrcName == "ASkillItem") )
			{
			
				if (a_ItemInfo.bDisabled)
				{
					SkillInfoClear();
					SetAdenaSpInfo();
					ResearchGuideDesc.SetText(GetSystemString(2041));
					AddSystemMessage(3070);
				}
				else
				{
					SkillInfoClear();
					RequestExEnchantSkillInfo(a_ItemInfo.ID.ClassID, a_ItemInfo.Level); 
					SetCurSkillInfo(a_ItemInfo);
					SetAdenaSpInfo();
				}

			}
		break;

	}
}

function DisableChecks()
{
	if (countOfRoutes > 0 && TempCheck != -1)
	{
		routeBox.SetSelectedNum( TempCheck );
	}	
}

defaultproperties
{
    
}
