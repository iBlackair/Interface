/**
*����Ʈ�ڽ���Ʈ�ѿ� ���� �Լ��� �����Ѵ�
*/
class ListBoxHandle extends WindowHandle
	native;

/**
*����Ʈ�ڽ��� ���ڿ��� �߰��Ѵ�

* @param
* Text : �߰��� ���ڿ�

* @return
* void

* @example
*var ListBoxHandle l_handle; //������ �ڵ� ����
*l_handle = GetListBoxHandle("UIEditor_FileManager.lstFiles");//�ڵ��� �����´�
*l_handle.AddString("New Item"); //"New Item"�̶�� ���ڿ��� �߰��Ͽ���
*/
native final function AddString(string Text);

/**
*����Ʈ�ڽ��� ���ڿ��� ��λ����Ѵ�

* @param
* void

* @return
* void

* @example
*var ListBoxHandle l_handle; //������ �ڵ� ����
*l_handle = GetListBoxHandle("UIEditor_FileManager.lstFiles");//�ڵ��� �����´�
*l_handle.Clear(); //���ڿ��� ��� �����Ǿ���
*/
native final function Clear();

/**
*����Ʈ�ڽ��� ���ڿ��� �߰��Ѵ�. ����� �����͸� �Բ� �����Ѵ�
*�׷��� ������ ���Լ��� �������� ���� ���ο����� AddString�� �Բ� �ϳ��� �Լ��� �������̵� �Ǿ��ִ�.
*���� ������ ������� �ʴ´�. ����Ʈ�ڽ��� ����ؼ� �����Ҷ� �ΰ��� ���������� �ٸ��뵵�� ����Ҽ��ִ�������
*�����ϸ� �ǰڴ�(GetSelectedColor�� GetSelectedData������ �Լ��� �ʿ��ϰ����� ���̴�)

* @param
* Text : �߰��� ���ڿ�
* Color : ���ڿ��� ����
* Data : ������ ����Ÿ

* @return
* void

* @example
*var ListBoxHandle l_handle; //������ �ڵ� ����
*var int itemcolor;
*var int itemdata;
*l_handle = GetListBoxHandle("UIEditor_FileManager.lstFiles"); //�ڵ��� �����´�
*itemcolor = 100;
*itemdata = 100;
*l_handle.AddStringWithData("New Item", tcolor, itemdata); //���ڿ��� �߰��Ѵ�
*/
native final function AddStringWithData(string Text, int Color, int Data);

/**
*���õ� �������� ���ڿ��� �����Ѵ�.

* @param
* void

* @return
* string

* @example
*var ListBoxHandle l_handle; //������ �ڵ� ����
*l_handle = GetListBoxHandle("UIEditor_FileManager.lstFiles"); //�ڵ��� �����´�
*debug(l_handle.GetSelectedString()); //���õ� ��Ʈ���� ����غ���
*/
native final function string GetSelectedString();

/**
*��ũ���� ��ġ�� �����Ѵ�

* @param
* pos : ��ũ���� ��ġ

* @return
* string

* @example
*var ListBoxHandle l_handle; //������ �ڵ� ����
*l_handle = GetListBoxHandle("UIEditor_FileManager.lstFiles"); //�ڵ��� �����´�
*l_handle.SetListBoxScrollPosition(10); //��ũ���� ��ġ�� 10(������ 10�� ������)�����Ѵ�
*/
native final function SetListBoxScrollPosition(int pos);

native final function SetDrawOffset(int offsetx, int offsety);

native final function SetMaxRow(int maxrow);
defaultproperties
{
}
