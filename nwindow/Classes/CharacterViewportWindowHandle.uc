/**
*텍스트리스트박스에 대한 함수를 정의한다.
*/
class CharacterViewportWindowHandle extends WindowHandle
	native;
/**
* Запускает поворот модели персонажа во вьюпорте

* @param
* bRight : true - поворот направо, false - поворот налево

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //Получение хендлера
* c_handle.StartRotation(true); //Поворот направо
*/
native final function StartRotation( bool bRight );

/**
* Останавливает поворот модели персонажа во вьюпорте

* @param
* void

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //Получение хендлера
* c_handle.StartRotation(true); // Поворот направо
* c_handle.EndRotation(); //Остановка поворота
*/
native final function EndRotation();

/**
* Масштабирование модели персонажа во вьюпорте

* @param
* bOut : true - уменьшение модели, false - увеличение модели

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //Получение хендлера
* c_handle.StartZoom(true); //Уменьшение масштаба
*/
native final function StartZoom( bool bOut );

/**
* Завершение масштабирования модели

* @param
* void

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //Получение хендлера
* c_handle.StartZoom(true); //Уменьшение масштаба
* c_handle.EndZoom(); //Завершение масштабирования модели
*/
native final function EndZoom();

/**
* Масштабирует модель персонажа(с указанным размером)

* @param
* fCharacterScale : масштаб

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //Получение хендлера
* c_handle.SetCharacterScale(1.03f); //масштабирует до размера 1.03 (относительно внутриигровых размеров, базовый размер 1)
*/
native final function SetCharacterScale( float fCharacterScale );

/**
* 뷰포트에 보이는 캐릭터의 X 방향 위치를 조정한다

* @param
* nOffsetX : x좌표

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //핸들을 가져온다
* c_handle.SetCharacterOffsetX(-4); //-4 위치로 이동시킨다
*/
native final function SetCharacterOffsetX( int nOffsetX );

/**
* 뷰포트에 보이는 캐릭터의 X 방향 위치를 조정한다

* @param
* nOffsetY : y좌표

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //핸들을 가져온다
* c_handle.SetCharacterOffsetY(-3); //-3 위치로 이동시킨다
*/
native final function SetCharacterOffsetY( int nOffsetY );

native final function SpawnNPC();

/**
* 뷰포트에 보이는 캐릭터에게 액션을 시킨다

* @param
* index : 액션의 종류

* @return
* void

* @example
* var CharacterViewportWindowHandle c_handle;
* c_handle = GetCharacterViewportWindowHandle("InventoryWnd.ObjectViewport"); //핸들을 가져온다
* c_handle.PlayAnimation(2); //인사하는 액션을 취한다
*/
native final function PlayAnimation(int index);
native final function ShowNPC(float Duration);
native final function HideNPC(float Duration);
defaultproperties
{
}
