class TestingBlood {
    var id: int;
    var retrieval: int;
    var startTest: int;

    predicate Valid()
    reads this
    {
        startTest > retrieval
    }

    constructor (bloodid: int, rdate: int, sdate: int)
    requires sdate > rdate
    ensures id == bloodid && rdate == retrieval && sdate == startTest
    modifies this
    ensures Valid()
    {
        id := bloodid;
        retrieval := rdate;
        startTest := sdate;
    }
}