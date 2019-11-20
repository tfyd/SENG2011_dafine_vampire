include "DisposedBlood.dfy"

class DisposedBloodList
{
    var list: array<DisposedBlood>;
    var upto: int;

    predicate Valid()
    reads this, this.list, this`upto;
    {
        list != null && list.Length > 0 && 0 <= upto <= list.Length
        && forall i :: 0 <= i < upto ==> list[i] != null
    }

    constructor(size: int)
    requires size > 0;
    ensures Valid(); 
    ensures fresh(list);
    ensures this.upto == 0;
    modifies this
    {
        list := new DisposedBlood[size];
        upto := 0;
    }


    method addBlood(blood: DisposedBlood)
    ensures Valid(); requires Valid();
    requires blood != null
    ensures upto > 0
    ensures list[upto-1] == blood;
    ensures upto == old(upto) + 1;
    ensures old(upto) == old(list.Length) ==> fresh(list) && list.Length == 2*old(list).Length;
    ensures forall i :: 0 <= i < old(upto)  ==> list[i] == old(list[i]);    
    modifies this, this.list, this`upto
    {
        assert list.Length != 0;
        if upto == list.Length
        {
            var newlist := new DisposedBlood[2*list.Length];
            forall(i | 0 <= i < list.Length)
            {
                newlist[i] := list[i];
            }
            list := newlist;
            assert upto < list.Length;
        }
        assert upto < list.Length;
        list[upto], upto := blood, upto + 1;

    }

    
    method extractBlood(id: int) returns (bloodFound: bool, blood: DisposedBlood)
    ensures Valid(); requires Valid();
    requires upto > 0;
    ensures !bloodFound  ==> upto == old(upto);
    ensures !bloodFound ==> old(list[0..upto]) == list[0..upto];
    ensures bloodFound ==> (exists t :: 0 <= t < old(upto) && old(list[t]) == blood
                    && (forall k :: 0 <= k < t ==> list[k] == old(list[k]))
                    && (forall q :: t < q < old(upto) ==> list[q-1] == old(list[q]))
                    );
    ensures blood != null ==> blood.id == id;
    ensures (exists t :: 0 <= t < old(upto) && old(list[t]).id == id) ==> bloodFound;
    ensures (forall t :: 0 <= t < old(upto) ==> old(list[t]).id != id) ==> !bloodFound;
    ensures bloodFound ==> upto == old(upto) - 1;
    ensures bloodFound ==> blood.id == id;
    modifies this.list, this`upto;
    {
        bloodFound := false;
        blood := null;
        var i:=0;
        var bloodIndex := -1;
        while i < upto
        invariant 0 <= i <= upto;
        invariant forall k :: 0 <= k < i ==> list[k] != blood;
        invariant forall j :: 0 <= j < i ==> list[j] == old(list[j])
        invariant (exists t :: 0 <= t < i && list[t].id == id) ==> bloodFound;
        invariant forall t :: 0 <= t < old(upto) && old(list[t])!= blood ==> (exists k :: 0 <= k < upto && old(list[t]) == list[k]);
        invariant bloodFound ==> forall l :: bloodIndex < l < i ==> list[l-1] == old(list[l])
        decreases upto - i;
        {
            if list[i].id == id
            {
                bloodFound := true;
                bloodIndex := i;
                blood := list[i];
                forall(j | i < j < upto)
                {
                    list[j - 1] := list[j];
                }
                upto := upto - 1;
                break;
            }
            i := i + 1;
        }

    }
}

method Main()
{
    var blood := new DisposedBlood(0);
    var blood2 := new DisposedBlood(1);
    var blood3 := new DisposedBlood(2);
    assert blood.id == 0;
    assert blood2.id == 1;
}