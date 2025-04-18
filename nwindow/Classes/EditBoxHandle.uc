/**
*����Ʈ�ڽ���Ʈ�ѿ� ���� �Լ��� ����
*/
class EditBoxHandle extends WindowHandle
	native;

/**
* ����Ʈ�ڽ��� �ؽ�Ʈ�� �����´�

* @param
* void

* @return
* string

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
*debug(e_handle.GetString()); //ä��â�� ��Ʈ���� ����ش�
*/
native final function string GetString();

/**
* ����Ʈ�ڽ��� �ؽ�Ʈ�� �����Ѵ�

* @param
* str : ������ �ؽ�Ʈ

* @return
* void

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
*e_handle.SetString("hihi"); //�ؽ�Ʈ�� �����Ͽ���.
*/
native final function SetString( string str );

/**
* ����Ʈ�ڽ��� �ؽ�Ʈ�� �����δ�

* @param
* str : ������ �ؽ�Ʈ

* @return
* void

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
*e_handle.SetString("hihi"); //�ؽ�Ʈ�� �����Ͽ���.
*e_handle.AddString("hihi"); //�ؽ�Ʈ�� ���ٿ���. ���� "hihihihi" �� �ȴ�
*/
native final function AddString( string str );

/**
* ����Ʈ�ڽ��� �ؽ�Ʈ�� ��ĭ�����

* @param
* void

* @return
* void

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
*e_handle.SetString("hihi"); //�ؽ�Ʈ�� �����Ͽ���. "hihi"�� �ȴ�
*e_handle.SimulateBackspace(); //��ĭ������ "hih"�� �ȴ�
*/
native final function SimulateBackspace();

/**
* ����Ʈ�ڽ��� �ؽ�Ʈ�� ��� �����

* @param
* void

* @return
* void

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
*e_handle.SetString("hihi"); //�ؽ�Ʈ�� �����Ͽ���.
*e_handle.Clear(); //�ؽ�Ʈ�� ��� ������
*/
native final function Clear();

/**
* ����Ʈ�ڽ��� Ÿ���� �����Ѵ�

* @param
* Type : Ÿ�� (normal, number, password)  �� �ִ�
* normal : �Ϲݸ��
* number : ���ڸ� �Էµ�
* password : �Է��� ��� * �� ǥ�õ�

* @return
* void

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox"); //�ڵ��� �����´�
*e_handle.SetEditType("password"); //�н����� Ÿ������ ����

*����: Ÿ���� ó���ϴ� cpp �κ�
*if( Type == FString(TEXT("normal")) ) 
*	pWnd->SetType( NC_EDIT_DEFAULT);
*else if( Type == FString(TEXT("number")) )
*	pWnd->SetType( NC_EDIT_NUMBER );
*else if( Type == FString(TEXT("password")) )
*	pWnd->SetType( NC_EDIT_PASSWORD );
*/
native final function SetEditType( string Type );

/**
* ����Ʈ�ڽ��� ���̶���Ʈ(��������) ȿ���� �ְų� ����Ѵ�

* @param
* bHighLight : true �� ȿ����, false�� ���

* @return
* void

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
*e_handle.SetHighLighting(true); //���̶���Ʈ ȿ���� ��
*/
native final function SetHighLight( bool bHighlight);

/**
* ����Ʈ�ڽ��� �ؽ�Ʈ�� ���̸� �����Ѵ�.(�ѱ�,����,���� ��� �Ȱ��� 1 ĳ���Ͱ� ����1�̴�)

* @param
* maxLength : �ִ����

* @return
* void

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
*e_handle.SetMaxLength(10); //10�ڷ� ����
*/
native final function SetMaxLength( int maxLength );

/**
* ����Ʈ�ڽ��� �ؽ�Ʈ�� �ִ���̸� �����Ѵ�

* @param
* void

* @return
* int : �ִ����

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
*e_handle.SetMaxLength(10); //10�ڷ� ����
*debug(string(e_handle.GetMaxLength())); // 10 ����µȴ�
*/
native final function int GetMaxLength();

/**
* ����Ʈ�ڽ��� �ؽ�Ʈ�� ��ũ����� �ο��ϰų� �����Ѵ�

* @param
* bEnable

* @return
* void

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
*e_handle.SetEnableTextLink(true); //�ؽ�Ʈ��ũ ����
*/
native final function SetEnableTextLink( bool bEnable );
/**
* ����Ʈ�ڽ��� �ڵ��ϼ� �����丮�� �����Ѵ�.

* @param
* void

* @return
* void

* @example
*var EditBoxHandle e_handle; //������ �ڵ� ����
*e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
*e_handle.ClearHistory(); //�ڵ��ϼ� �����丮�� �����Ѵ�.
*/
native final function ClearHistory();
/**
* ����Ʈ�ڽ��� �ڵ��ϼ��� Ž�� ����Ʈ�� �̸��� �߰��Ѵ�.

* @param
* string

* @return
* bool

* @example
* var EditBoxHandle e_handle; //������ �ڵ� ����
* var string name;
* e_handle = GetEditBoxHandle( "ChatWnd.ChatEditBox" ); //�ڵ��� �����´�
* e_handle.AddNameToAdditionalFriendSearchList(name); //�ڵ��ϼ� ģ�� Ž�� ����Ʈ�� �̸��� �߰��Ѵ�.
*/
native final function bool AddNameToAdditionalFriendSearchList(string name);
native final function bool FillAdditionalFriendSearchList(out array<string> stringArr);
native final function bool ClearAdditionalFriendSearchList();
native final function bool DeleteNameFromAdditionalFriendSearchList(string name);

native final function bool FillFriendSearchList(out array<string> stringArr);
native final function bool AddNameToFriendSearchList(string name);
native final function bool ClearFriendSearchList();
native final function bool DeleteNameFromFriendSearchList(string name);

native final function bool AddNameToPledgeMemberSearchList(string name);
native final function bool FillPledgeMemberSearchList(out array<string> stringArr);
native final function bool ClearPledgeMemberSearchList();
native final function bool DeleteNameFromPledgeMemberSearchList(string name);
native final function bool AddItemToAutoCompleteHistory(string name);
defaultproperties
{
}
