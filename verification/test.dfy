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
    modifies testedlist;
    modifies disposedlist;
    modifies testedlist.list;
    modifies disposedlist.list;
{
    var i := 0;
    while (i < testedlist.list.Length)
    invariant testedlist.Valid();
    invariant 0 <= i <= testedlist.list.Length;
    invariant forall j :: 0 <= j < i ==> testedlist.list[j].expiration > timenow;
    decreases testedlist.list.Length - i;
    {
        if (testedlist.list[i].expiration <= timenow) {
            var blood := testedlist.extractBlood(testedlist.list[i].id);
        } else {
            i := i + 1;
        }
    }
}