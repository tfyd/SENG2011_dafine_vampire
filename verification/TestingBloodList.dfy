include "TestingBlood.dfy"

class {:autocontracts} TestingBloodList
{
    var list: array<TestingBlood>;
    var upto: int;

    predicate Valid()
    reads this;
    {
        list != null && list.Length > 0 && 0 <= upto <= list.Length
        && forall i :: 0 <= i < upto ==> list[i] != null
    }

    constructor(size: int)
    requires size > 0;
    ensures fresh(list);  
    {
        list := new TestingBlood[size];
        upto := 0;
    }

    method addBlood(blood: TestingBlood)
    requires blood != null
    ensures upto > 0
    ensures list[upto-1] == blood;
    ensures upto == old(upto) + 1;
    ensures old(list[0..old(upto)]) == list[0..old(upto)];
    ensures old(upto) == old(list).Length ==> list.Length == 2*old(list).Length;
    {
        assert list.Length != 0;
        if upto == list.Length
        {
            var newlist := new TestingBlood[2*list.Length];
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

    method getBlood(id: int) returns (blood: TestingBlood)
    ensures blood != null ==> exists t :: 0 <= t < upto && list[t] == blood;
    {
        var i:= 0;
        blood := null;
        while (i < upto) 
        invariant blood != null ==> exists t :: 0 <= t <= i && list[t] == blood;
        {
            if list[i].id == id {
                blood := list[i];
                break;
            }
            i := i + 1;
        }
    }


    method removeBlood(blood: TestingBlood)
    requires upto > 0;
    requires exists t :: 0 <= t < upto && list[t] == blood;
    ensures upto == old(upto) - 1;
    ensures exists t :: 0 <= t < old(upto) && old(list[t]) == blood
                        && forall p :: 0 <= p < t ==> list[p] == old(list[p])
                        && forall q :: t < q < old(upto) ==> list[q-1] == old(list[q]);
    {
        var i:=0;
        var bloodFound := false;
        var bloodIndex := -1;
        while i <= upto
        invariant 0 <= i <= upto;
        invariant forall k :: 0 <= k < i ==> list[k] != blood;
        invariant forall j :: 0 <= j < i ==> list[j] == old(list[j])
        invariant bloodFound ==> forall l :: bloodIndex < l < i ==> list[l-1] == old(list[l])
        decreases upto - i;
        {
            if list[i] == blood
            {
                bloodFound := true;
                bloodIndex := i;
                forall(j | i < j < upto)
                {
                    list[j - 1] := list[j];
                }

                break;
            }
            i := i + 1;
        }

        upto := upto - 1;

    }

    method extractBlood(id: int)
    {
        var blood: TestingBlood;
        blood := getBlood(id);
        if(blood != null){
            removeBlood(blood);
        }
    }
}