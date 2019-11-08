class {:autocontracts} BloodList
{
  var list: array<int>;
  var upto: int;

  predicate Valid()
  reads this;
  {
    list != null && 0 <= upto < list.Length
  }

  constructor(size: int)
  requires size > 0;
  ensures fresh(list);
  {
    list := new int[size];
    upto := 0;
  }

  method addBlood(blood: int)
  ensures list[upto] == blood;
  ensures upto == old(upto) + 1;
  ensures old(list[0..old(upto)]) == list[0..old(upto)];
  {
   
    if upto == list.Length - 1
    {
      var newlist := new int[2*list.Length];
      forall(i | 0 <= i < list.Length)
      { 
        newlist[i] := list[i];
      }
      list := newlist;
    }
    list[upto+1], upto := blood, upto + 1;


  }


  method removeBlood(blood: int)
  requires upto > 0;
  requires exists t :: 0 <= t <= upto && list[t] == blood;
  ensures upto == old(upto) - 1;
  ensures exists t :: 0 <= t <= old(upto) && old(list[t]) == blood
                      && forall p :: 0 <= p < t ==> list[p] == old(list[p])
                      && forall q :: t < q <= old(upto) ==> list[q-1] == old(list[q]);
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
          forall(j | i < j <= upto)
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


// haven't complete verifying this part
/*method addBlood(a:seq<int>,id:int) returns (a:seq<int>)
  requires |a| > 0
  ensures id in a
{ 
  a := a + [id];
}


method RemoveBlood(a:seq<int>, id:int)returns (b:seq<int>)
  requires |a|>0
  ensures id !in a ==> a == b;
 // ensures forall k :: 0<=k<|b| ==> (b[k]!=id);
{
 var i:=0;
 assert i==0;
 
 while i < |a|
 invariant 0<=i<=|a|
 invariant forall k :: 0<=k<i ==> (a[k]!=id);
 decreases |a|-i
 {
   if a[i]==id 
   {
      assert a[i]==id;
      assert id in a;
      b :=a[..i] + a[i+1..];
      return;
   }
   i := i+1;
 }
 assert forall k:: 0<=k<|a| ==> (a[k]!=id); 
 assert i ==|a|;
 b := a[..];  
 assert a==b;
}


method Main() {
  var s:seq<int> := [20,18,33,44];
  print s[..];
  print "\n";
  var m:seq<int> := RemoveBlood(s,44);
 // assert |m| == 3;
 // assert m[0] == 20;
  //assert m[1] == 18;
  //assert m[2] == 33;
 // assert 44 !in m;
  print "After delete: ";
  print m;
  print "\n";
  
  var n:seq<int> := RemoveBlood(s,50);
  print "After delete: ";
  print n;
  print "\n";
  assert n==s;
}*/
