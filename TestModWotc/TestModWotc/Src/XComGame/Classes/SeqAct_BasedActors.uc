class SeqAct_BasedActors extends SequenceAction;

var() class<Actor> ActorClass;
var() bool AlwaysClearObjectList;
var Actor BaseActor;

event Activated()
{
  local Actor Actor;
  local array<SequenceObject> ObjectList;
  local SeqVar_ObjectList SeqVar_ObjectList;
  
  if (ActorClass != None && BaseActor != None)
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

        ForEach BaseActor.BasedActors(ActorClass, Actor)
        {
          SeqVar_ObjectList.ObjList.AddItem(Actor);
        }
      }
    }
  }

  ActivateOutputLink(0);
}

defaultproperties
{
  ObjName="Based Actors"
  ObjCategory="Iterators"
  InputLinks(0)=(LinkDesc="In")
  OutputLinks(0)=(LinkDesc="Out")
  VariableLinks.Empty
  VariableLinks(0)=(ExpectedType=class'SeqVar_ObjectList',LinkDesc="Out Objects",bWriteable=true)
  VariableLinks(1)=(ExpectedType=class'SeqVar_Object',LinkDesc="Base Actor",PropertyName=BaseActor)
}