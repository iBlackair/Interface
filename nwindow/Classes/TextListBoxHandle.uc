/**
*�ؽ�Ʈ����Ʈ�ڽ��� ���� �Լ��� �����Ѵ�.
*/

class TextListBoxHandle extends WindowHandle
	native;
/**
* ����Ʈ�ڽ��� �ؽ�Ʈ�� �߰��Ѵ�.

* @param
* text : �߰��� �ؽ�Ʈ
* textColor : �ؽ�Ʈ�� ����

* @return
* void

* @example
* var TextListBoxHandle t_handle;
* var Color Textcolor
* t_handle = GetTextListBoxHandle("PostDetailWnd_SafetyTrade.PostContents");
* t_handle.AddString("hello world", Textcolor);
*/

native final function AddString( string text, Color textColor );

/**
* ê�����쿡 �ؽ�Ʈ�� �߰��Ѵ�.

* @param
* text : �߰��� �ؽ�Ʈ
* textColor : �ؽ�Ʈ�� ����

* @return
* void

* @example
* var TextListBoxHandle t_handle;
* var Color Textcolor
* t_handle = GetTextListBoxHandle("PostDetailWnd_SafetyTrade.PostContents");
* t_handle.AddStringToChatWindow("hello world", Textcolor);
*/
native final function AddStringToChatWindow( string text, Color textColor );

/**
* ����Ʈ�� Ŭ�����Ѵ�.

* @param
* void

* @return
* void

* @example
* var TextListBoxHandle t_handle;
* var Color Textcolor
* t_handle = GetTextListBoxHandle("PostDetailWnd_SafetyTrade.PostContents"); 
* t_handle.AddString("hello world", Textcolor);
* t_handle.Clear();
*/
native final function Clear();

/**
* ����Ʈ�� ��ũ�� ��ġ�������Ѵ�.

* @param
* pos : ��ġ

* @return
* void

* @example
* var TextListBoxHandle t_handle;
* var Color Textcolor
* t_handle = GetTextListBoxHandle("PostDetailWnd_SafetyTrade.PostContents"); 
* t_handle.SetTextListBoxScrollPosition(10);
*/
native final function SetTextListBoxScrollPosition(int pos);
defaultproperties
{
}
