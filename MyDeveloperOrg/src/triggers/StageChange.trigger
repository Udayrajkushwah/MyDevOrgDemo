trigger StageChange on Opportunity (after update) {
        Opportunity i=[select ownerid, id, name, owner.name, owner.email from opportunity where id ='00658000002JpymAAC'];
        for(Opportunity opp:trigger.new){
            opportunity opp1=trigger.oldmap.get(opp.Id);
            if(opp1.stageName!=opp.stageName)
            {
                String mail=(String)i.Owner.email;
                OpportunityMail opm=new opportunitymail(mail);
                opm.sendmail();
            }
            
        }

}