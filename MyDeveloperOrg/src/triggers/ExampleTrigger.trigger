trigger ExampleTrigger on Contact (After insert,After Delete) {
    
    if(Trigger.isInsert){
        Integer recordCount = Trigger.new.Size();
        EmailManager.sendMail('udayraj.kushwah@gmail.com', 'Trailhead Trigger Tutorial', 
                    recordCount + ' contact(s) were inserted.');
    }
    else if (Trigger.isDelete){
        //Some code
    }

}