class ConsoleWnd extends UICommonAPI;

const DLG_ID_RESTART=0;
const DLG_ID_QUIT=1;
const DIG_ID_ASK_COUPLEACTION = 1112;

var WindowHandle m_hSystemMenuWnd;
var DialogBox	dScript;


function OnRegisterEvent()
{
	RegisterEvent( EV_OpenDialogQuit );
	RegisterEvent( EV_OpenDialogRestart );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );


	RegisterEvent ( EV_ShowAskCoupleActionDialog );
	RegisterEvent ( EV_CommandAddAllianceCrestFile );

	// ���͹����� �� ���� �ϸ� �ش� �̺�Ʈ �߻� 
	

	// couple action - lancelot 2009. 10. 14.
	// const EV_ShowAskCoupleActionDialog			= 4900;
	// const EV_CoupleActionFailedTargetIsNone		= 4910;
	// const EV_CoupleActionFailedIlligalTarget		= 4920;
}


function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		m_hSystemMenuWnd=GetHandle("SystemMenuWnd");
	else
		m_hSystemMenuWnd=GetWindowHandle("SystemMenuWnd");

	dScript = DialogBox(GetScript("DialogBox"));
}


function OnEvent(int Event_ID, String param)
{
	switch(Event_ID)
	{
		case EV_OpenDialogRestart :
			dScript.HideDialog();
			dScript.ShowDialog(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(126), string(Self) );
			dScript.SetID( DLG_ID_RESTART );
			//branch
			//DialogSetDefaultOK();
			dScript.SetDefaultAction( EDefaultOK );
			//end of branch
			//DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
			//DialogShow(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(126));
			//DialogSetID( DLG_ID_RESTART );
			break;
		
		case EV_OpenDialogQuit :
			dScript.HideDialog();
			dScript.ShowDialog(DIALOG_Modalless,DIALOG_Warning, GetSystemMessage(125), string(Self));
			dScript.SetID(DLG_ID_QUIT);
			//branch
			dScript.SetDefaultAction( EDefaultOK );
			//end of branch
			//DialogHide();	// �̹� â�� ���ִٸ� �����ش�.
			//DialogShow(DIALOG_Modalless,DIALOG_Warning, GetSystemMessage(125));
			//DialogSetID(DLG_ID_QUIT);
			break;
		
		case EV_DialogOK :
			HandleDlgOk();
			break;
		
		// 2009.10.17 , Ŀ�� �׼� �߰� 
		case EV_ShowAskCoupleActionDialog :
			// debug("====> �ߵ� : Ŀ�� �׼� " @ param);
			HandleCoupleActionAskStart(param);
			break;

		case EV_CommandAddAllianceCrestFile :
			HandleUploadAllianceCrestFile();
			break;


		case EV_DialogCancel :
			HandleDialogCancel();
			break;
	}
}


function HandleDlgOk()
{
	local InventoryWnd Script;
	Script = InventoryWnd(GetScript("InventoryWnd"));
	if (!DialogIsMine())
		return;

	switch(DialogGetID())
	{

		case DLG_ID_RESTART :
			//����ŸƮ�� ��������� �������. 
			m_hSystemMenuWnd.HideWindow();
			Script.SaveInventoryOrder();
			ExecRestart();
			break;

		case DLG_ID_QUIT :
			Script.SaveInventoryOrder();
			ExecQuit();
			break;
		
			
		case DIG_ID_ASK_COUPLEACTION:
			// Ŀ�� �׼��� ���� �ߴٸ�!
			// debug("=======================Ŀ�þ׼�========================================");
			// debug("==> DialogGetReservedInt() " @ DialogGetReservedInt());
			// debug("==> DialogGetReservedInt3() " @ DialogGetReservedInt3());		
			// debug("==> Answer " @ 1);		

			// Ȯ��, ��� �� ���� 
			dScript.SetButtonName( 1337, 1342 );
			AnswerCoupleAction(DialogGetReservedInt(), 1, DialogGetReservedInt3());
			break;
	}
}


function HandleCoupleActionAskStart( string param )
{
	local bool bOption;
	
	local int pActionID;
	local int pRequestUserID;

	local string userName;
	local string actionStr;



	bOption = GetOptionBool( "Game", "IsCoupleAction" );
	
	//ParseInt( param, "SocialAnimID", pSocialAnimID );
	//ParseInt( param, "requestUserID", pRequestUserID );

	ParseInt( param, "ActionID", pActionID );
	ParseInt( param, "requestUserID", pRequestUserID );


	// Debug("=====> " @ bOption);

	// ���� �̸��� ��´�
	userName = class'UIDATA_USER'.static.GetUserName(pRequestUserID);

	DialogSetReservedInt( pActionID );
	DialogSetReservedInt3( pRequestUserID );

	if (bOption == true)
	{
		// ���� Ŀ�� �׼� ������ �źε� �����Դϴ�. 
		// RequestDuelAnswerStart( type, int(bOption), 0 );
		// AddSystemMessage(3122);
		// debug("=====> ���� Ŀ�þ׼� �ɼ��� �ź� ���� ");

		// Ŀ�� �׼��� �ź� �����̹Ƿ� �ڵ����� �ź� �ȴ�.
		AnswerCoupleAction(DialogGetReservedInt(), -1, DialogGetReservedInt3());
	}
	else	
	{
		// debug("== > pSocialAnimID : " @ pActionID);
		// debug("===> pRequestUserID : " @ pRequestUserID);

		DialogSetParamInt64( IntToInt64(10*1000) );	
		DialogSetID( DIG_ID_ASK_COUPLEACTION );
		
		// ���̾� �α� �ڽ����� ��, �ƴϿ� �� �������� �Ѵ�.
		dScript.SetButtonName( 184, 185 );
		class'ActionAPI'.static.GetActionNameBySocialIndex(pActionID, actionStr);

		// $c1 ���� %s1 ��û�� �����Ͻðڽ��ϱ�?
		DialogShow(DIALOG_Modalless, DIALOG_Progress, MakeFullSystemMsg( GetSystemMessage(3118), userName, actionStr) );
	}
}


function HandleDialogCancel()
{
	local int dialogID;
	local bool bOption;

	// Ȯ��, ��� �� ���� 
	dScript.SetButtonName( 1337, 1342 );

	if(DialogIsMine())
	{
		dialogID = DialogGetID();
		if( dialogID == DIG_ID_ASK_COUPLEACTION )
		{
			bOption = GetOptionBool( "Game", "IsCoupleAction" );

			// debug("=====================Ŀ�þ׼�========================================");
			// debug("==> DialogGetReservedInt() " @ DialogGetReservedInt());
			// debug("==> DialogGetReservedInt3() " @ DialogGetReservedInt3());
			// debug("==> Answer " @ 0);
			
			AnswerCoupleAction(DialogGetReservedInt(), 0, DialogGetReservedInt3());
		}
	}
}



function HandleUploadAllianceCrestFile()
{
	local Array<string> fileextarr;

	if (class'UIAPI_WINDOW'.static.IsShowWindow("FileRegisterWnd") == false)
	{

		// ���͹����� 8 * 12 ũ���� 256 Į�� Bmp ���ϸ� ����� �� �ֽ��ϴ�.
		AddSystemMessage(3143);

		// ���� ���ε� 
		fileextarr.Length = 1;
		fileextarr[0] = "bmp";
		ClearFileRegisterWndFileExt();

		// 2233 : ��Ʈ�� �̹���
		AddFileRegisterWndFileExt(GetSystemString(2233), fileextarr);

		// ���� ������ ���� ���� ������ ����
		FileRegisterWndShow(FH_ALLIANCE_CREST_UPLOAD);
	}
}
defaultproperties
{
}
