include "TestedBloodList.dfy"
include "ReservedBloodList.dfy"

// find the blood of this id, 
// remove from testedbloodlist
// add to reservedlist
method reserveBlood(id: int, testedlist: TestedBloodList, reservedlist: ReservedBloodList) 
requires testedlist != null && reservedlist != null
requires testedlist.Valid() && reservedlist.Valid()
requires testedlist.upto > 0
modifies testedlist, testedlist.list, testedlist`upto
{
    var find, b := testedlist.extractBlood(id);
    if(find){
        
    }
}

// not sure if we need this
// need to first dispose expirated blood
// then sort the list and print sorted list
method viewBlood(list: TestedBloodList)
{

}

// not sure how to implement in dafny
// maybe return the number of blood in different type
method viewBloodType(list: TestedBloodList)
{

}

// same as viewBlood
method viewReservedList(list: ReservedBloodList) 
{

}

// remove from reservedlist, add to testedlist
method removeReservation(id: int, testedlist: TestedBloodList, reservedlist: ReservedBloodList)
{

}