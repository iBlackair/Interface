class PremiumItemGetWnd extends UICommonAPI;

const OFFSET_Y_1ST_LINE = 4;	// ù��° �� ������
const OFFSET_Y_SECONDLINE = -17;


//-------------------------------------------------------------------------------------------------
// ��������
//-------------------------------------------------------------------------------------------------

var int m_iItemNameLength;			// �� ����� �̸��� ����

var int m_clickedID;				// ���õ� ID	-1�̸� �ƹ��͵� ���õ��� ���� ��
var int m_clickedItemNum;			// ���õ� ID�� ������ ���� ���� ����
var int m_maxCount;				// ���� �� �ִ� ������ ���� �۷ι� ����

var bool m_bDrawBg;				// ��濡 �� �׵θ��� �����ư��� �׷��ֱ� ���� ����

var WindowHandle	Me;			//�׳� ���� ������ �ڵ�

var ButtonHandle		btnRecieve;	// �ޱ� ��ư
var ButtonHandle		btnCancle;		// ��� ��ư
var TreeHandle		PremiumItemListTree;	//Ʈ�� ��Ʈ��

var EditBoxHandle	GetnumEdit;	//���� ����Ʈ�ڽ� ��Ʈ��


//-------------------------------------------------------------------------------------------------
// �ε��� ó��
//-------------------------------------------------------------------------------------------------

function OnRegisterEvent()
{
	RegisterEvent( EV_PremiumItemList );		// �ӽ�
}

function OnLoad()
{	
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me = GetHandle( "PremiumItemGetWnd" ); // ���� ������ �ڵ� ��������
		btnRecieve = ButtonHandle( GetHandle( "PremiumItemGetWnd.btnRecieve" ) ); 
		btnCancle = ButtonHandle( GetHandle( "PremiumItemGetWnd.btnCancle" ) ); 
		PremiumItemListTree = TreeHandle( GetHandle( "PremiumItemGetWnd.PremiumItemListTree" ) ); 
		
		GetNumEdit = EditBoxHandle( GetHandle( "PremiumItemGetWnd.GetNumEdit" ) ); 
	}
	else
	{
		Me = GetWindowHandle( "PremiumItemGetWnd" ); // ���� ������ �ڵ� ��������
		btnRecieve = GetButtonHandle( "PremiumItemGetWnd.btnRecieve" ); 
		btnCancle = GetButtonHandle( "PremiumItemGetWnd.btnCancle" ); 
		PremiumItemListTree = GetTreeHandle( "PremiumItemGetWnd.PremiumItemListTree" ); 
		
		GetNumEdit = GetEditBoxHandle( "PremiumItemGetWnd.GetNumEdit" ); 
	}
	clear();
}

function clear()
{
	m_bDrawBg = true;
	m_clickedID = -1;
	m_clickedItemNum = -1;
	btnRecieve.DisableWindow();	//�𽺿��̺�
	GetnumEdit.clear();
}

function createTreeRoot()
{
	local XMLTreeNodeInfo	infNode;	
	local string strTmp;
	
	//Ʈ���� Root�߰�	// ��Ʈ�� �ε��� �ѹ��� �����. 
	infNode.strName = "PremiumItemListTreeRoot";
	infNode.nOffSetX = 0;
	infNode.nOffSetY = 0;
	strTmp = PremiumItemListTree.InsertNode("", infNode);
	if (Len(strTmp) < 1)
	{
		//debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}	
}

// ��ư Ŭ�� �̺�Ʈ��
function OnClickButton( string strID )
{	
	local int nowClickedID;
	local int nowClickedItemNum;
	local int nowEditBoxNum;
	local string removeRootStr;
	local int iLength;
	local int SplitCount;
	local array<string>	arrSplit;
	
	iLength = Len(strID) - Len("PremiumItemListTreeRoot."); // Ʈ���� �̸��� "PremiumItemListTreeRoot.ID" ���·� �ٰ� �ǹǷ�
	removeRootStr = Right(strID, iLength);

	switch( strID )
	{
	case "btnRecieve":
		if(m_clickedID != -1)	//���õ� ��尡 ���� ��쿡��
		{
			nowEditBoxNum = int(GetnumEdit.GetString());
			//debug ("m_clickedID = " $ m_clickedID $ "nowEditBoxNum = " $ nowEditBoxNum);	//���
			
			// ������ �ޱ⸦ ��û�ϴ� API �Լ�
			RequestWithDrawPremiumItem(m_clickedID, IntToInt64(nowEditBoxNum));
			
			if(m_maxCount == 1)	// �ϳ� ���� ���� ���� �Ŀ��� â�� �ڵ����� �ݾ���
			{
				Me.HideWindow();
			}
			return;
		}
		break;
		
	case "btnCancle":
		Me.HideWindow();
		return;
		break;
	}
	
	// �� �� ��쿡 �ش����� ������, Ʈ�� ��尡 Ŭ���� ���̴�.
	//��忡�� ���� �̾Ƴ���
	SplitCount = Split(removeRootStr, ".", arrSplit);	// "ID.����" ���¸� ����
	
	if(splitCount <0 || splitCount >2)	// "ID.����" ���°� �ƴϸ� ���״�.
	{
		//debug ("ERROR wrong button name!!");
		return;
	}
	
	//debug("SplitCount = " $ SplitCount);
	nowClickedID = int(arrSplit[0]);
	nowClickedItemNum = int(arrSplit[1]);
	
	if(m_clickedID == nowClickedID)
	{
		m_clickedID = -1;	// ������ Ŭ���ߴ� �Ŷ�� ���� ����
		m_clickedItemNum = 1;
		btnRecieve.DisableWindow();	//�𽺿��̺� ó��
		GetnumEdit.clear();
	}
	else
	{
		m_clickedID = nowClickedID;
		m_clickedItemNum = nowClickedItemNum;
		GetnumEdit.SetString("" $ nowClickedItemNum);
		btnRecieve.EnableWindow();	//�ο��̺� ó��
	}	
}

// �̺�Ʈ �޼��� ó��
function OnEvent(int Event_ID, string param)
{	
	switch(Event_ID)
	{
		
	case EV_PremiumItemList :
		clearInfo();	//�ʱ�ȭ
		PremiumItemListTree.Clear();	//�ʱ�ȭ
		if(!IsShowWindow("PremiumItemGetWnd"))	//â�� �ȶ������� ����ش�.
			ShowWindowWithFocus("PremiumItemGetWnd");
		
		HandlePremiumItemList(param);
		break;
	}
	
}

function HandlePremiumItemList(string param)
{
	local int 	i ;			//������ ���� ����
	local int	iItemCount ;	//����Ʈ�� ������ ��
	local int	iGift ;			//�����ΰ�
	local int	iItemClassID;	//�������� Ŭ���� ���̵�
	local INT64	iItemAmount;	//������ ����
	local string senderCharacter;	//������
	
	clear();			// �ⵥ���� �ʱ�ȭ
	createTreeRoot();	//��Ʈ ����
	
	//------------- ������ �Ľ�----------
	iItemCount = 0;
	ParseInt(param,"ItemCount", iItemCount);
	
	m_maxCount = iItemCount;	//���������� �� ������ ����Ʈ ���� �־��ش�. 
	
	for(i = 0; i<iItemCount ; i++)
	{
		ParseInt(param,"Gift_" $ i , iGift);
		ParseInt(param,"ItemClassID_" $ i , iItemClassID);
		ParseInt64(param,"ItemAmount_" $ i , iItemAmount);		
		ParseString(param,"SenderCharacter_" $ i , senderCharacter);	
		AddPremiumListItem( iGift, iItemClassID, iItemAmount, senderCharacter, i);
	}
}

function AddPremiumListItem(int iGift ,  int iItemClassID , INT64 iItemAmount , string senderCharacter , int iIndexID)
{
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;

	local string strRetName;
	local ItemID mItemID;
	local string strIconName;
	local string strName;
	
	local UserInfo myInfo;

	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//��ư���� ��� �߰�
	infNode = infNodeClear;
	infNode.strName = ""$ iIndexID $"." $Int64ToString(iItemAmount);
	infNode.bShowButton = 0;
	
	GetPlayerInfo( myInfo );
	
	mItemID.ClassID = iItemClassID;
	strIconName = class'UIDATA_ITEM'.static.GetItemTextureName( mItemID );
	strName = class'UIDATA_ITEM'.static.GetItemName( mItemID );

	//Expand�Ǿ������� BackTexture����
	//��Ʈ��ġ�� �׸��� ������ ExpandedWidth�� ����. ������ -2��ŭ ����� �׸���.
	infNode.nTexExpandedOffSetX = 0;		//OffSet
	infNode.nTexExpandedOffSetY = 0;		//OffSet
	infNode.nTexExpandedHeight = 38;		//Height
	infNode.nTexExpandedRightWidth = 0;		//������ �׶��̼Ǻκ��� ����
	infNode.nTexExpandedLeftUWidth = 30; 		//��Ʈ��ġ�� �׸� ���� �ؽ����� UVũ��
	infNode.nTexExpandedLeftUHeight = 38;
	infNode.strTexExpandedLeft = "L2UI_CH3.etc.IconSelect2";
	
	strRetName = PremiumItemListTree.InsertNode("PremiumItemListTreeRoot", infNode);
	if (Len(strRetName) < 1)
	{
		//debug("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	
	//�����ư��鼭 ��� �׷��ֱ�
	if (m_bDrawBg == true)
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureUHeight = 14;
		infNodeItem.u_nTextureWidth = 341;
		infNodeItem.u_nTextureHeight = 38;
		infNodeItem.u_strTexture = "L2UI_CH3.etc.textbackline";
		PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);
		m_bDrawBg = false;
	}
	else
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 341;
		infNodeItem.u_nTextureHeight = 38;
		infNodeItem.u_strTexture = "L2UI_CT1.EmptyBtn";
		PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);
		m_bDrawBg = true;	
	}

	//Insert Node Item - ������ ������ �׵θ� �ؽ���
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -341 +1;	
	infNodeItem.nOffSetY = 2;
	infNodeItem.u_nTextureWidth = 36;
	infNodeItem.u_nTextureHeight = 36;
	infNodeItem.u_strTexture ="L2UI_ct1.ItemWindow.ItemWindow_df_slotbox_2x2";
	PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);

	//Insert Node Item - ������ ������
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -36 + 2;
	infNodeItem.nOffSetY = 3;
	infNodeItem.u_nTextureWidth = 32;
	infNodeItem.u_nTextureHeight = 32;
	infNodeItem.u_strTexture = strIconName;
	PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);

	//Insert Node Item - ������ �̸�
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strName $ " X " $ Int64ToString(iItemAmount);
	infNodeItem.t_bDrawOneLine = true;
	infNodeItem.nOffSetX = 7;
	infNodeItem.nOffSetY = 5;
	PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);
	
	//Insert Node Item - �������
	//���� ��� ������ �ְ�, �� �̸��� �������� �ʴٸ� ������� ������ �����ش�. 
	if( ( Len(senderCharacter) > 0 ) && ( InStr( senderCharacter , myInfo.name ) < 0 ) )
	{
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = "["$ GetSystemString(1740) $ " " $ senderCharacter $ "]";
		infNodeItem.bLineBreak = true;
		infNodeItem.t_bDrawOneLine = true;
		infNodeItem.nOffSetX = 43;
		infNodeItem.nOffSetY = - 38 + 21;
		infNodeItem.t_color.R = 163;
		infNodeItem.t_color.G = 163;
		infNodeItem.t_color.B = 163;
		infNodeItem.t_color.A = 255;
		PremiumItemListTree.InsertNodeItem(strRetName, infNodeItem);
	}
}


//���� ���� �ʱ�ȭ
function clearInfo()
{
	m_bDrawBg = true;
}
defaultproperties
{
}
