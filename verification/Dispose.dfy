include "TestedBlood.dfy"
include "TestedBloodList.dfy"
include "DisposeBlood.dfy"
include "DisposeBloodList.dfy"

// check if given blood is exp
// Correspond to Dispose::checkExp()
predicate checkExp(blood: TestedBlood, timenow: int)
{
    blood.expiration < timenow
}

// go through the list, check if the blood is exp
// if exp, move from the list
// Correspond to Dispose::dispose()
method dispose(testedlist: TestedBloodList, disposedlist: DisposedList, timenow: int)
    modifies testedlist;
    modifies disposedlist;
    ensures forall blood: blood in testedlist.list ==> blood.expiration > timenow;
{
    var i := 0;
    while (i < testedlist.list.Length)
        invariant 0 <= i <= testedlist.list.Length;
        invariant 0 <= j < i ==> testedlist.list[i].expiration > timenow;
        decreases testedlist.list.Length - i;
    {
        if (testedlist.list[i].expiration <= timenow) {
            var found, blood := testedlist.list.extractBlood(testedlist.list[i].id);
            var newlydisposed := new DisposeBlood(blood.id);
            disposedlist.list.addBlood(newlydisposed);
        } else {
            i := i + 1;
        }
    }
}