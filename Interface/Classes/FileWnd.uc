class FileWnd extends UICommonAPI;
var bool m_bShow;
var WindowHandle Me;
var ListCtrlHandle FileListCtrl;
var EditBoxHandle EditBoxCtrl;
var ComboBoxHandle FilePathComboBoxCtrl;
var ComboBoxHandle FileExtComboBoxCtrl;
var string m_filePath;
var string FileTextureName, FolderTextureName;
var _FileHandler FileHandler;
var bool IsIdle;
var array<string> LastPath;
var string m_fileName;
//////////////////////////////////////////////////////////////////////// jdh84 /////////////////
//                             fileWnd�� ����.
//
// 1. filewnd�� XXX���� ��Ͽ� ����ϰ�ʹ�.
// 2. UICommonAPI�� _FileHandler �� ���ο� ENUM(TYPE) ���� �߰��Ѵ�.
// 3. ������ ��Ͻ�Ű�� API�� �ۼ��Ѵ�.
// 4. UploadFile�Լ��� �� ���� �ڵ鷯�� �´� API�� ����Ѵ�.
// 5-1. AddFileWndFileExt �Լ��� ClearFileWndFileExt �Լ��� ����� Ȯ���� �ڽ��� �����Ѵ�
// 5-2. FileWndShow(2������ ������ Ÿ��)�Լ��� ȣ���Ͽ� Ȱ��ȭ�Ѵ�  
////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
function ShowFileWnd(_FileHandler filehandlertype) //UICommanAPI �� ����ϱ� ���� Filewnd �� ĸ��ȭ
{
	if(m_bShow) 
	{
		return; //�̹� �ٸ� ���� ����â�� ���ִ�. �ǵ���� �־� �ݽô�
	}
	
	FileHandler = filehandlertype;
	
	switch(FileHandler)
	{
		case FH_PLEDGE_CREST_UPLOAD:
			Me.SetWindowTitle("CREST UPLOAD"); 			
			break;
		case FH_PLEDGE_EMBLEM_UPLOAD:
			Me.SetWindowTitle("EMBLEM UPLOAD"); 
			break;
		default:
			Me.SetWindowTitle("File Registeration"); 
			break;
	}
	Me.ShowWindow();
	Me.SetFocus();
}

function HideFileWnd() //UICommanAPI �� ����ϱ� ���� Filewnd �� ĸ��ȭ
{
	Me.HideWindow();
}

function AddFileExt(string str, array<string> strArray) //UICommanAPI �� ����ϱ� ���� Filewnd �� ĸ��ȭ
{
	FileExtComboBoxCtrl.AddStringWithFileExt(str,strArray);	
}

function ClearFileExt() //UICommanAPI �� ����ϱ� ���� Filewnd �� ĸ��ȭ
{
	FileExtComboBoxCtrl.Clear();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////





////////////////////////////////////////////////////////////////////////////////////////////////////
function bool UploadFile(string filePath, string fileName) 
{
	local string filestr;
	filestr = filePath $ "\\" $ fileName;
	if(FileHandler >= FH_MAX) return true;
	LastPath[FileHandler] = filePath; //������ ��ϰ�θ� ����
	UploadFileFullPath(filestr);
}

function bool UploadFileFullPath(string path)
{
	debug(path);
	if(FileHandler >= FH_MAX) return true;
	
	switch(FileHandler)
	{
		case FH_NONE:
			return true;
		case FH_PLEDGE_CREST_UPLOAD:
			return RequestClanRegisterCrestByFilePath(path); //���͹��� ���
		case FH_PLEDGE_EMBLEM_UPLOAD:
			return RequestClanRegisterEmblemByFilePath(path); //���͹��� ���
		default:
			return true;
	}
}

function OnLoad()
{
	// hard coding
	local array<string> strArray;
	local int i;

	LastPath.Length = _FileHandler.FH_MAX;
	for(i = 0; i < _FileHandler.FH_MAX; i++)
	{
		LastPath[i] = "C:"; //���� ��� ����
	}

	IsIdle = true; //ó������ idle ����(�ΰ��̻��� ���������츦 �������� �ʵ���)
	FileHandler = FH_NONE; //�ʱ���´� ���� �ڵ鷯�� ����
	FileTextureName = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon"; //������ �ؽ���
	FolderTextureName = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff"; //������ �ؽ���

	if(CREATE_ON_DEMAND==0)
	{
	}
	else
	{
		Me = GetWindowHandle( "FileWnd" );
		FileListCtrl = GetListCtrlHandle("FileWnd.FLWListCtrl");
		FileListCtrl.SetHeaderAlignment(0,TA_LEFT);
		EditBoxCtrl = GetEditBoxHandle("FileWnd.FLWEditBox");
		FilePathComboBoxCtrl = GetComboBoxHandle("FileWnd.FLWComboBox");
		FileExtComboBoxCtrl = GetComboBoxHandle("FileWnd.FLWFTypeComboBox");
		
		strArray.Length = 1;
		strArray[0] = "*";
		FileExtComboBoxCtrl.AddStringWithFileExt("��� ����", strArray);
		SetFilePathnAdjustControl("C:");
	}
	m_bShow = false;
}

function SetFilePathnAdjustControl( string s )
{
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;

	EditBoxCtrl.Clear();
	UpdateFilePathComboBox(s);
	
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	fInfoArray = GetFilesInfoList(m_filePath,fExtArray);
	EnumerateFile(fInfoArray);
}

function int SearchFileListWithName(string s)
{
	local int i, num;
	local LVDataRecord record;
	num = FileListCtrl.GetRecordCount();

	for ( i = 0; i < num; ++i )
	{
		FileListCtrl.GetRec(i,record);
		if ( record.LVDataList[0].szData == s )
			return i;
	}
	return -1;
}

function OnCompleteEditBox( String strID )
{
	local LVDataRecord record;
	local int idx;
	local string strEdit, filePath;

	if ( strID != "FLWEditBox" )
		return;

	strEdit = EditBoxCtrl.GetString();
	idx = SearchFileListWithName(strEdit);
	
	if ( idx < 0 )  //����Ʈ�ڽ��� ���ϸ��� �� ���丮�� ���ٸ� Full path�� ��������
	{
		UploadFileFullPath(strEdit);
		EditBoxCtrl.Clear();
		return;
	}

	FileListCtrl.GetRec(idx, record);

	m_fileName = record.LVDataList[0].szData;

	if ( record.nReserved1 == IntToInt64(1) ) //check
	{
		if ( UploadFile(m_filePath, m_fileName))
			Me.HideWindow();
		else
			;
	}
	else
		SetFilePathnAdjustControl(filePath);
}

function OnDBClickListCtrlRecord( String strID )
{
	local int Idx;
	local LVDataRecord record;
	local string str;
	if ( strID != "FLWListCtrl" )
		return;
	
	Idx = FileListCtrl.GetSelectedIndex();
	if( Idx < 0 )
		return;
		
	FileListCtrl.GetRec( Idx, record );
	str = record.LVDataList[0].szData;		
	
	if ( record.nReserved1 == IntToInt64(0) )		// case of directory
	{
		str = m_filePath $ str;
		SetFilePathnAdjustControl(str);
	}
	else
	{
		m_fileName = record.LVDataList[0].szData;
		if ( UploadFile(m_filePath, m_fileName))
			Me.HideWindow();
		else
			;
	}
}
function UpdateFilePathComboBox(String str)
{
	local int idx, i, j, k;
	local bool bComp;
	local string remainStr;
	local array<DriveInfo> arrDrvInfo;
	
	if ( Len(str) <= 0 ) return;

	FilePathComboBoxCtrl.Clear();
	m_filePath = str;
	k = -1;
	bComp = false;
	
	arrDrvInfo = GetDrivesInfoList();

	for ( j = 0; j < arrDrvInfo.Length; ++j )
	{
		if ( Left(arrDrvInfo[j].driveChar,1) != Left(m_filePath,1) )
		{
			FilePathComboBoxCtrl.AddString(Left(arrDrvInfo[j].driveChar,1) $ ":" );
			if ( !bComp ) ++k;
		}
		else
		{
			remainStr = str;

			idx = InStr(remainStr,"\\");
			if ( idx < 0 ) idx = Len(remainStr);

			str = Left(remainStr, idx);
			remainStr = Right(remainStr, Len(remainStr)-idx );
			FilePathComboBoxCtrl.AddStringWithGap(str,0);
			++k;
			i = 1;

			while (	Len(remainStr) > 0 )
			{
				remainStr = Right(remainStr,Len(remainStr)-1);
				idx = InStr( remainStr, "\\");
				if ( idx < 0 ) idx = Len(remainStr);
				str = Left(remainStr, idx);
				remainStr = Right(remainStr, Len(remainStr)-idx );

				str = "\\" $ str;

				FilePathComboBoxCtrl.AddStringWithGap(str,i);
				++i; ++k;
			}
			bComp = true;
		}
	}

	FilePathComboBoxCtrl.SetSelectedNum(k); // necessary for modifying
}

function OnClickListCtrlRecord( String strID )
{
	local int Idx;
	local LVDataRecord record;
	
	if( strID != "FLWListCtrl" )
		return;

	Idx = FileListCtrl.GetSelectedIndex();
	if( Idx < 0 )
		return;
		
	FileListCtrl.GetRec( Idx, record );
	EditBoxCtrl.SetString(record.LVDataList[0].szData);
}

function EnumerateFile( array<FileNameInfo> FList )
{
	local int k;
	local LVData Data;
	local LVDataRecord Record;
	FileListCtrl.DeleteAllItem();

	Record.LVDataList.Length = 1;

	for (k = 0; k < FList.Length; k++)
	{
		Data.szData = FList[k].fileName;
				
		Record.LVDataList[0].hasIcon = true;
		if(FList[k].bIsFile)
			Record.LVDataList[0].szTexture = FileTextureName;
		else
			Record.LVDataList[0].szTexture = FolderTextureName;
		
		Record.LVDataList[0].nTextureWidth = 14;
		Record.LVDataList[0].nTextureHeight = 14;
		Record.LVDataList[0].szData = FList[k].fileName;
		
		
		Record.nReserved1 = BoolToInt64( FList[k].bIsFile );
		FileListCtrl.InsertRecord(Record);
	}
	FileListCtrl.AdjustColumnWidth(0,296);
}

// function SortArray(array<FileNameInfo> FList)
// {
// 	local int i;
// 	local int j;
// 	local FileNameInfo temp;
// 	for(i = 0; i < FList.Length; i++)
// 	{
// 		for(j = 0; j < FList.Length; j++)
// 			{
// 				if(IsGreater(FList[i], FList[j], 1))
// 				{
// 					temp = FList[i];
// 					FList[i] = Flist[j];
// 					FList[j] = temp;
// 				}
// 			}	
// 	}
// 	for(i = 0; i < FList.Length; i++)
// 	{
// 		debug(FList[i].fileName);
// 	}
// }
// 
// function bool IsGreater(FileNameInfo a, FileNameInfo b,int SortingScheme) //0 : �������� else: ��������
// {
// 	local bool m_result;
// 	if(!a.bIsFile && b.bIsFile) m_result = true; //a�� ���丮
// 	else if(a.bIsFile && !b.bIsFile) m_result = false; //b�����丮
// 	else
// 	{
// 		if(a.fileName > b.fileName) m_result = true;
// 		else m_result = false;
// 	}
// 	if(SortingScheme == 0)
// 		m_result = !m_result; //��������
// 	return m_result;
// }

function OnShow()
{
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;

	EditBoxCtrl.Clear();
	FileListCtrl.InitListCtrl();
	FileExtComboBoxCtrl.SetSelectedNum(0);
	fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
	
	m_filePath = LastPath[FileHandler];
	fInfoArray = GetFilesInfoList(LastPath[FileHandler],fExtArray);
	EnumerateFile(fInfoArray);

	m_bShow = true;
}

function OnHide()
{
	m_bShow = false;
}

function OnComboBoxItemSelected( String strID, int index )
{
	local string str;
	local int i, s, e;
	local array<FileNameInfo> fInfoArray;
	local array<string> fExtArray;
	if ( index < 0 ) return;

	if (strID == "FLWComboBox" )
	{
		s = getIndexOfCurrentDrive();
		e = getIndexOfCurrentFolder();
		if ( index >= s && index <= e)
		{
			for ( i = s; i <= index; ++i )
				str = str $ FilePathComboBoxCtrl.GetString(i);
		}
		else
			str = FilePathComboBoxCtrl.GetString(index);

		SetFilePathnAdjustControl(str);
	}
	else if ( strID == "FLWFTypeComboBox" )
	{
		fExtArray = FileExtComboBoxCtrl.GetFileExtInfo(FileExtComboBoxCtrl.GetSelectedNum());
		fInfoArray = GetFilesInfoList(m_filePath,fExtArray);
		EnumerateFile(fInfoArray);
	}
}

function int getIndexOfCurrentDrive()
{
	local int idx, num;
	local string rootDrive;
	idx = InStr(m_filePath,"\\");

	if ( idx >= 0 )
		rootDrive = Left(m_filePath,idx);
	else
		rootDrive = m_filePath;

	num = FilePathComboBoxCtrl.GetNumOfItems();
	for ( idx = 0; idx < num; ++idx )
		if ( rootDrive == FilePathComboBoxCtrl.GetString(idx) )
			return idx;

	return -1;
}

function int getIndexOfCurrentFolder()
{
	local int s, i;
	local string str;
	str = m_filePath;

	for ( s = getIndexOfCurrentDrive(); InStr(str,"\\") >= 0; ++s )
	{
		i = InStr(str,"\\");
		str=Right(str,Len(str) - i - 1);
		if ( Len(str) <= 0 ) break;
	}

	return s;
}

function OnClickButton( string strID )
{
	local string editStr, filePath;
	local int index;
	local LVDataRecord record;

	switch( strID )
	{
	case "FLWButtonOK" :
		
		editStr = EditBoxCtrl.GetString();
		index = SearchFileListWithName(editStr);
		if ( index < 0 )
		{
			EditBoxCtrl.Clear();
			break;
		}
		FileListCtrl.GetRec(index, record);

		if ( record.nReserved1 == IntToInt64(1) )
		{
			m_fileName = record.LVDataList[0].szData;
			if ( UploadFile(m_filePath, m_fileName) )
				Me.HideWindow();
			else
				;
		}
		else
		{
			filePath = m_filePath $ record.LVDataList[0].szData;
			SetFilePathnAdjustControl(filePath);
		}
		break;
	case "FLWButtonCancel":
		Me.HideWindow();
		break;
	case "FLWButtonUp":
		index = InStrFromBack(m_filePath,"\\");
		if ( index >= 0 )
		{
			editStr = Left(m_filePath,index);
			SetFilePathnAdjustControl(editStr);
		}
		break;
	}
}
defaultproperties
{
}
