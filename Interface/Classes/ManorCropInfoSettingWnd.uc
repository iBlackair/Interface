class ManorCropInfoSettingWnd extends UICommonAPI;

var int m_ManorID;
var INT64 m_SumOfDefaultPrice;

const CROP_NAME=0;
const TODAY_CROP_TOTOAL_CNT=1;
const TODAY_CROP_PRICE=2;
const TODAY_PROCURE_TYPE=3;
const NEXT_CROP_TOTAL_CNT=4;
const NEXT_CROP_PRICE=5;
const NEXT_PROCURE_TYPE=6;
const MIN_CROP_PRICE=7;
const MAX_CROP_PRICE=8;
const CROP_LELEL=9;
const REWARD_TYPE_1=10;
const REWARD_TYPE_2=11;

const COLUMN_CNT=12;


const DIALOG_ID_STOP=777;
const DIALOG_ID_SETTODAY=888;

var string m_WindowName;
var ListCtrlHandle m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl;

function OnRegisterEvent()
{
	RegisterEvent( EV_ManorCropInfoSettingWndShow );
	RegisterEvent( EV_ManorCropInfoSettingWndAddItem );
	RegisterEvent( EV_ManorCropInfoSettingWndAddItemEnd );

	RegisterEvent( EV_ManorCropInfoSettingWndChangeValue );

	RegisterEvent( EV_DialogOK );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	m_WindowName="ManorCropInfoSettingWnd";
	m_ManorID=-1;
	m_SumOfDefaultPrice=IntToInt64(0);

	m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl=GetListCtrlHandle(m_WindowName$".ManorCropInfoSettingListCtrl");
}


function OnEvent( int Event_ID, string a_Param)
{
	switch( Event_ID )
	{
	case EV_ManorCropInfoSettingWndShow :
		HandleShow(a_Param);
		break;

	case EV_ManorCropInfoSettingWndAddItem :
		HandleAddItem(a_Param);
		break;
	case EV_ManorCropInfoSettingWndAddItemEnd :
		CalculateSumOfDefaultPrice();
		ShowWindowWithFocus("ManorCropInfoSettingWnd");
		break;
	case EV_ManorCropInfoSettingWndChangeValue :
		HandleChangeValue(a_Param);
		break;
	case EV_DialogOK :
		HandleDialogOk();
		break;
	}
}


function HandleDialogOk()
{
	local int DialogID;

	if(!DialogIsMine())
		return;

	DialogID=DialogGetID();

	switch(DialogID)
	{
	case DIALOG_ID_STOP :
		HandleStop();
		break;
	case DIALOG_ID_SETTODAY :
		HandleSetToday();
		break;
	}
}


function HandleStop()
{
	local int i;
	local int RecordCnt;
	local LVDataRecord record;
	local LVDataRecord recordClear;

	RecordCnt=m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();


//	debug("ī��Ʈ:"$RecordCnt);
	for(i=0; i<RecordCnt; ++i)
	{
		record = recordClear;		// �̷��� ���������� ������ �ڲ� �þ��.
		m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i,record);
//		debug("���ڵ��ε���:"$i$", ���ڵ����(��� 10�̾�� ����):"$record.LvDataList.Length);

		record.LVDataList[NEXT_CROP_TOTAL_CNT].szData="0";
		record.LVDataList[NEXT_CROP_PRICE].szData="0";
		record.LVDataList[NEXT_PROCURE_TYPE].szData="0";

		class'UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", i, record);
	}

	CalculateSumOfDefaultPrice();
}

function HandleSetToday()
{
	local int i;
	local int RecordCnt;
	local LVDataRecord record;
	local LVDataRecord recordClear;

	RecordCnt=m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();

	for(i=0; i<RecordCnt; ++i)
	{
		record = recordClear;
		m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i, record);

		record.LVDataList[NEXT_CROP_TOTAL_CNT].szData=record.LVDataList[TODAY_CROP_TOTOAL_CNT].szData;
		record.LVDataList[NEXT_CROP_PRICE].szData=record.LVDataList[TODAY_CROP_PRICE].szData;
		record.LVDataList[NEXT_PROCURE_TYPE].szData=record.LVDataList[TODAY_PROCURE_TYPE].szData;

		class'UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", i, record);
	}

	CalculateSumOfDefaultPrice();
}



function HandleShow(string a_Param)
{
	local int ManorID;
	local string ManorName;

	ParseInt(a_Param, "ManorID", ManorID);
	ParseString(a_Param, "ManorName", ManorName);

	m_ManorID=ManorID;

	class'UIAPI_TEXTBOX'.static.SetText("ManorCropInfoSettingWnd.txtManorName", ManorName);

	DeleteAll();
}


function DeleteAll()
{
	class'UIAPI_LISTCTRL'.static.DeleteAllItem("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl");
}

function OnDBClickListCtrlRecord( String strID )
{
	switch(strID)
	{
	case "ManorCropInfoSettingListCtrl" :
		OnChangeBtn();
		break;
	}
}

function OnClickButton(string strID)
{
	//debug(" "$strID);

	switch(strID)
	{
	case "btnChangeSell" :
		OnChangeBtn();
		break;
	case "btnSetToday" :
		DialogSetID(DIALOG_ID_SETTODAY);
		DialogShow(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(1601));
		break;
	case "btnStop" :
		DialogSetID(DIALOG_ID_STOP);
		DialogShow(DIALOG_Modalless, DIALOG_Warning, GetSystemMessage(1600));
		break;
	case "btnOk" :
		OnOk();
		HideWindow("ManorCropInfoSettingWnd");	
		break;
	case "btnCancel" :
		HideWindow("ManorCropInfoSettingWnd");
		break;
	}
}


function OnOk()
{
	local int RecordCount;
	local LVDataRecord record;
	local LVDataRecord recordClear;

	local int i;

	local string param;

	RecordCount=m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();

	ParamAdd(param, "ManorID", string(m_ManorID));
	ParamAdd(param, "CropCnt", string(RecordCount));

	// ���ڵ� ����ŭ ���鼭 �˻��ؼ� �ִ´�
	for(i=0; i<RecordCount; ++i)
	{
		record=recordClear;
		m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec(i, record);
	
		ParamAddINT64(param, "CropID"$i, record.nReserved1);
		ParamAdd(param, "BuyCnt"$i, record.LVDataList[NEXT_CROP_TOTAL_CNT].szData);
		ParamAdd(param, "Price"$i, record.LVDataList[NEXT_CROP_PRICE].szData);
		ParamAdd(param, "ProcureType"$i,record.LVDataList[NEXT_PROCURE_TYPE].szData);
	}

	RequestSetCrop(param);
}


function HandleAddItem(string a_Param)
{
	local LVDataRecord record;

	local int CropID;
	local string CropName;
	local INT64 TodayCropTotalCnt;
	local INT64 TodayCropPrice;
	local int TodayProcureType;
	local INT64 NextCropTotalCnt;
	local INT64 NextCropPrice;
	local int NextProcureType;
	local int MinCropPrice; 
	local int MaxCropPrice; 
	local int CropLevel;
	local string RewardType1;
	local string RewardType2;
	local int  MaxCropTotalCnt;
	local int  DefaultCropPrice;


	ParseInt(a_Param, "CropID", CropID);
	ParseString(a_Param, "CropName", CropName);
	ParseINT64(a_Param, "TodayCropTotalCnt", TodayCropTotalCnt);
	ParseINT64(a_Param, "TodayCropPrice", TodayCropPrice);
	ParseInt(a_Param, "TodayProcureType", TodayProcureType);
	ParseINT64(a_Param, "NextCropTotalCnt", NextCropTotalCnt);
	ParseINT64(a_Param, "NextCropPrice", NextCropPrice);
	ParseInt(a_Param, "NextProcureType", NextProcureType);
	ParseINT(a_Param, "MinCropPrice", MinCropPrice);
	ParseINT(a_Param, "MaxCropPrice", MaxCropPrice);
	ParseInt(a_Param, "CropLevel", CropLevel);
	ParseString(a_Param, "RewardType1", RewardType1);
	ParseString(a_Param, "RewardType2", RewardType2);

	ParseINT(a_Param, "MaxCropTotalCnt", MaxCropTotalCnt);
	ParseINT(a_Param, "DefaultCropPrice", DefaultCropPrice);


	record.LVDataList.Length=COLUMN_CNT;

	record.LVDataList[CROP_NAME].szData=CropName;
	record.LVDataList[TODAY_CROP_TOTOAL_CNT].szData=Int64ToString(TodayCropTotalCnt);
	record.LVDataList[TODAY_CROP_PRICE].szData=Int64ToString(TodayCropPrice);
	record.LVDataList[TODAY_PROCURE_TYPE].szData=string(TodayProcureType);
	record.LVDataList[NEXT_CROP_TOTAL_CNT].szData=Int64ToString(NextCropTotalCnt);
	record.LVDataList[NEXT_CROP_PRICE].szData=Int64ToString(NextCropPrice);
	record.LVDataList[NEXT_PROCURE_TYPE].szData=string(NextProcureType);
	record.LVDataList[MIN_CROP_PRICE].szData=string(MinCropPrice);
	record.LVDataList[MAX_CROP_PRICE].szData=string(MaxCropPrice);
	record.LVDataList[CROP_LELEL].szData=string(CropLevel);
	record.LVDataList[REWARD_TYPE_1].szData=RewardType1;
	record.LVDataList[REWARD_TYPE_2].szData=RewardType2;

	record.nReserved1=IntToInt64(CropID);
	record.nReserved2=IntToInt64(MaxCropTotalCnt);
	record.nReserved3=IntToInt64(DefaultCropPrice);

	class'UIAPI_LISTCTRL'.static.InsertRecord( "ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", record );
}


function CalculateSumOfDefaultPrice()
{
	local LVDataRecord record;
	local LVDataRecord recordClear;
	local int ItemCnt;
	local int i;
	local INT64 tmpMulti;

	local string AdenaString;

	m_SumOfDefaultPrice=IntToInt64(0);

	ItemCnt=m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRecordCount();

	for(i=0; i<ItemCnt; ++i)
	{
		record=recordClear;
		m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetRec( i, record );	

		tmpMulti=StringToInt64(record.LVDataList[NEXT_CROP_PRICE].szData)*StringToInt64(record.LVDataList[NEXT_CROP_TOTAL_CNT].szData);
		m_SumOfDefaultPrice+=tmpMulti;
	}

	AdenaString=MakeCostString(Int64ToString(m_SumOfDefaultPrice));
	class'UIAPI_TEXTBOX'.static.SetText("ManorCropInfoSettingWnd.txtVarNextTotalExpense", AdenaString);
}

function OnChangeBtn()
{
	local LVDataRecord record;
	local string param;

	m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetSelectedRec(record);

	ParamAdd(param, "CropName", record.LVDataList[CROP_NAME].szData);							// �۹��̸�
	ParamAdd(param, "TomorrowVolumeOfBuy", record.LVDataList[NEXT_CROP_TOTAL_CNT].szData);		// ���� ���ŷ�
	ParamAddINT64(param, "TomorrowLimit", record.nReserved2);								// ���� �����ѵ�
	ParamAdd(param, "TomorrowPrice", record.LVDataList[NEXT_CROP_PRICE].szData);				// ���� ���Ű���
	ParamAdd(param, "TomorrowProcure", record.LVDataList[NEXT_PROCURE_TYPE].szData);			// ���� ����Ÿ��
	ParamAdd(param, "MinCropPrice", record.LVDataList[MIN_CROP_PRICE].szData);					// �ּ��۹�����
	ParamAdd(param, "MaxCropPrice", record.LVDataList[MAX_CROP_PRICE].szData);					// �ִ��۹�����

	ExecuteEvent(EV_ManorCropInfoChangeWndShow, param);
}


function HandleChangeValue(string a_Param)
{
	local INT64 TomorrowAmountOfPurchase;
	local INT64 TomorrowPurchasePrice;
	local int TomorrowProcure;

	local LVDataRecord record;
	local int SelectedIndex;

	ParseINT64(a_Param, "TomorrowAmountOfPurchase", TomorrowAmountOfPurchase);
	ParseINT64(a_Param, "TomorrowPurchasePrice", TomorrowPurchasePrice);
	ParseInt(a_Param, "TomorrowProcure", TomorrowProcure);


	SelectedIndex=class'UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl");
	m_hManorCropInfoSettingWndManorCropInfoSettingListCtrl.GetSelectedRec(Record);

//	debug("�����ȷ��ڵ����ε���:"$SelectedIndex$", ����:"$record.LVDataList.Length);

 	record.LVDataList[NEXT_CROP_TOTAL_CNT].szData=Int64ToString(TomorrowAmountOfPurchase);
	record.LVDataList[NEXT_CROP_PRICE].szData=Int64ToString(TomorrowPurchasePrice);
	record.LVDataList[NEXT_PROCURE_TYPE].szData=string(TomorrowProcure);

	class'UIAPI_LISTCTRL'.static.ModifyRecord("ManorCropInfoSettingWnd.ManorCropInfoSettingListCtrl", SelectedIndex, record);

	CalculateSumOfDefaultPrice();
}

defaultproperties
{
    
}
