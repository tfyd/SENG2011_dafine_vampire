// Untested | Tested | Disposed
datatype State = UT | TD | DP

// datatype BloodType = 'O' | 'O+' | 'O-' | 'A+' | 'A-' | 'B+' | 'B-' | 'AB+' | 'AB-'
// above cause some error can't fix
// UD means undefined
datatype BloodType = A | B | O | AB | UD

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
        && (state == UT ==> bloodType == UD && expiration == -1 && retrieval != -1)
        && (state == TD ==> bloodType != UD && expiration != -1 && retrieval != -1 && expiration > retrieval)
        && (state == DP ==> bloodType == UD && expiration == -1 && retrieval == -1)
    }

    constructor (bloodid: int, rdate: int)
    requires bloodid > 0 && rdate > 0
    ensures state == UT && bloodType == UD && expiration == -1 
            && retrieval == rdate && id == bloodid;
    {
        id := bloodid;
        state := UT;
        bloodType := UD;
        retrieval := rdate;
        expiration := -1;
    }

    method testSucc (exdate: int, tp: BloodType) 
    requires exdate > 0 && state == UT && tp != UD
    requires exdate > retrieval
    ensures state == TD && expiration == exdate && bloodType == tp 
    ensures retrieval == old(retrieval) && id == old(id)
    {
        expiration := exdate;
        bloodType := tp;  
        state := TD;   
    }

    // if failed test just dispose I think?
    method disposeBlood() 
    requires state == UT || state == TD
    ensures state == DP && bloodType == UD && expiration == -1 && retrieval == -1
    ensures id == old(id)
    {
        state := DP;
        bloodType := UD;
        expiration := -1;
        retrieval := -1;
    }
}