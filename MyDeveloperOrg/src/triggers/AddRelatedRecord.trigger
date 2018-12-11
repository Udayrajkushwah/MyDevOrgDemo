trigger AddRelatedRecord on Account (After insert, After update) {
    
    List<Opportunity>  oppList = new List<Opportunity>();
    Map<Id,Account>  acctsWithOpps = new Map<Id,Account>([SELECT Id,(SELECT Id FROM Opportunities) FROM Account WHERE Id IN :Trigger.New]);
    
    System.debug('acctsWithOpps==' + acctsWithOpps);
    
    for(Account a : Trigger.new){
        System.debug('acctsWithOpps.get(a.Id).Opportunities.Size()==' + acctsWithOpps.get(a.Id).Opportunities.Size());
        If (acctsWithOpps.get(a.Id).Opportunities.Size()==0){
             System.debug('a.NameTest==' + a.Name);
             System.debug('a.IdTest2==' + a.Id);
            oppList.add(new Opportunity(Name=a.Name + ' Opportunity',
                                        StageName='Prospecting',
                                        CloseDate=System.today().addMonths(1),
                                        AccountId=a.Id));
        }
    }
    if(oppList.size()>0){
       insert  oppList;
    }

}