include "UntestedBloodList.dfy"
include "TestingBloodList.dfy"
include "TestedBloodList.dfy"

// remove from untested, add to testing
method startTest(id: int, untestedlist: UntestedBloodList, testing: TestingBloodList)
{

}

// remove from testing, add to tested
method test(id: int, bloodtype: BloodType, expiration: int, testing: TestingBloodList, testedlist: TestedBloodList)
{

}