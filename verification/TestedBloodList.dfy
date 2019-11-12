include "TestedBlood.dfy"

class {:autocontracts} TestedBloodList
{
    var list: array<TestedBlood>;
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
        list := new TestedBlood[size];
        upto := 0;
    }

    method checkStorage()
    {
        
    }


    method insufficentBloodList()
    {

    }

    method numOfStorageCurrent()
    {

    }

    method numOfStorageFuture(date: int)
    {

    }


    method testedBloodNum() returns (num: int)
    ensures num == upto;
    {
        num := upto;
    }
    

    /*method sortByExpiryDate()
    requires list != null // 1.9.7
    requires list.Length > 1 && upto > 1
    ensures Sorted(0, upto);
    ensures multiset(list[..]) == multiset(old(list[..]));
    ensures upto == old(upto);
    ensures list != null;
    modifies list;
    {
        var up:=1;
        while (up < upto)
        invariant list != null;
        invariant 0 <= upto <= list.Length;
        invariant 1 <= up <= upto;
        invariant forall i :: 0 <= i < up ==> list[i] != null
        invariant Sorted(0, up);
        invariant multiset(list[..upto]) == multiset(old(list[..upto]));
        invariant list != null && list.Length > 0 && 0 <= upto <= list.Length
                   && forall i :: 0 <= i < upto ==> list[i] != null
        {
            var down := up; 
            while (down >= 1 && list[down-1].expiration > list[down].expiration)
            invariant 0 <= down <= up;
            invariant list != null;
            invariant 0 <= upto <= list.Length;
            invariant 1 <= up <= upto;
            invariant forall i :: 0 <= i < up ==> list[i] != null
            invariant forall i,j:: (0<=i<j<=up && j!=down) ==> list[i].expiration<=list[j].expiration;
            invariant multiset(list[..upto]) == multiset(old(list[..upto]));
            invariant list != null && list.Length > 0 && 0 <= upto <= list.Length
                      && forall i :: 0 <= i < upto ==> list[i] != null
            {
                list[down-1], list[down] := list[down], list[down-1];
                down:=down-1;
            }
            up:=up+1;
        }
        assert list != null && list.Length > 0 && 0 <= upto <= list.Length
                 && forall i :: 0 <= i < upto ==> list[i] != null;
    }*/

    predicate Sorted(low:int, high:int)
    requires list != null 
    requires 0 <= upto <= list.Length
    requires 0<=low<=high<=upto
    requires forall i :: low <= i < high ==> list[i] != null
    reads this, list, set m | low <= m < high :: list[m]`expiration
    { forall j,k:: low<=j<k<high ==> list[j].expiration<=list[k].expiration }


    method addBlood(blood: TestedBlood)
    requires blood != null
    ensures upto > 0
    ensures list[upto-1] == blood;
    ensures upto == old(upto) + 1;
    ensures old(list[0..old(upto)]) == list[0..old(upto)];
    ensures old(upto) == old(list).Length ==> fresh(list) && list.Length == 2*old(list).Length;
    modifies this, list, this`upto
    {
        assert list.Length != 0;
        if upto == list.Length
        {
            var newlist := new TestedBlood[2*list.Length];
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

    method getBlood(id: int) returns (blood: TestedBlood)
    ensures blood == null ==> forall t :: 0 <= t < upto ==> list[t] != blood;
    ensures blood != null ==> blood.id == id;
    ensures blood != null ==> exists t :: 0 <= t < upto && list[t] == blood;
    {
        var i:= 0;
        blood := null;
        while (i < upto) 
        invariant 0 <= i <= upto;
        invariant blood != null ==> list[i].id == blood.id == id;
        invariant blood == null ==> forall t :: 0 <= t < i ==> list[t] != blood;
        {
            if list[i].id == id {
                blood := list[i];
                break;
            }
            i := i + 1;
        }
    }


    method removeBlood(blood: TestedBlood)
    requires upto > 0;
    requires exists t :: 0 <= t < upto && list[t] == blood;
    ensures upto == old(upto) - 1;
    ensures exists t :: 0 <= t < old(upto) && old(list[t]) == blood
                        && forall p :: 0 <= p < t ==> list[p] == old(list[p])
                        && forall q :: t < q < old(upto) ==> list[q-1] == old(list[q]);
    ensures blood.id == old(blood.id);
    ensures blood == old(blood);
    modifies this, list, this`upto;
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

    method extractBlood(id: int) // returns (blood: TestedBlood)
    // ensures blood != null ==> id == blood.id
    modifies this, this.list, this`upto
    {
        var blood := getBlood(id);
        if(blood != null){
            assert blood.id == id;
            removeBlood(blood);
            assert blood.id == id;
        }
    }
}