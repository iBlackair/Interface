/**
*�������ͽ� �����ܿ� ���� �Լ��� ����. 2�����迭ó�� �������ͽ��������� ������ �����ϸ鼭 �۵��Ѵ�
*/
class StatusIconHandle extends WindowHandle
	native;

/**
* �����߰��Ѵ�.(�������� ������������?)
* ���� �߰��ϴ� �ൿ�� ���� ������ Ȯ�������� �ʴ´�. �࿡ ���� �߰��ؾ� ��μ� ������ Ȯ���ȴ�

* @param
* void
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* s_handle.AddRow(); // ���� �߰��Ѵ�.
*/
native final function AddRow();

/**
* �����߰��Ѵ�. (�������� ����ĭ������?) �̶� ������ �������� ���� �־���� �ϴµ� �Ƹ��� �������� ���� �ø��� ���� �����ϱ� �����ε��Ѵ�.

* @param
* a_Row : ���� �߰��� ��
* a_Info : ������ ����������
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* var StatusIconInfo s_item;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* s_handle.AddRow(); //���� �߰��Ѵ�(������ Ȯ���ߴ�)
* s_handle.AddCol(0,s_item); // Ȯ���� ������ ���� �������� �߰��Ѵ�.

*struct native constructive StatusIconInfo
*{
*	var string	Name;
*	var string	IconName;
*	var int		Size;
*	var string	Description;
*	var string  BackTex;

*	var int		RemainTime;
*	var ItemID	Id;
*	var int		Level;
	
*	var bool	bShow;
*	var bool	bShortItem;
*	var bool	bEtcItem;
*	var bool	bDeBuff;
*};
*/

native final function AddCol( int a_Row, StatusIconInfo a_Info );

/**
* ���� ������ �࿡ ������ ����� �з�����.(�������� ������������?)
* ���� �߰��ϴ� �ൿ�� ���� ������ Ȯ�������� �ʴ´�. �࿡ ���� �߰��ؾ� ��μ� ������ Ȯ���ȴ�

* @param
* a_Row : ���� ������ ��ġ
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* var StatusIconInfo s_item;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* s_handle.AddRow(); // ���� �߰��Ѵ�.
* s_handle.AddCol(0,s_item); // Ȯ���� ������ ���� �������� �߰��Ѵ�.
* s_InsertRow(0); //���� �����Ѵ�. ������ 0���� ���� 1���� �Ǿ���.
* s_Addcol(0,s_item); //������ �غ��� ������ 0���� 1������ �з����� 0�࿡ �������� �߰��ȴ�
*/
native final function InsertRow( int a_Row );

/**
* ���� ������ ���� �߰��Ѵ�. ������ ������ �з�����(�������� ����ĭ������?)

* @param
* a_Row : ������ ��
* a_Col : ������ ��
* a_Info : ������ ����������
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* var StatusIconInfo s_item;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* s_handle.AddRow(); // ���� �߰��Ѵ�.
* s_handle.AddCol(0,s_item); // Ȯ���� ������ ���� �������� �߰��Ѵ�.
* s_handle.InsertCol(0,0,s_item); // ���� �����Ѵ�. ������ �����۵��� �з�����.

*struct native constructive StatusIconInfo
*{
*	var string	Name;
*	var string	IconName;
*	var int		Size;
*	var string	Description;
*	var string  BackTex;

*	var int		RemainTime;
*	var ItemID	Id;
*	var int		Level;
	
*	var bool	bShow;
*	var bool	bShortItem;
*	var bool	bEtcItem;
*	var bool	bDeBuff;
*};
*/

native final function InsertCol( int a_Row, int a_Col, StatusIconInfo a_Info );

/**
* ����� �����Ѵ� (�������� ������������?)


* @param
* void
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* var int rowcount;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* rowcount = s_handle.GetRowCount(); // ����� �����´�.
*/
native final function int GetRowCount();

/**
* ������ ���� ������ �����Ѵ� (�������� ����ĭ������?)

* @param
* a_Row : ������ ������ ��
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* s_handle.GetRowCount(3); // 3���� ������ �����´�.
*/
native final function int GetColCount( int a_Row );

/**
* ������ ������� �������� �����Ѵ�. (��ġ 2���� �迭ó��)

* @param
* a_Row : ��
* a_Col : ��
* a_Info : �������� ���� ����
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* var StatusIconInfo s_item;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* s_handle.GetItem(0,0,s_item); // 0�� 0�� �� �������� �����´�

*struct native constructive StatusIconInfo
*{
*	var string	Name;
*	var string	IconName;
*	var int		Size;
*	var string	Description;
*	var string  BackTex;

*	var int		RemainTime;
*	var ItemID	Id;
*	var int		Level;
	
*	var bool	bShow;
*	var bool	bShortItem;
*	var bool	bEtcItem;
*	var bool	bDeBuff;
*};
*/
native final function GetItem( int a_Row, int a_Col, out StatusIconInfo a_Info );

/**
* ������ ������� �������� �����Ѵ�. (��ġ 2���� �迭ó��)

* @param
* a_Row : ��
* a_Col : ��
* a_Info : ������ ������
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* var StatusIconInfo s_item;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* s_handle.SetItem(0,0,s_item); // 0�� 0�� �� �������� �����Ѵ�

*struct native constructive StatusIconInfo
*{
*	var string	Name;
*	var string	IconName;
*	var int		Size;
*	var string	Description;
*	var string  BackTex;

*	var int		RemainTime;
*	var ItemID	Id;
*	var int		Level;
	
*	var bool	bShow;
*	var bool	bShortItem;
*	var bool	bEtcItem;
*	var bool	bDeBuff;
*};
*/
native final function SetItem( int a_Row, int a_Col, StatusIconInfo a_Info );

/**
* ������ ������� �������� �����. (��ġ 2���� �迭ó��)

* @param
* a_Row : ��
* a_Col : ��
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* s_handle.DelItem(0,0); // 0�� 0�� �� �������� �����
*/
native final function DelItem( int a_Row, int a_Col );

/**
* �������� ����� �����Ѵ�.

* @param
* a_Size : ������
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* s_handle.SetIconSize(30); // ������ ����� 30���� �Ѵ�
*/
native final function SetIconSize( int a_Size );

/**
* ������� �ʱ�ȭ�Ѵ�

* @param
* void
*
* @return
* void

* @example
* var StatusIconHandle s_handle;
* s_handle = GetStatusIconHandle("AbnormalStatusWnd.StatusIcon"); //�ڵ��� �����´�
* s_handle.Clear(); �ʱ�ȭ �Ǿ���.
*/
native final function Clear();
defaultproperties
{
}
