public with sharing class PaginationExtension {

    Public List<Account> accList = new List<Account>();
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
     public List<Account> result {get;set;}

    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                size = 5;
                string queryString = 'Select Name from Account order by Name';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }set;
    }
    Public List<Account> getAccounts(){
        
            //for(Account a : (List<Account>)setCon.getRecords())
          accList  =(List<Account>)setCon.getRecords();
            //accList.add(a);
        return accList;
        }
      
    
    public pageReference refresh() {
        setCon = null;
        getAccounts();
        setCon.setPageNumber(1);
        return null;
    }
    public string searchstring {get;set;} 
    
    public void search(){  
    result = new List<Account>();
    
    for(Account account:accList){
     if(account.Name.contains(searchstring)){
     result.add(account);
     }
    }         
   } 
    
}