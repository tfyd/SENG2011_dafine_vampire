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
    modifies this, this.list, this`upto
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
    ensures bloodFound ==> upto == old(upto) - 1;
    ensures bloodFound ==> exists t :: 0 <= t < old(upto) && old(list[t]) == blood
                        && forall p :: 0 <= p < t ==> list[p] == old(list[p])
                        && forall q :: t < q < old(upto) ==> list[q-1] == old(list[q]);
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