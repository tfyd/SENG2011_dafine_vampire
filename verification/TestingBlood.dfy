class {:autocontracts} TestingBlood {
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
    {
        id := bloodid;
        retrieval := rdate;
        startTest := sdate;
    }
}