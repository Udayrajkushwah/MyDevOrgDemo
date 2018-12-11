trigger managername on Opportunity (after update) { 
Opportunity i=[select ownerid, id,Owner.manager.email,Owner.manager.name from opportunity where id=:trigger.newMap.keySet()];
for (Opportunity o : Trigger.new) 
{ 
if(o.StageName=='Closed Won'){  
String userEmail = i.Owner.manager.email; 
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
String[] toAddresses = new String[] {userEmail}; 
mail.setToAddresses(toAddresses); 
mail.setSubject('Automated email: Contact created'); 
String body = 'won'; 
mail.setPlainTextBody(body); 
Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail});
} 
} 
}