public class OpportunityMail {
public String userEmail;
    public opportunitymail(String email)
    {
        userEmail = email; 
    }
public void sendmail()
{
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
String[] toAddresses = new String[] {userEmail}; 
mail.setToAddresses(toAddresses); 
mail.setSubject('Automated email: Opportunity stageName has been changed'); 
String body = 'won'; 
mail.setPlainTextBody(body); 
Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail});
}
}