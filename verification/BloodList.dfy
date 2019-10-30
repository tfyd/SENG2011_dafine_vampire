
// haven't complete verifying this part
method addBlood(a:seq<int>,id:int) returns (b:seq<int>)
{ 
  b := a + [id];
}


method RemoveBlood(a:seq<int>, id:int)returns (b:seq<int>)
  requires |a|>0
  ensures id !in a ==> a ==b;
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
}
