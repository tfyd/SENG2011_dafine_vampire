datatype BloodType = O | OP | OM | AP | AM | BP | BM | ABP | ABM
// Python Type:      O | O+ | O- | A+ | A- | B+ | B- | AB+ | AB-
class {:autocontracts} TestedBlood {
    var id: int;
    var retrieval: int;
    var bloodType: BloodType;
    var expiration: int;

    predicate Valid()
    reads this
    {
        expiration > retrieval
    }

    constructor (bloodid: int, rdate: int, btype: BloodType, edate: int)
    requires edate > rdate
    ensures id == bloodid && rdate == retrieval && edate == expiration && bloodType == btype
    {
        id := bloodid;
        bloodType := btype;
        retrieval := rdate;
        expiration := edate;
    }
}