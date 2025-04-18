class SceneEditorAPI extends Object
	native;

native static function InitSceneEditorData();
native static function PlayScene(int EndSceneNo, bool bShowInfo);
native static function AddScene(int Index);
native static function DeleteScene(int Index);
native static function CopyScene(int SrcIndex, int DestIndex);
native static function LoadSceneData(string FileName);
native static function SaveSceneData(string FileName, string CurPath, bool bForceToPlay);
native static function GetCurSceneTimeAndDesc(int Index, out int Time, out string Desc);
native static function SaveCurSceneTimeAndDesc(int Index, int Time, string Desc);
defaultproperties
{
}
