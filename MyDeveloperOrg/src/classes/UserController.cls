public without sharing class UserController 
{
    public List<User> UserTemp = new List<User>();
    public List<User> result {get;set;}

    public UserController()
    {
    
    }

    public string searchstring {get;set;} 
    
    public void search(){  
    result = new List<User>();
    
    for(User user:userTemp){
     if(user.Name.contains(searchstring)){
     result.add(user);
     }
    }         
   } 
    
    public List<User> UserList
    {
        get
        {
            UserTemp = [Select u.Id, u.Name From User u];
            
            return UserTemp ;
        }
        set;
    }
}