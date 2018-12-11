public without sharing class UserContact 
{
    public List<Contact> ContactTemp = new List<Contact>();
    
    
    public UserContact()
    {
    
    }

       
    public List<Contact> ContactList
    {
        get
        {
          //ContactTemp = [select c.FirstName, c.LastName from Contact c];
         ContactTemp =[select c.FirstName,c.LastName from Contact c where SystemModStamp >= LAST_N_DAYS:7];
         
        
                                
           return ContactTemp ;
        }
        set;
    }
}