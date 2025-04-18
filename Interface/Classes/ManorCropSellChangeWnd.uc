class ManorCropSellChangeWnd extends UICommonAPI;


const MANOR_NAME=0;
const CROP_REMAIN_CNT=1;
const CROP_PRICE=2;
const PROCURE_TYPE=3;

const COLUMN_CNT=4;

var string m_WindowName;
var ListCtrlHandle m_hManorCropSellChangeWndManorCropSellChangeListCtrl;
var ListCtrlHandle m_hManorCropSellWndManorCropSellListCtrl;

function OnRegisterEvent()
{
	RegisterEvent( EV_ManorCropSellChangeWndShow );
	RegisterEvent( EV_ManorCropSellChangeWndAddItem );
	RegisterEvent( EV_ManorCropSellChangeWndSetCropNameAndRewardType );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	m_WindowName="ManorCropSellChangeWnd";
	m_hManorCropSellChangeWndManorCropSellChangeListCtrl=GetListCtrlHandle(m_WindowName$".ManorCropSellChangeListCtrl");
	m_hManorCropSellWndManorCropSellListCtrl=GetListCtrlHandle("ManorCropSellWnd.ManorCropSellListCtrl");
}

function OnEvent( int Event_ID, string a_param )
{
	switch( Event_ID )
	{
	case EV_ManorCropSellChangeWndShow :
		if(IsShowWindow("ManorCropSellChangeWnd"))
		{
			HideWindow("ManorCropSellChangeWnd");
		}
		else
		{
			Clear();
			ShowWindowWithFocus("ManorCropSellChangeWnd");
		}
		break;

	case EV_ManorCropSellChangeWndAddItem :
		HandleAddItem(a_param);
		break;
	case EV_ManorCropSellChangeWndSetCropNameAndRewardType :
		// �۹��̸�, ����Ÿ�� ������ ���̴°� ����
		HandleSetCropNameAndRewardType(a_param);
		break;
	}
}

function Clear()
{
	class'UIAPI_LISTCTRL'.static.DeleteAllItem("ManorCropSellChangeWnd.ManorCropSellChangeListCtrl");

	class'UIAPI_COMBOBOX'.static.Clear("ManorCropSellChangeWnd.cbPurchasePlace");
	class'UIAPI_COMBOBOX'.static.SYS_AddStringWithReserved("ManorCropSellChangeWnd.cbPurchasePlace", 1276, -1);
	class'UIAPI_COMBOBOX'.static.SetSelectedNum("ManorCropSellChangeWnd.cbPurchasePlace", 0);	// ����ó �޺��ڽ��� ��ó���� ����

	class'UIAPI_EDITBOX'.static.Clear("ManorCropSellChangeWnd.ebSalesVolume");					// ����Ʈ�ڽ� ���
}


function HandleSetCropNameAndRewardType(string a_param)
{
	local string CropName;
	local string RewardType1;
	local string RewardType2;

	ParseString(a_param, "CropName", CropName);
	ParseString(a_param, "RewardType1", RewardType1);
	ParseString(a_param, "RewardType2", RewardType2);
	
	class'UIAPI_TEXTBOX'.static.SetText("ManorCropSellChangeWnd.txtVarCropName", CropName);
	class'UIAPI_TEXTBOX'.static.SetText("ManorCropSellChangeWnd.txtVarRewardType1", RewardType1);
	class'UIAPI_TEXTBOX'.static.SetText("ManorCropSellChangeWnd.txtVarRewardType2", RewardType2);
}

function HandleAddItem(string a_Param)
{
	local LVDataRecord record;

	local string ManorName;
	local INT64 CropRemainCnt;
	local INT64 CropPrice;
	local int ProcureType;
	local int ManorID;

	record.LVDataList.Length=COLUMN_CNT;

	ParseString(a_Param, "ManorName", ManorName);
	ParseINT64(a_Param, "CropRemainCnt", CropRemainCnt);
	ParseINT64(a_Param, "CropPrice", CropPrice);
	ParseInt(a_Param, "ProcureType", ProcureType);
	ParseInt(a_Param, "ManorID", ManorID);

//	debug("CropName"$CropName$"ManorName"$ManorName$"CropRemainCnt"$CropRemainCnt$"CropPrice"$CropPrice$"ProcureType"$ProcureType$"MyCropCnt"$MyCropCnt);

	record.LVDataList[MANOR_NAME].szData=ManorName;
	record.LVDataList[CROP_REMAIN_CNT].szData=Int64ToString(CropRemainCnt);
	record.LVDataList[CROP_PRICE].szData=Int64ToString(CropPrice);
	record.LVDataList[PROCURE_TYPE].szData=string(ProcureType);
	record.nReserved1=IntToInt64(ManorID);

	class'UIAPI_LISTCTRL'.static.InsertRecord("ManorCropSellChangeWnd.ManorCropSellChangeListCtrl", record );

	class'UIAPI_COMBOBOX'.static.AddStringWithReserved("ManorCropSellChangeWnd.cbPurchasePlace", ManorName, ManorID);
}


function OnClickButton(string strID)
{
	//debug(" "$strID);

	switch(strID)
	{
	case "btnMax" :
		HandleMaxButton();
		break;
	case "btnOk" :
		HandleOkBtn();
		break;
	case "btnCancel" :
		HideWindow("ManorCropSellChangeWnd");
		break;
	}
}

function HandleMaxButton()
{
	local LVDataRecord record;
	local int ManorID;
	local INT64 MyCropCnt;
	local INT64 CropRemainCnt;
	local INT64 MinValue;
	local string MinValueString;

	// �޺��ڽ����� ��� ���̵� �����´�
	record=GetComboBoxSelectedRecord();
		
	CropRemainCnt=StringToInt64(record.LVDataList[CROP_REMAIN_CNT].szData);
	ManorID=GetComboBoxSelectedManorID();
	if(ManorID ==-1) 
		return;
	MyCropCnt=GetMyCropCnt(ManorID);	

	//debug("��������"$record.LVDataList[CROP_REMAIN_CNT].szData$" ManorID:"$ManorID$" MyCropCnt"$MyCropCnt);

	// ���߿� �����ɷ� ǥ�����ش�
	MinValue=Min64(MyCropCnt, CropRemainCnt);

	if(MinValue==IntToInt64(-1))
		MinValueString="0";
	else
		MinValueString=Int64ToString(MinValue);

	class'UIAPI_EDITBOX'.static.SetString("ManorCropSellChangeWnd.ebSalesVolume", MinValueString);
}


function HandleOkBtn()
{
	local LVDataRecord record;

	local int ManorID;
	local string SellCntString;

	local string param;

	record=GetComboBoxSelectedRecord();

	SellCntString=class'UIAPI_EDITBOX'.static.GetString("ManorCropSellChangeWnd.ebSalesVolume");
	ManorID=Int64ToInt(record.nReserved1);

	// �۹��Ǹŷ� ���� ������ �Ǹ� �����쿡 �����ش�
	ParamAdd(param, "SellCntString", SellCntString);
	ParamAdd(param, "ManorID", string(ManorID));
	ParamAdd(param, "ManorName", record.LVDataList[MANOR_NAME].szData);
	ParamAdd(param, "CropRemainCntString", record.LVDataList[CROP_REMAIN_CNT].szData);
	ParamAdd(param, "CropPriceString", record.LVDataList[CROP_PRICE].szData);
	ParamAdd(param, "ProcureTypeString", record.LVDataList[PROCURE_TYPE].szData);

	ExecuteEvent(EV_ManorCropSellWndSetCropSell, param);

	HideWindow("ManorCropSellChangeWnd");
}


function int GetComboBoxSelectedManorID()
{
	local int ManorID;
	local int cbSelectedIndex;
	
	//debug("GetComboboxSelectedManorID");
	cbSelectedIndex=class'UIAPI_COMBOBOX'.static.GetSelectedNum("ManorCropSellChangeWnd.cbPurchasePlace");
		
	//debug("selectedindex:" $ cbSelectedIndex);

	ManorID=class'UIAPI_COMBOBOX'.static.GetReserved("ManorCropSellChangeWnd.cbPurchasePlace", cbSelectedIndex);
		
	//debug("ID:"$ManorID);

	return ManorID;
}

function LVDataRecord GetComboBoxSelectedRecord()
{
	local LVDataRecord record;
	local int ManorID;
	local int RecordCount;
	local int i;

	ManorID=GetComboBoxSelectedManorID();

	// ����Ʈ ���� ���´�
	RecordCount=m_hManorCropSellChangeWndManorCropSellChangeListCtrl.GetRecordCount();

	for(i=0; i<RecordCount; ++i)
	{
		m_hManorCropSellChangeWndManorCropSellChangeListCtrl.GetRec(i, record);
		
		// ����Ʈ�� ���ٰ� ID�� ������ �u�ߵǸ� ã�� ���ڵ�
		if(Int64ToInt(record.nReserved1)==ManorID)
			break;
	}

	return record;
}


function INT64 GetMyCropCnt(int ManorID)
{
	local INT64 MyCropCnt;
	local LVDataRecord record;

	MyCropCnt=IntToInt64(-1);

	m_hManorCropSellWndManorCropSellListCtrl.GetSelectedRec(record);
	MyCropCnt=StringToInt64(record.LVDataList[5].szData);
	
	return MyCropCnt;
}

defaultproperties
{
    
}
