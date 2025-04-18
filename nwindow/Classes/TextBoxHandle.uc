/**
*�ؽ�Ʈ�ڽ� ��Ʈ�ѿ� ���� �Լ��� ����
*/
class TextBoxHandle extends WindowHandle
	native;
/**
* �ؽ�Ʈ �ڽ��� �ؽ�Ʈ�� �����´�

* @param
* void

* @return
* String : �ؽ�Ʈ �ڽ��� �ؽ�Ʈ�� ����

* @example
* var TextBoxHandle t_handle;
* t_handle = GetTextboxHandle("ChatFilterWnd.CurrentText"); //�ؽ�Ʈ�ڽ� ��Ʈ���� �ڵ��� �����´�
* debug(t_handle.GetText()); //�ؽ�Ʈ�� ������ ����غ���
*/
native final function String GetText();

/**
* �ؽ�Ʈ �ڽ��� �ؽ�Ʈ�� �����Ѵ�

* @param
* a_Text : ������ �ؽ�Ʈ

* @return
* void

* @example
* var TextBoxHandle t_handle;
* t_handle = GetTextboxHandle("ChatFilterWnd.CurrentText"); //�ؽ�Ʈ�ڽ� ��Ʈ���� �ڵ��� �����´�
* t_handle.SetText("Hello World"); // �ؽ�Ʈ�� �����Ѵ�
*/
native final function SetText( String a_Text );

/**
* �ؽ�Ʈ �ڽ��� �ؽ�Ʈ������ �����Ѵ�

* @param
* a_Color : ������ ����

* @return
* void

* @example
* var TextBoxHandle t_handle;
* var Color TextColor;
* t_handle = GetTextboxHandle("ChatFilterWnd.CurrentText"); //�ؽ�Ʈ�ڽ� ��Ʈ���� �ڵ��� �����´�
* t_handle.SetText("Hello World"); // �ؽ�Ʈ�� �����Ѵ�
* TextColor.R = 100;
* TextColor.G = 100;
* TextColor.B = 100;
* t_handle.SetTextColor(TextColor); // ������ �����Ѵ�
*/
native final function SetTextColor( Color a_Color );

/**
* �ؽ�Ʈ �ڽ��� �ؽ�Ʈ������ �����´�

* @param
* void

* @return
* Color : �ؽ�Ʈ �ڽ��� ������ ����

* @example
* var TextBoxHandle t_handle;
* var Color TextColor;
* t_handle = GetTextboxHandle("ChatFilterWnd.CurrentText"); //�ؽ�Ʈ�ڽ� ��Ʈ���� �ڵ��� �����´�
* TextColor = t_handle.GetTextColor(); // ������ �����´�
*/
native final function Color GetTextColor();

/**
* �ؽ�Ʈ �ڽ��� ������ �����Ѵ�

* @param
* align : ������ ���Ļ���

* @return
* void

* @example
* var TextBoxHandle t_handle;
* t_handle = GetTextboxHandle("ChatFilterWnd.CurrentText"); //�ؽ�Ʈ�ڽ� ��Ʈ���� �ڵ��� �����´�
* t_handle.SetAlign(TA_Left); // �������ķ� �Ѵ�

*enum ETextAlign
*{
*	TA_Undefined,
*	TA_Left, 
*	TA_Center,
*	TA_Right,
*	TA_MacroIcon,
*};
*/
native final function SetAlign(ETextAlign align);

/**
* �������¸� �޾Ƽ� �ؽ�Ʈ�ڽ��� �ؽ�Ʈ�� ���Ѵ�.

* @param
* Number : �ؽ�Ʈ�� �� ����

* @return
* void

* @example
* var TextBoxHandle t_handle;
* t_handle = GetTextboxHandle("ChatFilterWnd.CurrentText"); //�ؽ�Ʈ�ڽ� ��Ʈ���� �ڵ��� �����´�
* t_handle.SetInt("10000"); // 10000 �� �ؽ�Ʈ�� �ȴ�

*enum ETextAlign
*{
*	TA_Undefined,
*	TA_Left, 
*	TA_Center,
*	TA_Right,
*	TA_MacroIcon,
*};
*/
native final function SetInt(int Number);

/**
* �ؽ�Ʈ �ڽ��� ���� ��Ʈ���� ���Ѵ�.

* @param
* align : ������ ���� ��Ʈ��

* @return
* void

* @example
* var TextBoxHandle t_handle;
* t_handle = GetTextboxHandle("ChatFilterWnd.CurrentText"); //�ؽ�Ʈ�ڽ� ��Ʈ���� �ڵ��� �����´�
* t_handle.SetToolTipString("tooltip"); // ������Ʈ���� ���Ѵ�.
*/

native final function SetTooltipString(string Text);
defaultproperties
{
}
