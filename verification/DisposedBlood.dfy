// match python class: DisposedBlood
class DisposedBlood {
    var id: int;

    constructor (bloodid: int)
    ensures id == bloodid
    modifies this
    {
        id := bloodid;
    }
}