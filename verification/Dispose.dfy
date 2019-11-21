include "TestedBlood.dfy"
include "TestedBloodList.dfy"
include "DisposedBlood.dfy"
include "DisposedBloodList.dfy"


// check if given blood is exp
// Correspond to Dispose::checkExp()
predicate checkExp(blood: TestedBlood, timenow: int)
requires blood != null;
reads blood;
{
    blood.expiration < timenow
}

// go through the list, check if the blood is exp
// if exp, move from the list
// Correspond to Dispose::dispose()
// Ignore email sender related functions
// Use testedlist and disposedlist to represent transfer
// from tested blood to disposed blood
method dispose(testedlist: TestedBloodList, disposedlist: DisposedBloodList, timenow: int)
    requires testedlist != null;
    requires disposedlist != null;
    requires testedlist.Valid();
    requires disposedlist.Valid();
    requires testedlist.UniqueId();
    requires disposedlist.UniqueId();
    modifies testedlist;
    modifies disposedlist;
    ensures testedlist.Valid();
    ensures disposedlist.Valid();
    ensures testedlist != null;
    ensures disposedlist != null;
{
    var i := 0;
    var toBeRemoved : seq<int> := []; 
    while (i < testedlist.list.Length)
    invariant 0 <= i <= testedlist.list.Length;
    invariant forall id :: id in toBeRemoved ==> (exists i :: 0 <= i < testedlist.upto && testedlist.list[i].id == id);
    invariant forall j :: 0 <= j < i ==> testedlist.list[j].expiration > timenow;
    {
        if (testedlist.list[i].expiration <= timenow) {
            toBeRemoved := toBeRemoved + [testedlist.list[i].id];
        }
        i := i + 1;
    }
}

// var blood := testedlist.extractBlood(testedlist.list[i].id);
// var newlydisposed := new DisposedBlood(blood.id);
// disposedlist.addBlood(newlydisposed);

        // invariant 0 <= i <= testedlist.list.Length;
        // invariant forall j :: 0 <= j < i ==> testedlist.list[j].expiration > timenow;
        // decreases testedlist.list.Length - i;