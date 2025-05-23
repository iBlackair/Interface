//=============================================================================
// Emitter: An Unreal Mesh Particle Emitter.
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class MeshEmitter extends ParticleEmitter
	native;

var (Mesh)		staticmesh		StaticMesh;
var (Mesh)		bool			UseMeshBlendMode;
var (Mesh)		bool			RenderTwoSided;
var (Mesh)		bool			UseParticleColor;
var ()			bool			IsEnchantEffect;

var	transient	vector			MeshExtent;

defaultproperties
{
     UseMeshBlendMode=True
     StartSizeRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
}
