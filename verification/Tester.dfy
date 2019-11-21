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
    // blood id must be valid
    requires exists t :: (0 <= t < untestedlist.upto && untestedlist.list[t].id == id);
    // Date limit
    requires forall t :: (0 <= t < untestedlist.upto && untestedlist.list[t].id == id ) 
                ==> (untestedlist.list[t].retrieval < startTime);
    // blood id must be unique among two lists
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
    ensures testing == old(testing);
    ensures untestedlist == old(untestedlist);
    ensures untestedlist.list == old(untestedlist.list); 
    ensures testing.list == old(testing.list) || fresh(testing.list);
    ensures untestedlist.upto == old(untestedlist.upto) - 1;
    ensures testing.upto == old(testing.upto) + 1;
    // Successfully Removed
    ensures (forall t :: 0 <= t < untestedlist.upto ==> untestedlist.list[t].id != id);
    // Successfully Added
    ensures (exists t :: 0 <= t < testing.upto ==> testing.list[t].id == id);
{
    var extracted := untestedlist.extractBlood(id);
    var newBlood := new TestingBlood(id, extracted.retrieval, startTime);
    testing.addBlood(newBlood);
}

// remove from testing, add to tested
// Correspond to Tester.py::test()
method test(id: int, bloodtype: BloodType, expiration: int, testing: TestingBloodList, testedlist: TestedBloodList)
    requires testedlist != null;
    requires testing != null;
    requires testedlist.Valid();
    requires testing.Valid();
    requires testedlist.UniqueId();
    requires testing.UniqueId();
    // blood id must be valid
    requires exists t :: (0 <= t < testing.upto && testing.list[t].id == id);
    // Date limit
    requires forall t :: (0 <= t < testing.upto && testing.list[t].id == id ) 
                ==> (testing.list[t].retrieval < expiration);
    // blood id must be unique among two lists
    requires forall i :: 0 <= i < testedlist.upto  ==> 
                (forall k :: 0 <= k < testing.upto ==> 
                testedlist.list[i].id != testing.list[k].id);
    modifies testedlist;
    modifies testedlist.list;
    modifies testedlist`upto;
    modifies testing;
    modifies testing.list;
    modifies testing`upto;
    ensures testedlist.Valid();
    ensures testing.Valid();
    ensures testedlist.UniqueId();
    ensures testing.UniqueId();
    ensures testedlist != null;
    ensures testing != null;
    ensures testing == old(testing);
    ensures testedlist == old(testedlist);
    ensures testedlist.list == old(testedlist.list) || fresh(testedlist.list);
    ensures testing.list == old(testing.list);

    ensures testedlist.upto == old(testedlist.upto) + 1;
    ensures testing.upto == old(testing.upto) - 1;
    // Successfully Removed
    ensures (forall t :: 0 <= t < testing.upto ==> testing.list[t].id != id);
    // Successfully Added
    ensures (exists t :: 0 <= t < testedlist.upto ==> testedlist.list[t].id == id);
{
    var extracted := testing.extractBlood(id);
    var newBlood := new TestedBlood(id, extracted.retrieval, bloodtype, expiration);
    testedlist.addBlood(newBlood);
}