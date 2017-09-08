class SeqAct_AllActors extends SequenceAction;

var() class<Actor> ActorClass;
var() class<Interface> InterfaceClass;
var() bool AlwaysClearObjectList;
var() bool DynamicActorsOnly;
var() int Index;

event Activated()
{
  local Actor Actor;
  local WorldInfo WorldInfo;
  local array<SequenceObject> ObjectList;
  local SeqVar_ObjectList SeqVar_ObjectList;
  
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
          if (AlwaysClearObjectList)
          {
            SeqVar_ObjectList.ObjList.Length = 0;
          }

          if (DynamicActorsOnly)
          {
            ForEach WorldInfo.DynamicActors(ActorClass, Actor, InterfaceClass)
            {
              SeqVar_ObjectList.ObjList.AddItem(Actor);
            }
			Index = SeqVar_ObjectList.ObjList.Length;
          }
          else
          {
            ForEach WorldInfo.AllActors(ActorClass, Actor, InterfaceClass)
            {
              SeqVar_ObjectList.ObjList.AddItem(Actor);
            }
			Index = SeqVar_ObjectList.ObjList.Length;
          }
        }
      }
    }
  }

  ActivateOutputLink(0);
}

defaultproperties
{
  ObjName="Iterate All Actors"
  ObjCategory="Iterators"
  InputLinks(0)=(LinkDesc="In")
  OutputLinks(0)=(LinkDesc="Out")
  VariableLinks.Empty
  VariableLinks(0)=(ExpectedType=class'SeqVar_ObjectList',LinkDesc="Out Objects",bWriteable=true)
  VariableLinks(1) = (ExpectedType = class'SeqVar_Int', LinkDesc = "Index", bWriteable = true, PropertyName = Index)
}