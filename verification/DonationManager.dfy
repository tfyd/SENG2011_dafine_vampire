include "UntestedBloodList.dfy"

// create new untestedblood
// add to list
method insertBlood(list: UntestedBloodList, id: int, retrieval: int)
requires list != null && list.Valid()
modifies list, list.list, list`upto
{
    var newblood := new UntestedBlood(id, retrieval);
    list.addBlood(newblood);
}