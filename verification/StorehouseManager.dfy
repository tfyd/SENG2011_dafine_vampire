include "DisposedBloodList.dfy"
include "TestedBloodList.dfy"

// remove from disposedlist
// Correspond to StorehouseManager.py::dispose()
method dispose(id: int, list: DisposedBloodList)
requires list != null
requires list.Valid(); ensures list.Valid()
requires list.UniqueId(); ensures list.UniqueId()
modifies list.list, list`upto
{
    var blood := list.extractBlood(id);
}


// remove all from Disposedlist
// Correspond to StorehouseManager.py::disposeAll()
method disposeAll(list: DisposedBloodList)
requires list != null
requires list.Valid(); ensures list.Valid()
requires list.UniqueId(); ensures list.UniqueId()
modifies list`upto
{
    list.upto := 0;
}