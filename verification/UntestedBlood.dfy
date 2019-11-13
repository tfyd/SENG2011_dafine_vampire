class UntestedBlood {
    var id: int;
    var retrieval:int;

    /*predicate Valid()
    reads this
    {
        true
    }*/

    constructor (bloodid: int, rdate: int)
    ensures id == bloodid && rdate == retrieval
    modifies this
    {
        id := bloodid;
        retrieval := rdate;
    }
}