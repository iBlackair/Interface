//=============================================================================
// ParticleEmitter: Base class for sub- emitters.
//
// make sure to keep structs in sync in UnParticleSystem.h
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class ParticleEmitter extends Object
	abstract
	editinlinenew
	native;

enum EBlendMode
{
	BM_MODULATE,
	BM_MODULATE2X,
	BM_MODULATE4X,
	BM_ADD,
	BM_ADDSIGNED,
	BM_ADDSIGNED2X,
	BM_SUBTRACT,
	BM_ADDSMOOTH,
	BM_BLENDDIFFUSEALPHA,
	BM_BLENDTEXTUREALPHA,
	BM_BLENDFACTORALPHA,
	BM_BLENDTEXTUREALPHAPM,
	BM_BLENDCURRENTALPHA,
	BM_PREMODULATE,
	BM_MODULATEALPHA_ADDCOLOR,
	BM_MODULATEINVALPHA_ADDCOLOR,
	BM_MODULATEINVCOLOR_ADDALPHA,
	BM_HACK	
};

enum EParticleDrawStyle
{
	PTDS_Regular,
	PTDS_AlphaBlend,
	PTDS_Modulated,
	PTDS_Translucent,
	PTDS_AlphaModulate_MightNotFogCorrectly,
	PTDS_Darken,
	PTDS_Brighten
};

enum EParticleCoordinateSystem
{
	PTCS_Independent,
	PTCS_Relative,
	PTCS_Absolute,
//#ifdef __L2 //kurt
	PTCS_RelativeRotation,
	// __L2 // by nonblock
	PTCS_Spray,
	// __L2 // by elsacred
//#ifdef L2_WEATHER_SYSTEM
	PTCS_RelativePosition,
//#endif
	PTCS_ScreenAbsolute,
	PTCS_ScreenRelative
//#endif
};

//solasys
enum EParticleParticleChoice
{
	PTWC_MaxParticle,
	PTWC_ParticlePerSecond
};

enum EParticleRotationSource
{
	PTRS_None,
	PTRS_Actor,
	PTRS_Offset,
	PTRS_Normal
};

enum EParticleVelocityDirection
{
	PTVD_None,
	PTVD_StartPositionAndOwner,
	PTVD_OwnerAndStartPosition,
	PTVD_AddRadial
};

enum EParticleStartLocationShape
{
	PTLS_Box,
	PTLS_Sphere,
	PTLS_Polar,
	PTLS_All
};

enum EParticleEffectAxis
{
	PTEA_NegativeX,
	PTEA_PositiveZ
};

enum EParticleCollisionSound
{
	PTSC_None,
	PTSC_LinearGlobal,
	PTSC_LinearLocal,
	PTSC_Random
};

enum EParticleMeshSpawning
{
	PTMS_None,
	PTMS_Linear,
	PTMS_Random
};

enum ESkelLocationUpdate
{
	PTSU_None,
	PTSU_SpawnOffset,
	PTSU_Location
};

struct ParticleTimeScale
{
	var () float	RelativeTime;		// always in range [0..1]
	var () float	RelativeSize;
};

struct ParticleRevolutionScale
{
	var () float	RelativeTime;		// always in range [0..1]
	var () vector	RelativeRevolution;
};

struct ParticleColorScale
{
	var () float	RelativeTime;		// always in range [0..1]
	var () color	Color;
};

struct ParticleVelocityScale
{
	var () float	RelativeTime;		// always in range [0..1]
	var () vector	RelativeVelocity;
};

struct Particle
{
	var vector	Location;
	var vector	OldLocation;
	var vector	Velocity;
	var vector	StartSize;
	var vector	SpinsPerSecond;
	var vector	StartSpin;
	var vector  RevolutionCenter;
	var vector  RevolutionsPerSecond;
	var vector	RevolutionsMultiplier;
	var vector	Size;
	var vector  StartLocation;
	var vector  ColorMultiplier;
	var vector	VelocityMultiplier;
	var vector	OldMeshLocation;
	var color	Color;
	var float	Time;
	var float	MaxLifetime;
	var float	Mass;
	var int		HitCount;
	var int		Flags;
	var int		Subdivision;
	var int 	BoneIndex;
//#ifdef __L2 //kurt
	var Rotator	Rotation;
	var vector	Acceleration;
//#endif
};

struct ParticleSound
{
	var () sound	Sound;
	var () range	Radius;
	var () range	Pitch;
	var () int		Weight;
	var () range	Volume;
	var () range	Probability;
};

var (Acceleration)	vector						Acceleration;

//#ifdef __L2 // by nonblock
var (Acceleration)	bool						IndependentSprayAccel;	// if PTCS_Spray and true, VelocityLoss and Accel are 'PTCS_Independent' value.
//#endif

var (Collision)		bool						UseCollision;
var (Collision)		vector						ExtentMultiplier;
var (Collision)		rangevector					DampingFactorRange;
var (Collision)		bool						UseCollisionPlanes;
var (Collision)		array<plane>				CollisionPlanes;
var	(Collision)		bool						UseMaxCollisions;
var (Collision)		range						MaxCollisions;
var (Collision)		int							SpawnFromOtherEmitter;
var (Collision)		int							SpawnAmount;
var (Collision)		rangevector					SpawnedVelocityScaleRange;
var (Collision)		bool						UseSpawnedVelocityScale;

var (Color)			bool						UseColorScale;
var (Color)			array<ParticleColorScale>	ColorScale;
var (Color)			float						ColorScaleRepeats;
var (Color)			rangevector					ColorMultiplierRange;
var (Color)			float						Opacity; // Added by Demiurge (PSE)
// #ifdef __L2 nonblock
var (Color)			transient float				OpacityRatio;
// #endif
var (Color)			bool						UseCloudColor;

var (Fading)		plane						FadeOutFactor;
var (Fading)		float						FadeOutStartTime;
var (Fading)		bool						FadeOut;
var (Fading)		plane						FadeInFactor;
var (Fading)		float						FadeInEndTime;
var (Fading)		bool						FadeIn;

var (Force)			bool						UseActorForces;

var (General)		int							MaxActiveDistance;
var (General)		EParticleCoordinateSystem	CoordinateSystem;
var (General)		const int					MaxParticles;
var (General)		bool						ResetAfterChange;
var (General)		EParticleEffectAxis			EffectAxis;

//solasys
var (General)		const int					LevelOfWeather;
var (General)		const int					CheckLevelOfWeather;
var (General)		EParticleParticleChoice		ParticleChoice;
var (General)		bool						WeatherEffect;
// winkey : WeatherRangeTimeјУјєА» WeatherEffectї©єОїЎ °ь°и ѕшАМ »зїл°ЎґЙ ЗПµµ·П єЇ°ж - 2010.9.13
var (General)		array<range>				WeatherRangeTime;
var (General)		bool						WeatherSoundCheck;

var					bool						IsRepresentativeParticle;
//#ifdef __L2//kurt
var (General)		bool						ForcedLifeTime;
var (General)		bool						ForcedFade;
var (General)		bool						ForcedMaxParticles;
//#endif
var (General)		bool						AlwaysFullSpawnRate;		// АМЖСЖ® З°Бъ їЙјЗїЎ єЇИ­їЎµµ ЗЧ»у ЅєЖщ єсАІА» 1.0f ·О АЇБц ЗТБц ї©єО - y2jinc

var (Local)			bool						DestroyWhenHitTarget;		// ProjectileАМ TargetїЎ Hit µЗѕъА» ¶§ Destroy ЗТБц ї©єО
var (Local)			bool						RespawnDeadParticles;
var (Local)			bool						AutoDestroy;
var (Local)			bool						AutoReset;
var (Local)			bool						Disabled;
var (Local)			bool						DisableFogging;
var (Local)			range						AutoResetTimeRange;
var (Local)			string						Name;

var (Location)		vector						StartLocationOffset;
var (Location)		rangevector					StartLocationRange;
var (Location)		int							AddLocationFromOtherEmitter;
var (Location)		EParticleStartLocationShape StartLocationShape;
var (Location)		range						SphereRadiusRange;
var (Location)		rangevector					StartLocationPolarRange;

var (Mass)			range						StartMassRange;

var (MeshSpawning)	staticmesh					MeshSpawningStaticMesh;
var (MeshSpawning)	EParticleMeshSpawning		MeshSpawning;
var (MeshSpawning)	rangevector					VelocityScaleRange;
var (MeshSpawning)	rangevector					MeshScaleRange;
var (MeshSpawning)	bool						VelocityFromMesh;
var (MeshSpawning)	bool						UniformMeshScale;
var (MeshSpawning)	bool						UniformVelocityScale;
var (MeshSpawning)	bool						UseColorFromMesh;
var (MeshSpawning)	bool						SpawnOnlyInDirectionOfNormal;
var (MeshSpawning)	vector						MeshNormal;
var (MeshSpawning)	range						MeshNormalThresholdRange;

var (Rendering)		int							AlphaRef;
var (Rendering)		bool						AlphaTest;
var (Rendering)		bool						AcceptsProjectors;
var (Rendering)		bool						ZTest;
var (Rendering)		bool						ZWrite;

var (Revolution)	bool						UseRevolution;
var (Revolution)	bool						UseRevolutionScale;
var (Revolution)	rangevector					RevolutionCenterOffsetRange;
var (Revolution)	rangevector					RevolutionsPerSecondRange;
var (Revolution)	array<ParticleRevolutionScale> RevolutionScale;
var (Revolution)	float						RevolutionScaleRepeats;

var (Rotation)		EParticleRotationSource		UseRotationFrom;
var (Rotation)		bool						SpinParticles;
var (Rotation)		bool						DampRotation;
var (Rotation)		rotator						RotationOffset;
var (Rotation)		vector						SpinCCWorCW;
var (Rotation)		rangevector					SpinsPerSecondRange;
var (Rotation)		rangevector					StartSpinRange;
var (Rotation)		rangevector					RotationDampingFactorRange;
var (Rotation)		vector						RotationNormal;

var (Size)			bool						UseSizeScale;
var (Size)			bool						UseRegularSizeScale;
var (Size)			bool						UniformSize;
var (Size)			array<ParticleTimeScale>	SizeScale;
var (Size)			float						SizeScaleRepeats;
var (Size)			rangevector					StartSizeRange;

var (SkeletalMesh)	ESkelLocationUpdate			UseSkeletalLocationAs;
var	(SkeletalMesh)	actor						SkeletalMeshActor;
var (SkeletalMesh)	vector						SkeletalScale;
var (SkeletalMesh)	range						RelativeBoneIndexRange;

var (Sound)			array<ParticleSound>		Sounds;
var (Sound)			EParticleCollisionSound		SpawningSound;
var (Sound)			range						SpawningSoundIndex;
var (Sound)			range						SpawningSoundProbability;
var (Sound)			EParticleCollisionSound		CollisionSound;
var (Sound)			range						CollisionSoundIndex;
var (Sound)			range						CollisionSoundProbability;

var (Spawning)		float						ParticlesPerSecond;
var (Spawning)		float						InitialParticlesPerSecond;
var (Spawning)		bool						AutomaticInitialSpawning;
	
var (Texture)		EParticleDrawStyle			DrawStyle;
var (Texture)		texture						Texture;
var (Texture)		int							TextureUSubdivisions;
var (Texture)		int							TextureVSubdivisions;
var (Texture)		bool						BlendBetweenSubdivisions;
var (Texture)		bool						UseRandomSubdivision;
var	(Texture)		bool						UseSubdivisionScale;
var (Texture)		array<float>				SubdivisionScale;
var (Texture)		int							SubdivisionStart;
var (Texture)		int							SubdivisionEnd;

var (Tick)			float						SecondsBeforeInactive;
var (Tick)			float						MinSquaredVelocity;

var	(Time)			range						InitialTimeRange;
var (Time)			range						LifetimeRange;
var (Time)			range						InitialDelayRange;

var (Trigger)		bool						TriggerDisabled;
var (Trigger)		bool						ResetOnTrigger;
var (Trigger)		range						SpawnOnTriggerRange;
var (Trigger)		float						SpawnOnTriggerPPS;

var (Velocity)		rangevector					StartVelocityRange;
var (Velocity)		range						StartVelocityRadialRange;
var (Velocity)		vector						MaxAbsVelocity;
var (Velocity)		rangevector					VelocityLossRange;
var (Velocity)		int							AddVelocityFromOtherEmitter;
var (Velocity)		rangevector					AddVelocityMultiplierRange;
var (Velocity)		EParticleVelocityDirection	GetVelocityDirectionFrom;
var (Velocity)		bool						UseVelocityScale;
var (Velocity)		array<ParticleVelocityScale> VelocityScale;
var (Velocity)		float						VelocityScaleRepeats;

var (Warmup)		float						WarmupTicksPerSecond;
var (Warmup)		float						RelativeWarmupTime;

var (Texture)		array<Material>				CustomMaterials;

var (SoftParticle)	bool						UseSoftParticle;
var (SoftParticle)	float						SoftParticleFadeDist;

var transient		emitter						Owner;
var	transient		bool						Initialized;
var transient		bool						Inactive;
var	transient		bool						RealDisableFogging;
var transient		bool						AllParticlesDead;
var transient		bool						WarmedUp;
var	transient		bool						bOwnerTracking;
var transient		bool						InActiveUntilReset;
var transient		bool						IsOutOfActiveDistance;		// lpislhy. Is ParticleEmitter out of MaxActiveDistance?
var transient		float						InactiveTime;
var transient		array<Particle>				Particles;
var transient		int							ParticleIndex;			// index into circular list of particles
var transient		int							ActiveParticles;		// currently active particles
var transient		float						PPSFraction;			// used to keep track of fractional PPTick
var transient		box							BoundingBox;

var transient		vector						RealExtentMultiplier;
var	transient		int							OtherIndex;
var transient		float						InitialDelay;
var transient		vector						GlobalOffset;
var transient		float						TimeTillReset;
var transient		int							PS2Data;
var transient		int							MaxActiveParticles;
var transient		int							CurrentCollisionSoundIndex;
var transient		int							CurrentSpawningSoundIndex;
var transient		int							CurrentMeshSpawningIndex;
var transient		float						MaxSizeScale;
var transient		int							KillPending;
var transient		int							DeferredParticles;
var transient		vector						RealMeshNormal;
var transient		array<vector>				MeshVertsAndNormals;
var transient		int							CurrentSpawnOnTrigger;

var	transient		float						CurLifeTime;
var transient		float						Speed;

var transient		ParticleMaterial			ParticleMaterial;
var transient		int							InRangeTime;

native function SpawnParticle( int Amount );
native function Trigger();

defaultproperties
{
}
