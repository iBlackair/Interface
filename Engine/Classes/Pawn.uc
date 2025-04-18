//=============================================================================
// Pawn, the base class of all actors that can be controlled by players or AI.
//
// Pawns are the physical representations of players and creatures in a level.  
// Pawns have a mesh, collision, and physics.  Pawns can take damage, make sounds, 
// and hold weapons and other inventory.  In short, they are responsible for all 
// physical interaction between the player or AI and the world.
//
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
// ?????????? ?????????????????????? ?? ?????????????????????? BITHACK
//=============================================================================
class Pawn extends Actor 
	abstract
	native
	placeable
	config(user)
	nativereplication
	;

#exec Texture Import File=Textures\Pawn.pcx Name=S_Pawn Mips=Off MASKED=1

//-----------------------------------------------------------------------------
// Pawn variables.

var			mesh			SubMeshes[9];			// SubMesh if DrawType=DT_Mesh.
var			mesh			RightHandMesh;			// RightHandMesh if DrawType=DT_Mesh.
var			mesh			LeftHandMesh;			// LeftHandMesh if DrawType=DT_Mesh.
var			mesh			RightArmMesh;			// ArmHandMesh if DrawType=DT_Mesh.
var			mesh			LeftArmMesh;			// ArmHandMesh if DrawType=DT_Mesh.
var			mesh			CloakMesh;				// CloakMesh if DrawType=DT_Mesh.
var			mesh			CloakCoverMesh;			// CloakMesh if DrawType=DT_Mesh.

var transient MeshInstance SubMeshInstances[9];		// Mesh instance.
var transient MeshInstance RightHandMeshInstance;	// RightHandMesh instance.
var transient MeshInstance LeftHandMeshInstance;	// LeftHandMesh instance.
var transient MeshInstance RightArmMeshInstance;	// RightArmMesh instance.
var transient MeshInstance LeftArmMeshInstance;		// LeftArmMesh instance.
var transient MeshInstance CloakMeshInstance;		// CloakMesh instance.
var transient MeshInstance CloakCoverMeshInstance;	// CloakMesh instance.

var name RightHandBone;
var name LeftHandBone;
var name RightArmBone;
var name LeftArmBone;
var name SpineBone;
var name LowbodyBone;
var name CapeBone;
var name RightFootBone;
var name LeftFootBone;
// L2_KAMAEL
var name WingBone;
var name LeftUpperArmBone;
var name RightUpperArmBone;
var name LeftShoulderBone;
var name RightShoulderBone;
var int  EffectSpawnBoneIdx;
var name SecondHeadBone;
var bool bHasSecondHeadBone;
var bool bDonotApplyAdjustPawnLocation;

var	config	 Material		SubSkins[9];		// SubMesh skin support.
var	config	 Material		RightHandSkins;		// RightHandMesh Skin support.
var	config	 Material		LeftHandSkins;		// LeftHandMesh Skin support.
var	config	 Material		RightArmSkins;		// RightArmMesh Skin support.
var	config	 Material		LeftArmSkins[3];	// LeftArmMesh Skin support.
var	config	 Material		CloakSkins[2];		// CloakMesh Skin support.

// __L2 Hunter
var(NpcPos)	string	nickname;
var(NpcPos)	name	ai;
var(NpcPos)	array<NpcPrivate> Privates;
var(NpcPos)	WhenExtinctionCreate when_extinction_create;
var(NpcPos)	bool	bWayPointsShow;
var(NpcPos)	array<WayPoint> WayPoints;

// __L2 kinggoat
var float       WeaponScale;

var transient bool		bIsScenePawn; //?????????????????? ????????? ?????????

enum MagicInfoSlot 
{
	MIS_FIRST,
	MIS_SECOND
};

var transient NMagicInfo	MagicInfo[2];
var transient bool			bDblCasting;
var transient int			DblCastingSlot;
var transient name			PlaythroughAnim;

// flagoftiger
var			mesh			SubMeshesBuffer[9];
var			Material		SubSkinsBuffer[9];
var			mesh			RightHandMeshBuffer;
var			Material		RightHandSkinsBuffer;
var			mesh			LeftHandMeshBuffer;
var			Material		LeftHandSkinsBuffer;
var			mesh			RightArmMeshBuffer;
var			Material		RightArmSkinsBuffer;
var			mesh			LeftArmMeshBuffer;
var			Material		LeftArmSkinsBuffer[3];
var			mesh			CloakMeshBuffer;
var			Material		CloakSkinsBuffer[2];
var			mesh			CloakCoverMeshBuffer;

// __L2 Hunter
enum NActionList 
{
	NACT_NONE,
	NACT_MELEEATTACK,
	NACT_RANGEDATTACK,
	NACT_PICITEM,
	NACT_CHANGEITEM,
	NACT_SKILLUSE,
	NACT_SKILLINPUTWAIT,	// anima	
	NACT_THROWATTACK,
	NACT_SHOTATTACK,
	NACT_PRIVATESTORE,
	NACT_OBSERVING,
	NACT_SKILLINPUTWAIT2,	// elsacred
};

// for double casting - lancelot 2010. 7. 13.
enum DoubleCastingState
{
	DCS_None,
	DCS_MustPlayBaseAnim,
	DCS_CastingMagicInfo,
	DCS_TerminatedAllMagicInfo
};

struct NActionPtr
{
	var	int		Ptr;
};
struct native NAttackActionParam
{
	var	int		Damage;	
	var	bool	bMiss;
	var	bool	bCritical;
	var	bool	bShieldDefense;
	var	bool	bSpirit;
	var int		SoulshotGrade;
	var int		JewelItemClassID;  // JEWEL ?????? - by y2jinc (2013. 9. 4)
	var actor   ActionTarget;
};
struct native NPrimeActionParam
{
	var	int		ActionID;
	var	int		Damage;
	var	bool	bMiss;
	var	bool	bCritical;
	var	bool	bShieldDefense;
	var	bool	bSpirit;
	var int		SoulshotGrade;
	var actor   ActionTarget;
	var int		MaxAtkShotNum;
	var int		CurAtkShotNum;
// #ifdef __L2 // anima
	var	int		SkillID;			// use when ActionID is NACT_SKILLINPUTWAIT
	//var int		SkillLevel;			// elsacred
// #endif

	var int		JewelItemClassID;  // JEWEL ?????? - by y2jinc (2013. 9. 4)

	var array<NAttackActionParam> NAssociatedAttackParam;
};

struct native NAtkConsumeItemParam
{	
	var int		RangedAttackItemID;
	var int		RangedAttackConsumeItemID;
};

struct native NSilhouetteParam
{
	var byte Type;
	var byte R;
	var byte G;
	var byte B;
};

struct native ChannelingData
{
	var int targetID;
	var	Emitter ChannelingEmitter;
};

//branch 110824
struct native BoneAdditionalEffect
{
	var name	EffectName;
	var	name	BoneName;
	var	Emitter Emitter;	
	var bool	bDestory;
};
var array<BoneAdditionalEffect> BoneAttachedAdditionalEffects;
//end of branch

var	transient int		FollowTargetCreatureID;
var transient int		FollowDistance;

var NSilhouetteParam	NSilhouetteData;
var NPrimeActionParam	NPrimeAction;
var array<NActionPtr> NActions;
var NAtkConsumeItemParam	NAtkConsumeItem;

var array<ExtraMeshData> ExtraMeshDatas;

var bool		IsGetFrameSkippable;
var bool        bUpdateMovementAnim;

var bool		bPhysicInit;
var bool		bAsTreatWorld;
var bool		bIgnorePhysics;
var bool		CanBeIgnoredCollision;
var bool		bPlayingSpecialAnim;
var bool		bFaceRotation;
var bool		bEnableFaceRotation;
var	bool		bNpc;
var bool		bNpcUsePCMesh;
var bool		bWantChangeYaw;
var	bool		bTurning;
var	bool		bNotRotationMoving;
var rotator		LastNeckRot;
var rotator		LastBodyRot;
var	int			CharClassID;
var	int			NpcClassID;
var int			AttackItemClassID;
var int			DefenseItemClassID;
var int			ShieldItemClassID;

// removed by lancelot
// For halloween event - lancelot 2009. 10. 7
//var int			BR_HairItemClassID;

var float		AttackSpeedRate;
var float		NonAttackSpeedRate;
var float		SkillSpeedRate;
var float		PhysicalSkillSpeedRate;
var float		MoveTimer;
var float		MoveToPawnAdjust;
var int			MoveEmergencyLevel;
var int			WalkAnimFrameInMove;
var float		ValidateLocationMoveTime;
var float		ValidateLocationSpeed;
var int			WantedYaw;
var	int			TurningDir;

var float		TweenTimeForLargePawn;

var class<Emitter>	DamageEffect;
//#ifdef	SHOULDER_EFFECT
//var Emitter		ShoulderEffect[2];
//#endif
var float		GroundMaxSpeed;
var float		GroundMinSpeed;
var float		WaterMaxSpeed;
var float		WaterMinSpeed;
var float		AirMaxSpeed;
var float		AirMinSpeed;
var float		HoverMaxSpeed;
var float		HoverMinSpeed;

var enum EUpdateMovementAnimType
{
	UM_NONE,
	UM_ONCE,
	UM_FORCE

} UpdateMovementAnimType;

// WeaponType ?????? Animation??? ?????? ???????????? ????????????.
// WeaponType ??? ???????????????
// 1. PawnAnimData.h??? ?????? WEAPONTYPE_NUM ????????? ??????????????????.
// 2. PawnSheathingMgr.uc??? ?????? WEAPONTYPE_CNT??? ????????? ??????????????????.
// 3. ??????????????? ????????? ?????? L2GameData.cpp??? ?????? Charagrp.txt?????? ????????? sound ???????????? ????????? ????????????????????????
// 4. ????????? ????????? ????????? ??? ???????????? ?????????????????? AbnormalProcess.cpp?????? ????????????????????????
// 5. ?????? ?????? BOW??? CROSSBOW ??????????????? ?????? ????????? ??? ??????????????????(????????? ?????? ???)
// 6. ??????????????? ????????? ?????? L2GameData.cpp?????? ?????????????????? ?????? ????????? soulshot.int?????? ???????????? ????????? ??????(WeaponString[]. ?????? ??????????????? ???????????? ??????????????? ?????? ?????????????????????.
enum WeaponType
{
	WT_HAND,
	WT_1HS,
	WT_2HS,
	WT_DUAL,
	WT_POLE,
	WT_BOW,
	WT_THROW,	
	WT_DUALFIST,
	WT_CROSSBOW,//#ifdef L2_KAMAEL	
	WT_RAPIER,	
	WT_DUALDAGGER,
	WT_TWOHANDCROSSBOW,
	WT_DAGGER,
	WT_DUALBLUNT,
	WT_STAFF
};
//kurt ride temp
enum RideType
{
	RD_NONE,
	RD_STRIDER,
	RD_WYVERN,
	RD_WOLF,
	RD_TRANSFORM_HORSE,
	RD_TRANSFORM_LION,
	RD_TRANSFORM_SLEDGE,
	RD_TRANSFORM_PLATFORM,
	RD_TRANSFORM_FOX,
};

var pawn		RidePawn;
var RideType	CurRideType;
var WeaponType	CurWeaponType;
var bool		bRide;
var bool		bDriver;
var int			VehicleType;

enum FlyType
{
	FLY_NONE,
	FLY_BIRD,
	FLY_FLOATING_A,
	FLY_FLOATING_B,
	FLY_SHUTTLE
};

var FlyType		FlyingType;
var bool		bFly;

// #ifdef __L2 // idearain
enum FishingType
{
	FST_NONE,
	FST_WAIT,
	FST_BATTLE
};

// ????????? ?????? - lancelot 2010. 8. 23.
enum SheathingState
{
	SS_UNSHEATHING,
	SS_SHEATHING
};

enum FlyMoveState
{
	FMT_NONE,
	FMT_JUMP_LOW,
	FMT_JUMP_MID,
	FMT_JUMP_HIGH,
	FMT_LOW,
	FMT_MID,
	FMT_HIGH,
	FMT_EXP_LOW,
	FMT_EXP_MID,
	FMT_EXP_HIGH
};

struct native constructive SheathingInfo
{
	var name AttachBoneName;
	var rotator	AttachRotation;
	var vector		AttachOffset;
	var vector		OffsetForMantle;
	var bool		HideSheathing;
};

var SheathingState	m_SheathingState;
var name			m_SheathingMgrName;

var name		m_AliasMgrName;

var bool		bFish;
var FishingType	CurFishingType;
var actor		FishLine;
var L2Float		FishFloat;
var ViewportWindowController	VWController;
// #endif

// #ifdef __L2 // idearain
var float		SkinNotifyElapsedTime;
var float		SkinNotifyNextStartTime;
// #endif

//#ifdef __L2 // kurt 
var int					bDemageStatus;
var float				DemageDist;
var bool				bDemageAct;
//#ifdef GSTAR2010 ????????? ??????????????? ???????????? ???????????? ????????????
var bool				bPhysicalSkillDamageAct;
//#endif

var bool				bSpineRotation;
var bool				bTargetSpineRotation;
var	transient bool		bCreatedResource;
var	transient vector	EffTargetLocation;
var	transient int		LoadingResourceRef;

// by nonblock
var(CurveProjectile) int				Curvature;	// ??????
var(CurveProjectile) float			WaistAngle; // ?????????

// by idearain(????????????)
var vector				WarpDest;
var	bool				IsWarpDest;
var bool				bReadyToWarp;
var bool				bIgnoreToWarp;

//solasys-???????????? ????????? ???????????? run ?????????????????? ?????? ????????? ??????????????????
var bool		bTreasureMimic;
var bool		bTreasureMimicEven;

// by nonblock(Swimming)
// var transient	bool bForceSwim;
var transient	bool bHitGroundInWater;	// only valid if physics == PHYS_Swimming
var transient	bool bSwimAfloat;
var transient	int	 Environment;
//var float SpawnBubblePeriod;
var transient	rotator	LastFootRot;

var transient private FlyMoveState FlyMoveType;

var Controller Controller;

// cache net relevancy test
var float NetRelevancyTime;
var playerController LastRealViewer;
var actor LastViewer;

// Physics related flags.
var bool		bJustLanded;		// used by eyeheight adjustment
var bool		bUpAndOut;			// used by swimming 
var bool		bIsWalking;			// currently walking (can't jump, affects animations)
var bool		bWarping;			// Set when travelling through warpzone (so shouldn't telefrag)
var bool		bWantsToCrouch;		// if true crouched (physics will automatically reduce collision height to CrouchHeight)
var const bool	bIsCrouched;		// set by physics to specify that pawn is currently crouched
var const bool	bTryToUncrouch;		// when auto-crouch during movement, continually try to uncrouch
var() bool		bCanCrouch;			// if true, this pawn is capable of crouching
var bool		bCrawler;			// crawling - pitch and roll based on surface pawn is on
var const bool	bReducedSpeed;		// used by movement natives
var bool		bJumpCapable;
var	bool		bCanJump;			// movement capabilities - used by AI
var	bool 		bCanWalk;
var	bool		bCanSwim;
var	bool		bCanFly;
var	bool		bCanClimbLadders;
var	bool		bCanStrafe;
var	bool		bCanDoubleJump;
var	bool		bAvoidLedges;		// don't get too close to ledges
var	bool		bStopAtLedges;		// if bAvoidLedges and bStopAtLedges, Pawn doesn't try to walk along the edge at all
var	bool		bNoJumpAdjust;		// set to tell controller not to modify velocity of a jump/fall	
var	bool		bCountJumps;		// if true, inventory wants message whenever this pawn jumps
var const bool	bSimulateGravity;	// simulate gravity for this pawn on network clients when predicting position (true if pawn is walking or falling)
var	bool		bUpdateEyeheight;	// if true, UpdateEyeheight will get called every tick
var	bool		bIgnoreForces;		// if true, not affected by external forces
var const bool	bNoVelocityUpdate;	// used by C++ physics
var	bool		bCanWalkOffLedges;	// Can still fall off ledges, even when walking (for Player Controlled pawns)
var bool		bSteadyFiring;		// used for third person weapon anims/effects
var bool		bCanBeBaseForPawns;	// all your 'base', are belong to us
var bool		bClientCollision;	// used on clients when temporarily turning off collision
var const bool	bSimGravityDisabled;	// used on network clients
var bool		bDirectHitWall;		// always call pawn hitwall directly (no controller notifyhitwall)

// used by dead pawns (for bodies landing and changing collision box)
var		bool	bThumped;		
var		bool	bInvulnerableBody;

// AI related flags
var		bool	bIsFemale;
var		bool	bAutoActivate;			// if true, automatically activate Powerups which have their bAutoActivate==true
var		bool	bCanPickupInventory;	// if true, will pickup inventory when touching pickup actors
var		bool	bUpdatingDisplay;		// to avoid infinite recursion through inventory setdisplay
var		bool	bAmbientCreature;		// AIs will ignore me
var(AI) bool	bLOSHearing;			// can hear sounds from line-of-sight sources (which are close enough to hear)
										// bLOSHearing=true is like UT/Unreal hearing
var(AI) bool	bSameZoneHearing;		// can hear any sound in same zone (if close enough to hear)
var(AI) bool	bAdjacentZoneHearing;	// can hear any sound in adjacent zone (if close enough to hear)
var(AI) bool	bMuffledHearing;		// can hear sounds through walls (but muffled - sound distance increased to double plus 4x the distance through walls
var(AI) bool	bAroundCornerHearing;	// Hear sounds around one corner (slightly more expensive, and bLOSHearing must also be true)
var(AI) bool	bDontPossess;			// if true, Pawn won't be possessed at game start
var		bool	bAutoFire;				// used for third person weapon anims/effects
var		bool	bRollToDesired;			// Update roll when turning to desired rotation (normally false)
var		bool	bIgnorePlayFiring;		// if true, ignore the next PlayFiring() call (used by AnimNotify_FireWeapon)

var		bool	bCachedRelevant;		// network relevancy caching flag
var		bool	bUseCompressedPosition;	// use compressed position in networking - true unless want to replicate roll, or very high velocities
var		globalconfig bool bWeaponBob;
var     bool    bHideRegularHUD;
var		bool	bSpecialHUD;
var		bool    bSpecialCalcView;		// If true, the Controller controlling this pawn will call 'SpecialCalcView' to find camera pos.
var		bool	bNoTeamBeacon;			// never display team beacon for this pawn
var		bool	bNoWeaponFiring;

var		byte	FlashCount;				// used for third person weapon anims/effects
// AI basics.
var 	byte	Visibility;			//How visible is the pawn? 0=invisible, 128=normal, 255=highly visible 
var		float	DesiredSpeed;
var		float	MaxDesiredSpeed;
var(AI) name	AIScriptTag;		// tag of AIScript which should be associated with this pawn
var(AI) float	HearingThreshold;	// max distance at which a makenoise(1.0) loudness sound can be heard
var(AI)	float	Alertness;			// -1 to 1 ->Used within specific states for varying reaction to stimuli 
var(AI)	float	SightRadius;		// Maximum seeing distance.
var(AI)	float	PeripheralVision;	// Cosine of limits of peripheral vision.
var()	float	SkillModifier;			// skill modifier (same scale as game difficulty)	
var const float	AvgPhysicsTime;		// Physics updating time monitoring (for AI monitoring reaching destinations)
var		float	MeleeRange;			// Max range for melee attack (not including collision radii)
var NavigationPoint Anchor;			// current nearest path;
var const NavigationPoint LastAnchor;		// recent nearest path
var		float	FindAnchorFailedTime;	// last time a FindPath() attempt failed to find an anchor.
var		float	LastValidAnchorTime;	// last time a valid anchor was found
var		float	DestinationOffset;	// used to vary destination over NavigationPoints
var		float	NextPathRadius;		// radius of next path in route
var		vector	SerpentineDir;		// serpentine direction
var		float	SerpentineDist;
var		float	SerpentineTime;		// how long to stay straight before strafing again
var const float	UncrouchTime;		// when auto-crouch during movement, continually try to uncrouch once this decrements to zero
var		float	SpawnTime;

// Movement.
var float   GroundSpeed;    // The maximum ground speed.
var float   WaterSpeed;     // The maximum swimming speed.
var float   AirSpeed;		// The maximum flying speed.
var float	LadderSpeed;	// Ladder climbing speed
var float	AccelRate;		// max acceleration rate
var float	JumpZ;      	// vertical acceleration w/ jump
var float   AirControl;		// amount of AirControl available to the pawn
var float	WalkingPct;		// pct. of running speed that walking speed is
var float	CrouchedPct;	// pct. of running speed that crouched walking speed is
var float	MaxFallSpeed;	// max speed pawn can land without taking damage (also limits what paths AI can use)
var vector	ConstantAcceleration;	// acceleration added to pawn when falling

// Player info.
var	string			OwnerName;		// Name of owning player (for save games, coop)
var travel Weapon	Weapon;			// The pawn's current weapon.
var Weapon			PendingWeapon;	// Will become weapon once current weapon is put down
var travel Powerups	SelectedItem;	// currently selected inventory item
var float      		BaseEyeHeight; 	// Base eye height above collision center.
var float        	EyeHeight;     	// Current eye height, adjusted for bobbing and stairs.
var	const vector	Floor;			// Normal of floor pawn is standing on (only used by PHYS_Spider and PHYS_Walking)
var float			SplashTime;		// time of last splash
var float			CrouchHeight;	// CollisionHeight when crouching
var float			CrouchRadius;	// CollisionRadius when crouching
var float			OldZ;			// Old Z Location - used for eyeheight smoothing
var PhysicsVolume	HeadVolume;		// physics volume of head
var float           HealthMax;      
var travel int      Health;         // Health: 100 = normal maximum
var	float			BreathTime;		// used for getting BreathTimer() messages (for no air, etc.)
var float			UnderWaterTime; // how much time pawn can go without air (in seconds)
var	float			LastPainTime;	// last time pawn played a takehit animation (updated in PlayHit())
var class<DamageType> ReducedDamageType; // which damagetype this creature is protected from (used by AI)
var byte            ViewPitch;      // jjs - something to replicate so we can see which way remote clients are looking
var float			HeadScale;

//#ifdef __L2 // zodiac
var PhysicsVolume	FootVolume;		// physics volume of Foot 
//#endif

// Sound and noise management
// remember location and position of last noises propagated
var const 	vector 		noise1spot;
var const 	float 		noise1time;
var const	pawn		noise1other;
var const	float		noise1loudness;
var const 	vector 		noise2spot;
var const 	float 		noise2time;
var const	pawn		noise2other;
var const	float		noise2loudness;
var			float		LastPainSound;

// view bob
var				globalconfig float Bob;
var				float				LandBob, AppliedBob;
var				float bobtime;
var				vector			WalkBob;

var float SoundDampening;
var float DamageScaling;

var localized  string MenuName; // Name used for this pawn type in menus (e.g. player selection) 

// shadow decal
var Projector Shadow;
//#ifdef __L2 //kurt
var ShadowProjector	Shadow1;
var bool		bIgnoreShadowClipping;
var bool		bSameAnim;
var	bool		bLongDeathWaitAnim;

var bool								bShowArrow;
var L2Alarm								OverHeadAlarm;
var vector								ArrowTarget;

var Emitter		HungerEmitter;

struct NPawnLightPtr
{
	var	int		Ptr;
};
struct NAbnormalStatPtr
{
	var	int		Ptr;
};
struct NAppendixEffectPtr
{
	var	int		Ptr;
};
struct NWeaponEffectPtr
{
	var	int		Ptr;
};
struct NCursedWeaponEffectPtr
{
	var int		Ptr;
};
struct NBoneTransformationStatPtr
{
	var	int		Ptr;
};
var array<NPawnLightPtr>				NPawnLight;
var array<NAbnormalStatPtr>				NAbnormalStat;
var array<NBoneTransformationStatPtr>	NBoneTransformationStat;
var array<NCubics>						NCubicArray;
var	NAgathion							Agathion;
var array<NAppendixEffectPtr>			NAppendixEffect;
var array<NWeaponEffectPtr>				NWeaponEffect;
var Emitter								NHeroEffect;
var Emitter								NCuriousHouseWinnerEffect;
var Emitter								NUltimateSkillEffect;
var NCursedWeaponEffectPtr				NCursedWeaponEffect;
var array<Emitter>						NDecoEffect;

var Emitter								TutorialQuestMark;
var Emitter								NSpoilEffect;

//var array<Emitter>						BoneAttachedEffects; //branch 110824

//[QuestMark] - by jin
var Emitter								NQuestMarkEffect;

//branch
//var array<NAbnormalStatPtr>				BR_NAbnormalStat;

var bool	br_bChangedWeaponEffect;
//end of branch

var enum ESamePoseStat
{
	SPS_NONE,
	SPS_ONCE,
	SPS_TWICE

} SamePoseStat;

// blood effect
var class<Effects> BloodEffect;
var class<Effects> LowGoreBlood;

var class<AIController> ControllerClass;	// default class to use when pawn is controlled by AI (can be modified by an AIScript)

var PlayerReplicationInfo PlayerReplicationInfo;

var LadderVolume OnLadder;		// ladder currently being climbed

var name LandMovementState;		// PlayerControllerState to use when moving on land or air
var name WaterMovementState;	// PlayerControllerState to use when moving in water

var PlayerStart LastStartSpot;	// used to avoid spawn camping
var float LastStartTime;

//__L2 kinggoat
var int    ComboAnimPlayNum; 
var name   ComboAnimPlayName[8];
var int    ComboAnimPlayCount;
//End

// Animation status
var name AnimAction;			// use for replicating anims 

// Animation updating by physics FIXME - this should be handled as an animation object
// Note that animation channels 2 through 11 are used for animation updating
var vector TakeHitLocation;		// location of last hit (for playing hit/death anims)
var class<DamageType> HitDamageType;	// damage type of last hit (for playing hit/death anims)
var vector TearOffMomentum;		// momentum to apply when torn off (bTearOff == true)
var EPhysics OldPhysics;
var bool bPhysicsAnimUpdate;	
var bool bWasCrouched;
var bool bWasWalking;
var bool bWasOnGround;
var bool bInitializeAnimation;
var bool bPlayedDeath;

// jjs - physics based animation stuff
var bool bIsIdle;           // true when standing still on the ground, Physics can be used for determining other states
var bool bWaitForAnim;      // true if the pawn is playing an important non-looping animation (eg. landing/dodge) and doesn't feel like being interrupted
var const bool bReverseRun;
var bool bDoTorsoTwist;
var const bool FootTurning;
var const bool FootStill;

var float OldRotYaw;			// used for determining if pawn is turning
var vector OldAcceleration;
var float BaseMovementRate;		// FIXME - temp - used for scaling movement
var name MovementAnims[4];		// Forward, Back, Left, Right
var name TurnLeftAnim;
var name TurnRightAnim;			// turning anims when standing in place (scaled by turn speed)
var(AnimTweaks) float BlendChangeTime;	// time to blend between movement animations
var float MovementBlendStartTime;	// used for delaying the start of run blending
var float ForwardStrafeBias;	// bias of strafe blending in forward direction
var float BackwardStrafeBias;	// bias of strafe blending in backward direction

// #ifdef __L2 unbalans
var String ChatMsg;
// #endif
//#ifdef __L2 //kurt
var vector               HitLocation; //hit watervolume Hit Pos
var	float				 HitWaterEffectTimer;
var transient float      RecentHitWaterInterval;	// by nonblock
//#endif
// #ifdef __L2 yohan
//var int m_PrivateStoreChatMsg;
var string PrivateStoreChatMsg;
var string PrivateBuyChatMsg;
var string PrivateStoreWholeChatMsg;		// lancelot 2007. 1. 16
// #endif
// #ifdef __L2 unbalans
var string RecipeShopMsg;
// var INT64 AbnormalVisualEffectType;
var transient array<INT> AbnormalVisualEffectTypes;
//var int AbnormalVisualEffectStopMoveFlag;
//var float AbnormalVisualEffectLifeTime;
var int AppendixEffectType;
// #endif

//branch
//var int BR_ExtraVisualEffectType;
//end of branch

// #ifdef __L2 kurt
var MarkProjector Mark;
var rotator		TargetDirSpineRot;
var bool  bNeedTurnAnim;
// #endif

// #ifdef __L2 // zodiac
var bool bPlayerCharacter; // ??? ???????????? Character??? Mouse??? ???????????? ????????? ?????? ??????.
var float BoundRadius;
// #endif

// #ifdef __L2 // zodiac
var float fBlinkTime;
var bool bShowGuilty;
// #endif
// #ifdef __L2 // elsacred
var const float fTotalAcceleratedBlickTime;
var const float fInitBlinkGap;
var const float flastBlinkGap;
var float fAcceleratedRate;
var float	fCurBlinkGap; 
var float	fCurAcceleratedBlinkTime;
// #endif

// #ifdef __L2 // zodiac
var bool bLobbyCharacter;
var name LobbyWaitAnim;
var float NameOffset;
var float DeadNameOffset;
// #endif

// #ifdef __L2 // idearain
var float fMaxAirSpeed;
var float fMinAirSpeed;
var float fAirSpeedAccel;		// AirSpeed??? ?????? ?????????
var int CameraWalkingAccelMode;	// CameraWalkingMode ?????? ????????? ??????
var float fMaxAirSpeedIncRate;	// fMaxAirSpeed??? ?????? ?????????
// #endif

// #ifdef __L2 // by nonblock
var float CastingEffectScale;
var vector CastingEffectOffset;
var bool bUseDarkEffect;

var bool bIsHero;
var bool bHeroWeapon;
// #endif

var int CHState; //?????????????????????

// ProjectedTargetEffect ??????
var bool bUseProjectedTargetEffect;
var string ProjectedTargetEffectName;
var float fProjectedTargetEffectScale;

// #if __L2 // gigadeth
var bool bRendered;
// #endif

// #ifdef __L2 // idearain - ?????? ????????? ????????? ???????????? ???????????? ?????????
var bool bIsCursedWeapon;
var int CursedWeaponLevel;
// #endif

// #ifdef __L2 // flagoftiger
var int SoundableBootsClassID;	// Soundable Boots Class ID
// #endif
var int LastAttackItemClassID;
var int AttackItemEnchantedValue;

// #ifdef __L2 // idearain - ?????? ??????????????? ???????????? ???????????? ?????????
var int	AttackItemVariationOption1;
var int	AttackItemVariationOption2;
// #endif

// #ifdef __L2 // flagoftiger
var(Collision) const float OriCollisionRadius;		// Radius of collision cyllinder.
var(Collision) const float OriCollisionHeight;		// Half-height cyllinder.
var vector		HelmMeshOrigin;
var rotator		HelmMeshRotOrigin;
var vector		HairAcceMeshOrigin[2];
var rotator		HairAcceMeshRotOrigin[2];
// #endif

// #ifdef __L2 // ttmayrin
struct native NCollisionInfo
{
	var vector	RelativeLocation;
	var float	CollisionRadius;
	var float	CollisionHeight;
};
var(Collision) array<NCollisionInfo> ExCollisionInfos;	// Extra Collision Infomations.
// #endif

// #ifdef __L2 // yohan
var array<int> NQuestList;
// #endif

// [QuestMark] - by jin
var array<int> NQuestStepList;

// flagoftiger - 0?????? ?????? ?????????????????? ?????? ?????????. (TIck ?????? ????????????.)
var float		fAutoTargetPendingTime;
var pawn		AutoTargetPawn;
// flagoftiger - SetPawnResource??? ???????????? (???????????? true ?????? ?????? ?????? false????????????.)
var bool		bNeedSetPawnResource;
// SetPawnResource ??? ????????? true??? ??????.
var bool		bNeedPostSetPawnResourceProcess;

// #ifdef __L2 // anima - ??????
var bool		bPendingTransform;
// #endif

var bool bColosseumSelected;
var transient CompressedPosition PawnPosition;
var int ColosseumTeam;
var int ColosseumPartyNum;

// ttmayrin - Looping Skill Sound List
var array<Sound> SkillLoopingSoundList;

// #ifdef __L2 // anima	- ??????
struct native NIllusionParam
{
	var float		RemainTime;
	var float		SpawnDelay;
	var	vector		SpawnLocation;
	var	float		AnimFrame;
	var	name		SeqName;
	var rotator		Rotation;	
 	var color		IllusionColor;
 	var	bool		bUseIllusionColor;
};

struct native NIllusionPawnParam
{
	var	pawn		IllusionPawn;
	var float		RemainTime;
	var float		TotalTime;
};

var array<NIllusionParam>		NIllusionSpawnList;
var array<NIllusionPawnParam>	NIllusionPawnList;
// #endif

// #ifdef __L2 // anima - ??????
var name ChargeAniName;
// #endif

// #ifdef __L2 // anima
var bool bChangeWeapon;
// #endif

// 2008/01/17 Default mesh information.
// bUseDefaultMesh is false for most of the time. The only case it is set to true
// is when Pawn is placed within the editor.
// - NeverDie
var bool bUseDefaultMesh;

var bool bRelativeSoundRadius;	// true??? ??????, Drawscale??? ?????? Sound??? Radius??? ????????????.

// anima - equip item
var int EquipItem;

var bool bDamageEffectRelativeCollisionRadius;// flagoftiger - for Location offset of Attacked Effect UnPawn.cpp APawn::AssociateAttackedNotify()
var bool HasDamageEffectOffsetForLargePawn;		// lancelot - damage effect offset for large pawn
var float DamageEffectOffset;

//2009/10/13  by elsacred // Pawn???????????? ????????? ??????..  
var int PawnState;

// #ifdef __L2	lancelot 2009. 11. 20.  actor??? ????????? ?????????
var bool				bHideRightHandMesh;
var bool				bHideLeftHandMesh;
// #endif

//branch
var bool bBR_ShowTargetName;
//end of branch

var array<ChannelingData> ChannelingEmitters;
var name ChannelingEmitterName;
var name ChannelingBoneName;

var bool bAutoDestroyWhenCurrentAnimEnd;

var bool m_bSheathing;

//unr??? ?????? ???????????? ?????? ?????? ???????????? ????????? true??? ??????.
var() bool IsClientSidePawn;

// jylee, ???????????? ??????. ?????? ClientSidePawnAnimList ??? ?????? ??????????????? ??????????????? ???????????? ???????????????
// ?????? ????????? ?????? ?????? ????????? ????????? ????????? ?????? ????????? ?????????
// APawn.Serialize() ????????? ?????? ???????????? ????????? List??? ????????? ?????? None?????? ???????????? ???????????????
// ????????? ?????? ??? ?????? ??????.
var name ClientSidePawnAnim; 

//unr??? ????????? ?????? ?????? ????????? ????????? ????????? unr??? ???????????? pawn??? ????????? ?????????. ?????????
//pawn??? serialize?????? ????????? ?????? ????????????
var name SavedMeshName;

// ?????????????????? ???????????? ?????? ???????????? ????????? bone index??? ?????? - lancelot 2011. 1. 31.
enum DualCastingBoneBlend
{
	DCBB_LeftStart,
	DCBB_LeftEnd,
	DCBB_RightStart,
	DCBB_RightEnd
};
var int m_DualCastBlendBoneIdx[4];
var float m_BlendFactor;

//jylee, hairshop test
var	transient color		DynamicHairColor; // hairex ?????? ?????? color vector
var	transient bool		bUseDynamicHairColor; // ??? ????????? ????????? ?????????????????? ?????????, ?????? ?????? ????????? ????????? ??????
var transient int		m_nHairStyle;

var private int			m_nMeshType;
replication
{
	// Variables the server should send to the client.
	reliable if( bNetDirty && (Role==ROLE_Authority) )
        bSimulateGravity, bIsCrouched, bIsWalking, bIsTyping, PlayerReplicationInfo, AnimAction, HitDamageType, TakeHitLocation,HeadScale;
	reliable if( bTearOff && bNetDirty && (Role==ROLE_Authority) )
		TearOffMomentum;	
	reliable if ( bNetDirty && !bNetOwner && (Role==ROLE_Authority) ) 
		bSteadyFiring;
	reliable if( bNetDirty && bNetOwner && Role==ROLE_Authority )
         Controller,SelectedItem, GroundSpeed, WaterSpeed, AirSpeed, AccelRate, JumpZ, AirControl;
	reliable if( bNetDirty && Role==ROLE_Authority )
         Health;
    unreliable if ( !bNetOwner && Role==ROLE_Authority )
		PawnPosition;

	// replicated functions sent to server by owning client
	reliable if( Role<ROLE_Authority )
		ServerChangedWeapon;
}

//sori, extrude info
var transient enum EExtrudeMeshRenderType
{
	EMRT_NotRender,
	EMRT_Always,
	EMRT_BlinkLong,
	EMRT_BlinkShort,
} extrudeMeshRenderType;
var transient enum EExtrudeMeshVisibleState
{
	EMVS_None,
	EMVS_Show,
	EMVS_FadeIn,
	EMVS_Hide,
	EMVS_FadeOut,
} extrudeMeshVisibleState;
var private transient float extrudeMeshTime;

//jylee, ???????????? ???????????????
var private transient float burningProgressTime;

//sunrice, NPC Spawn Event
var	int					L2NPCSpawnEventID;

var int	CurAtkAnimIndex;		// ?????? ??????????????? ?????????????????? ?????? ??????????????? ?????????

var int	FlyToLocationType;

var float DodgeSpeedFactor; // dodge speed moved here so animation knows the diff between a jump and a dodge
var float DodgeSpeedZ;

var const int OldAnimDir;
var const Vector OldVelocity;
var float IdleTime;

var name SwimAnims[4];      // 0=forward, 1=backwards, 2=left, 3=right
var name CrouchAnims[4];
var name WalkAnims[4];
var name AirAnims[4];
var name TakeoffAnims[4];
var name LandAnims[4];
var name DoubleJumpAnims[4];
var name DodgeAnims[4];
var name AirStillAnim;
var name TakeoffStillAnim;
var name CrouchTurnRightAnim;
var name CrouchTurnLeftAnim;
var name IdleCrouchAnim;
var name IdleSwimAnim;
var name IdleWeaponAnim;    // WeaponAttachment code will set this one
var name IdleRestAnim;

var array<name> TauntAnims; // Array of names of taunt anim that can be played by this character. First 4 assumed to be orders.
var localized string TauntAnimNames[8]; // Text description

var const int  FootRot;     // torso twisting/looking stuff
var const int  TurnDir;
var name RootBone;
var name HeadBone;
var name SpineBone1;
var name SpineBone2;

// xPawn replicated properties - moved here to take advantage of native replication
const DamageDirMax = 4;

var(Shield) transient float ShieldStrength;          // current shielding (having been activated)
var() byte  DamageDirIntensity[DamageDirMax];

struct HitFXData
{
    var() Name    Bone;
    var() class<DamageType> damtype;
    var() bool bSever;
    var() Rotator rotDir;
};

var() HitFXData HitFx[8];
var transient int   HitFxTicker;

var() array<name> ClientSidePawnAnimList;
var() bool bPlayingRandomly;
var	  transient int PlayingAnimIndex;
var() name IntervalAnim;
var() name ForcedPlayAnimFirst;
var transient bool bIntervalAnimPlaying;
//jylee, ????????? ?????? ?????? variation
var transient rotator RecoiledAngle;
var transient int RecoiledAngleType;

var transient bool 	bBeHitNoDamaged;

replication
{
	// Variables the server should send to the client.
	reliable if( bNetDirty && (Role==ROLE_Authority) )
        bSimulateGravity, bIsCrouched, bIsWalking, PlayerReplicationInfo, AnimAction, HitDamageType, TakeHitLocation,HeadScale;
	reliable if( bTearOff && bNetDirty && (Role==ROLE_Authority) )
		TearOffMomentum;	
	reliable if ( bNetDirty && !bNetOwner && (Role==ROLE_Authority) ) 
        bSteadyFiring, ViewPitch; // - jjs
	reliable if( bNetDirty && bNetOwner && Role==ROLE_Authority )
         Controller,SelectedItem, GroundSpeed, WaterSpeed, AirSpeed, AccelRate, JumpZ, AirControl, HealthMax;
	reliable if( bNetDirty && Role==ROLE_Authority )
         Health;
    unreliable if ( !bNetOwner && Role==ROLE_Authority )
		PawnPosition;
       
    // xPawn replicated properties - moved here to take advantage of native replication
    reliable if (Role==ROLE_Authority)
        ShieldStrength, HitFx, HitFxTicker, DamageDirIntensity;

	// replicated functions sent to server by owning client
	reliable if( Role<ROLE_Authority )
		ServerChangedWeapon;

}

simulated native function SetTwistLook( int twist, int look );
simulated native function int Get4WayDirection( );
simulated event SetHeadScale(float NewScale);
simulated event AnimBegin(name SequenceName);

native function AddHungerEffect();
native function RemoveHungerEffect();

native function bool ReachedDestination(Actor Goal);
native function ForceCrouch();
native final function PlayAnimUM( name Sequence, optional int UpdateMovementAnim, optional float Rate, optional float TweenTime, optional int Channel );

//#ifdef __L2
native function SetWeaponHide(bool bHideRight, bool bHideLeft);		// lancelot 2009. 12. 4.
//#endif

/* Reset() 
reset actor to initial state - used when restarting level without reloading.
*/
function Reset()
{
	if ( (Controller == None) || Controller.bIsPlayer )
		Destroy();
	else
		Super.Reset();
}

function Fire( optional float F )
{
    if( Weapon!=None )
        Weapon.Fire(F);
}

function DrawHUD(Canvas Canvas);

// If returns false, do normal calview anyway
function bool SpecialCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation );

simulated function String GetHumanReadableName()
{
	if ( PlayerReplicationInfo != None )
		return PlayerReplicationInfo.PlayerName;
	return MenuName;
}

function PlayTeleportEffect(bool bOut, bool bSound)
{
	MakeNoise(1.0);
}

/* PossessedBy()
 Pawn is possessed by Controller
*/
function PossessedBy(Controller C)
{
	Controller = C;
	NetPriority = 3;

	if ( C.PlayerReplicationInfo != None )
	{
		PlayerReplicationInfo = C.PlayerReplicationInfo;
		OwnerName = PlayerReplicationInfo.PlayerName;
	}
	if ( C.IsA('PlayerController') )
	{
		if ( Level.NetMode != NM_Standalone )
			RemoteRole = ROLE_AutonomousProxy;
		BecomeViewTarget();
	}
	else
		RemoteRole = Default.RemoteRole;

	SetOwner(Controller);	// for network replication
	Eyeheight = BaseEyeHeight;
	ChangeAnimation();
}

function UnPossessed()
{	
	PlayerReplicationInfo = None;
	SetOwner(None);
	Controller = None;
}

/* PointOfView()
called by controller when possessing this pawn
false = 1st person, true = 3rd person
*/
simulated function bool PointOfView()
{
	return false;
}

function BecomeViewTarget()
{
	bUpdateEyeHeight = true;
}

function DropToGround()
{
	bCollideWorld = True;
	bInterpolating = false;
	if ( Health > 0 )
	{
		SetCollision(true,true,true);
		SetPhysics(PHYS_Falling);
		AmbientSound = None;
		if ( IsHumanControlled() )
			Controller.GotoState(LandMovementState);
	}
}

function bool CanGrabLadder()
{
	return ( bCanClimbLadders 
			&& (Controller != None)
			&& (Physics != PHYS_Ladder)
			&& ((Physics != Phys_Falling) || (abs(Velocity.Z) <= JumpZ)) );
}

event SetWalking(bool bNewIsWalking)
{
	if ( bNewIsWalking != bIsWalking )
	{
		bIsWalking = bNewIsWalking;
		ChangeAnimation();
	}
}

function bool CanSplash()
{
	if ( (Level.TimeSeconds - SplashTime > 0.25)
		&& ((Physics == PHYS_Falling) || (Physics == PHYS_Flying))
		&& (Abs(Velocity.Z) > 100) )
	{
		SplashTime = Level.TimeSeconds;
		return true;
	}
	return false;
}

function EndClimbLadder(LadderVolume OldLadder)
{
	if ( Controller != None )
		Controller.EndClimbLadder();
	if ( Physics == PHYS_Ladder )
		SetPhysics(PHYS_Falling);
}

function ClimbLadder(LadderVolume L)
{
	OnLadder = L;
	SetRotation(OnLadder.WallDir);
	SetPhysics(PHYS_Ladder);
	if ( IsHumanControlled() )
		Controller.GotoState('PlayerClimbing');
}

/* DisplayDebug()
list important actor variable on canvas.  Also show the pawn's controller and weapon info
*/
simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
	local string T;
	Super.DisplayDebug(Canvas, YL, YPos);

	Canvas.SetDrawColor(255,255,255);

	Canvas.DrawText("Animation Action "$AnimAction$" Health "$Health);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	Canvas.DrawText("Anchor "$Anchor$" Serpentine Dist "$SerpentineDist$" Time "$SerpentineTime);
	YPos += YL;
	Canvas.SetPos(4,YPos);

	T = "Floor "$Floor$" DesiredSpeed "$DesiredSpeed$" Crouched "$bIsCrouched$" Try to uncrouch "$UncrouchTime;
	if ( (OnLadder != None) || (Physics == PHYS_Ladder) )
		T=T$" on ladder "$OnLadder;
	Canvas.DrawText(T);
	YPos += YL;
	Canvas.SetPos(4,YPos);
	Canvas.DrawText("EyeHeight "$Eyeheight$" BaseEyeHeight "$BaseEyeHeight$" Physics Anim "$bPhysicsAnimUpdate);
	YPos += YL;
	Canvas.SetPos(4,YPos);

	if ( Controller == None )
	{
		Canvas.SetDrawColor(255,0,0);
		Canvas.DrawText("NO CONTROLLER");
		YPos += YL;
		Canvas.SetPos(4,YPos);
	}
	else
		Controller.DisplayDebug(Canvas,YL,YPos);

	if ( Weapon == None )
	{
		Canvas.SetDrawColor(0,255,0);
		Canvas.DrawText("NO WEAPON");
		YPos += YL;
		Canvas.SetPos(4,YPos);
	}
	else
		Weapon.DisplayDebug(Canvas,YL,YPos);
}
		 		
//
// Compute offset for drawing an inventory item.
//
simulated function vector CalcDrawOffset(inventory Inv)
{
	local vector DrawOffset;

	if ( Controller == None )
		return (Inv.PlayerViewOffset >> Rotation) + BaseEyeHeight * vect(0,0,1);

	DrawOffset = ((0.9/Weapon.DisplayFOV * 100 * ModifiedPlayerViewOffset(Inv)) >> GetViewRotation() ); 
	if ( !IsLocallyControlled() )
		DrawOffset.Z += BaseEyeHeight;
	else
	{	
		DrawOffset.Z += EyeHeight;
        // gam ---
        if( bWeaponBob )
		    DrawOffset += WeaponBob(Inv.BobDamping);
        // --- gam
        DrawOffset += CameraShake(); 
	}
	return DrawOffset;
}

function vector CameraShake()
{
    local vector x, y, z, shakevect;
    local PlayerController pc;

    pc = PlayerController(Controller);
    
    if (pc == None)
        return shakevect;

    GetAxes(pc.Rotation, x, y, z);

    shakevect = pc.ShakeOffset.X * x +
                pc.ShakeOffset.Y * y +
                pc.ShakeOffset.Z * z;

    return shakevect;
}

function vector ModifiedPlayerViewOffset(inventory Inv)
{
	return Inv.PlayerViewOffset;
}

function vector WeaponBob(float BobDamping)
{
	Local Vector WBob;

	WBob = BobDamping * WalkBob;
	WBob.Z = (0.45 + 0.55 * BobDamping) * WalkBob.Z;
	return WBob;
}

function CheckBob(float DeltaTime, vector Y)
{
	local float Speed2D;

    if( !bWeaponBob )
    {
		BobTime = 0;
		WalkBob = Vect(0,0,0);
        return;
    }
 
	if (Physics == PHYS_Walking )
	{
		Speed2D = VSize(Velocity);
		if ( Speed2D < 10 )
			BobTime += 0.2 * DeltaTime;
		else
			BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
		WalkBob = Y * Bob * Speed2D * sin(8 * BobTime);
		AppliedBob = AppliedBob * (1 - FMin(1, 16 * deltatime));
		WalkBob.Z = AppliedBob;
		if ( Speed2D > 10 )
			WalkBob.Z = WalkBob.Z + 0.75 * Bob * Speed2D * sin(16 * BobTime);
		if ( LandBob > 0.01 )
		{
			AppliedBob += FMin(1, 16 * deltatime) * LandBob;
			LandBob *= (1 - 8*Deltatime);
		}
	}
	else if ( Physics == PHYS_Swimming )
	{
		Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
		WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * Level.TimeSeconds);
		WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * Level.TimeSeconds);
	}
	else
	{
		BobTime = 0;
		WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
	}
}

//***************************************
// Interface to Pawn's Controller

// return true if controlled by a Player (AI or human)
simulated function bool IsPlayerPawn()
{
	return ( (Controller != None) && Controller.bIsPlayer );
}

// return true if was controlled by a Player (AI or human)
simulated function bool WasPlayerPawn()
{
	return false;
}

// return true if controlled by a real live human
simulated function bool IsHumanControlled()
{
	return ( PlayerController(Controller) != None );
}

// return true if controlled by local (not network) player
simulated function bool IsLocallyControlled()
{
	if ( Level.NetMode == NM_Standalone )
		return true;
	if ( Controller == None )
		return false;
	if ( PlayerController(Controller) == None )
		return true;

	return ( Viewport(PlayerController(Controller).Player) != None );
}

// return true if viewing this pawn in first person pov. useful for determining what and where to spawn effects
simulated function bool IsFirstPerson()
{
    local PlayerController PC;
 
    PC = PlayerController(Controller);
    return ( PC != None && !PC.bBehindView && Viewport(PC.Player) != None );
}

simulated function rotator GetViewRotation()
{
	if ( Controller == None )
		return Rotation;
	return Controller.GetViewRotation();
}

simulated function SetViewRotation(rotator NewRotation )
{
	if ( Controller != None )
		Controller.SetRotation(NewRotation);
}

final function bool InGodMode()
{
	return ( (Controller != None) && Controller.bGodMode );
}

function bool NearMoveTarget()
{
	if ( (Controller == None) || (Controller.MoveTarget == None) )
		return false;

	return ReachedDestination(Controller.MoveTarget);
}

simulated final function bool PressingFire()
{
	return ( (Controller != None) && (Controller.bFire != 0) );
}

simulated final function bool PressingAltFire()
{
	return ( (Controller != None) && (Controller.bAltFire != 0) );
}

function Actor GetMoveTarget()
{	
	if ( Controller == None )
		return None;

	return Controller.MoveTarget;
}

function SetMoveTarget(Actor NewTarget )
{
	if ( Controller != None )
		Controller.MoveTarget = NewTarget;
}

function bool LineOfSightTo(actor Other)
{
	return ( (Controller != None) && Controller.LineOfSightTo(Other) );
} 

simulated final function rotator AdjustAim(Ammunition FiredAmmunition, vector projStart, int aimerror)
{
	if ( Controller == None )
		return Rotation;

	return Controller.AdjustAim(FiredAmmunition, projStart, aimerror);
}

function Actor ShootSpecial(Actor A)
{
	if ( !Controller.bCanDoSpecial || (Weapon == None) )
		return None;

	Controller.FireWeaponAt(A);
	return A;
}

/* return a value (typically 0 to 1) adjusting pawn's perceived strength if under some special influence (like berserk)
*/
function float AdjustedStrength()
{
	return 0;
}

function HandlePickup(Pickup pick)
{
	MakeNoise(0.2);
	if ( Controller != None )
		Controller.HandlePickup(pick);
}

function ReceiveLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	if ( PlayerController(Controller) != None )
		PlayerController(Controller).ReceiveLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
}

event ClientMessage( coerce string S, optional Name Type )
{
	if ( PlayerController(Controller) != None )
		PlayerController(Controller).ClientMessage( S, Type );
}

function Trigger( actor Other, pawn EventInstigator )
{
	if ( Controller != None )
		Controller.Trigger(Other, EventInstigator);
}

//***************************************

function bool CanTrigger(Trigger T)
{
	return true;
}

function CreateInventory(string InventoryClassName)
{
}

function GiveWeapon(string aClassName )
{
	local class<Weapon> WeaponClass;
	local Weapon NewWeapon;

	WeaponClass = class<Weapon>(DynamicLoadObject(aClassName, class'Class'));

	if( FindInventoryType(WeaponClass) != None )
		return;
	newWeapon = Spawn(WeaponClass);
	if( newWeapon != None )
		newWeapon.GiveTo(self);
}

function SetDisplayProperties(ERenderStyle NewStyle, Material NewTexture, bool bLighting )
{
	Style = NewStyle;
	Texture = NewTexture;
	bUnlit = bLighting;
	if ( Weapon != None )
		Weapon.SetDisplayProperties(Style, Texture, bUnlit);

	if ( !bUpdatingDisplay && (Inventory != None) )
	{
		bUpdatingDisplay = true;
		Inventory.SetOwnerDisplay();
	}
	bUpdatingDisplay = false;
}

function SetDefaultDisplayProperties()
{
	Style = Default.Style;
	texture = Default.Texture;
	bUnlit = Default.bUnlit;
	if ( Weapon != None )
		Weapon.SetDefaultDisplayProperties();

	if ( !bUpdatingDisplay && (Inventory != None) )
	{
		bUpdatingDisplay = true;
		Inventory.SetOwnerDisplay();
	}
	bUpdatingDisplay = false;
}

function FinishedInterpolation()
{
	DropToGround();
}

function JumpOutOfWater(vector jumpDir)
{
	Falling();
	Velocity = jumpDir * WaterSpeed;
	Acceleration = jumpDir * AccelRate;
	velocity.Z = FMax(380,JumpZ); //set here so physics uses this for remainder of tick
	bUpAndOut = true;
}

simulated event DestroyShadowProjector()
{
	//overwritted in Lineagepawn
}

simulated event AttachShadowProjector()
{
	//overwritted in Lineagepawn
}

/*
Modify velocity called by physics before applying new velocity
for this tick.

Velocity,Acceleration, etc. have been updated by the physics, but location hasn't
*/
simulated event ModifyVelocity(float DeltaTime, vector OldVelocity);

event FellOutOfWorld(eKillZType KillType)
{
	if ( Role < ROLE_Authority )
		return;
	if ( (Controller != None) && Controller.AvoidCertainDeath() )
		return;
	Health = -1;

	if( KillType == KILLZ_Lava)
		Died( None, class'FellLava', Location );
	else if(KillType == KILLZ_Suicide)
		Died( None, class'Fell', Location );
	else
	{
		SetPhysics(PHYS_None);
		Died( None, class'Fell', Location );
	}
}

/* ShouldCrouch()
Controller is requesting that pawn crouch
*/
function ShouldCrouch(bool Crouch)
{
	bWantsToCrouch = Crouch;
}

// Stub events called when physics actually allows crouch to begin or end
// use these for changing the animation (if script controlled)
event EndCrouch(float HeightAdjust)
{
	EyeHeight -= HeightAdjust;
	OldZ += HeightAdjust;
	BaseEyeHeight = Default.BaseEyeHeight;
}

event StartCrouch(float HeightAdjust)
{
	EyeHeight += HeightAdjust;
	OldZ -= HeightAdjust;
	BaseEyeHeight = FMin(0.8 * CrouchHeight, CrouchHeight - 10);
}

function RestartPlayer();
function AddVelocity( vector NewVelocity)
{
	if ( bIgnoreForces )
		return;
	if ( (Physics == PHYS_Walking)
		|| (((Physics == PHYS_Ladder) || (Physics == PHYS_Spider)) && (NewVelocity.Z > Default.JumpZ)) )
		SetPhysics(PHYS_Falling);
	if ( (Velocity.Z > 380) && (NewVelocity.Z > 0) )
		NewVelocity.Z *= 0.5;
	Velocity += NewVelocity;
}

function KilledBy( pawn EventInstigator )
{
	local Controller Killer;

	Health = 0;
	if ( EventInstigator != None )
		Killer = EventInstigator.Controller;
	Died( Killer, class'Suicided', Location );
}

function TakeFallingDamage()
{
	local float Shake, EffectiveSpeed;

	if (Velocity.Z < -0.5 * MaxFallSpeed)
	{
		MakeNoise(1.0);
		if (Velocity.Z < -1 * MaxFallSpeed)
		{
			if ( Role == ROLE_Authority )
			{
				EffectiveSpeed = Velocity.Z;
				if ( TouchingWaterVolume() )
					EffectiveSpeed += 100;
				TakeDamage(-100 * (EffectiveSpeed + MaxFallSpeed)/MaxFallSpeed, None, Location, vect(0,0,0), class'Fell');
			}
		}
		if ( Controller != None )
		{
			Shake = FMin(1, -1 * Velocity.Z/MaxFallSpeed);
            Controller.DamageShake(Shake);
		}
	}
	else if (Velocity.Z < -1.4 * JumpZ)
		MakeNoise(0.5);
}

function ClientReStart()
{
	Velocity = vect(0,0,0);
	Acceleration = vect(0,0,0);
	BaseEyeHeight = Default.BaseEyeHeight;
	EyeHeight = BaseEyeHeight;
	PlayWaiting();
}

function ClientSetLocation( vector NewLocation, rotator NewRotation )
{
	if ( Controller != None )
		Controller.ClientSetLocation(NewLocation, NewRotation);
}

function ClientSetRotation( rotator NewRotation )
{
	if ( Controller != None )
		Controller.ClientSetRotation(NewRotation);
}

simulated function FaceRotation( rotator NewRotation, float DeltaTime )
{
	if ( Physics == PHYS_Ladder )
		SetRotation(OnLadder.Walldir);
	else
	{
		if ( (Physics == PHYS_Walking) || (Physics == PHYS_Falling) )
			NewRotation.Pitch = 0;
		SetRotation(NewRotation);
	}
}

function ClientDying(class<DamageType> DamageType, vector HitLocation)
{
	if ( Controller != None )
		Controller.ClientDying(DamageType, HitLocation);
}

function DoComboName( string ComboClassName );
function bool InCurrentCombo()
{
	return false;
}
//=============================================================================
// UDamage stub. 
function EnableUDamage(float amount);
function DisableUDamage();

//=============================================================================
// Shield stubs. 
function float GetShieldStrengthMax();
function float GetShieldStrength();
function bool AddShieldStrength(int amount);

//=============================================================================
// Inventory related functions.

// check before throwing
simulated function bool CanThrowWeapon()
{
    return ( (Weapon != None) && Weapon.CanThrow()
			&& ((Level.Game == None) || !Level.Game.bWeaponStay) );
}

// toss out a weapon
function TossWeapon(Vector TossVel)
{
	local Vector X,Y,Z;

	Weapon.Velocity = TossVel;
	GetAxes(Rotation,X,Y,Z);
	Weapon.DropFrom(Location + 0.8 * CollisionRadius * X - 0.5 * CollisionRadius * Y); 
}	

// The player/bot wants to select next item
exec function NextItem()
{
	if (SelectedItem==None) {
		SelectedItem = Inventory.SelectNext();
		Return;
	}
	if (SelectedItem.Inventory!=None)
		SelectedItem = SelectedItem.Inventory.SelectNext(); 
	else
		SelectedItem = Inventory.SelectNext();

	if ( SelectedItem == None )
		SelectedItem = Inventory.SelectNext();
}

// FindInventoryType()
// returns the inventory item of the requested class
// if it exists in this pawn's inventory 

function Inventory FindInventoryType( class DesiredClass )
{
	local Inventory Inv;
	local int Count;

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
	{
		if ( Inv.class == DesiredClass )
			return Inv;
		Count++;
		if ( Count > 1000 )
			return None;
	}
	return None;
} 

// Add Item to this pawn's inventory. 
// Returns true if successfully added, false if not.
function bool AddInventory( inventory NewItem )
{
	// Skip if already in the inventory.
	local inventory Inv;
	local actor Last;

	Last = self;
	
	// The item should not have been destroyed if we get here.
	if (NewItem ==None )
		log("tried to add none inventory to "$self);

	for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
	{
		if( Inv == NewItem )
			return false;
		Last = Inv;
	}

	// Add to back of inventory chain (so minimizes net replication effect).
	NewItem.SetOwner(Self);
	NewItem.Inventory = None;
	Last.Inventory = NewItem;

	if ( Controller != None )
		Controller.NotifyAddInventory(NewItem);
	return true;
}

// Remove Item from this pawn's inventory, if it exists.
function DeleteInventory( inventory Item )
{
	// If this item is in our inventory chain, unlink it.
	local actor Link;
	local int Count;
	
	if ( Item == Weapon )
		Weapon = None;
	if ( Item == SelectedItem )
		SelectedItem = None;
	for( Link = Self; Link!=None; Link=Link.Inventory )
	{
		if( Link.Inventory == Item )
		{
			Link.Inventory = Item.Inventory;
			Item.Inventory = None;
			break;
		}
		Count++;
		if ( Count > 1000 )
			break;
	}
	Item.SetOwner(None);
}

// Just changed to pendingWeapon
function ChangedWeapon()
{
	local Weapon OldWeapon;

	OldWeapon = Weapon;

	if (Weapon == PendingWeapon)
	{
		if ( Weapon == None )
		{
			Controller.SwitchToBestWeapon();
			return;
		}
		else if ( Weapon.IsInState('DownWeapon') ) 
			Weapon.GotoState('Idle');
		PendingWeapon = None;
		ServerChangedWeapon(OldWeapon, Weapon);
		return;
	}
	if ( PendingWeapon == None )
		PendingWeapon = Weapon;
		
	Weapon = PendingWeapon;
	if ( (Weapon != None) && (Level.NetMode == NM_Client) )
		Weapon.BringUp();
	PendingWeapon = None;
	Weapon.Instigator = self;
	ServerChangedWeapon(OldWeapon, Weapon);
	if ( Controller != None )
		Controller.ChangedWeapon();
}

function name GetWeaponBoneFor(Inventory I)
{
	return 'righthand';
}

function ServerChangedWeapon(Weapon OldWeapon, Weapon W)
{
	if ( OldWeapon != None )
	{
		OldWeapon.SetDefaultDisplayProperties();
		OldWeapon.DetachFromPawn(self);		
	}
	Weapon = W;
	if ( Weapon == None )
		return;

	if ( Weapon != None )
	{
		//log("ServerChangedWeapon: Attaching Weapon to actor bone.");
		Weapon.AttachToPawn(self);
	}

	Weapon.SetRelativeLocation(Weapon.Default.RelativeLocation);
	Weapon.SetRelativeRotation(Weapon.Default.RelativeRotation);
	if ( OldWeapon == Weapon )
	{
		if ( Weapon.IsInState('DownWeapon') ) 
			Weapon.BringUp();
		Inventory.OwnerEvent('ChangedWeapon'); // tell inventory that weapon changed (in case any effect was being applied)
		return;
	}
	else if ( Level.Game != None )
		MakeNoise(0.1 * Level.Game.GameDifficulty);		
	Inventory.OwnerEvent('ChangedWeapon'); // tell inventory that weapon changed (in case any effect was being applied)

	PlayWeaponSwitch(W);
	Weapon.BringUp();
}

//==============
// Encroachment
event bool EncroachingOn( actor Other )
{
	if ( Other.bWorldGeometry )
		return true;
		
	if ( ((Controller == None) || !Controller.bIsPlayer || bWarping) && (Pawn(Other) != None) )
		return true;
		
	return false;
}

event EncroachedBy( actor Other )
{
	if ( Pawn(Other) != None )
		gibbedBy(Other);
}

function gibbedBy(actor Other)
{
	if ( Role < ROLE_Authority )
		return;
	if ( Pawn(Other) != None )
		Died(Pawn(Other).Controller, class'DamTypeTelefragged', Location);
	else
		Died(None, class'Gibbed', Location);
}

//Base change - if new base is pawn or decoration, damage based on relative mass and old velocity
// Also, non-players will jump off pawns immediately
function JumpOffPawn()
{
	Velocity += (100 + CollisionRadius) * VRand();
	Velocity.Z = 200 + CollisionHeight;
	SetPhysics(PHYS_Falling);
	bNoJumpAdjust = true;
	Controller.SetFall();
}

singular event BaseChange()
{
	local float decorMass;
	
	if(Physics == PHYS_Flying)
		return;
		
	if ( bInterpolating )
		return;
	if ( (base == None) && (Physics == PHYS_None) )
		SetPhysics(PHYS_Falling);
	// Pawns can only set base to non-pawns, or pawns which specifically allow it.
	// Otherwise we do some damage and jump off.
	else if ( Pawn(Base) != None )
	{	
		if ( !Pawn(Base).bCanBeBaseForPawns )
		{
			Base.TakeDamage( (1-Velocity.Z/400)* Mass/Base.Mass, Self,Location,0.5 * Velocity , class'Crushed');
			JumpOffPawn();
		}
//#ifdef	__L2	Hunter
		/*TripShip = Vehicle(Base);
		if( TripShip != None )
		{
			TripShip.bTrip = true;
			TripShip.TripTarget.X = -90742.f;
			TripShip.TripTarget.Y = 141933.f;
			TripShip.TripTarget.Z = -3791.f;
		}*/
//#endif
	}
	else if ( (Decoration(Base) != None) && (Velocity.Z < -400) )
	{
		decorMass = FMax(Decoration(Base).Mass, 1);
		Base.TakeDamage((-2* Mass/decorMass * Velocity.Z/400), Self, Location, 0.5 * Velocity, class'Crushed');
	}
}

event UpdateEyeHeight( float DeltaTime )
{
	local float smooth, MaxEyeHeight;
	local float OldEyeHeight;
	local Actor HitActor;
	local vector HitLocation,HitNormal;

	if ( Controller == None )
	{
		EyeHeight = 0;
		return;
	}
	if ( bTearOff )
	{
		EyeHeight = 0;
		bUpdateEyeHeight = false;
		return;
	}
	HitActor = trace(HitLocation,HitNormal,Location + (CollisionHeight + MAXSTEPHEIGHT + 14) * vect(0,0,1),
					Location + CollisionHeight * vect(0,0,1),true);
	if ( HitActor == None )
		MaxEyeHeight = CollisionHeight + MAXSTEPHEIGHT;
	else
		MaxEyeHeight = HitLocation.Z - Location.Z - 14;
							
	// smooth up/down stairs
	smooth = FMin(1.0, 10.0 * DeltaTime/Level.TimeDilation);
	If( Controller.WantsSmoothedView() )
	{
		OldEyeHeight = EyeHeight;
		EyeHeight = FClamp((EyeHeight - Location.Z + OldZ) * (1 - smooth) + BaseEyeHeight * smooth,
							-0.5 * CollisionHeight, MaxEyeheight);
	}
	else
	{
		bJustLanded = false;
		EyeHeight = FMin(EyeHeight * ( 1 - smooth) + BaseEyeHeight * smooth, MaxEyeHeight);
	}
	Controller.AdjustView(DeltaTime);
}

/* EyePosition()
Called by PlayerController to determine camera position in first person view.  Returns
the offset from the Pawn's location at which to place the camera
*/
function vector EyePosition()
{
	return EyeHeight * vect(0,0,1) + WalkBob;
}

//=============================================================================

simulated event Destroyed()
{
	//if ( Shadow != None )
	//	Shadow.Destroy();
 	if ( Shadow1 != None )
 		Shadow1.Destroy();

	if ( Controller != None && !IsA('Vehicle') )
		Controller.PawnDied(self);
	if ( Level.NetMode == NM_Client )
		return;

	while ( Inventory != None )
		Inventory.Destroy();

	Weapon = None;
	Super.Destroyed();
}

//=============================================================================
//
// Called immediately before gameplay begins.
//
event PreBeginPlay()
{
	Super.PreBeginPlay();
	Instigator = self;
	DesiredRotation = Rotation;
	if ( bDeleteMe )
		return;

	if ( BaseEyeHeight == 0 )
		BaseEyeHeight = 0.8 * CollisionHeight;
	EyeHeight = BaseEyeHeight;

	if ( menuname == "" )
		menuname = GetItemName(string(class));
}

event PostBeginPlay()
{
	local AIScript A;

	Super.PostBeginPlay();
	SplashTime = 0;
	SpawnTime = Level.TimeSeconds;
	EyeHeight = BaseEyeHeight;
	OldRotYaw = Rotation.Yaw;
//#ifdef	__L2	//Hunter
	GroundSpeed = GroundMaxSpeed;
	WantedYaw = Rotation.Yaw;
//#endif

	// #ifdef __L2 // by nonblock
	LastFootRot.Yaw = 0 ;
	LastFootRot.Pitch = 0 ;
	LastFootRot.Roll = 0;
	RecentHitWaterInterval = 0.0;
	// #endif

	// #ifdef __L2 // by nonblock
	fAcceleratedRate = (flastBlinkGap - fInitBlinkGap) /  fTotalAcceleratedBlickTime ;
	// #endif
	// automatically add controller to pawns which were placed in level
	// NOTE: pawns spawned during gameplay are not automatically possessed by a controller
	if ( !IsClientSidePawn && Level.bStartup && (Health > 0) && !bDontPossess )
	{
		// check if I have an AI Script
		if ( AIScriptTag != '' )
		{
			ForEach AllActors(class'AIScript',A,AIScriptTag)
				break;
			// let the AIScript spawn and init my controller
			if ( A != None )
			{
				A.SpawnControllerFor(self);
				if ( Controller != None )
					return;
			}
		}
		if ( (ControllerClass != None) && (Controller == None) )
			Controller = spawn(ControllerClass);
		if ( Controller != None )
		{
			Controller.Possess(self);
			AIController(Controller).Skill += SkillModifier;
		}
	}
}

// called after PostBeginPlay on net client
simulated event PostNetBeginPlay()
{
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
		MaxLights = Min(4,MaxLights);
	if ( Role == ROLE_Authority )
		return;
	if ( Controller != None )
	{
		Controller.Pawn = self;
		if ( (PlayerController(Controller) != None)
			&& (PlayerController(Controller).ViewTarget == Controller) )
			PlayerController(Controller).SetViewTarget(self);
	}

	if ( Role == ROLE_AutonomousProxy )
		bUpdateEyeHeight = true;

	if ( (PlayerReplicationInfo != None) 
		&& (PlayerReplicationInfo.Owner == None) )
		PlayerReplicationInfo.SetOwner(Controller);
	PlayWaiting();
}

simulated function SetMesh()
{
    if (Mesh != None)
        return;

	LinkMesh( default.mesh );
}

function Gasp();
function SetMovementPhysics();

function bool GiveHealth(int HealAmount, int HealMax)
{
	if (Health < HealMax) 
	{
		Health = Min(HealMax, Health + HealAmount);
        return true;
	}
    return false;
}

function bool HasUDamage()
{
	return false;
}

function int ShieldAbsorb( int damage )
{
    return damage;
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType)
{
	local int actualDamage;
	local bool bAlreadyDead;
	local Controller Killer;

	if ( damagetype == None )
		warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
	if ( Role < ROLE_Authority )
	{
		log(self$" client damage type "$damageType$" by "$instigatedBy);
		return;
	}

	bAlreadyDead = (Health <= 0);

	if (Physics == PHYS_None)
		SetMovementPhysics();
	if (Physics == PHYS_Walking)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	if ( (instigatedBy == self) 
		|| ((Controller != None) && (InstigatedBy != None) && (InstigatedBy.Controller != None) && InstigatedBy.Controller.SameTeamAs(Controller)) )
		momentum *= 0.6;
	momentum = momentum/Mass;

    if (Weapon != None)
        Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
    if ( (InstigatedBy != None) && InstigatedBy.HasUDamage() ) // FIXME THIS SUCKS
        Damage *= 2;
	actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
	if( DamageType.default.bArmorStops && (actualDamage > 0) )
		actualDamage = ShieldAbsorb(actualDamage); 

	Health -= actualDamage;
	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;
	if ( bAlreadyDead )
		return;

	PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum);
	if ( Health <= 0 )
	{
		// pawn died
		if ( instigatedBy != None )
			Killer = instigatedBy.GetKillerController();
		if ( bPhysicsAnimUpdate )
			TearOffMomentum = momentum;
		Died(Killer, damageType, HitLocation);
	}
	else
	{
		if ( (InstigatedBy != None) && (InstigatedBy != self) && (Controller != None)
			&& (InstigatedBy.Controller != None) && InstigatedBy.Controller.SameTeamAs(Controller) ) 
			Momentum *= 0.5;
			
		AddVelocity( momentum ); 
		if ( Controller != None )
			Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
	}
	MakeNoise(1.0); 
}

function TeamInfo GetTeam()
{
	if ( PlayerReplicationInfo != None )
		return PlayerReplicationInfo.Team;
	return None;
}

function Controller GetKillerController()
{
	return Controller;
}

event GetEffTargetLocation(out vector LocVector)
{
}

function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
    local Vector TossVel;

	if ( bDeleteMe )
		return; //already destroyed

	// mutator hook to prevent deaths
	// WARNING - don't prevent bot suicides - they suicide when really needed
	if ( Level.Game.PreventDeath(self, Killer, damageType, HitLocation) )
	{
		Health = max(Health, 1); //mutator should set this higher
		return;
	}
	Health = Min(0, Health);

    if (Weapon != None)
    {
        Weapon.HolderDied();
        TossVel = Vector(GetViewRotation());
        TossVel = TossVel * ((Velocity Dot TossVel) + 500) + Vect(0,0,200);
        TossWeapon(TossVel);
    }

	if ( Controller != None ) 
	{   
		Controller.WasKilledBy(Killer);
		Level.Game.Killed(Killer, Controller, self, damageType);
	}
	else
		Level.Game.Killed(Killer, Controller(Owner), self, damageType);
		
	if ( Killer != None )
		TriggerEvent(Event, self, Killer.Pawn);
	else
		TriggerEvent(Event, self, None);

	Velocity.Z *= 1.3;
	if ( IsHumanControlled() )
		PlayerController(Controller).ForceDeathUpdate();
    if ( (DamageType != None) && DamageType.default.bAlwaysGibs )
		ChunkUp( Rotation, DamageType.default.GibPerterbation );
	else
	{
		PlayDying(DamageType, HitLocation);
		if ( Level.Game.bGameEnded )
			return;
		if ( !bPhysicsAnimUpdate && !IsLocallyControlled() )
			ClientDying(DamageType, HitLocation);
	}

}

function bool Gibbed(class<DamageType> damageType)
{
	if ( damageType.default.GibModifier == 0 )
		return false; 
	if ( damageType.default.GibModifier >= 100 )
		return true;	
	if ( (Health < -80) || ((Health < -40) && (FRand() < 0.6)) )
		return true;
	return false;
}

event Falling()
{
	//SetPhysics(PHYS_Falling); //Note - physics changes type to PHYS_Falling by default
	if ( Controller != None )
		Controller.SetFall();
}

event HitWall(vector HitNormal, actor Wall);

event Landed(vector HitNormal)
{
	LandBob = FMin(50, 0.055 * Velocity.Z); 
	TakeFallingDamage();
	if ( Health > 0 )
		PlayLanded(Velocity.Z);
	bJustLanded = true;
}

event HeadVolumeChange(PhysicsVolume newHeadVolume)
{
	if ( (Level.NetMode == NM_Client) || (Controller == None) )
		return;

	// 2006/10/10 NeverDie
	if( HeadVolume == None )
		return;

	// 2006/10/10 NeverDie
	if( newHeadVolume == None )
		return;

	if ( HeadVolume.bWaterVolume )
	{
		if (!newHeadVolume.bWaterVolume)
		{
			if ( Controller.bIsPlayer && (BreathTime > 0) && (BreathTime < 8) )
				Gasp();
			BreathTime = -1.0;
		}
	}
	else if ( newHeadVolume.bWaterVolume )
		BreathTime = UnderWaterTime;
}

function bool TouchingWaterVolume()
{
	local PhysicsVolume V;

	ForEach TouchingActors(class'PhysicsVolume',V)
		if ( V.bWaterVolume )
			return true;
			
	return false;
}

//Pain timer just expired.
//Check what zone I'm in (and which parts are)
//based on that cause damage, and reset BreathTime

function bool IsInPain()
{
	local PhysicsVolume V;

	ForEach TouchingActors(class'PhysicsVolume',V)
		if ( V.bPainCausing && (V.DamageType != ReducedDamageType) 
			&& (V.DamagePerSec > 0) )
			return true;
	return false;
}
	
event BreathTimer()
{
	if ( (Health < 0) || (Level.NetMode == NM_Client) )
		return;
	TakeDrowningDamage();
	if ( Health > 0 )
		BreathTime = 2.0;
}

function TakeDrowningDamage();		

function bool CheckWaterJump(out vector WallNormal)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, checkpoint, start, checkNorm, Extent;

	checkpoint = vector(Rotation);
	checkpoint.Z = 0.0;
	checkNorm = Normal(checkpoint);
	checkPoint = Location + CollisionRadius * checkNorm;
	Extent = CollisionRadius * vect(1,1,0);
	Extent.Z = CollisionHeight;
	HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, true, Extent);
	if ( (HitActor != None) && (Pawn(HitActor) == None) )
	{
		WallNormal = -1 * HitNormal;
		start = Location;
		start.Z += 1.1 * MAXSTEPHEIGHT;
		checkPoint = start + 2 * CollisionRadius * checkNorm;
		HitActor = Trace(HitLocation, HitNormal, checkpoint, start, true);
		if (HitActor == None)
			return true;
	}

	return false;
}

function DoDoubleJump( bool bUpdating );
function bool CanDoubleJump();

function UpdateRocketAcceleration(float DeltaTime, float YawChange, float PitchChange);

function bool Dodge(eDoubleClickDir DoubleClickMove)
{
	return false;
}

//Player Jumped
function bool DoJump( bool bUpdating )
{
	if ( !bIsCrouched && !bWantsToCrouch && ((Physics == PHYS_Walking) || (Physics == PHYS_Ladder) || (Physics == PHYS_Spider)) )
	{
		if ( Role == ROLE_Authority )
		{
			if ( (Level.Game != None) && (Level.Game.GameDifficulty > 2) )
				MakeNoise(0.1 * Level.Game.GameDifficulty);
			if ( bCountJumps && (Inventory != None) )
				Inventory.OwnerEvent('Jumped');
		}
		if ( Physics == PHYS_Spider )
			Velocity = JumpZ * Floor;
		else if ( Physics == PHYS_Ladder )
			Velocity.Z = 0;
		else if ( bIsWalking )
			Velocity.Z = Default.JumpZ;
		else
			Velocity.Z = JumpZ;
		if ( (Base != None) && !Base.bWorldGeometry )
			Velocity.Z += Base.Velocity.Z; 
		SetPhysics(PHYS_Falling);
        return true;
	}
    return false;
}

/* PlayMoverHitSound()
Mover Hit me, play appropriate sound if any
*/
function PlayMoverHitSound();

function PlayDyingSound();

function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum)
{
	local vector BloodOffset, Mo, HitNormal;
	local class<Effects> DesiredEffect;
	local class<Emitter> DesiredEmitter;
	local PlayerController PC;

	if ( (Damage <= 0) && !Controller.bGodMode )
		return;
		
	if (Damage > DamageType.Default.DamageThreshold) //spawn some blood
	{

		HitNormal = Normal(HitLocation - Location);
	
		// Play any set effect
		if ( EffectIsRelevant(Location,true) )
		{	
			DesiredEffect = DamageType.static.GetPawnDamageEffect(HitLocation, Damage, Momentum, self, (Level.bDropDetail || Level.DetailMode == DM_Low));

			if ( DesiredEffect != None )
			{
				BloodOffset = 0.2 * CollisionRadius * HitNormal;
				BloodOffset.Z = BloodOffset.Z * 0.5;

				Mo = Momentum;
				if ( Mo.Z > 0 )
					Mo.Z *= 0.5;
				spawn(DesiredEffect,self,,HitLocation + BloodOffset, rotator(Mo));
			}

			// Spawn any preset emitter
			
			DesiredEmitter = DamageType.Static.GetPawnDamageEmitter(HitLocation, Damage, Momentum, self, (Level.bDropDetail || Level.DetailMode == DM_Low)); 		
			if (DesiredEmitter != None)
				spawn(DesiredEmitter,,,HitLocation+HitNormal, Rotator(HitNormal)); 
		}		
	}
	if ( Health <= 0 )
	{
		if ( PhysicsVolume.bDestructive && (PhysicsVolume.ExitActor != None) )
			Spawn(PhysicsVolume.ExitActor);
		return;
	}
	
	// jdf ---
	if ( (Level.NetMode != NM_DedicatedServer) && (Level.NetMode != NM_ListenServer) )
	{
		PC = PlayerController(Controller);
		if ( PC != None && PC.bEnableDamageForceFeedback )
			PC.ClientPlayForceFeedback("Damage");
	}
	// --- jdf
	
	if ( Level.TimeSeconds - LastPainTime > 0.1 )
	{
		PlayTakeHit(HitLocation,Damage,damageType);
		LastPainTime = Level.TimeSeconds;
	}
}

/* 
Pawn was killed - detach any controller, and die
*/

// blow up into little pieces (implemented in subclass)		

simulated function ChunkUp( Rotator HitRotation, float ChunkPerterbation ) // gam
{
	if ( (Level.NetMode != NM_Client) && (Controller != None) )
	{
		if ( Controller.bIsPlayer )
			Controller.PawnDied(self);
		else
			Controller.Destroy();
	}
	destroy();
}

State Dying
{
ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

	event ChangeAnimation() {}
	event StopPlayFiring() {}
	function PlayFiring(float Rate, name FiringMode) {}
	function PlayWeaponSwitch(Weapon NewWeapon) {}
	function PlayTakeHit(vector HitLoc, int Damage, class<DamageType> damageType) {}
	simulated function PlayNextAnimation() {}

	function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
	{
	}

	event FellOutOfWorld(eKillZType KillType)
	{
		if(KillType == KILLZ_Lava || KillType == KILLZ_Suicide )
			return;

		Destroy();
	}

	function Timer()
	{
		if ( !PlayerCanSeeMe() )
			Destroy();
		else
			SetTimer(2.0, false);	
	}

	function Landed(vector HitNormal)
	{
		local rotator finalRot;

		LandBob = FMin(50, 0.055 * Velocity.Z); 
		if( Velocity.Z < -500 )
			TakeDamage( (1-Velocity.Z/30),Instigator,Location,vect(0,0,0) , class'Crushed');

		finalRot = Rotation;
		finalRot.Roll = 0;
		finalRot.Pitch = 0;
		setRotation(finalRot);
		SetPhysics(PHYS_None);
		SetCollision(true, false, false);

		if ( !IsAnimating(0) )
			LieStill();
	}

	/* ReduceCylinder() made obsolete by ragdoll deaths */
	function ReduceCylinder()
	{
		SetCollision(false,false,false);
	}

	function LandThump()
	{
		// animation notify - play sound if actually landed, and animation also shows it
		if ( Physics == PHYS_None)
			bThumped = true;
	}

	event AnimEnd(int Channel)
	{
		if ( Channel != 0 )
			return;
		if ( Physics == PHYS_None )
			LieStill();
		else if ( PhysicsVolume.bWaterVolume )
		{
			bThumped = true;
			LieStill();
		}
	}

	function LieStill()
	{
		if ( !bThumped )
			LandThump();
		ReduceCylinder();
	}

	singular function BaseChange()
	{
		if( base == None )
			SetPhysics(PHYS_Falling);
		else if ( Pawn(base) != None ) // don't let corpse ride around on someone's head
        	ChunkUp( Rotation, 1.0 ); 
	}

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, class<DamageType> damageType)
	{
		SetPhysics(PHYS_Falling);
		if ( (Physics == PHYS_None) && (Momentum.Z < 0) )
			Momentum.Z *= -1;
		Velocity += 3 * momentum/(Mass + 200);
		if ( bInvulnerableBody )
			return;
		Damage *= DamageType.Default.GibModifier;
		Health -=Damage;
		if ( ((Damage > 30) || !IsAnimating()) && (Health < -80) )
        	ChunkUp( Rotation, DamageType.default.GibPerterbation ); // gam
	}

	function BeginState()
	{
		if ( (LastStartSpot != None) && (LastStartTime - Level.TimeSeconds < 6) )
			LastStartSpot.LastSpawnCampTime = Level.TimeSeconds;
		if ( bTearOff && (Level.NetMode == NM_DedicatedServer) )
			LifeSpan = 1.0;
		else
			SetTimer(12.0, false);
		SetPhysics(PHYS_Falling);
		bInvulnerableBody = true;
		if ( Controller != None )
		{
			if ( Controller.bIsPlayer )
				Controller.PawnDied(self);
			else
				Controller.Destroy();
		}
	}
	
Begin:
	Sleep(0.15);
	bInvulnerableBody = false;
	PlayDyingSound();
}

//=============================================================================
// Animation interface for controllers

simulated event SetAnimAction(name NewAction);

/* PlayXXX() function called by controller to play transient animation actions 
*/
simulated event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	AmbientSound = None;
	GotoState('Dying');
	if ( bPhysicsAnimUpdate )
	{
		bReplicateMovement = false;
		bTearOff = true;
		Velocity += TearOffMomentum;
		SetPhysics(PHYS_Falling);
	}
	bPlayedDeath = true;
}

simulated function PlayFiring(optional float Rate, optional name FiringMode);
function PlayWeaponSwitch(Weapon NewWeapon);
simulated event StopPlayFiring()
{
	bSteadyFiring = false;
}

function PlayTakeHit(vector HitLoc, int Damage, class<DamageType> damageType)
{
	local Sound DesiredSound;

	if (Damage==0)
		return;
	// 		
	// Play a hit sound according to the DamageType

 	DesiredSound = DamageType.Static.GetPawnDamageSound();
	if (DesiredSound != None)
		PlayOwnedSound(DesiredSound,SLOT_Misc);
}

//=============================================================================
// Pawn internal animation functions

simulated event ChangeAnimation()
{
	if ( (Controller != None) && Controller.bControlAnimations )
		return;
	// player animation - set up new idle and moving animations
	PlayWaiting();
	PlayMoving();
}

simulated event AnimEnd(int Channel)
{
	if ( Channel == 0 )
		PlayWaiting();
//#ifdef __L2 //kurt
	SetWeaponHide(false, false);
	switch( UpdateMovementAnimType )
	{
		case UM_ONCE:
		case UM_FORCE:
			UpdateMovementAnimType = UM_NONE; 
			bUpdateMovementAnim=false;
			break;
	}
//#endif
}

// Animation group checks (usually implemented in subclass)

function bool CannotJumpNow()
{
	return false;
}

simulated event PlayJump();
simulated event PlayFalling();
simulated function PlayMoving();
simulated function PlayWaiting();

function PlayLanded(float impactVel)
{
	if ( !bPhysicsAnimUpdate )
		PlayLandingAnimation(impactvel);
}

simulated event PlayLandingAnimation(float ImpactVel);

function PlayVictoryAnimation();

function HoldCarriedObject(CarriedObject O, name AttachmentBone);

//#ifdef __L2 //kurt
simulated event AttackedNotify(Pawn Attacker,Actor AttackActor,INT type, bool keepframerate, bool showeffect);
simulated event AssociateAttackedNotify(Pawn Attacker,Actor AttackActor,int type,int damage, bool bmiss, bool bshielddefense, bool bcritical, bool bSpirit, bool keepframerate, bool showeffect);
function NotifyAttack(Actor Attacker);
//native function bool SetRelativeCoords(Actor Goal, vector RelLoc, rotator RelRot);
native function bool SetRelativeCoords(Actor Goal);
native function sound GetDefenseItemSound();
native function sound GetShieldItemSound();
native function int GetRefSkeletonNum();
simulated event NotifyDie();
event GetSimulationCollision( out array<SimulationCollision> SimulationCollisions );
event SetSimulationCollision( array<SimulationCollision> SimulationCollisions );

//2009.10.13 by elsacred 
event ChangePawnState(int iState)
{
	switch(iState)
	{
		case 100: //hungery
			AddHungerEffect();
			break; 
		case 101: //not hungry
			RemoveHungerEffect();
			break;
	}
}

//#endif

native function bool IsMeshLoaded();

//#ifdef	__L2	Hunter
//function name GetTurnAnimName() {return TurnAnimName[CurWeaponType];}					//??????
//function name GetWalkAnimName() {return WalkAnimName[CurWeaponType];}					//??????
native function name GetWalkAnimName();				//??????
native function name GetRunAnimName();						//??????
//function name GetRunAnimName() {return RunAnimName[CurWeaponType];}						//??????
//function name GetJumpAnimName() {return JumpAnimName[CurWeaponType];}					//??????
//function name GetBJumpAnimName() {return BJumpAnimName[CurWeaponType];}					//????????????
native function name GetWaitAnimName();					//????????????
//function name GetWaitAnimName() {return WaitAnimName[CurWeaponType];}					//????????????
//function name GetAtkWaitAnimName() {return AtkWaitAnimName[CurWeaponType];}				//????????????
native function name GetAtkWaitAnimName();				//????????????
//function name GetSitAnimName() {return SitAnimName[CurWeaponType];}						//???????????? ????????????
native function name GetSitWaitAnimName();				//????????? ????????? ?????????
//function name GetSitWaitAnimName() {return SitWaitAnimName[CurWeaponType];}				//????????? ????????? ?????????
//function name GetStandAnimName() {return StandAnimName[CurWeaponType];}					//?????? ????????? ?????? ??????
//function name GetDeathStandAnimName() {return DeathStandAnimName[CurWeaponType];}		//?????? ????????? ?????? ??????
//function name GetChairSitAnimName() {return ChairSitAnimName[CurWeaponType];}			//????????? ?????? ??????
//function name GetChairWaitAnimName() {return ChairWaitAnimName[CurWeaponType];}			//????????? ????????? ?????????
//function name GetChairStandAnimName() {return ChairStandAnimName[CurWeaponType];}		//???????????? ?????????
//function name GetStunAnimName() {return StunAnimName[CurWeaponType];}					//??????, ????????????
//function name GetAtk01AnimName() {return Atk01AnimName[CurWeaponType];}					//??????1(???)
//function name GetAtk02AnimName() {return Atk02AnimName[CurWeaponType];}					//??????2(???)
//function name GetAtk03AnimName() {return Atk03AnimName[CurWeaponType];}					//??????3(???)
//function name GetAtkUpAnimName() {return AtkUpAnimName[CurWeaponType];}					//??????4(???)
//function name GetAtkDownAnimName() {return AtkDownAnimName[CurWeaponType];}				//??????5(???)
//function name GetSpAtk01AnimName() {return SpAtk01AnimName[CurWeaponType];}				//????????????1
//function name GetSpAtk02AnimName() {return SpAtk02AnimName[CurWeaponType];}				//????????????2
//function name GetSpAtk03AnimName() {return SpAtk03AnimName[CurWeaponType];}				//????????????3
//function name GetSpAtk04AnimName() {return SpAtk04AnimName[CurWeaponType];}				//????????????4
//function name GetSpAtk05AnimName() {return SpAtk05AnimName[CurWeaponType];}				//????????????5
//function name GetSpAtk06AnimName() {return SpAtk06AnimName[CurWeaponType];}				//????????????6
//function name GetSpAtk07AnimName() {return SpAtk07AnimName[CurWeaponType];}				//?????? 7~16 : ????????????????????????
//function name GetSpAtk08AnimName() {return SpAtk08AnimName[CurWeaponType];}
//function name GetSpAtk09AnimName() {return SpAtk09AnimName[CurWeaponType];}
//function name GetSpAtk10AnimName() {return SpAtk10AnimName[CurWeaponType];}
//function name GetSpAtk11AnimName() {return SpAtk11AnimName[CurWeaponType];}
//function name GetSpAtk12AnimName() {return SpAtk12AnimName[CurWeaponType];}
//function name GetSpAtk13AnimName() {return SpAtk13AnimName[CurWeaponType];}
//function name GetSpAtk14AnimName() {return SpAtk14AnimName[CurWeaponType];}
//function name GetSpAtk15AnimName() {return SpAtk15AnimName[CurWeaponType];}
//function name GetSpAtk16AnimName() {return SpAtk16AnimName[CurWeaponType];}
//function name GetSpAtk17AnimName() {return SpAtk17AnimName[CurWeaponType];}
//function name GetSpAtk18AnimName() {return SpAtk18AnimName[CurWeaponType];}
//function name GetSpAtk19AnimName() {return SpAtk19AnimName[CurWeaponType];}
//function name GetSpAtk20AnimName() {return SpAtk20AnimName[CurWeaponType];}
//function name GetSpAtk21AnimName() {return SpAtk21AnimName[CurWeaponType];}
//function name GetSpAtk22AnimName() {return SpAtk22AnimName[CurWeaponType];}
//function name GetSpAtk23AnimName() {return SpAtk23AnimName[CurWeaponType];}
//function name GetSpAtk24AnimName() {return SpAtk24AnimName[CurWeaponType];}
//function name GetSpAtk25AnimName() {return SpAtk25AnimName[CurWeaponType];}
//function name GetSpAtk26AnimName() {return SpAtk26AnimName[CurWeaponType];}
//function name GetSpAtk27AnimName() {return SpAtk27AnimName[CurWeaponType];}
//function name GetSpAtk28AnimName() {return SpAtk28AnimName[CurWeaponType];}
//function name GetShieldAtkAnimName() {return ShieldAtkAnimName[CurWeaponType];}			//????????? ??????
//function name GetDefenceAnimName() {return DefenceAnimName[CurWeaponType];}				//??????????????????
//function name GetDodgeAnimName() {return DodgeAnimName[CurWeaponType];}					//??????????????????
//function name GetDeathAnimName() //???????????? ?????? ??????
//{ 
//	if(Physics == PHYS_Swimming && SwimDeathAnimName[CurWeaponType] != 'None' ) 
//		return SwimDeathAnimName[CurWeaponType]; 
//	else if(Controller != None && Controller.WaitType == STP_SIT && SitDeathAnimName[CurWeaponType] != 'None')	
//		return SitDeathAnimName[CurWeaponType];		
//	return DeathAnimName[CurWeaponType];
//}					
native function name GetDeathWaitAnimName();		//???????????? ??????
//{ 
//	if(Physics == PHYS_Swimming && SwimDeathWaitAnimName[CurWeaponType] != 'None' ) 
//		return SwimDeathWaitAnimName[CurWeaponType]; 
//	else if((Controller != None) && (Controller.WaitType == STP_SIT) && (SitDeathWaitAnimName[CurWeaponType] != 'None'))	
//		return SitDeathWaitAnimName[CurWeaponType];		
//	else
//		return DeathWaitAnimName[CurWeaponType];
//}	
//function name GetDamageAnimName() {return DamageAnimName[CurWeaponType];}				//?????????
//function name GetCastShortAnimName() {return CastShortAnimName[CurWeaponType];}			//????????????1 (1?????????)
//function name GetCastMidAnimName() {return CastMidAnimName[CurWeaponType];}				//????????????2 (2-5???)
//function name GetCastLongAnimName() {return CastLongAnimName[CurWeaponType];}			//????????????3 (5?????????)
////#ifdef   __L2   kinggoat
//function name GetCastEndAnimName() {return CastEndAnimName[CurWeaponType];}	//???????????? 
////#endif
//function name GetMagicThrowAnimName() {return MagicThrowAnimName[CurWeaponType];}		//????????????1 (?????????)
//function name GetMagicShotAnimName() {return MagicShotAnimName[CurWeaponType];}			//????????????2 (??????)
//function name GetMagicNoTargetAnimName() {return MagicNoTargetAnimName[CurWeaponType];}	//????????????3 (????????????)
//function name GetMagicFriendAnimName() {return MagicFriendAnimName[CurWeaponType];}		//????????????4 (????????????)
//function name GetPicItemAnimName() {return PicItemAnimName[CurWeaponType];}				//????????? ??????
//function name GetThrowAnimName() {return ThrowAnimName[CurWeaponType];}					//????????? ?????????
//
//function name GetRiderWaitAnimName() {if(!bRide) return 'None'; return RiderWaitAnimName[CurRideType];}
//function name GetRiderAtkAnimName() {if(!bRide) return 'None'; return RiderAtkAnimName[CurRideType];}
//function name GetRiderRunAnimName() {if(!bRide) return 'None'; return RiderRunAnimName[CurRideType];}
//function name GetRiderDeathWaitAnimName() {if(!bRide) return 'None'; return RiderDeathWaitAnimName[CurRideType];}
//function name GetRiderDeathAnimName() {if(!bRide) return 'None'; return RiderDeathAnimName[CurRideType];}
native function name GetSwimAttackWaitAnimName();
native function name GetSwimWaitAnimName();
// ??????????????? A???????????? L?????? ?????? ????????? ?????? ?????? ??????????????? 7??? lancelot 2009. 10. 19.
//function name GetCastShort_A_AnimName() { return RandomAnim.CastShortAnimNameA[CurWeaponType]; }
//function name GetCastMid_A_AnimName() { return RandomAnim.CastMidAnimNameA[CurWeaponType]; }
//function name GetCastLong_A_AnimName() { return RandomAnim.CastLongAnimNameA[CurWeaponType]; }
//function name GetCastEnd_A_AnimName() { return RandomAnim.CastEndAnimNameA[CurWeaponType]; }
//function name GetMagicNoTarget_A_AnimName() { return RandomAnim.MagicNoTargetAnimNameA[CurWeaponType]; }
//function name GetMagicShot_A_AnimName() { return RandomAnim.MagicShotAnimNameA[CurWeaponType]; }
//function name GetMagicThrow_A_AnimName() { return RandomAnim.MagicThrowAnimNameA[CurWeaponType]; }