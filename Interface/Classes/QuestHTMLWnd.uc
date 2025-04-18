class QuestHTMLWnd extends UICommonAPI;

var WindowHandle 	Me;
var HtmlHandle		m_hHtmlViewer;
var TreeHandle 		QuestRewardItemTree;
var bool			m_bDrawBg;

//
var bool			m_bPressCloseButton;
var bool			m_bReShowWndMode;
var bool			m_bReShowQuestHtmlWnd;	


function OnRegisterEvent()
{
	RegisterEvent(EV_QuestHtmlWndShow);
	RegisterEvent(EV_QuestHtmlWndHide);
//	RegisterEvent(EV_NPCDialogWndHide);
	RegisterEvent(EV_QuestHtmlWndLoadHtmlFromString);
	RegisterEvent(EV_QuestIDWndLoadHtmlFromString);
	
	// register gamingstate enter/exit event 
	// - ������� ������, ó�� ȣ��ɶ� OnEnter�� OnExit�� ȣ����� ����.
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_GamingStateExit);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me=GetHandle("QuestHTMLWnd");
		m_hHtmlViewer=HtmlHandle(GetHandle("QuestHTMLWnd.HtmlViewer"));
		QuestRewardItemTree = TreeHandle(GetHandle("QuestHTMLWnd.QuestRewardItemTree"));
	}
	else
	{
		Me=GetWindowHandle("QuestHTMLWnd");
		m_hHtmlViewer=GetHtmlHandle("QuestHTMLWnd.HtmlViewer");
		QuestRewardItemTree = GetTreeHandle("QuestHTMLWnd.QuestRewardItemTree");
	}
}

function OnEvent(int Event_ID, String param)
{
	switch(Event_ID)
	{
		case EV_QuestHtmlWndShow :
			ShowQuestHtmlWnd();
			break;
			
		case EV_QuestHtmlWndHide :	
			HideQuestHtmlWnd();
			break;
			
		case EV_QuestHtmlWndLoadHtmlFromString :
			Me.SetWindowTitle(GetSystemString(444));	 //Ÿ��Ʋ�� "��ȭ"�� �ٲ��ش�. 
			HandleLoadHtmlFromString(param);
			break;
			
		case EV_QuestIDWndLoadHtmlFromString:
			HandleQuestIDLoadHtmlFromString(param);
			break;
	}
}

function HandleQuestIDLoadHtmlFromString(string param)
{
	local int QuestID;
	local Array<int> rewardIDList;
	local Array<int> rewardClear;
	local Array<int> rewardNumList;
		
	local XMLTreeNodeInfo infNode;
	local XMLTreeNodeItemInfo infNodeItem;
	local XMLTreeNodeInfo infNodeClear;
	local XMLTreeNodeItemInfo infNodeItemClear;
	local int i;
	local string strRetName;
	
	
	
	ParseInt(param, "QuestID", QuestID);
	
	rewardIDList 	= 	rewardClear;
	rewardNumList 	= 	rewardClear;
	
	
	class'UIDATA_QUEST'.static.GetQuestReward(QuestID, 1, rewardIDList, rewardNumList);
	
	//~ class'UIDATA_QUEST'.static.GetQuestReward(QuestID, 0, rewardIDList, rewardNumList);
		
	//debug("RWD Quest Dialogue HTML" @ rewardIDList[0] @  rewardNumList[0]);
	

	// ������ ����Ʈ ���� Ʈ���� ���� 
	QuestRewardItemTree.Clear();

	if (rewardIDList.length > 0 )
	{
		//QuestRewardItemTree.Clear();

		infNode = infNodeClear;
		infNode.strName = "Root";
		QuestRewardItemTree.InsertNode("", infNode);		

		
		//~ if (rewardIDList.length > 3)
			//~ QuestRewardItemTree.ShowScrollBar(true);
		//~ else
			//~ QuestRewardItemTree.ShowScrollBar(false);
		
		for (i=0; i<rewardIDList.length; i++)
		{
			//debug ("QuestRewardItem HTML Total Count" @ rewardIDList.length);
			infNode = infNodeClear;
			infNode.strName = "RewardItem"$i;
			infNode.bShowButton = 0;
			
			//~ GetPlayerInfo( myInfo );
			
			//~ mItemID.ClassID = iItemClassID;
			//~ strIconName = class'UIDATA_ITEM'.static.GetItemTextureName( mItemID );
			//~ strName = class'UIDATA_ITEM'.static.GetItemName( mItemID );
		
			//Expand�Ǿ������� BackTexture����
			//��Ʈ��ġ�� �׸��� ������ ExpandedWidth�� ����. ������ -2��ŭ ����� �׸���.
			infNode.nTexExpandedOffSetX = 0;		//OffSet
			infNode.nTexExpandedOffSetY = 0;		//OffSet
			infNode.nTexExpandedHeight = 38;		//Height
			infNode.nTexExpandedRightWidth = 0;		//������ �׶��̼Ǻκ��� ����
			infNode.nTexExpandedLeftUWidth = 30; 		//��Ʈ��ġ�� �׸� ���� �ؽ����� UVũ��
			infNode.nTexExpandedLeftUHeight = 38;
			//~ infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
			
			strRetName = QuestRewardItemTree.InsertNode("root", infNode);
			//~ strRetName = class'UIAPI_TREECTRL'.static.InsertNode("QuestTreeDrawerWnd.QuestRewardItemTree", "root", infNode);
			if (Len(strRetName) < 1)
			{
				//debug("ERROR: Can't insert node. Name: " $ infNode.strName);
				return;
			}
			//debug ("strRet HTML" @ strRetName);
			
		//~ }
		//~ for (i=0; i<rewardIDList.length; i++)
		//~ {
			if (m_bDrawBg == true)
			{
				//Insert Node Item - ������ ���?
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXTURE;
				infNodeItem.nOffSetX = 0;
				infNodeItem.nOffSetY = 0;
				infNodeItem.u_nTextureUHeight = 14;
				infNodeItem.u_nTextureWidth = 257;
				infNodeItem.u_nTextureHeight = 38;
				infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
				QuestRewardItemTree.InsertNodeItem(strRetName, infNodeItem);
				m_bDrawBg = false;
			}
			else
			{
				//Insert Node Item - ������ ���?
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXTURE;
				infNodeItem.nOffSetX = 0;
				infNodeItem.nOffSetY = 0;
				infNodeItem.u_nTextureWidth = 257;
				infNodeItem.u_nTextureHeight = 38;
				infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
				QuestRewardItemTree.InsertNodeItem(strRetName, infNodeItem);
				m_bDrawBg = true;	
			}
			
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXTURE;
			infNodeItem.nOffSetX = -251;		// -4 // -2
			infNodeItem.nOffSetY = 2;			// -2 // -1
			infNodeItem.u_nTextureWidth = 36;
			infNodeItem.u_nTextureHeight = 36;
		
			infNodeItem.u_strTexture ="L2UI_ct1.ItemWindow_df_frame";
			QuestRewardItemTree.InsertNodeItem(strRetName, infNodeItem);
		
			//Insert Node Item - ������ ������
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXTURE;
			infNodeItem.nOffSetX = -35;
			infNodeItem.nOffSetY = 2;
			infNodeItem.u_nTextureWidth = 32;
			infNodeItem.u_nTextureHeight = 32;
			switch (rewardIDList[i])
			{
				case 57:
					infNodeItem.u_strTexture =  class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(57));
					break;
				default:
					infNodeItem.u_strTexture =  class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(rewardIDList[i]));
			}
			QuestRewardItemTree.InsertNodeItem( strRetName, infNodeItem);
			
			//Insert Node Item - ������ �̸�
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;
			switch (rewardIDList[i])
			{
				
				case 57:
					//~ infNodeItem.t_strText = "�Ƶ���"; 
					infNodeItem.t_strText = GetSystemString(469);	
					break;
				default:
					infNodeItem.t_strText =  class'UIDATA_ITEM'.static.GetItemName(GetItemID(rewardIDList[i]));
					break;
			}
			infNodeItem.t_bDrawOneLine = true;
			infNodeItem.nOffSetX = 8;
			infNodeItem.nOffSetY = 5;
		
			QuestRewardItemTree.InsertNodeItem( strRetName, infNodeItem);

			//Insert Node Item - Item Count
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;
			
			infNodeItem.t_color.R = 175;
			infNodeItem.t_color.G = 152;
			infNodeItem.t_color.B = 120;
			infNodeItem.t_color.A = 255;
			
			
			switch (rewardIDList[i])
			{
				
				case 57:
					if (rewardNumList[i] == 0)
						//~ infNodeItem.t_strText = "����";
						infNodeItem.t_strText = GetSystemString(584);
					else
						//~ infNodeItem.t_strText = string(rewardNumList[i]) $ " �Ƶ���";
						infNodeItem.t_strText = MakeFullSystemMsg(GetSystemMessage(2932), string(rewardNumList[i]),"");
					break;
				//~ case 0:
					//~ infNodeItem.t_strText = "����";
					//~ break;
				default:
					if (rewardNumList[i] == 0)
						//~ infNodeItem.t_strText = "����";
						infNodeItem.t_strText = GetSystemString(584);
					else
						// �Ʒ��� �ش��ϴ� ��� �� "��" ǥ�ð� �ȵǾ�� �Ѵ�.
						if (rewardIDList[i] == 15623 ||   // ����ġ  
							rewardIDList[i] == 15624 ||   // ��ų ����Ʈ
							rewardIDList[i] == 15625 ||   // ����ǥ        
							rewardIDList[i] == 15626 ||   // Ȱ�� ����Ʈ
							rewardIDList[i] == 15627 ||   // ���� ����Ʈ
							rewardIDList[i] == 15628 ||   // ���� ����
							rewardIDList[i] == 15629 ||   // ������ ����
							rewardIDList[i] == 15630 ||   // �߰� ����
							rewardIDList[i] == 15631 ||   // ���� Ŭ���� ���� ȹ��
							rewardIDList[i] == 15632 ||   // PK ī��Ʈ �϶� 
							rewardIDList[i] == 15633)
						{
							infNodeItem.t_strText = string(rewardNumList[i]);
						}
						else
						{
							//~ infNodeItem.t_strText = string(rewardNumList[i]) $ "��";
							infNodeItem.t_strText = MakeFullSystemMsg(GetSystemMessage(1983), string(rewardNumList[i]),"");
						}
						// [����Ʈ ������ ���� �߰�] ����Ʈ ���� �����ۿ� ������ ǥ���ϱ� ���� item class id�� ����.
						infNodeItem.nReserved = rewardIDList[i];


					break;
			}
			
			infNodeItem.bLineBreak = true;
			infNodeItem.nOffSetX = 48;
			infNodeItem.nOffSetY = -20;
			QuestRewardItemTree.InsertNodeItem(strRetName, infNodeItem);
		}	
	}
	
	
	
	Me.ShowWindow();
	Me.SetFocus();
}

function OnHtmlMsgHideWindow(HtmlHandle a_HtmlHandle)
{
	if(a_HtmlHandle==m_hHtmlViewer)
	{
		HideQuestHTMLWnd();
	}
}

function HandleLoadHtmlFromString(string param)
{
	local string htmlString;
	ParseString(param, "HTMLString", htmlString);

	m_hHtmlViewer.LoadHtmlFromString(htmlString);
}


function ShowQuestHTMLWnd()
{
	ExecuteEvent(EV_NPCDialogWndHide);
	Me.ShowWindow();
	Me.SetFocus();
	m_bReShowQuestHTMLWnd = true;
}

function HideQuestHTMLWnd()
{			
	Me.HideWindow();
	m_bReShowQuestHTMLWnd = false;
}

function OnHide()
{
	ProcCloseQuestHTMLWnd();
}

function OnClickButton( string Name )
{
	PressCloseButton();
}


function OnExitState( name a_NextStateName )
{
	
	if( a_NextStateName == 'NpcZoomCameraState')
	{
		Clear();
		m_bReShowWndMode = true;
	}
}

function OnEnterState( name a_PreStateName )
{		
	
	if( a_PreStateName == 'NpcZoomCameraState' )
	{
		ReShowQuestHTMLWnd();
		Clear();	
	}
}

function Clear()
{
	//
	m_bReShowWndMode	= false;	
	m_bPressCloseButton = false;
	m_bReShowQuestHtmlWnd = false;
}


//
function PressCloseButton()
{
	// press close button
	if( m_bReShowWndMode )
	{
		m_bPressCloseButton = true;
	}
}

function ProcCloseQuestHTMLWnd()
{	
	if( m_bPressCloseButton && m_bReShowWndMode && m_bReShowQuestHTMLWnd)
	{
		// must first m_bReShowQuestHTMLWnd be false because calling recursive function.
		m_bReShowWndMode = false;		
		RequestFinishNPCZoomCamera();		
	}
}

function ReShowQuestHTMLWnd()
{
	if( m_bReShowWndMode && m_bReShowQuestHTMLWnd )
	{
		ShowQuestHTMLWnd();			
	}	
}


defaultproperties
{
}
