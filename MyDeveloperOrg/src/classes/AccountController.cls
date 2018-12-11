public without sharing class AccountController
{
    public List<Account> AccountTemp = new List<Account>();
    public List<Account> result {get;set;}

    public AccountController()
    {
    
    }

    public string searchstring {get;set;} 
    
    public void search(){  
    result = new List<Account>();
    
    for(Account account:accountTemp){
     if(account.Name.contains(searchstring)){
     result.add(account);
     }
    }         
   } 
    
    public List<Account> AccountList
    {
        get
        {
            AccountTemp = [Select u.Id, u.Name From Account u ];
            
            return AccountTemp ;
        }
        set;
    }
    
    
}