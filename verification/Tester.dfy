include "UntestedBloodList.dfy"
include "TestingBloodList.dfy"
include "TestedBloodList.dfy"
include "UntestedBlood.dfy"
include "TestingBlood.dfy"
include "TestedBlood.dfy"

// remove from untested, add to testing
// Correspond to Tester.py::startTest()
// Use startTime to represent current time
method startTest(id: int, startTime: int, untestedlist: UntestedBloodList, testing: TestingBloodList)
    requires untestedlist != null;
    requires testing != null;
    requires untestedlist.Valid();
    requires testing.Valid();
    requires untestedlist.UniqueId();
    requires testing.UniqueId();
    requires exists t :: (0 <= t < untestedlist.upto && untestedlist.list[t].id == id);
    requires forall t :: (0 <= t < untestedlist.upto && untestedlist.list[t].id == id ) ==> (untestedlist.list[t].retrieval < startTime);
    requires forall i :: 0 <= i < untestedlist.upto  ==> 
        (forall k :: 0 <= k < testing.upto ==> 
        untestedlist.list[i].id != testing.list[k].id);
    modifies untestedlist;
    modifies untestedlist.list;
    modifies untestedlist`upto;
    modifies testing;
    modifies testing.list;
    modifies testing`upto;
    ensures untestedlist.Valid();
    ensures testing.Valid();
    ensures untestedlist.UniqueId();
    ensures testing.UniqueId();
    ensures untestedlist != null;
    ensures testing != null;
    ensures untestedlist.list == old(untestedlist.list); 
    ensures testing.list == old(testing.list) || fresh(testing.list);
{
    var extracted := untestedlist.extractBlood(id);
    var newBlood := new TestingBlood(id, extracted.retrieval, startTime);
    testing.addBlood(newBlood);
}

// remove from testing, add to tested
// Correspond to Tester.py::test()
method test(id: int, bloodtype: BloodType, expiration: int, testing: TestingBloodList, testedlist: TestedBloodList)
{

}