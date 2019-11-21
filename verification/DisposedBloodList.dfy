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

    predicate UniqueId()
    requires Valid(); ensures Valid();
    requires list != null 
    requires 0 <= upto <= list.Length
    requires forall i :: 0 <= i < upto ==> list[i] != null
    reads this, this.list, this`upto, set m | 0 <= m < upto :: list[m]`id;
    {
        forall j,k:: 0<=j<k<upto ==> list[j].id != list[k].id
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
    requires UniqueId(); ensures UniqueId();
    requires blood != null
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

    method getBlood(id: int) returns (blood: DisposedBlood)
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

    method removeBlood(blood: DisposedBlood)
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
    
    method extractBlood(id: int) returns (blood: DisposedBlood)
    requires Valid(); ensures Valid();
    requires UniqueId(); ensures UniqueId();
    ensures blood != null ==> upto == old(upto-1);
    ensures blood == null ==> upto == old(upto);
    ensures blood == null ==> old(list[0..upto]) == list[0..upto];
    ensures (blood != null) ==> (exists t :: 0 <= t < old(upto) && old(list[t]) == blood
                            && old(list[0..t]) == list[0..t]
                            && old(list[t+1..old(upto)]) == list[t..upto]
                            );
    ensures (blood != null) ==> (forall t :: 0 <= t < upto ==> list[t].id != id);
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
//     var blood := new DisposedBlood(0);
//     var blood2 := new DisposedBlood(1);
//     var blood3 := new DisposedBlood(2);
//     assert blood.id == 0;
//     assert blood2.id == 1;
//     var bloodlist := new DisposedBloodList(2);
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
// }