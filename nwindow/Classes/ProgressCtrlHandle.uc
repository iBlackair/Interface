/**
*���α׷���(�����)�ڵ鿡 ���� �Լ��� ����
*/
class ProgressCtrlHandle extends WindowHandle
	native;

/**
* ���α׷��ù��� ��ü ���� �ð��� �����Ѵ�.

* @param
* Millitime : ���α׷������� ��ü �ð�(1/1000 �ʴ���)

* @return
* void

* @example
* var ProgressCtrlHandle	p_handle;
* p_handle = GetProgressCtrlHandle("ItemEnchantWnd.EnchantProgress"); //�ڵ��� �����´�
* p_handle.SetProgressTime(2000); //2�ʷ� ����
*/	
native final function SetProgressTime(int Millitime);

/**
* ���α׷��ù��� ���� �ð��� ���Ѵ�.

* @param
* Millitime : ���α׷������� ���� �ð�(1/1000 �ʴ���)

* @return
* void

* @example
* var ProgressCtrlHandle	p_handle;
* p_handle = GetProgressCtrlHandle("ItemEnchantWnd.EnchantProgress"); //�ڵ��� �����´�
* p_handle.SetProgressTime(2000); //�ѽð� 2�ʷ� ����
* p_handle.SetPos(2); //2�ʷ� ���۽ð� ����
*/	

native final function SetPos(int Millitime);

/**
* ���α׷��ú�ٸ� �����Ѵ�. (���߰� 0�ʷ� ���� �ð�����)

* @param
* void

* @return
* void

* @example
* var ProgressCtrlHandle	p_handle;
* p_handle = GetProgressCtrlHandle("ItemEnchantWnd.EnchantProgress"); //�ڵ��� �����´�
* p_handle.SetProgressTime(2000); //�ѽð� 2�ʷ� ����
* p_handle.SetPos(2000); //0�ʷ� ���۽ð� ����
* p_handle.Start(); //����
* p_handle.Reset(); //�����Ѵ�
*/	
native final function Reset();

/**
* ���α׷��ú���� ������ �����

* @param
* void

* @return
* void

* @example
* var ProgressCtrlHandle	p_handle;
* p_handle = GetProgressCtrlHandle("ItemEnchantWnd.EnchantProgress"); //�ڵ��� �����´�
* p_handle.SetProgressTime(2000); //�ѽð� 2�ʷ� ����
* p_handle.SetPos(2000); //2�ʷ� ���۽ð� ����
* p_handle.Start(); //����
* p_handle.Stop(); //�����
*/	
native final function Stop();

/**
* ���α׷��ú���� ���������� �����ϵ��� �Ѵ�

* @param
* void

* @return
* void

* @example
* var ProgressCtrlHandle	p_handle;
* p_handle = GetProgressCtrlHandle("ItemEnchantWnd.EnchantProgress"); //�ڵ��� �����´�
* p_handle.SetProgressTime(2000); //�ѽð� 2�ʷ� ����
* p_handle.SetPos(2000); //2�ʷ� ���۽ð� ����
* p_handle.Start(); //����
* p_handle.Stop(); //�����
* p_handle.Resume(); //�ٽ� �����δ�
*/	
native final function Resume();

/**
* ���α׷��ú�ٸ� ������ ���۽�Ų��.

* @param
* void

* @return
* void

* @example
* var ProgressCtrlHandle	p_handle;
* p_handle = GetProgressCtrlHandle("ItemEnchantWnd.EnchantProgress"); //�ڵ��� �����´�
* p_handle.SetProgressTime(2000); //�ѽð� 2�ʷ� ����
* p_handle.SetPos(2000); //2�ʷ� ���۽ð� ����
* p_handle.Start(); //����
*/	
native final function Start();

native final function SetBackTex(string left, string mid, string right);
native final function SetBarTex(string left, string mid, string right);
defaultproperties
{
}
