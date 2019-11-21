datatype TestedBloodType = O | OP | OM | AP | AM | BP | BM | ABP | ABM
// Python Type:      O | O+ | O- | A+ | A- | B+ | B- | AB+ | AB-
class TestedBlood {
    var id: int;
    var retrieval: int;
    var bloodType: TestedBloodType;
    var expiration: int;

    predicate Valid()
    reads this
    {
        expiration > retrieval
    }

    constructor (bloodid: int, rdate: int, btype: TestedBloodType, edate: int)
    requires edate > rdate
    ensures Valid()
    ensures id == bloodid && rdate == retrieval && edate == expiration && bloodType == btype
    modifies this`id, this`bloodType, this`retrieval, this`expiration
    {
        id := bloodid;
        bloodType := btype;
        retrieval := rdate;
        expiration := edate;
    }
}


// method Main()
// {
//     var blood := new TestedBlood(0, 2, O, 4);
//     var blood2 := new TestedBlood(1, 2, O, 3);
//     assert blood.id == 0;
//     assert blood2.id == 1;
//     assert blood.retrieval == 2;
//     assert blood2.retrieval == 2;
//     assert blood.bloodType == O;
//     assert blood2.bloodType == O;
//     assert blood.expiration == 4;
//     assert blood2.expiration = 3;
// }
