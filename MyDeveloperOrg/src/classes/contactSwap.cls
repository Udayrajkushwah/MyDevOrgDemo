public class contactSwap {
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator([select Firstname,Lastname from Contact]));
            }
            return setCon;
        }
        set;
    }
    public List<Contact> getContacts() {
       return (List<Contact>) setCon.getRecords();
        
           }
}