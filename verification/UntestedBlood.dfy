class UntestedBlood {
    var id: int;
    var retrieval:int;

    constructor (bloodid: int, rdate: int)
    ensures id == bloodid && rdate == retrieval
    modifies this`id, this`retrieval
    {
        id := bloodid;
        retrieval := rdate;
    }
}