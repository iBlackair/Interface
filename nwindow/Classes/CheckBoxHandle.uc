/**
*üũ�ڽ��� ���� �Լ��� ����
*/
class CheckBoxHandle extends WindowHandle
	native;
/**
* Ÿ��Ʋ�� �ؽ�Ʈ(üũĭ ���� �ؽ�Ʈ)�� �����Ѵ�

* @param
* Title : ������ Ÿ��Ʋ �ؽ�Ʈ

* @return
* void

* @example
*var CheckBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetCheckBoxHandle ( "RadarOptionWnd.checkPartyView" ); //�ڵ��� �����´�
*c_handle.SetTitle("check me!!!!!!!!"); //Ÿ��Ʋ ����
*/
native final function SetTitle(string Title);

/**
* üũ�ڽ��� üũ���¸� �����Ѵ�

* @param
* bCheck : true�� üũ, false �� uncheck

* @return
* void

* @example
*var CheckBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetCheckBoxHandle ( "RadarOptionWnd.checkPartyView" ); //�ڵ��� �����´�
*c_handle.SetCheck(true); //üũ�Ѵ�
*/
native final function SetCheck(bool bCheck);

/**
* üũ�ڽ��� üũ���¸� �˻��Ѵ�

* @param
* void

* @return
* bool : true �� üũ false�� uncheck

* @example
*var CheckBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetCheckBoxHandle ( "RadarOptionWnd.checkPartyView" ); //�ڵ��� �����´�
*if(c_handle.IsChecked()) c_handle.SetCheck(false); //üũ�Ǿ������� üũ�� �����Ѵ�
*/
native final function bool IsChecked();

/**
* üũ�ڽ��� ��Ȱ��ȭ �������� �˻��Ѵ�

* @param
* void

* @return
* bool : true �� ��Ȱ��ȭ  false�� Ȱ��ȭ

* @example
*var CheckBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetCheckBoxHandle ( "RadarOptionWnd.checkPartyView" ); //�ڵ��� �����´�
*if(c_handle.IsDisable()) c_handle.SetDisable(false); // ��Ȱ��ȭ �Ǿ������� Ȱ��ȭ ��Ų��
*/
native final function bool IsDisable();

/**
* üũ�ڽ��� ��Ȱ��ȭ ��Ű�ų� �����Ѵ�

* @param
* bDisable : true �� ��Ȱ��ȭ false�� Ȱ��ȭ

* @return
* void

* @example
*var CheckBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetCheckBoxHandle ( "RadarOptionWnd.checkPartyView" ); //�ڵ��� �����´�
*if(c_handle.IsDisable()) c_handle.SetDisable(false); // ��Ȱ��ȭ �Ǿ������� Ȱ��ȭ ��Ų��
*/
native final function SetDisable(bool bDisable);

/**
* üũ�ڽ��� ��Ȱ��ȭ ���¸� ����Ѵ�(Ȱ��ȭ -> ��Ȱ��ȭ -> Ȱ��ȭ...........)

* @param
* void

* @return
* void

* @example
*var CheckBoxHandle c_handle; //������ �ڵ� ����
*c_handle = GetCheckBoxHandle ( "RadarOptionWnd.checkPartyView" ); //�ڵ��� �����´�
*c_handle.ToggleDisable(); // Ȱ��ȭ���¸� ����Ѵ�
*/
native final function ToggleDisable();
defaultproperties
{
}
