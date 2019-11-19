include "DisposedBloodList.dfy"
include "TestedBloodList.dfy"

// remove from disposedlist
method dispose(id: int, list: DisposedBloodList)
requires list != null
requires list.Valid(); ensures list.Valid()
modifies list.list, list`upto
{
    var result, blood := list.extractBlood(id);
}


// remove all from Disposedlist
method disposeAll(list: DisposedBloodList)
requires list != null
requires list.Valid(); ensures list.Valid()
modifies list`upto
{
    list.upto := 0;
}

// same as viewblood in doctor.dfy
method viewBlood(list: TestedBloodList)
{

}

method viewBloodStockCurrent()
{

}

method viewBloodStockFuture()
{

}