/**
*Ʈ�������� ��Ʈ�ѵ��� �⺻�� ���(������, ����, travelsal ��)�� ����(����Ʈ Ʈ��� ���ȹ� �ִ�.)
*/

class TreeHandle extends WindowHandle
	native;

/**
*Ʈ����  infNode������ ���ϴ� ���ο� ��带 �����Ѵ�.
*infNode�� ����ü�ν� strName�̶�� ����� ���ϴµ� �̷ν� Identification�� �Ѵ�
*strParentName�� strName���� ������ ����� �������ν� ���ο� ��尡 �����ȴ�
*������ �̸��� ��尡 ������ �����Ѵ�.
*strParentName�� �� ��Ʈ��("") �ΰ�� ���λ����� ��尡 Root�� �ȴ�.
* @param
*strParentName �θ����� �̸�
*infNode ������ ����� ������ ���� ����ü

* @return
*string
*��� ���� ������ ���λ��� ����� strName�� ����(pull path�� ���� ex:root.child1.child2)
*��� ���� ���н� NULL�� ����

* @example
*var TreeHandle	MainTree;
*var XMLTreeNodeInfo infNode;
*var string strRetName;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode); //1st param�� "" �̹Ƿ� ��Ʈ��尡 �ȴ�
*infNode.strName = "child1";
*strRetName = MainTree.InsertNode("root", infNode); //�ռ��� ������ "root"����� child ��尡 �ȴ�. ���ϰ��� "root.child1" �̵ȴ�
*/
	
native final function string InsertNode(string strParentName, XMLTreeNodeInfo infNode);

/**
*NodeName�� �̸����� ������ ��忡 �������� �����Ѵ�.(���� �����۸���Ʈ�� ���� �����Ѵ�)
* @param
*NodeName : �������� ���� ����� �̸�
*infNodeItem : ��忡 ������ ������

* @return
*void

* @example
*var TreeHandle	MainTree; // Ʈ������
*var XMLTreeNodeInfo infNode;
*var string strRetName;
*var XMLTreeNodeItemInfo infNodeItem;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode); //root ��带 �����Ѵ�.
*infNodeItem.t_nTextID = 0;
*infNodeItem.eType = XTNITEM_TEXT;
*infNodeItem.t_strText = strRetName;
*........								//�������� �����Ѵ�. �������� ID=0, Ÿ���� text, str�� root
*........
*MainTree.InsertNodeItem("root", infNodeItem); // root��忡 �������� �ܴ�
*/

native final function InsertNodeItem(string NodeName, XMLTreeNodeItemInfo infNodeItem);

/**
*Ʈ���� Ŭ�����ϰ� ��� �޸𸮸� �����Ѵ�.
* @param
*void

* @return
*void

* @example
*var TreeHandle	MainTree; // Ʈ������
*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*.... // ��� Ʈ���� ������� ����ϴٰ�
*....
*MainTree.Clear(); // Ʈ���� �ٽ� �ʱ�ȭ

*/
native final function Clear();

/**
*����� expanded����(��ħ)�� �����Ѵ�.
* @param
*void

* @return
*void

* @example
*var TreeHandle	MainTree;
*var XMLTreeNodeInfo infNode;
*var string strRetName;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode);//root ��带 �����Ѵ�.
*infNode.strName = "child1";
*strRetName = MainTree.InsertNode("root", infNode); // root�� child1�� �޾Ҵ�
*infNode.strName = "child2";
*strRetName = MainTree.InsertNode("root.child2", infNode); // root.child1�� child2�� �޾Ҵ�
*MainTree.SetExpandedNode("root.child1", true); // ��ģ��. child2�� ������.
*MainTree.SetExpandedNode("root.child1", false); // �ݴ´�. child2�� ������.
*/

native final function SetExpandedNode(string NodeName, bool bExpanded);

/**
*����� expanded�� child���� �̸��� ��ȯ�Ѵ�.
* @param
*NodeName : �˻��� ����� �̸�

* @return
*string : expanded �� child���� �̸�(�������� ��� "|" �� �̾�����);

* @example
*var TreeHandle	MainTree;
*var XMLTreeNodeInfo infNode;
*var string strRetName;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode);
*infNode.strName = "child1";
*strRetName = MainTree.InsertNode("root", infNode); // root�� child1�� �޾Ҵ�
*infNode.strName = "child2";
*strRetName = MainTree.InsertNode("root.child2", infNode); // root.child1�� child2�� �޾Ҵ�
*MainTree.SetExpandedNode("root.child1", true); // ��ģ��. child2�� ������.
*strRetName = MainTree.GetExpandedNode("root", false); // "root.child1" �� ���ϵȴ�(������ ����)
*/

native final function string GetExpandedNode(string NodeName);

/**
* ������ �̸��� ��带 �����Ѵ�.(�̸��� Full Path��� �Ϳ� ��������. child1�� root�� �޸� "root.child1"�̶�� �̸����� �������Ѵ�)
* @param
* NodeName : ���� ����� �̸�

* @return
* void

* @example
*var TreeHandle	MainTree;
*var XMLTreeNodeInfo infNode;
*var string strRetName;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode);//root ��带 �����Ѵ�.
*infNode.strName = "child1";
*strRetName = MainTree.InsertNode("root", infNode); // root�� child1�� �޾Ҵ�
*MainTree.DeleteNode("root.child1"); // �����
*/

native final function bool DeleteNode(string NodeName);

/**
* ������ �̸��� ���� ��尡 �����ϴ��� ���θ� �����Ѵ�
* @param
* NodeName : ���� ���θ� �Ǵ��� �̸�

* @return
* bool : �����Ѵٸ� true ���ٸ� false

* @example
*var TreeHandle	MainTree;
*var XMLTreeNodeInfo infNode;
*var string strRetName;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode); //root ��带 �����Ѵ�.
*infNode.strName = "child1";
*strRetName = MainTree.InsertNode("root", infNode); // root�� child1�� �޾Ҵ�
*if(MainTree.IsNodeNameExist("root.child1")) debug("Exist Node"); //root.child1�̶�� ��尡 �ִٸ� ����Ѵ�.
*else debug("Never reach"); //���ٸ� ����Ѵ�. (������ child1�� �޾����Ƿ� ��µ��� �ʴ´�)
*/

native final function bool IsNodeNameExist(string NodeName);

/**
* ������ �̸��� ��尡 Expanded(������) �� ���θ� �����Ѵ�.
* @param
* NodeName : Expanded(������) ���θ� �Ǵ��� ����� �̸�

* @return
* bool : Expanded(������)�Ǿ� �ִٸ� true ���ٸ� false

* @example
*var TreeHandle	MainTree;
*var XMLTreeNodeInfo infNode;
*var string strRetName;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode);//root ��带 �����Ѵ�. root �� �⺻ ������ expanded �̴�.
*if(IsExpandedNode("root")) debug("root is always opened."); //root�� expanded �Ǿ������Ƿ� ��µȴ�.
*else debug("Nerver reach") //��µ��� �ʴ´�.
*/

native final function bool IsExpandedNode(string NodeName);

/**
* ������ ����� �ڽĳ����� �̸��� �����Ѵ�. �ڽ��� �������� ��� "|" �� �̾�����.
* @param
* NodeName :�ڽĵ��� ���캼 ����� �̸�

* @return
* string : �ڽĳ����� �̸�. �ڽ��� �������� ��� "|" �� �̾�����.

* @example
*var TreeHandle	MainTree;
*var XMLTreeNodeInfo infNode;
*var string strRetName;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode);//root ��带 �����Ѵ�.
*infNode.strName = "child1";
*strRetName = MainTree.InsertNode("root", infNode); // root�� child1�� �޾Ҵ�
*infNode.strName = "child2";
*strRetName = MainTree.InsertNode("root", infNode); // root�� child2�� �޾Ҵ�
*strRetName = MainTree.GetChildNode("root"); // root�� �ڽĳ����� ��´�
*debug(strRetName); // root.child1|root.child2 �� ��µȴ�.
*/

native final function string GetChildNode(string NodeName);

/**
* ������ ����� �θ����� �̸��� �����Ѵ�.
* @param
* NodeName :�θ� ���캼 ����� �̸�

* @return
* string : �θ����� �̸�.

* @example
*var TreeHandle	MainTree;
*var XMLTreeNodeInfo infNode;
*var string strRetName;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode);//root ��带 �����Ѵ�.
*infNode.strName = "child1";
*strRetName = MainTree.InsertNode("root", infNode); // root�� child1�� �޾Ҵ�
*strRetName = MainTree.GetParentNode("root.child1"); // root.child1 �� �θ��带 ��´�
*debug(strRetName); // root �� ��µȴ�.
*/

native final function string GetParentNode(string NodeName);

/**
* ��ũ�ѹ��� show ���θ� �����Ѵ�.
* @param
* bShow : true�� show, false�� hide

* @return
* void

* @example
*var TreeHandle	MainTree;
*var XMLTreeNodeInfo infNode;
*var string strRetName;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode);//root ��带 �����Ѵ�.
*MainTree.ShowScrollBar(true); //��ũ�ѹٸ� �����ش�
*MainTree.ShowScrollBar(false); //��ũ�ѹٸ� �����
*/

native final function ShowScrollBar(bool bShow);
 
//For Text Item

/**
* ��忡 �޷��ִ� �������� �ؽ�Ʈ�� �����Ѵ�.
* @param
* NodeName : ����� �̸�
* nTextID : �������� ID
* strText : �������� �ؽ�Ʈ

* @return
* void

* @example
*var TreeHandle	MainTree; // Ʈ������
*var XMLTreeNodeInfo infNode;
*var string strRetName;
*var XMLTreeNodeItemInfo infNodeItem;

*MainTree = GetTreeHandle("QuestTreeWnd.MainTree1");
*infNode.strName = "root";
*strRetName = MainTree.InsertNode("", infNode); //root ��带 �����Ѵ�.
*infNodeItem.t_nTextID = 0;
*infNodeItem.eType = XTNITEM_TEXT;
*infNodeItem.t_strText = strRetName;	
*........								//�������� �����Ѵ�. �������� ID=0, Ÿ���� text, str�� root
*........
*MainTree.InsertNodeItem("root", infNodeItem); // root��忡 �������� �ܴ�
*MainTree.SetNodeItemText("root", 0, "rootroot"); // root����� �������� 0�� �������� str�� rootroot�� �����Ѵ�.
*/

native final function SetNodeItemText(string NodeName, int nTextID, string strText);
defaultproperties
{
}
