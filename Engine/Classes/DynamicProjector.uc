//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class DynamicProjector extends Projector;

function Tick(float DeltaTime)
{
	DetachProjector();
	AttachProjector();
}

defaultproperties
{
     bDynamicAttach=True
     bStatic=False
}
