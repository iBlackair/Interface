/**
*�ؽ�Ʈ����Ʈ�ڽ��� ���� �Լ��� �����Ѵ�.
*/
class CharacterViewportWindowHandle extends WindowHandle
	native;
/**
* ���Ѭ���ܬѬ֬� ���Ӭ���� �ެ�լ֬ݬ� ��֬���߬Ѭج� �Ӭ� �Ӭ�������

* @param
* bRight : true - ���Ӭ���� �߬Ѭ��ѬӬ�, false - ���Ӭ���� �߬Ѭݬ֬Ӭ�

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //����ݬ��֬߬ڬ� ��֬߬լݬ֬��
* c_handle.StartRotation(true); //����Ӭ���� �߬Ѭ��ѬӬ�
*/
native final function StartRotation( bool bRight );

/**
* �����Ѭ߬ѬӬݬڬӬѬ֬� ���Ӭ���� �ެ�լ֬ݬ� ��֬���߬Ѭج� �Ӭ� �Ӭ�������

* @param
* void

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //����ݬ��֬߬ڬ� ��֬߬լݬ֬��
* c_handle.StartRotation(true); // ����Ӭ���� �߬Ѭ��ѬӬ�
* c_handle.EndRotation(); //�����Ѭ߬�Ӭܬ� ���Ӭ�����
*/
native final function EndRotation();

/**
* ���Ѭ���ѬҬڬ��ӬѬ߬ڬ� �ެ�լ֬ݬ� ��֬���߬Ѭج� �Ӭ� �Ӭ�������

* @param
* bOut : true - ��ެ֬߬��֬߬ڬ� �ެ�լ֬ݬ�, false - ��Ӭ֬ݬڬ�֬߬ڬ� �ެ�լ֬ݬ�

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //����ݬ��֬߬ڬ� ��֬߬լݬ֬��
* c_handle.StartZoom(true); //���ެ֬߬��֬߬ڬ� �ެѬ���ѬҬ�
*/
native final function StartZoom( bool bOut );

/**
* ���ѬӬ֬��֬߬ڬ� �ެѬ���ѬҬڬ��ӬѬ߬ڬ� �ެ�լ֬ݬ�

* @param
* void

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //����ݬ��֬߬ڬ� ��֬߬լݬ֬��
* c_handle.StartZoom(true); //���ެ֬߬��֬߬ڬ� �ެѬ���ѬҬ�
* c_handle.EndZoom(); //���ѬӬ֬��֬߬ڬ� �ެѬ���ѬҬڬ��ӬѬ߬ڬ� �ެ�լ֬ݬ�
*/
native final function EndZoom();

/**
* ���Ѭ���ѬҬڬ��֬� �ެ�լ֬ݬ� ��֬���߬Ѭج�(�� ��ܬѬ٬Ѭ߬߬�� ��Ѭ٬ެ֬���)

* @param
* fCharacterScale : �ެѬ���Ѭ�

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //����ݬ��֬߬ڬ� ��֬߬լݬ֬��
* c_handle.SetCharacterScale(1.03f); //�ެѬ���ѬҬڬ��֬� �լ� ��Ѭ٬ެ֬�� 1.03 (���߬��ڬ�֬ݬ�߬� �Ӭ߬���ڬڬԬ��Ӭ�� ��Ѭ٬ެ֬���, �ҬѬ٬�Ӭ�� ��Ѭ٬ެ֬� 1)
*/
native final function SetCharacterScale( float fCharacterScale );

/**
* ����Ʈ�� ���̴� ĳ������ X ���� ��ġ�� �����Ѵ�

* @param
* nOffsetX : x��ǥ

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //�ڵ��� �����´�
* c_handle.SetCharacterOffsetX(-4); //-4 ��ġ�� �̵���Ų��
*/
native final function SetCharacterOffsetX( int nOffsetX );

/**
* ����Ʈ�� ���̴� ĳ������ X ���� ��ġ�� �����Ѵ�

* @param
* nOffsetY : y��ǥ

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //�ڵ��� �����´�
* c_handle.SetCharacterOffsetY(-3); //-3 ��ġ�� �̵���Ų��
*/
native final function SetCharacterOffsetY( int nOffsetY );

native final function SpawnNPC();

/**
* ����Ʈ�� ���̴� ĳ���Ϳ��� �׼��� ��Ų��

* @param
* index : �׼��� ����

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //�ڵ��� �����´�
* c_handle.PlayAnimation(2); //�λ��ϴ� �׼��� ���Ѵ�
*/
native final function PlayAnimation(int index);
native final function ShowNPC(float Duration);
native final function HideNPC(float Duration);
defaultproperties
{
}
