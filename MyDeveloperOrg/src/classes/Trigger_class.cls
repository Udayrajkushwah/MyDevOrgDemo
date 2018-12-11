Public class Trigger_class{
     public static void check_opt(List<Opportunity> opt){
     
     Double Total_amount = 0;
     for(Opportunity o1 : [Select Amount from Opportunity where createdDate=TODAY
                                                           AND createdbyID= :UserInfo.getUserID()]){
                                                            
     Total_amount += o1.Amount;                                                           
     }
     For(Opportunity o2 : opt){
     Total_amount += o2.Amount;
     if(Total_amount > 10000)
     o2.addError('You have Exceeded daily Limit');
     }
     }
}