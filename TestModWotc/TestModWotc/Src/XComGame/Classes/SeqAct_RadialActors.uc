class SeqAct_RadialActors extends SequenceAction;

enum EIteratorType
{
  EIT_Visible<DisplayName="Visible">,
  EIT_VisibleColliding<DisplayName="Visible and Collidable">,
  EIT_Colliding<DisplayName="Collidable">,
  EIT_Overlapping<DisplayName="Overlapping">
};

var() class<Actor> ActorClass;
var() bool AlwaysClearObjectList;
var() EIteratorType IteratorType;

var() float Radius;
// Location will be overriden when using an attached actor
var() Vector Location;
var Actor ActorLocation;

var(VisibleCollidingActors) bool VCAIgnoreHidden<DisplayName="Ignore Hidden">;
var(VisibleCollidingActors) Vector VCAExtent<DisplayName="Trace Extent">;
var(VisibleCollidingActors) bool VCATraceActors<DisplayName="Trace Actors">;
var(VisibleCollidingActors) class<Interface> VCAInterfaceClass<DisplayName="Interface Class">;

var(CollidingActors) bool CAUseOverlapCheck<DisplayName="Use Overlap Check">;
var(CollidingActors) class<Interface> CAInterfaceClass<DisplayName="Interface Class">;

var(OverlappingActors) bool OAIgnoreHidden<DisplayName="Ignore Hidden">;

event Activated()
{
  local WorldInfo WorldInfo;
  local Actor Actor;
  local array<SequenceObject> ObjectList;
  local SeqVar_ObjectList SeqVar_ObjectList;
  local Vector IteratorLocation;

  if (ActorClass != None)
  {
    WorldInfo = class'WorldInfo'.static.GetWorldInfo();

    if (WorldInfo != None)
    {
      // Get the object list seq var
      GetLinkedObjects(ObjectList, class'SeqVar_ObjectList', false);

      if (ObjectList.Length > 0)
      {
        SeqVar_ObjectList = SeqVar_ObjectList(ObjectList[0]);

        if (SeqVar_ObjectList != None)
        {
          IteratorLocation = (ActorLocation != None) ? ActorLocation.Location : Location;

          if (AlwaysClearObjectList)
          {
            SeqVar_ObjectList.ObjList.Length = 0;
          }

          switch (IteratorType)
          {
          case EIT_Visible:
            ForEach WorldInfo.VisibleActors(ActorClass, Actor, Radius, IteratorLocation)
            {
              SeqVar_ObjectList.ObjList.AddItem(Actor);
            }
            break;

          case EIT_VisibleColliding:
            ForEach WorldInfo.VisibleCollidingActors(ActorClass, Actor, Radius, IteratorLocation, VCAIgnoreHidden, VCAExtent, VCATraceActors, VCAInterfaceClass)
            {
              SeqVar_ObjectList.ObjList.AddItem(Actor);
            }
            break;

          case EIT_Colliding:
            ForEach WorldInfo.CollidingActors(ActorClass, Actor, Radius, IteratorLocation, CAUseOverlapCheck, CAInterfaceClass)
            {
              SeqVar_ObjectList.ObjList.AddItem(Actor);
            }
            break;

          case EIT_Overlapping:
            ForEach WorldInfo.OverlappingActors(ActorClass, Actor, Radius, IteratorLocation, OAIgnoreHidden)
            {
              SeqVar_ObjectList.ObjList.AddItem(Actor);
            }
            break;

          default:
            break;
          }
        }
      }
    }
  }

  ActivateOutputLink(0);
}

defaultproperties
{
  ObjName="Radial Actors"
  ObjCategory="Iterators"
  InputLinks(0)=(LinkDesc="In")
  OutputLinks(0)=(LinkDesc="Out")
  VariableLinks.Empty
  VariableLinks(0)=(ExpectedType=class'SeqVar_ObjectList',LinkDesc="Out Objects",bWriteable=true)
  VariableLinks(1)=(ExpectedType=class'SeqVar_Float',LinkDesc="Radius",PropertyName=Radius)
  VariableLinks(2)=(ExpectedType=class'SeqVar_Object',LinkDesc="Actor Location",bHidden=true,PropertyName=ActorLocation)
  VariableLinks(3)=(ExpectedType=class'SeqVar_Vector',LinkDesc="Location",PropertyName=Location)
}