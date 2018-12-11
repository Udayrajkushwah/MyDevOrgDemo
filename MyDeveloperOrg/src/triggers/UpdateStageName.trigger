trigger UpdateStageName on Opportunity (after update) {
    
    List<Opportunity> oppList = new List<Opportunity>();
     for(Opportunity opp: Trigger.new) {

        if(Trigger.isInsert){
        if(opp.StageName=='Closed Won') {
            oppList.add(opp);
        }
    }
       else {
        Opportunity oldOpp  = Trigger.oldMap.get(opp.Id);
        Boolean oldOppIsWon = oldOpp.StageName.equals('Closed Won');
        Boolean newOppIsWon = opp.StageName.equals('Closed Won');

        if(!oldOppIsWon && newOppIsWon) {

            oppList.add(opp);
        }
    }

    

}
}