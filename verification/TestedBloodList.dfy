include "TestedBlood.dfy"

predicate Sorted(list: array<TestedBlood>,low:int, high:int)
requires list != null 
requires 0 <= high <= list.Length
requires 0<=low<=high
requires forall i :: low <= i < high ==> list[i] != null
reads list, set m | low <= m < high :: list[m]`expiration
{ forall j,k:: low<=j<k<high ==> list[j].expiration<=list[k].expiration }

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
    ensures this.upto == 0;
    modifies this
    {
        list := new TestedBlood[size];
        upto := 0;
    }

    // Print for each of blood type
    // Instead of print, in dafny, we return the multiset
    // * Got stuck on verifying this one
    method numOfStorageCurrent() returns (summary: multiset<BloodType>)
    requires Valid(); ensures Valid();
    ensures upto = old(upto);
    ensures list = old(list);
    
    {
        var types: seq<BloodType> := []; 
        var i := 0;
        while (i < upto) 
            invariant 0 <= i <= upto;
        {
            types := types + [list[i].bloodType];
            i := i+1;
        }
        summary := multiset(types);
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
    ensures Sorted(list, 0, upto);
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
        invariant Sorted(list, 0, up);
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

    method addBlood(blood: TestedBlood)
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
    requires Valid(); ensures Valid();
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
    
    method removeBlood(blood: TestedBlood)
    requires Valid(); ensures Valid();
    modifies this.list, this`upto
    requires upto > 0;
    requires exists t :: 0 <= t < upto && list[t] == blood;
    ensures upto == old(upto) - 1;
    ensures blood == old(blood);
    ensures (exists t :: 0 <= t < old(upto) && old(list[t]) == blood
                    && (forall k :: 0 <= k < t ==> list[k] == old(list[k]))
                    && (forall q :: t < q < old(upto) ==> list[q-1] == old(list[q]))
                    );
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

    method extractBlood(id: int) returns (blood: TestedBlood)
    requires Valid(); ensures Valid();
    ensures blood != null ==> upto == old(upto-1);
    ensures blood == null ==> upto == old(upto);
    ensures blood == null ==> old(list[0..upto]) == list[0..upto];
    ensures (blood != null) ==> (exists t :: 0 <= t < old(upto) && old(list[t]) == blood
                            && old(list[0..t]) == list[0..t]
                            && old(list[t+1..old(upto)]) == list[t..upto]
                            );
    ensures blood != null ==> blood.id == id;
    ensures (exists t :: 0 <= t < old(upto) && old(list[t]).id == id) ==> blood != null;
    ensures (forall t :: 0 <= t < old(upto) ==> old(list[t]).id != id) ==> blood == null;
    modifies this.list, this`upto
    {
        blood := getBlood(id);
        if(blood != null){
            removeBlood(blood);
        }
    }
}

// method Main()
// {
//     var blood := new TestedBlood(0, 2, O, 4);
//     var blood2 := new TestedBlood(1, 2, O, 5);
//     var blood3 := new TestedBlood(2, 2, O, 3);

//     // will need to reallocated array size
//     var bloodlist := new TestedBloodList(2);


//     bloodlist.addBlood(blood);
//     assert bloodlist.list[0] == blood;
//     assert bloodlist.upto == 1;
//     bloodlist.addBlood(blood2);
//     assert bloodlist.list[1] == blood2;
//     assert bloodlist.list[0] == blood;
//     bloodlist.addBlood(blood3);
//     assert bloodlist.list[0] == blood;
//     assert bloodlist.list[1] == blood2;
//     assert bloodlist.list[2] == blood3;

//     assert bloodlist.list[..bloodlist.upto] == [blood,blood2,blood3];

//     ghost var temp := multiset(bloodlist.list[..bloodlist.upto]); 

//     bloodlist.sortByExpiryDate();

//     assert multiset(bloodlist.list[..bloodlist.upto]) == temp;
//     assert Sorted(bloodlist.list, 0, bloodlist.upto);
//     assert bloodlist.list[..bloodlist.upto] == [blood3,blood,blood2];
//     assert bloodlist.list[0].expiration <= bloodlist.list[1].expiration <= bloodlist.list[2].expiration;
    
//     assert bloodlist.upto == 3;

//     // id = 5 does't exist
//     var removed := bloodlist.extractBlood(5);
//     assert removed == null;
//     assert bloodlist.upto == 3;

//     var removed1 := bloodlist.extractBlood(blood3.id);
//     assert removed1.id == blood3.id;
//     assert bloodlist.upto == 2;

//     // id = 5 does't exist
//     var removed2 := bloodlist.extractBlood(5);
//     assert removed2 == null;
//     assert bloodlist.upto == 2;

//     var removed3 := bloodlist.extractBlood(blood.id);
//     assert removed3.id == blood.id;
//     assert bloodlist.upto == 1;

//     var removed4 := bloodlist.extractBlood(blood2.id);
//     assert removed4.id == blood2.id;
//     assert bloodlist.upto == 0;
// }