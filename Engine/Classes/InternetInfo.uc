//=============================================================================
// InternetInfo: Parent class for Internet connection classes
//=============================================================================
// Пакет перепаковал и переработал BITHACK Исправил BITHACK =)
//=============================================================================
class InternetInfo extends Info
	native
	transient;

// gam ---
function int GetBeaconCount()
{
    return (0);
}
// --- gam

function string GetBeaconAddress( int i );
function string GetBeaconText( int i );

defaultproperties
{
}
