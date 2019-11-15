// Untested | Tested | Disposed
datatype State = UNTESTED | TESTED | DISPOSED

// datatype BloodType = 'O' | 'O+' | 'O-' | 'A+' | 'A-' | 'B+' | 'B-' | 'AB+' | 'AB-'
// above cause some error can't fix
datatype BloodType = A | B | O | AB | UNDEFINED

class {:autocontracts} Blood {

    var state: State;
    var id: int;
    var retrieval: int;
    var bloodType: BloodType;
    var expiration: int;

    predicate Valid()
    reads this
    {
        id != -1
        && (state == UNTESTED ==> bloodType == UNDEFINED && expiration == -1 && retrieval != -1)
        && (state == TESTED ==> bloodType != UNDEFINED && expiration != -1 && retrieval != -1 && expiration > retrieval)
        && (state == DISPOSED ==> bloodType == UNDEFINED && expiration == -1 && retrieval == -1)
    }

    constructor (bloodid: int, rdate: int)
    requires bloodid > 0 && rdate > 0
    ensures state == UNTESTED && bloodType == UNDEFINED && expiration == -1 
            && retrieval == rdate && id == bloodid;
    {
        id := bloodid;
        state := UNTESTED;
        bloodType := UNDEFINED;
        retrieval := rdate;
        expiration := -1;
    }

    method testSucc (exdate: int, tp: BloodType) 
    requires exdate > 0 && state == UNTESTED && tp != UNDEFINED
    requires exdate > retrieval
    ensures state == TESTED && expiration == exdate && bloodType == tp 
    ensures retrieval == old(retrieval) && id == old(id)
    {
        expiration := exdate;
        bloodType := tp;  
        state := TESTED;   
    }

    // if failed test just dispose I think?
    method disposeBlood() 
    requires state == UNTESTED || state == TESTED
    ensures state == DISPOSED && bloodType == UNDEFINED && expiration == -1 && retrieval == -1
    ensures id == old(id)
    {
        state := DISPOSED;
        bloodType := UNDEFINED;
        expiration := -1;
        retrieval := -1;
    }
}