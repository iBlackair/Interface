/**
*����Ʈ��Ʈ�ѿ� ���� �Լ��� �����Ѵ�
*/
class ListCtrlHandle extends WindowHandle
	native;

/**
*���ڵ带 �����Ѵ�

* @param
*Record : ������ ���ڵ�

* @return
*void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*var LVDataRecord newrec;
*newrec.LVDataList.length = 5; //�ϳ��� ���ڵ忡 ��� �����ͷ� �̷�����ֳ�. �̸� ��������Ѵ�
*newrec.LVDataList[0].szData = "hi";
*newrec.LVDataList[1].szData = "mam";
*newrec.LVDataList[2].szData = "what's";
*newrec.LVDataList[3].szData = "up";
*newrec.LVDataList[4].szData = "?";
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*l_handle.InsertRecord(newrec); //���ο� ���ڵ带 �����Ѵ�.

*struct native constructive LVDataRecord
*{	
*	var array<LVData> LVDataList;
*	var string szReserved;
*	var INT64 nReserved1;
*	var INT64 nReserved2;
*	var INT64 nReserved3;
*};

*struct native constructive LVData
*{
*	var string szData;
*	var string szReserved;

*	var bool bUseTextColor;
*	var Color TextColor;

*	var int nReserved1;
*	var int nReserved2;
*	var int nReserved3;
	
*	//Main Texture(�ؽ��� �ϳ��� �����Ҷ�, Centeralign�ȴ�)
*	var string szTexture;
*	var int nTextureWidth;
*	var int nTextureHeight;
	
*	//Texture Array
*	var array<LVTexture> arrTexture;
*};
*/
native final function InsertRecord(LVDataRecord Record);

/**
*��� ���ڵ带 �����Ѵ�

* @param
*Record : ������ ���ڵ�

* @return
*void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*l_handle.DeleteAllItem();
*/
native final function DeleteAllItem();

/**
*Ư�� ���ڵ带 �����Ѵ�

* @param
*index : ������ ���ڵ��� �ε���

* @return
*void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*l_handle.DeleteRecord(0); //���� ���� ���ڵ带 �����
*/
native final function DeleteRecord(int index);

/**
*���ڵ��� ���� �����Ѵ�.

* @param
* void

* @return
* int : ���ڵ��� ��

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*var int recnum;
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*recnum = l_handle.GetRecordCount(); //���ڵ��� ���� ����
*/
native final function int GetRecordCount();

/**
*���õ� ���ڵ��� �ε����� �����Ѵ�.(�ƹ��͵� ���þ��������� -1)

* @param
* void

* @return
* int : ���õ� ���ڵ��� �ε��� (�ƹ��͵� ���þ��������� -1)

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*var int recindex;
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*recindex = l_handle.GetSelectedIndex(); //���õ� ���ڵ��� �ε����� ����
*/
native final function int GetSelectedIndex();

/**
*������ �ε����� ���ڵ带 �����Ѵ�.

* @param
* index : ������ ���ڵ��� �ε���
* bMoveToRow : true�� ���ڵ�� �̵�, false�� �̵�����

* @return
* void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*l_handle.SetSelectedIndex(0,true); //ù���ڵ带 �����ϰ� ���ڵ�� �̵��Ѵ�
*/
native final function SetSelectedIndex( int index, bool bMoveToRow);

/**
*��ũ�ѹٸ� ���̰� �ϰų� �Ⱥ��̰��Ѵ�

* @param
* bShow : true�� ���� false�� �Ⱥ���

* @return
* void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*l_handle.ShowScrollBar(false); ��ũ�ѹٸ� �Ⱥ��̰� �Ѵ�
*/
native final function ShowScrollBar( bool bShow);

/**
*������ �ε����� ���ڵ带 �����Ѵ�.

* @param
* index : ������ ���ڵ��� �ε���
* Record : ���� �� ���ڵ�

* @return
* void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*var LVDataRecord rec;
*rec.LVDataList.length = 5; //�ϳ��� ���ڵ忡 ��� �����ͷ� �̷�����ֳ�. �̸� ��������Ѵ�
*newrec.LVDataList[0].szData = "hi";
*newrec.LVDataList[1].szData = "mam";
*newrec.LVDataList[2].szData = "what's";
*newrec.LVDataList[3].szData = "up";
*newrec.LVDataList[4].szData = "?";
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*l_handle.ModifyRecord(0,newrec); //ù ���ڵ带 newrec�� ��ü�Ѵ�

*struct native constructive LVDataRecord
*{	
*	var array<LVData> LVDataList;
*	var string szReserved;
*	var INT64 nReserved1;
*	var INT64 nReserved2;
*	var INT64 nReserved3;
*};

*struct native constructive LVData
*{
*	var string szData;
*	var string szReserved;

*	var bool bUseTextColor;
*	var Color TextColor;

*	var int nReserved1;
*	var int nReserved2;
*	var int nReserved3;
	
*	//Main Texture(�ؽ��� �ϳ��� �����Ҷ�, Centeralign�ȴ�)
*	var string szTexture;
*	var int nTextureWidth;
*	var int nTextureHeight;
	
*	//Texture Array
*	var array<LVTexture> arrTexture;
*};
*/
native final function bool ModifyRecord(int index, LVDataRecord Record);

/**
*���õ� �ε����� ���ڵ带 �����´�

* @param
* record : ���ڵ带 ������ ����

* @return
* void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*var LVDataRecord rec;
*rec.LVDataList.length = 5; //�ϳ��� ���ڵ忡 ��� �����ͷ� �̷�����ֳ�. �̸� ��������Ѵ�
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*GetSelectedRec(rec); // ���õ� ���ڵ带 rec�� �����´�. ���õȰ� ���ٸ� none

*struct native constructive LVDataRecord
*{	
*	var array<LVData> LVDataList;
*	var string szReserved;
*	var INT64 nReserved1;
*	var INT64 nReserved2;
*	var INT64 nReserved3;
*};

*struct native constructive LVData
*{
*	var string szData;
*	var string szReserved;

*	var bool bUseTextColor;
*	var Color TextColor;

*	var int nReserved1;
*	var int nReserved2;
*	var int nReserved3;
	
*	//Main Texture(�ؽ��� �ϳ��� �����Ҷ�, Centeralign�ȴ�)
*	var string szTexture;
*	var int nTextureWidth;
*	var int nTextureHeight;
	
*	//Texture Array
*	var array<LVTexture> arrTexture;
*};
*/
native final function GetSelectedRec(out LVDataRecord record);

/**
*������ �ε����� ���ڵ带 �����´�

* @param
* index : ������ �ε���
* record : ���ڵ带 ������ ����

* @return
* void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*var LVDataRecord rec;
*rec.LVDataList.length = 5; //�ϳ��� ���ڵ忡 ��� �����ͷ� �̷�����ֳ�. �̸� ��������Ѵ�
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*GetRec(0,rec); // ù ���ڵ带 rec�� �����´�. 

*struct native constructive LVDataRecord
*{	
*	var array<LVData> LVDataList;
*	var string szReserved;
*	var INT64 nReserved1;
*	var INT64 nReserved2;
*	var INT64 nReserved3;
*};

*struct native constructive LVData
*{
*	var string szData;
*	var string szReserved;

*	var bool bUseTextColor;
*	var Color TextColor;

*	var int nReserved1;
*	var int nReserved2;
*	var int nReserved3;
	
*	//Main Texture(�ؽ��� �ϳ��� �����Ҷ�, Centeralign�ȴ�)
*	var string szTexture;
*	var int nTextureWidth;
*	var int nTextureHeight;
	
*	//Texture Array
*	var array<LVTexture> arrTexture;
*};
*/
native final function GetRec( int index, out LVDataRecord record );

/**
*����Ʈ��Ʈ���� �ʱ�ȭ�Ѵ�. ������� ȣ��������

* @param
* void

* @return
* void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*var LVDataRecord rec;
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*L_handle.InitListCtrl(); // �ʱ�ȭ�Ѵ�
*/
native final function InitListCtrl();

/**
*����Ʈ��Ʈ���� ������ ���� ���̸� �����ۿ� ���缭 �ڵ������Ѵ�. (�ּҰ��� �����Ҽ� �ִ�. ���̻� �۾����� �ʴ´�)

* @param
* col : ������ ��
* minWidth : ������ �ּҰ�

* @return
* void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*var LVDataRecord rec;
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*L_handle.AdjustColumnWidth(0,100); //0���� ���̸� �����Ѵ�. �ּҰ� 100�ȼ�
*/
native final function AdjustColumnWidth(int col, int minWidth);

/**
*����Ʈ��Ʈ���� ������ ���� ����� �ؽ�Ʈ ������ �����Ѵ�

* @param
* col : ������ ��
* align : ���� (TA_LEFT, TA_CENTER, TA_RIGHT)

* @return
* void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*var LVDataRecord rec;
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*L_handle.SetHeaderAlignment(0,TA_LEFT); //0���� ����� �ؽ�Ʈ�� ���� �����Ѵ�.
*/
native final function SetHeaderAlignment(int col, ETextAlign align);

/**
*����Ʈ��Ʈ���� ����� �ؽ�Ʈ �տ� �������� �ش�

* @param
* col : ������ ��
* align : ���� (TA_LEFT, TA_CENTER, TA_RIGHT)

* @return
* void

* @example
*var ListCtrlHandle l_handle; //������ �ڵ� ����
*var LVDataRecord rec;
*l_handle = GetListCtrlHandle( "PartyMatchWnd.UnionMatchListCtrl" );
*L_handle.SetHeaderAlignment(0,TA_LEFT); //0���� ����� �ؽ�Ʈ�� ���� �����Ѵ�.
*/
native final function SetHeaderTextOffset(int col, int offset);

native final function SetResizable(bool b);
defaultproperties
{
}
