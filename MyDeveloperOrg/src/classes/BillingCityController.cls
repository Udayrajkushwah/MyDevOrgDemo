public without sharing class BillingCityController 
{
    public List<Account> AccountTemp = new List<Account>();
    public List<Account> result {get;set;}

    public BillingCityController()
    {
    
    }
    
    //public string countAccountCity {get;set;} 
    
   // public void cityMap(){  
    //result = new List<Account>();
    
   // Map<String,Integer> billingmap = new Map<String, Integer>();
        
      // }         
  // } 
       
    public List<Account> AccountList
    {
        get
        {
            AccountTemp = [SELECT BillingCity FROM Account];
            
            return AccountTemp  ;
        }
        set;
    }
    
    
}