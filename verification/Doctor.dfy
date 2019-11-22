include "TestedBloodList.dfy"
include "ReservedBloodList.dfy"

// find the blood of this id, 
// remove from testedbloodlist
// add to reservedlist
// Correspond to Doctor.py::reserveBlood()

method reserveBlood(id: int, testedlist: TestedBloodList, reservedlist: ReservedBloodList) 
    requires testedlist != null;
 
    requires reservedlist != null;
    requires testedlist.Valid();
    requires reservedlist.Valid();
    requires testedlist.UniqueId();
    requires reservedlist.UniqueId();
    // blood id must be valid
    requires exists t :: (0 <= t < testedlist.upto && testedlist.list[t].id == id);
    // blood id must be unique among two lists
    requires forall i :: 0 <= i < testedlist.upto  ==> 
                (forall k :: 0 <= k < reservedlist.upto ==> 
                testedlist.list[i].id != reservedlist.list[k].id);
    modifies testedlist;
    modifies testedlist.list;
    modifies testedlist`upto;
    modifies reservedlist;
    modifies reservedlist.list;
    modifies reservedlist`upto;
    ensures testedlist.Valid();
    ensures reservedlist.Valid();
    ensures testedlist.UniqueId();
    ensures reservedlist.UniqueId();
    ensures testedlist != null;
    ensures reservedlist != null;
    ensures reservedlist == old(reservedlist);
    ensures testedlist == old(testedlist);
    ensures testedlist.list == old(testedlist.list); 
    ensures reservedlist.list == old(reservedlist.list) || fresh(reservedlist.list);
    ensures testedlist.upto == old(testedlist.upto) - 1;
    ensures reservedlist.upto == old(reservedlist.upto) + 1;
    ensures forall i :: 0 <= i < testedlist.upto ==> testedlist.list[i] != null
    // Successfully Removed
    ensures (forall t :: 0 <= t < testedlist.upto ==> testedlist.list[t].id != id);
    // Successfully Added
    ensures (exists t :: 0 <= t < reservedlist.upto ==> reservedlist.list[t].id == id);
{
    var extracted := testedlist.extractBlood(id);
    reservedlist.addBlood(extracted);
}


// remove from reservedlist, add to testedlist
// Correspond to Doctor.py::removeReservation()
method removeReservation(id: int, testedlist: TestedBloodList, reservedlist: ReservedBloodList)
    requires testedlist != null;
 
    requires reservedlist != null;
    requires testedlist.Valid();
    requires reservedlist.Valid();
    requires testedlist.UniqueId();
    requires reservedlist.UniqueId();
    // blood id must be valid
    requires exists t :: (0 <= t < testedlist.upto && testedlist.list[t].id == id);
    // blood id must be unique among two lists
    requires forall i :: 0 <= i < testedlist.upto  ==> 
                (forall k :: 0 <= k < reservedlist.upto ==> 
                testedlist.list[i].id != reservedlist.list[k].id);
    modifies testedlist;
    modifies testedlist.list;
    modifies testedlist`upto;
    modifies reservedlist;
    modifies reservedlist.list;
    modifies reservedlist`upto;
    ensures testedlist.Valid();
    ensures reservedlist.Valid();
    ensures testedlist.UniqueId();
    ensures reservedlist.UniqueId();
    ensures testedlist != null;
    ensures reservedlist != null;
    ensures reservedlist == old(reservedlist);
    ensures testedlist == old(testedlist);
    ensures testedlist.list == old(testedlist.list); 
    ensures testedlist.list == old(testedlist.list) || fresh(testedlist.list);
    ensures testedlist.upto == old(testedlist.upto) + 1;
    ensures reservedlist.upto == old(reservedlist.upto) - 1;
    // Successfully Removed
    ensures (forall t :: 0 <= t < reservedlist.upto ==> reservedlist.list[t].id != id);
    // Successfully Added
    ensures (exists t :: 0 <= t < testedlist.upto ==> testedlist.list[t].id == id);
{
    var extracted := reservedlist.extractBlood(id);
    testedlist.addBlood(extracted);
}