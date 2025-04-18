/**
*����Ʈ�ѿ� �ʿ��� �Լ��� ����
*/
class TabHandle extends WindowHandle
	native;

//tab ��Ʈ�� �ʱ�ȭ onshow���� ȣ�� ������Ѵ�.

/**
* tab ��Ʈ�� �ʱ�ȭ onshow���� ȣ�� ������Ѵ�.

* @param
* void

* @return
* void

* @example
* var TabHandle t_handle;
* t_handle = GetTabHandle("QuestTreeWnd.QuestTreeTab"); //�ڵ��� �����´�
* function OnShow(){
*	t_handle.InitTabCtrl(); //onshow���� �ʱ�ȭ ���ش�
*   ..............
* }
*/
native final function InitTabCtrl();

/**
* ���õ� tab �� �ٲ۴�.

* @param
* index : ���õ� ���� �ε���
* bSendMessage : WM_NWND_MSG �޽����� ���� �����쿡�� dispatch������ �����Ѵ�. �������޵Ǵ� param�� index �̴�. true�� ����.

* @return
* void

* @example
* var TabHandle t_handle;
* t_handle = GetTabHandle("QuestTreeWnd.QuestTreeTab"); //�ڵ��� �����´�
* t_handle.SetTopOrder(1,false); //1������ �����Ѵ�.(0������ ����)
*/
native final function SetTopOrder(int index, bool bSendMessage);

/**
* ���õ� tab�� �ε����� �����´�

* @param
* void

* @return
* int : ���õ� tab�� �ε���

* @example
* var TabHandle t_handle;
* var int index;
* t_handle = GetTabHandle("QuestTreeWnd.QuestTreeTab"); //�ڵ��� �����´�
* t_handle.SetTopOrder(1,false); //1������ �����Ѵ�.(0������ ����)
* index = t_handle.GetTopIndex(); // 1�������´�
*/
native final function int GetTopIndex();

/**
* tab��Ʈ���� ���� ��Ȱ��ȭ �Ѵ�.

* @param
* index : ��Ȱ��ȭ �� ���� �ε���
* bDisable : true �� ��Ȱ��ȭ false�� Ȱ��ȭ
*
* @return
* void

* @example
* var TabHandle t_handle;
* var int index;
* t_handle = GetTabHandle("QuestTreeWnd.QuestTreeTab"); //�ڵ��� �����´�
* t_handle.SetDisable(2,true); //2������ ��Ȱ��ȭ �Ѵ�
*/
native final function SetDisable(int index, bool bDisable);

/**
* tab��ư�� tab ��Ʈ�ѿ� ���δ�.

* @param
* index : ���� ���� �ε���
*
* @return
* void

* @example
* var TabHandle t_handle;
* var int index;
* t_handle = GetTabHandle("QuestTreeWnd.QuestTreeTab"); //�ڵ��� �����´�
* t_handle.MergeTab(0); //0������ ���δ�.
* t_handle.MergeTab(1); //1������ ���δ�.
*/
native final function MergeTab(int index);

/**
* tab��Ʈ���� ���� �ؽ�Ʈ�� �ٲ۴�

* @param
* index : �̸��� �ٲ� ���� �ε���
* NewName : �ٲ� �ؽ�Ʈ
*
* @return
* void

* @example
* var TabHandle t_handle;
* var int index;
* t_handle = GetTabHandle("QuestTreeWnd.QuestTreeTab"); //�ڵ��� �����´�
* t_handle.SetButtonName(3,"3t"); 3��° ���� �ؽ�Ʈ�� 3t �� �ٲ۴�
*/
native final function SetButtonName(int index, string NewName);
defaultproperties
{
}
