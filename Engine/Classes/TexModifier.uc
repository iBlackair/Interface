//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class TexModifier extends Modifier
	noteditinlinenew
	native;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var enum ETexCoordSrc
{
	TCS_Stream0,
	TCS_Stream1,
	TCS_Stream2,
	TCS_Stream3,
	TCS_Stream4,
	TCS_Stream5,
	TCS_Stream6,
	TCS_Stream7,
	TCS_WorldCoords,
	TCS_CameraCoords,
	TCS_WorldEnvMapCoords,
	TCS_CameraEnvMapCoords,
	TCS_ProjectorCoords,
	TCS_NoChange,				// don't specify a source, just modify it
} TexCoordSource;

var() enum ETexCoordCount
{
	TCN_2DCoords,
	TCN_3DCoords,
	TCN_4DCoords
} TexCoordCount;

var() bool TexCoordProjected;

defaultproperties
{
     TexCoordSource=TCS_NoChange
}
