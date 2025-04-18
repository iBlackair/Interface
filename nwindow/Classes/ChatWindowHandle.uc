/**
* ê������ �ڵ鿡 ���� �Լ��� �����Ѵ�. ���ٽ��� TextListBoxHandle�� ��ӹ޾����Ƿ� TextListBoxHandle.uc�� �Լ��� �����Ѵ�

*/
class ChatWindowHandle extends TextListBoxHandle native;

/**
* ê �������� �ؽ��ĸ� ���̰��ϰų� �Ⱥ��̰��Ѵ�
* ������ ê��â�� �ؽ��ĸ� ������ �ʰ� �Ǿ��ִ�. ê�����쿡�� ��ü������ �ؽ��ĸ� ������
* ���� ��Ʈ���� NormalChat ��Ʈ�ѿ����� �� �ؽ��İ� ������ �ʰ� ���ֱ� ���ؼ��̴�

* @param
* bVlaue : true�� ��� false�� ������

* @return
* void

* @example
* var ChatWindowHandle c_handle;
* c_handle = GetChatWindowHandle( "ChatWnd.NormalChat" ); //�ڵ��� ������
* c_handle.EnableTexture(true); //�ؽ��ĸ� ���̰� �غ���
*/
native final function EnableTexture( bool bValue );
defaultproperties
{
}
