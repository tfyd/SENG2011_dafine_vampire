include "UntestedBloodList.dfy"

// create new untestedblood
// add to list
// Correspond to DonationManager.py::insertBlood()
method insertBlood(list: UntestedBloodList, id: int, retrieval: int)
requires list != null && list.Valid() && list.UniqueId();
ensures list.Valid() && list.UniqueId();
requires forall i :: 0 <= i < list.upto  ==> list.list[i].id != id;
modifies list, list.list, list`upto
{
    var newblood := new UntestedBlood(id, retrieval);
    list.addBlood(newblood);
}