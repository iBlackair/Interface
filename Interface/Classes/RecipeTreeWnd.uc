class RecipeTreeWnd extends UICommonAPI;

function OnRegisterEvent()
{
	RegisterEvent( EV_RecipeShowRecipeTreeWnd );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
}

function OnEvent(int Event_ID, String param)
{
	local int RecipeID;
	local int SuccessRate;

	if (Event_ID == EV_RecipeShowRecipeTreeWnd)
	{
		ParseInt( param, "RecipeID", RecipeID );
		ParseInt( param, "SuccessRate", SuccessRate );
		StartRecipeTreeWnd( RecipeID, SuccessRate );
	}
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnClose":
		CloseWindow();
		break;
	}
}

//������ �ݱ�
function CloseWindow()
{
	Clear();
	class'UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//�ʱ�ȭ
function Clear()
{
	class'UIAPI_TREECTRL'.static.Clear("RecipeTreeWnd.MainTree");
}

//Start Function
function StartRecipeTreeWnd(int RecipeID, int SuccessRate)
{
	//Show
	class'UIAPI_WINDOW'.static.ShowWindow("RecipeTreeWnd");
	class'UIAPI_WINDOW'.static.SetFocus("RecipeTreeWnd");
	
	Clear();
	SetRecipeInfo(RecipeID, SuccessRate);
}

//������ ���� ����
function SetRecipeInfo(int RecipeID, int SuccessRate)
{
	local string		strTmp;
	local string		strTmp2;
	local int			nTmp;
	local XMLTreeNodeInfo	infNode;
	
	local int			ProductID;
	
	//������ ������ �ؽ���
	strTmp = class'UIDATA_RECIPE'.static.GetRecipeIconName(RecipeID);
	if (Len(strTmp)>0)
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeTreeWnd.texIcon", strTmp);
	}
	else
	{
		class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeTreeWnd.texIcon", "Default.BlackTexture");
	}
	
	//������ �̸�
	ProductID = class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	strTmp = MakeFullItemName(ProductID);
	
	//Crystal Type(Grade Emoticon���)
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	strTmp2 = GetItemGradeTextureName(nTmp);
	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeTreeWnd.texGrade", strTmp2);
	
	class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtName", strTmp);
	
	//MP�Һ�
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtMPConsume", "" $ nTmp);
	
	//����Ȯ��
	class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtSuccessRate", SuccessRate $ "%");
	
	//������ ����
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeLevel(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.TxtForgeLevelValue", string(nTmp));
	
	//�ɼǺο� ����
	if (bool(class'UIDATA_RECIPE'.static.GetRecipeIsMultipleProduct(RecipeID)))
		class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtOption", GetSystemMessage(2320));
	else
		class'UIAPI_TEXTBOX'.static.SetText("RecipeTreeWnd.txtOption", "");

	
	//Ʈ���� Root�߰�
	infNode.strName = "root";
	infNode.nOffSetX = 1;
	infNode.nOffSetY = 5;
	strTmp = class'UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree", "", infNode);
	if (Len(strTmp) < 1)
	{
		//debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}
	
	//Ʈ�� �ۼ�
	AddRecipeItem(ProductID, SuccessRate, IntToInt64(0), "root");
}

function AddRecipeItem(int ProductID, int SuccessRate, INT64 NeedCount, string NodeName)
{
	local int		i;
	local string	param;
	local INT64		nTmp;
	local string	strTmp;
	local string	strTmp2;
	local int		nMax;
	local bool		bIamRoot;
	
	local array<int>	arrMatID;
	local array<int>	arrMatRate;
	local array<INT64>	arrMatNeedCount;
	
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;
	local string		strRetName;
	
	//������ �̸�
	strTmp = class'UIDATA_RECIPE'.static.GetRecipeNameBy2Condition(ProductID, SuccessRate);
	
	//Child�� �ִ� ������
	if (Len(strTmp)>0)
	{
		if (NodeName == "root")
		{
			bIamRoot = true;
		}
		else
		{
			bIamRoot = false;
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert Node - with Button
		infNode = infNodeClear;
		infNode.strName = "" $ ProductID $ "_" $ SuccessRate;
		infNode.Tooltip = MakeTooltipSimpleText(strTmp);
		infNode.bFollowCursor = true;
		if (!bIamRoot)
		{
			infNode.nOffSetX = 16;
		}
		infNode.bShowButton = 1;
		infNode.nTexBtnWidth = 12;
		infNode.nTexBtnHeight = 12;
		infNode.nTexBtnOffSetY = 10;
		infNode.strTexBtnExpand = "L2UI.RecipeWnd.TreePlus";
		infNode.strTexBtnCollapse = "L2UI.RecipeWnd.TreeMinus";
		
		strRetName = class'UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree", NodeName, infNode);
		if (Len(strRetName) < 1)
		{
			Log("ERROR: Can't insert node. Name: " $ infNode.strName);
			return;
		}
		
		//������ ������ �̸�
		strTmp2 = class'UIDATA_RECIPE'.static.GetRecipeIconNameBy2Condition(ProductID, SuccessRate);
		if (Len(strTmp2)<1)
		{
			strTmp2 = "Default.BlackTexture";
		}
		
		//Insert Node Item - ������ ������
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 2;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 32;
		infNodeItem.u_nTextureHeight = 32;
		infNodeItem.u_strTexture = strTmp2;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - ������ ������(�׵θ�)
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = -32;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 32;
		infNodeItem.u_nTextureHeight = 32;
		infNodeItem.u_strTexture = "L2UI.RecipeWnd.RecipeTreeIconBack";
		infNodeItem.u_strTextureExpanded = "L2UI.RecipeWnd.RecipeTreeIconBack_click";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
		
		if (!bIamRoot)
		{
			//�κ��丮�� �ش� �������� ����
			nTmp = GetInventoryItemCount(GetItemID(ProductID));
			
			//��ᰡ �� �ȸ���� ����� �帴�ϰ� ǥ��
			if (nTmp < NeedCount)
			{
				//Insert Node Item - �帴 �ؽ���
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXTURE;
				infNodeItem.nOffSetX = -32;
				infNodeItem.nOffSetY = 0;
				infNodeItem.u_nTextureWidth = 32;
				infNodeItem.u_nTextureHeight = 32;
				infNodeItem.u_strTexture = "Default.ChatBack";
				class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
			}	
		}
		
		//Insert Node Item - ������ �̸�
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = strTmp;
		infNodeItem.t_bDrawOneLine = true;
		infNodeItem.nOffSetX = 5;
		infNodeItem.nOffSetY = 4;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
		
		if (!bIamRoot)
		{
			//Insert Node Item - ��� ����
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;
			infNodeItem.t_strText = "(" $ Int64ToString(nTmp) $ "/" $ Int64ToString(NeedCount) $ ")";
			infNodeItem.bLineBreak = true;
			infNodeItem.nOffSetX = 51;
			infNodeItem.nOffSetY = -14;
			class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
		}
		
		//Insert Node Item - Blank
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_BLANK;
		infNodeItem.bStopMouseFocus = true;
		infNodeItem.b_nHeight = 6;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
		
		//Child �����ǵ��� �߰�
		param = class'UIDATA_RECIPE'.static.GetRecipeMaterialItemBy2Condition(ProductID, SuccessRate);
		ParseInt(param, "Count", nMax);
		
		//���߿� Recursiveȣ���ϴ� �κ��� �����Ƿ�, Static�� Param�� �ϴ� ������ �̾ƾ�(?)�Ѵ�.
		arrMatID.Length = nMax;
		arrMatRate.Length = nMax;
		arrMatNeedCount.Length = nMax;
		for (i=0; i<nMax; i++)
		{
			ParseInt(param, "ID_" $ i, arrMatID[i]);
			ParseInt(param, "SuccessRate_" $ i, arrMatRate[i]);
			ParseINT64(param, "NeededNum_" $ i, arrMatNeedCount[i]);
		}
		for (i=0; i<nMax; i++)
		{
			//Recursive
			AddRecipeItem(arrMatID[i], arrMatRate[i], arrMatNeedCount[i], strRetName);
		}
	}
	
	//Child�� ���� ��
	else
	{
		//������ �̸�
		strTmp = class'UIDATA_ITEM'.static.GetItemName(GetItemID(ProductID));
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert Node - with No Button
		infNode = infNodeClear;
		infNode.strName = "" $ ProductID $ "_" $ SuccessRate;
		infNode.nOffSetX = 30;
		infNode.Tooltip = MakeTooltipSimpleText(strTmp);
		infNode.bFollowCursor = true;
		infNode.bShowButton = 0;
		strRetName = class'UIAPI_TREECTRL'.static.InsertNode("RecipeTreeWnd.MainTree", NodeName, infNode);
		if (Len(strRetName) < 1)
		{
			Log("ERROR: Can't insert node. Name: " $ infNode.strName);
			return;
		}
		
		//������ ������ �̸�
		strTmp2 = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
		if (Len(strTmp2)<1)
		{
			strTmp2 = "Default.BlackTexture";
		}
		
		//Insert Node Item - ������ ������
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 32;
		infNodeItem.u_nTextureHeight = 32;
		infNodeItem.u_strTexture = strTmp2;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - ������ ������(Disable)
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = -32;
		infNodeItem.nOffSetY = 0;
		infNodeItem.u_nTextureWidth = 32;
		infNodeItem.u_nTextureHeight = 32;
		infNodeItem.u_strTexture = "L2UI.RecipeWnd.RecipeTreeIconDisableBack";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
		
		//�κ��丮�� �ش� �������� ����
		nTmp = GetInventoryItemCount(GetItemID(ProductID));
		
		//��ᰡ �� �ȸ���� ����� �帴�ϰ� ǥ��
		if (nTmp < NeedCount)
		{
			//Insert Node Item - �帴 �ؽ���
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXTURE;
			infNodeItem.nOffSetX = -32;
			infNodeItem.nOffSetY = 0;
			infNodeItem.u_nTextureWidth = 32;
			infNodeItem.u_nTextureHeight = 32;
			infNodeItem.u_strTexture = "Default.ChatBack";
			class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
		}
		
		//Insert Node Item - ������ �̸�
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = strTmp;
		infNodeItem.t_bDrawOneLine = true;
		infNodeItem.nOffSetX = 5;
		infNodeItem.nOffSetY = 3;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - ��� ����
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = "(" $ Int64ToString(nTmp) $ "/" $ Int64ToString(NeedCount) $ ")";
		infNodeItem.bLineBreak = true;
		infNodeItem.nOffSetX = 37;
		infNodeItem.nOffSetY = -14;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - Blank
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_BLANK;
		infNodeItem.bStopMouseFocus = true;
		infNodeItem.b_nHeight = 4;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("RecipeTreeWnd.MainTree", strRetName, infNodeItem);
	}
}
defaultproperties
{
}
