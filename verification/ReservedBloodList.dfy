include "TestedBlood.dfy"

class ReservedBloodList
{
    var list: array<TestedBlood>;
    var upto: int;

    predicate UniqueId()
    requires Valid(); ensures Valid();
    requires list != null 
    requires 0 <= upto <= list.Length
    requires forall i :: 0 <= i < upto ==> list[i] != null
    reads this, this.list, this`upto, set m | 0 <= m < upto :: list[m]`id;
    {
        forall j,k:: 0<=j<k<upto ==> list[j].id != list[k].id
    }

    predicate Valid()
    reads this, this.list, this`upto;
    {
        list != null && list.Length > 0 && 0 <= upto <= list.Length
        && forall i :: 0 <= i < upto ==> list[i] != null
    }

    predicate Sorted(list: array<TestedBlood>,low:int, high:int)
    requires list != null 
    requires 0 <= high <= list.Length
    requires 0<=low<=high
    requires forall i :: low <= i < high ==> list[i] != null
    reads list, set m | low <= m < high :: list[m]`expiration
    { forall j,k:: low<=j<k<high ==> list[j].expiration<=list[k].expiration }


    constructor(size: int)
    requires size > 0;
    ensures Valid(); 
    ensures UniqueId();
    ensures fresh(list);
    ensures this.upto == 0;
    modifies this
    {
        list := new TestedBlood[size];
        upto := 0;
    }
    
    // Correspond to ReservedBloodList.py::sortByExpiryDate()
    method sortByExpiryDate()
    requires list != null 
    requires list.Length > 1 && upto > 1
    requires Valid(); ensures Valid();
    ensures Sorted(list, 0, upto);
    ensures multiset(list[..upto]) == multiset(old(list[..upto]));
    ensures upto == old(upto);
    ensures list != null;
    requires UniqueId(); ensures UniqueId();
    modifies list;
    ensures list == old(list);
    {
        var up:=1;
        while (up < upto)
        invariant list != null;
        invariant 0 <= upto <= list.Length;
        invariant 1 <= up <= upto;
        invariant forall i :: 0 <= i < up ==> list[i] != null
        invariant Valid();
        invariant Sorted(list, 0, up);
        invariant multiset(list[..upto]) == multiset(old(list[..upto]));
        invariant list != null && list.Length > 0 && 0 <= upto <= list.Length
                   && forall i :: 0 <= i < upto ==> list[i] != null
        invariant UniqueId();
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
            invariant UniqueId();
            {
                list[down-1], list[down] := list[down], list[down-1];
                down:=down-1;
            }
            up:=up+1;
        }
        assert list != null && list.Length > 0 && 0 <= upto <= list.Length
                 && forall i :: 0 <= i < upto ==> list[i] != null;
    }

    // Correspond to ReservedBloodList.py::addBlood() -- inherited from BloodList
    method addBlood(blood: TestedBlood)
    ensures Valid(); requires Valid();
    requires UniqueId(); ensures UniqueId();
    ensures list == old(list) || fresh(list)
    requires blood != null;
    requires list != null;
    requires forall i :: 0 <= i < upto  ==> list[i]!=null;
    requires forall i :: 0 <= i < upto  ==> list[i].id != blood.id;
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

    // Correspond to ReservedBloodList.py::getBlood() -- inherited from BloodList
    method getBlood(id: int) returns (blood: TestedBlood)
    requires Valid(); ensures Valid();
    requires UniqueId(); ensures UniqueId();
    ensures blood != null ==> exists t :: 0 <= t < upto && list[t] == blood;
    ensures blood == null ==> forall t :: 0 <= t < upto ==> list[t] != blood;
    ensures blood != null ==> blood.id == id;
    ensures (exists t :: 0 <= t < old(upto) && old(list[t]).id == id) ==> blood != null;
    ensures (forall t :: 0 <= t < old(upto) ==> old(list[t]).id != id) ==> blood == null;
    ensures multiset(old(list[0..old(upto)])) == multiset(list[0..upto]);
    ensures forall t :: 0 <= t < upto ==> list[t] == old(list[t]);
    ensures upto == old(upto);

    {
        var i:= 0;
        blood := null;
        while (i < upto) 
        invariant i <= upto;
        invariant blood != null ==> exists t :: 0 <= t <= i && list[t] == blood;
        invariant (exists t :: 0 <= t < old(i) && old(list[t]).id == id) ==> blood != null;
        invariant (forall t :: 0 <= t < old(i) ==> old(list[t]).id != id) ==> blood == null;
        {
            if list[i].id == id {
                blood := list[i];
                break;
            }
            i := i + 1;
        }
    }
    
    // Correspond to ReservedBloodList.py::removeBlood() -- inherited from BloodList
    method removeBlood(blood: TestedBlood)
    requires Valid(); ensures Valid();
    requires UniqueId(); ensures UniqueId();
    modifies this.list, this`upto
    requires upto > 0;
    requires exists t :: 0 <= t < upto && list[t] == blood;
    ensures upto == old(upto) - 1;
    ensures blood == old(blood);
    ensures (exists t :: 0 <= t < old(upto) && old(list[t]) == blood
                    && (forall k :: 0 <= k < t ==> list[k] == old(list[k]))
                    && (forall q :: t < q < old(upto) ==> list[q-1] == old(list[q]))
                    );
    ensures (forall t :: 0 <= t < upto ==> list[t].id != blood.id);
    ensures list == old(list);
    {
        var i:=0;
        var bloodFound := false;
        var bloodIndex := -1;
        while i <= upto
        invariant 0 <= i <= upto;
        invariant forall k :: 0 <= k < i ==> list[k] != blood;
        invariant forall j :: 0 <= j < i ==> list[j] == old(list[j]);
        invariant (exists t :: 0 <= t < i && list[t] == blood) ==> bloodFound;
        invariant bloodFound ==> forall l :: bloodIndex < l < i ==> list[l-1] == old(list[l]);
        invariant forall t :: 0 <= t < old(upto) && old(list[t])!= blood ==> (exists k :: 0 <= k < upto && old(list[t]) == list[k]);
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
                upto := upto - 1;
                break;
            }
            i := i + 1;
        }
    }

    // Correspond to ReservedBloodList.py::extractBlood() -- inherited from BloodList
    method extractBlood(id: int) returns (blood: TestedBlood)
    requires Valid(); ensures Valid();
    requires UniqueId(); ensures UniqueId();
    ensures blood != null ==> upto == old(upto-1);
    ensures blood == null ==> upto == old(upto);
    ensures blood == null ==> old(list[0..upto]) == list[0..upto];
    ensures (blood != null) ==> (exists t :: 0 <= t < old(upto) && old(list[t]) == blood
                            && old(list[0..t]) == list[0..t]
                            && old(list[t+1..old(upto)]) == list[t..upto]
                            );
    ensures (blood != null) ==> (exists t :: 0 <= t < old(upto) && old(list[t]) == blood
                        && (forall k :: 0 <= k < t ==> list[k].expiration == old(list[k]).expiration)
                        && (forall q :: t < q < old(upto) ==> list[q-1].expiration == old(list[q]).expiration)
                        );
    ensures (blood != null) ==> (forall t :: 0 <= t < upto ==> list[t].id != id);
    ensures blood != null ==> blood.id == id;
    ensures (exists t :: 0 <= t < old(upto) && old(list[t]).id == id) ==> blood != null;
    ensures (forall t :: 0 <= t < old(upto) ==> old(list[t]).id != id) ==> blood == null;
    ensures blood == null ==> (forall t :: 0 <= t < upto ==> list[t].id != id);
    ensures (forall t :: 0 <= t < upto ==> list[t].id != id);
    ensures list == old(list);
    modifies this.list, this`upto
    {
        blood := getBlood(id);
        if(blood != null){
            removeBlood(blood);
        }
    }
}