public class Trg1_handler {
    public static void before_insert(List<Account> acc){
        For(Account a: acc){
            if(a.Description==null){
                a.Description='Hello';
            }
        }
        
        
    }
    public static void before_update(List<Account> acc){
        For(Account a: acc){
            if(a.Description==null){
                a.Description='Word';
            }
        }
        
        
    }

}