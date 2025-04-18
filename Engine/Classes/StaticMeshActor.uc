//=============================================================================
// StaticMeshActor.
// An actor that is drawn using a static mesh(a mesh that never changes, and
// can be cached in video memory, resulting in a speed boost).
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class StaticMeshActor extends Actor
	native
	placeable;

var() bool bExactProjectileCollision;		// nonzero extent projectiles should shrink to zero when hitting this actor

defaultproperties
{
     bExactProjectileCollision=True
     DrawType=DT_StaticMesh
     bStatic=True
     bWorldGeometry=True
     bShadowCast=True
     bStaticLighting=True
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
     bBlockKarma=True
     bEdShouldSnap=True
}
