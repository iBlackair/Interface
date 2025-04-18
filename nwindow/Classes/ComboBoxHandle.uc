/**
*�޺��ڽ��� ���� �Լ��� �����Ѵ�
*/
class ComboBoxHandle extends WindowHandle
	native;



/**
* �޺��ڽ��� ��Ʈ���� �߰��Ѵ�

* @param
* str : �߰��� ��Ʈ��

* @return
* void

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.AddString("new item"); //���ο� ��Ʈ���� �߰��Ѵ�.
*/
native final function AddString(string str);

/**
* �޺��ڽ��� ��Ʈ���� �߰��ϵ� �տ� ���� �д�

* @param
* str : �߰��� ��Ʈ��
* gap_mode : ��, ��1�� 4ĭ�� ���ʿ� �������

* @return
* void

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.AddStringWithGap("new item",1); //���ο� ��Ʈ���� �߰��Ѵ�. ���� ��ĭ����
*/
native final function AddStringWithGap(string str, optional int gap_mode);

/**
* �޺��ڽ��� �ý��� ��Ʈ���� �߰��Ѵ�

* @param
* index : �߰��� �ý��۽�Ʈ���� ��ȣ

* @return
* void

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.SYS_AddString(0); //��ĭ�� �߰��Ǿ���
*c_handle.SYS_AddString(1); //"�κ��丮"�� �߰��Ǿ���
*c_handle.SYS_AddString(2); //"������"�� �߰��Ǿ���
*c_handle.SYS_AddString(3); //"�����Ѱ�"�� �߰��Ǿ���
*c_handle.SYS_AddString(4); //"û��"�� �߰��Ǿ���
*c_handle.SYS_AddString(5); //"ö"�� �߰��Ǿ���
*c_handle.SYS_AddString(6); //"����"�� �߰��Ǿ���
*c_handle.SYS_AddString(7); //"��"�� �߰��Ǿ��� //���ٽ��� ��ǹ������� �˱��������
*/
native final function SYS_AddString(int index);

/**
* �޺��ڽ��� ��Ʈ���� �߰��԰� ���ÿ� �� ��Ʈ���� �߰�������(int��)�� �����س��´�

* @param
* str : �߰��� ��Ʈ��
* reserved : �����ҵ�����

* @return
* void

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*var int c_reserved;
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.Clear();//��� �����
*c_handle.AddStringWithReserved("has100", 100); // "has100"�̶�� ��Ʈ���� �߰��Ǿ��� 100�̶�� �����͸� �����Ѵ�
*c_handle.AddStringWithReserved("has1000", 1000); // "has100"�̶�� ��Ʈ���� �߰��Ǿ��� 1000�̶�� �����͸� �����Ѵ�
*c_reserved = c_handle.GetReserved(0); // 100 �������´�
*c_reserved = c_handle.GetReserved(1); // 1000 �������´�
*/
native final function AddStringWithReserved(string str,int reserved);

/**
* �޺��ڽ��� �ý��� ��Ʈ���� �߰��԰� ���ÿ� �� ��Ʈ���� �߰�������(int��)�� �����س��´�

* @param
* index : �߰��� �ý��۽�Ʈ���� ��ȣ
* reserved : �����ҵ�����

* @return
* void

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*var int c_reserved;
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.Clear();//��� �����
*c_handle.SYS_AddStringWithReserved(1, 100); // "�κ��丮"�̶�� ��Ʈ���� �߰��Ǿ��� 100�̶�� �����͸� �����Ѵ�
*c_handle.SYS_AddStringWithReserved(2, 1000); // "������"�̶�� ��Ʈ���� �߰��Ǿ��� 1000�̶�� �����͸� �����Ѵ�
*c_reserved = c_handle.GetReserved(0); // 100 �������´�
*c_reserved = c_handle.GetReserved(1); // 1000 �������´�
*/
native final function SYS_AddStringWithReserved(int index,int reserved);

/**
* �޺��ڽ��� ������ �ε����� ��Ʈ���� �����´�

* @param
* num : ������ �ε���

* @return
* string : ������ �ε����� ��Ʈ��

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*debug(c_handle.GetString(0)); // ���� ���� ��Ʈ���� ����Ѵ�
*/
native final function string GetString(int num);

/**
* ��Ʈ���� ������ �ξ��� reserved �����͸� ��ȯ�Ѵ�.

* @param
* num : �����͸� ������ �ε���

* @return
* int : ������ �ξ��� reserved ������

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*var int c_reserved;
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.Clear();//��� �����
*c_handle.AddStringWithReserved("has100", 100); // "has100"�̶�� ��Ʈ���� �߰��Ǿ��� 100�̶�� �����͸� �����Ѵ�
*c_handle.AddStringWithReserved("has1000", 1000); // "has100"�̶�� ��Ʈ���� �߰��Ǿ��� 1000�̶�� �����͸� �����Ѵ�
*c_reserved = c_handle.GetReserved(0); // 100 �������´�
*c_reserved = c_handle.GetReserved(1); // 1000 �������´�
*/
native final function int GetReserved(int num);

/**
* ���õ� �������� �ε����� �����Ѵ�

* @param
* void

* @return
* int : ���õ� �������� �ε���

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.SetSelectedNum(0); //0��°�� ����
*debug(string(c_handle.GetSelectedNum())); // 0����µȴ�
*/
native final function int GetSelectedNum();

/**
* ������ �ε����� �������� �����Ѵ�.

* @param
* num : �ε���

* @return
* void

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.SetSelectedNum(0); //0��°�� ����
*debug(string(c_handle.GetSelectedNum())); // 0����µȴ�
*/
native final function SetSelectedNum(int num);

/**
* �����Ͻô´�� ��� �������� �����

* @param
* num : �ε���

* @return
* void

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.Clear();//�� �����
*/
native final function Clear();

/**
* �������� �Ѽ��� �����Ѵ�.

* @param
* void

* @return
* int : �� �����ۼ�

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*var int totalnum;
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*totalnum = c_handle.GetNumOfItems();//�������� ���� �����´�
*/
native final function int GetNumOfItems();

/**
* ��Ʈ���� ���������Ͽ� �߰��Ѵ�.

* @param
* str : �߰��� ��Ʈ��
* Col : ������ ����

* @return
* void

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*var color textcolor;
*textcolor.R = 255;
*textcolor.G = 0;
*textcolor.B = 0;
*textcolor.A = 255;
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.AddStringWithColor("Red item", textcolor); //"Red item"�� ���������� �߰��Ѵ�
*/
native final function int AddStringWithColor(string str, color Col);

/**
* �Լ� AddStringWithFileExt() �� ������������. ������ �ε����� �����ۿ� �޾Ƶξ��� ������ �����´�.

* @param
* num : �������� �ε���

* @return
* array<string>

* @example
*var ComboBoxHandle FileExtComboBoxCtrl; //������ �ڵ� ����
*var array<string> strArray;
*FileExtComboBoxCtrl = GetComboBoxHandle( "FileListWnd.FLWFTypeComboBox" );//�ڵ��� �����´�
*FileExtComboBoxCtrl.Clear();
*strArray.Length = 1;
*strArray[0] = "*";
*FileExtComboBoxCtrl.AddStringWithFileExt("��� ����", strArray);
*strArray.Length = 2;
*strArray[0] = "txt";
*strArray[1] = "doc";
*FileExtComboBoxCtrl.AddStringWithFileExt("�ؽ�Ʈ ����", strArray);
*strArray.Length = 1;
*strArray[0] = "log";
*FileExtComboBoxCtrl.AddStringWithFileExt("�α� ����", strArray); //���� ���Ϳ����� ������ ���ϴ�
*strArray = FileExtComboBoxCtrl.GetFileExtInfo(1); //����Ȱ��� �ҷ��´�
*/
native final function array<string> GetFileExtInfo(int num);

/**
* ��Ʈ���� �߰��ϵ� �� ��Ʈ���� �ش��ϴ� ������ Ȯ���ڸ� �޾��ش�
* �ռҸ��� ���������� ������ ���ּ���

* @param
* str : �߰��� ��Ʈ��
* strArray : �ش��ϴ� Ȯ���� ���

* @return
* void

* @example
*var ComboBoxHandle FileExtComboBoxCtrl; //������ �ڵ� ����
*var array<string> strArray;
*FileExtComboBoxCtrl = GetComboBoxHandle( "FileListWnd.FLWFTypeComboBox" );//�ڵ��� �����´�
*FileExtComboBoxCtrl.Clear();
*strArray.Length = 1;
*strArray[0] = "*";
*FileExtComboBoxCtrl.AddStringWithFileExt("��� ����", strArray);
*strArray.Length = 2;
*strArray[0] = "txt";
*strArray[1] = "doc";
*FileExtComboBoxCtrl.AddStringWithFileExt("�ؽ�Ʈ ����", strArray);
*strArray.Length = 1;
*strArray[0] = "log";
*FileExtComboBoxCtrl.AddStringWithFileExt("�α� ����", strArray); //���� ���Ϳ����� ������ ���ϴ�
*/
native final function AddStringWithFileExt(string str, array<string> strArray);

/**
* �޺��ڽ��� ��Ʈ���� �߰��ϵ� �������� �ܴ�.

* @param
* str : �߰��� ��Ʈ��

* @return
* void

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.AddString("new item"); //���ο� ��Ʈ���� �߰��Ѵ�.
*/
native final function AddStringWithIcon(string str, string Icontex);

/**
* �޺��ڽ��� ��Ʈ���� �߰��ϵ� �������� �޸鼭 �����ش�

* @param
* str : �߰��� ��Ʈ��

* @return
* void

* @example
*var ComboBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetComboBoxHandle( "PartyMatchWnd.LevelFilterComboBox" );//�ڵ��� �����´�
*c_handle.AddString("new item"); //���ο� ��Ʈ���� �߰��Ѵ�.
*/
native final function AddStringWithIconWithGap(string str, string Icontex, optional int gap_mode);

native final function AddStringWithIconWithStr(string str, string Icontex , string additionalstr);

native final function AddStringWithIconWithGapWithStr(string str, string Icontex, int gap_mode, string additionalstr);
native final function string GetAdditionalString(int num);
defaultproperties
{
}
