class X2PhotoboothTag extends XGLocalizeTag native(Core);

var int Kills;
var int Missions;

var string FirstName0;
var string FirstName1;
var string LastName0;
var string LastName1;
var string NickName0;
var string NickName1;
var string Class0;
var string Class1;
var string RankName0;
var string RankName1;
var string Location;
var string Date;
var string Flag;
var string Operation;

native function bool Expand(string InString, out string OutString);

DefaultProperties
{
	Tag = "Photobooth"
}
