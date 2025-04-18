/**
* ��Ƽ����Ʈ�ڽ�(�����پ����ִ� ����Ʈ �ڽ�)�� ���� �Լ�����
*/
class MultiEditBoxHandle extends WindowHandle
	native;

/**
* ����Ʈ�ڽ��� ��Ʈ���� �����´�

* @param
* void

* @return
* void

* @example
* var MultiEditBoxHandle t_handle;
* t_handle = GetMultiEditBoxHandle("PostWriteWnd.PostContents"); //�ڵ��� �����´�
* debug(t_handle.GetString()); //��Ʈ���� ������ ����Ѵ�.
*/
native final function string GetString();

/**
* ����Ʈ�ڽ��� ��Ʈ���� �����Ѵ�

* @param
* void

* @return
* void

* @example
* var MultiEditBoxHandle t_handle;
* t_handle = GetMultiEditBoxHandle("PostWriteWnd.PostContents"); //�ڵ��� �����´�
* t_handle.SetString("It is so easy to see dysfunction beetween U and Me"); //�ؽ�Ʈ�� �����Ѵ�.
*/
native final function SetString( string str );
defaultproperties
{
}
