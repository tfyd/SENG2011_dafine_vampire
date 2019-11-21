datatype DisposedBloodType = O | OP | OM | AP | AM | BP | BM | ABP | ABM
// Python Type:      O | O+ | O- | A+ | A- | B+ | B- | AB+ | AB-
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