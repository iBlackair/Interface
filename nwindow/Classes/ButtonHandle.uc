/**
*��ư��Ʈ�ѿ� ���� �Լ��� ����
*/
class ButtonHandle extends WindowHandle
	native;
/**
* ��ư�� �ؽ�Ʈ�� �����´�

* @param
* void

* @return
* String : ��ư�� �ؽ�Ʈ

* @example
* var ButtonHandle b_handle;
* b_handle = GetButtonHandle("PartyMatchWnd.RefreshBtn"); //�ڵ��� �����´�
* debug(b_handle.GetButtonName()); //"��ϰ���" �� ��µǾ���
*/
native final function String GetButtonName();

/**
* ��ư�� �ؽ�Ʈ�� �����Ѵ�. �̶� �ý��۽�Ʈ���� �ε����� �־� �ؽ�Ʈ�� �����Ѵ�

* @param
* a_NameID : �ý��۽�Ʈ���� �ε���

* @return
* void

* @example
* var ButtonHandle b_handle;
* b_handle = GetButtonHandle("PartyMatchWnd.RefreshBtn"); //�ڵ��� �����´�
* b_handle.SetButtonName(1); // "�κ��丮"�� �ٲ����
*/
native final function SetButtonName( int a_NameID );

/**
* ��ư�� �ؽ�Ʈ�� �����Ѵ�. 

* @param
* a_NameID : ������ �ؽ�Ʈ

* @return
* void

* @example
* var ButtonHandle b_handle;
* b_handle = GetButtonHandle("PartyMatchWnd.RefreshBtn"); //�ڵ��� �����´�
* b_handle.SetNameText("sohee"); //��ư�� �ؽ�Ʈ�� �����Ѵ�
*/
native final function SetNameText( string NameText );

/**
* ��ư�� �ؽ��ĸ� �����Ѵ�

* @param
* sForeTexture : ���� �ؽ���
* sBackTexture : �������� �ؽ���
* sHighlightTexture : ���콺 ������ �ؽ���

* @return
* void

* @example
* var ButtonHandle b_handle;
* b_handle = GetButtonHandle("PartyMatchWnd.RefreshBtn"); //�ڵ��� �����´�
* b_handle.SetTexture("L2UI_CH3.Msn.chatting_msn5", "L2UI_CH3.Msn.chatting_msn5_down", "L2UI_CH3.Msn.chatting_msn5_over"); //�ؽ��ĸ� �����Ͽ���. ������ ��ư�ؽ��ĸ� ��Ƽ��Ī������ �� ��ư�� �������Ҵ�
*/
native final function SetTexture( string sForeTexture, string sBackTexture, string sHighlightTexture );
defaultproperties
{
}
