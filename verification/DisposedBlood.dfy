class DisposedBlood {
    var id: int;

    /*predicate Valid()
    reads this
    {
        true
    }*/

    constructor (bloodid: int)
    ensures id == bloodid
    modifies this
    {
        id := bloodid;
    }
}