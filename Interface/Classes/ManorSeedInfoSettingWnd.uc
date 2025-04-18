class ManorSeedInfoSettingWnd extends UICommonAPI;

var int m_ManorID;
var INT64 m_SumOfDefaultPrice;


const SEED_NAME=0;
const TODAY_VOLUME_OF_SALES=1;
const TODAY_PRICE=2;
const TOMORROW_VOLUME_OF_SALES=3;
const TOMORROW_PRICE=4;

const MINIMUM_CROP_PRICE=5;
const MAXIMUM_CROP_PRICE=6;
const SEED_LEVEL=7;
const REWARD_TYPE_1=8;
const REWARD_TYPE_2=9;

const COLUMN_CNT=10;

const DIALOG_ID_STOP=555;
const DIALOG_ID_SETTODAY=666;

var string m_WindowName;
var ListCtrlHandle m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl;

function OnRegisterEvent()
{
	RegisterEvent( EV_ManorSeedInfoSettingWndShow );
	RegisterEvent( EV_ManorSeedInfoSettingWndAddItem );
	RegisterEvent( EV_ManorSeedInfoSettingWndAddItemEnd );

	RegisterEvent( EV_ManorSeedInfoSettingWndChangeValue );

	RegisterEvent( EV_DialogOK );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();
	m_WindowName="ManorSeedInfoSettingWnd";
	m_ManorID=-1;
	m_SumOfDefaultPrice=IntToInt64(0);

	m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl=GetListCtrlHandle(m_WindowName$".ManorSeedInfoSettingListCtrl");
}

function OnEvent( int Event_ID, string a_Param)
{
	switch( Event_ID )
	{
	case EV_ManorSeedInfoSettingWndShow :
		HandleShow(a_Param);
		break;

	case EV_ManorSeedInfoSettingWndAddItem :
		HandleAddItem(a_Param);
		break;
	case EV_ManorSeedInfoSettingWndAddItemEnd :
		CalculateSumOfDefaultPrice();
		ShowWindowWithFocus("ManorSeedInfoSettingWnd");
		break;
	case EV_ManorSeedInfoSettingWndChangeValue :
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

	RecordCnt=m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();


	//debug("ī��Ʈ:"$RecordCnt);
	for(i=0; i<RecordCnt; ++i)
	{
		record = recordClear;		// �̷��� ���������� ������ �ڲ� �þ��.
		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, record);
//		//debug("���ڵ��ε���:"$i$", ���ڵ����(��� 10�̾�� ����):"$record.LvDataList.Length);

		record.LVDataList[TOMORROW_VOLUME_OF_SALES].szData="0";
		record.LVDataList[TOMORROW_PRICE].szData="0";

		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.ModifyRecord(i, record);
	}

	CalculateSumOfDefaultPrice();
}

function HandleSetToday()
{
	local int i;
	local int RecordCnt;
	local LVDataRecord record;
	local LVDataRecord recordClear;

	RecordCnt=m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();

	for(i=0; i<RecordCnt; ++i)
	{
		record = recordClear;
		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, record);

		record.LVDataList[TOMORROW_VOLUME_OF_SALES].szData=record.LVDataList[TODAY_VOLUME_OF_SALES].szData;
		record.LVDataList[TOMORROW_PRICE].szData=record.LVDataList[TODAY_PRICE].szData;

		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.ModifyRecord(i, record);
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

	class'UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoSettingWnd.txtManorName", ManorName);

	DeleteAll();
}

function HandleChangeValue(string a_Param)
{
	local INT64 TomorrowSalesVolume;
	local INT64 TomorrowPrice;

	local LVDataRecord record;
	local int SelectedIndex;

	ParseINT64(a_Param, "TomorrowSalesVolume", TomorrowSalesVolume);
	ParseINT64(a_Param, "TomorrowPrice", TomorrowPrice);

	SelectedIndex=class'UIAPI_LISTCTRL'.static.GetSelectedIndex("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl");
	m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetSelectedRec(Record);

//	debug("�����ȷ��ڵ����ε���:"$SelectedIndex$", ����:"$record.LVDataList.Length);
	
	record.LVDataList[TOMORROW_VOLUME_OF_SALES].szData=Int64ToString(TomorrowSalesVolume);
	record.LVDataList[TOMORROW_PRICE].szData=Int64ToString(TomorrowPrice);

	class'UIAPI_LISTCTRL'.static.ModifyRecord("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl", SelectedIndex, record);

	CalculateSumOfDefaultPrice();
}



function DeleteAll()
{
	class'UIAPI_LISTCTRL'.static.DeleteAllItem("ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl");
}

function OnDBClickListCtrlRecord( String strID )
{
	switch(strID)
	{
	case "ManorSeedInfoSettingListCtrl" :
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
		break;
	case "btnCancel" :
		HideWindow("ManorSeedInfoSettingWnd");
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


	RecordCount=m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();

	ParamAdd(param, "ManorID", string(m_ManorID));
	ParamAdd(param, "SeedCnt", string(RecordCount));

	// ���ڵ� ����ŭ ���鼭 �˻��ؼ� �ִ´�
	for(i=0; i<RecordCount; ++i)
	{
		record=recordClear;
		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, record);
	
		ParamAddINT64(param, "SeedID"$i, record.nReserved1);
		ParamAdd(param, "TomorrowSalesVolume"$i, record.LVDataList[TOMORROW_VOLUME_OF_SALES].szData);
		ParamAdd(param, "TomorrowPrice"$i,record.LVDataList[TOMORROW_PRICE].szData);
	}

	RequestSetSeed(param);

	HideWindow("ManorSeedInfoSettingWnd");
}

function OnChangeBtn()
{
	local LVDataRecord record;
	local string param;

	m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetSelectedRec(Record);

	ParamAdd(param, "SeedName", record.LVDataList[SEED_NAME].szData);								// �����̸�
	ParamAdd(param, "TomorrowVolumeOfSales", record.LVDataList[TOMORROW_VOLUME_OF_SALES].szData);	// ���� �Ǹŷ�
	ParamAddINT64(param, "TomorrowLimit", record.nReserved2);									// ���� �߸��ѵ�
	ParamAdd(param, "TomorrowPrice", record.LVDataList[TOMORROW_PRICE].szData);						// ���� ����

	ParamAdd(param, "MinCropPrice", record.LVDataList[MINIMUM_CROP_PRICE].szData);					// �ּ��۹�����
	ParamAdd(param, "MaxCropPrice", record.LVDataList[MAXIMUM_CROP_PRICE].szData);					// �ִ��۹�����

	ExecuteEvent(EV_ManorSeedInfoChangeWndShow, param);
}



function HandleAddItem(string a_Param)
{
	local LVDataRecord record;

	local int SeedID;
	local string SeedName;
	local int TodaySeedTotalCnt;
	local INT64 TodaySeedPrice;
	local INT64 NextSeedTotalCnt;
	local INT64 NextSeedPrice;
	local int MinCropPrice;
	local int MaxCropPrice;
	local int SeedLevel;
	local string RewardType1;
	local string RewardType2;
	local INT64 MaxSeedTotalCnt;
	local int DefaultSeedPrice;

	ParseInt(a_Param, "SeedID", SeedID);
	ParseString(a_Param, "SeedName", SeedName);
	ParseINT(a_Param, "TodaySeedTotalCnt", TodaySeedTotalCnt);
	ParseINT64(a_Param, "TodaySeedPrice", TodaySeedPrice);
	ParseINT64(a_Param, "TodayNextSeedTotalCnt", NextSeedTotalCnt);
	ParseINT64(a_Param, "NextSeedPrice", NextSeedPrice);
	ParseINT(a_Param, "MinCropPrice", MinCropPrice);
	ParseINT(a_Param, "MaxCropPrice", MaxCropPrice);
	ParseInt(a_Param, "SeedLevel", SeedLevel);
	ParseString(a_Param, "RewardType1", RewardType1);
	ParseString(a_Param, "RewardType2", RewardType2);
	ParseINT64(a_Param, "MaxSeedTotalCnt", MaxSeedTotalCnt);
	ParseINT(a_Param, "DefaultSeedPrice", DefaultSeedPrice);


	record.LVDataList.Length=COLUMN_CNT;

	record.LVDataList[SEED_NAME].szData=SeedName;										// �����̸�
	record.LVDataList[TODAY_VOLUME_OF_SALES].szData=string(TodaySeedTotalCnt);			// ���� �Ǹŷ�
	record.LVDataList[TODAY_PRICE].szData=Int64ToString(TodaySeedPrice);						// ���� ����
	record.LVDataList[TOMORROW_VOLUME_OF_SALES].szData=Int64ToString(NextSeedTotalCnt);		// ���� �Ǹŷ�
	record.LVDataList[TOMORROW_PRICE].szData=Int64ToString(NextSeedPrice);						// ���� ����

	record.LVDataList[MINIMUM_CROP_PRICE].szData=string(MinCropPrice);					
	record.LVDataList[MAXIMUM_CROP_PRICE].szData=string(MaxCropPrice);
	record.LVDataList[SEED_LEVEL].szData=string(SeedLevel);
	record.LVDataList[REWARD_TYPE_1].szData=RewardType1;
	record.LVDataList[REWARD_TYPE_2].szData=RewardType2;

	record.nReserved1=IntToInt64(SeedID);
	record.nReserved2=MaxSeedTotalCnt;
	record.nReserved3=IntToInt64(DefaultSeedPrice);

	class'UIAPI_LISTCTRL'.static.InsertRecord( "ManorSeedInfoSettingWnd.ManorSeedInfoSettingListCtrl", record );
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

	ItemCnt=m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRecordCount();

	for(i=0; i<ItemCnt; ++i)
	{
		record=recordClear;
		m_hManorSeedInfoSettingWndManorSeedInfoSettingListCtrl.GetRec(i, record);	

		tmpMulti=record.nReserved3*StringToInt64(record.LVDataList[TOMORROW_VOLUME_OF_SALES].szData);
		m_SumOfDefaultPrice+=tmpMulti;
	}

	AdenaString=MakeCostString(Int64ToString(m_SumOfDefaultPrice));
	class'UIAPI_TEXTBOX'.static.SetText("ManorSeedInfoSettingWnd.txtVarNextTotalExpense", AdenaString);
}

defaultproperties
{
    
}
