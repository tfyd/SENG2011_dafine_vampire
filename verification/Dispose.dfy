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
    requires forall i :: 0 <= i < testedlist.upto  ==> (forall k :: 0 <= k < disposedlist.upto ==> testedlist.list[i].id != disposedlist.list[k].id);
    modifies testedlist;
    modifies testedlist.list;
    modifies testedlist`upto;
    modifies disposedlist;
    modifies disposedlist.list;
    modifies disposedlist`upto;
    ensures testedlist.Valid();
    ensures disposedlist.Valid();
    ensures testedlist.UniqueId();
    ensures disposedlist.UniqueId();
    ensures testedlist != null;
    ensures disposedlist != null;
    // ensure all blood in the list is healthy
    // ensures forall j :: 0 <= j < testedlist.upto ==> testedlist.list[j].expiration > timenow;

    // ensure all bloods remove from tested list is inserted to disposedBlood list
    // ensures forall j :: 0 <= j < old(testedlist.upto) 
    //         && (forall i :: 0 <= i < testedlist.upto 
    //         && old(testedlist).list[j].id != testedlist.list[i].id) 
    //         ==> (exists k :: 0 <= k < disposedlist.upto && disposedlist.list[k].id == old(testedlist).list[j].id);

{
    var i := 0;
    var toBeRemoved : set<int> := {}; 
    while (i < testedlist.upto)
    invariant testedlist.Valid(); invariant disposedlist.Valid();
    invariant testedlist.UniqueId(); invariant disposedlist.UniqueId();
    invariant testedlist.list == old(testedlist.list); invariant disposedlist.list == old(disposedlist.list);
    invariant forall i :: 0 <= i < testedlist.upto  ==> (forall k :: 0 <= k < disposedlist.upto ==> testedlist.list[i].id != disposedlist.list[k].id);
    invariant forall id :: id in toBeRemoved  ==> (forall k :: 0 <= k < disposedlist.upto ==> id != disposedlist.list[k].id);
    invariant 0 <= i <= testedlist.upto;
    invariant forall id :: id in toBeRemoved ==> (exists k :: 0 <= k < i
                                                    && testedlist.list[k].id == id 
                                                    && testedlist.list[k].expiration <= timenow);
    invariant forall j :: 0 <= j < i && testedlist.list[j].expiration <= timenow ==> exists id :: id in toBeRemoved && id == testedlist.list[j].id;
    {
        if (testedlist.list[i].expiration <= timenow) {
            toBeRemoved := toBeRemoved + {testedlist.list[i].id};
        }
        i := i + 1;
    }


    var c := toBeRemoved;
    ghost var h : set<int> := {};
    while ( c != {} )
    invariant testedlist.Valid(); invariant disposedlist.Valid();
    invariant testedlist.UniqueId(); invariant disposedlist.UniqueId();
    invariant testedlist.list == old(testedlist.list); invariant disposedlist.list == old(disposedlist.list) || fresh(disposedlist.list);
    invariant forall id :: id in c  ==> (forall k :: 0 <= k < disposedlist.upto ==> id != disposedlist.list[k].id);
    invariant forall id :: (id in old(c) && ! (id in c)) ==> (forall j :: 0 <= j < testedlist.upto ==> testedlist.list[j].id != id);
    invariant c + h == toBeRemoved;
    // invariant forall id :: id in c ==> (exists k :: 0 <= k < testedlist.upto
    //                                                 && testedlist.list[k].id == id 
    //                                                 && testedlist.list[k].expiration <= timenow);
    // invariant forall j :: 0 <= j < i && testedlist.list[j].expiration <= timenow ==> (exists id :: id in c && id == testedlist.list[j].id);
    // invariant forall j :: 0 <= j < testedlist.upto ==> (testedlist.list[j].expiration > timenow || (exists id :: id in c && testedlist.list[j].id == id));
    decreases c;
    {
        var y :| y in c;
        var newlydisposed := new DisposedBlood(y);
        var extracted := testedlist.extractBlood(y);
        disposedlist.addBlood(newlydisposed);
        c := c - { y };
        h := h + { y };
    }
}
