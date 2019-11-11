class {:autocontracts} DisposedBlood {
    var id: int;

    predicate Valid()
    reads this
    {
        true
    }

    constructor (bloodid: int)
    ensures id == bloodid
    {
        id := bloodid;
    }
}