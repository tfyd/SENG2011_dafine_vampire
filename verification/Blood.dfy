// match python abstract class Blood
class Blood {
    var id: int;

    constructor (bloodid: int)
    ensures id == bloodid
    modifies this
    {
        id := bloodid;
    }
}