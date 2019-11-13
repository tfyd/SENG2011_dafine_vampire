include "TestedBlood.dfy"

class TestedBloodList
{
    var list: array<TestedBlood>;
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
    ensures Valid(); requires Valid();
    ensures num == upto;
    {
        num := upto;
    }
    

    method sortByExpiryDate()
    requires list != null // 1.9.7
    requires list.Length > 1 && upto > 1
    requires Valid(); ensures Valid();
    ensures Sorted(0, upto);
    ensures multiset(list[..upto]) == multiset(old(list[..upto]));
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
        invariant Valid();
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
            invariant 1 <= up < upto;
            invariant forall i :: 0 <= i <= up ==> list[i] != null
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
    }

    predicate Sorted(low:int, high:int)
    requires Valid(); ensures Valid();
    requires list != null 
    requires 0 <= upto <= list.Length
    requires 0<=low<=high<=upto
    requires forall i :: low <= i < high ==> list[i] != null
    reads this, list, set m | low <= m < high :: list[m]`expiration
    { forall j,k:: low<=j<k<high ==> list[j].expiration<=list[k].expiration }


    method addBlood(blood: TestedBlood)
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

    
    method extractBlood(id: int) returns (bloodFound: bool, blood: TestedBlood)
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
                break;
            }
            i := i + 1;
        }

        upto := upto - 1;
    }
}

/*method Main()
{
    var blood := new TestedBlood(0, 2, O, 4);
    var blood2 := new TestedBlood(1, 2, O, 3);
    var bloodlist := new TestedBloodList(5);
    bloodlist.addBlood(blood);
    bloodlist.addBlood(blood2);
    print blood.id, "\n";
    print bloodlist.upto, "\n";
    //assert bloodlist.upto == 2;
    var find, removed := bloodlist.extractBlood(0);
    print bloodlist.upto, "\n";
}*/