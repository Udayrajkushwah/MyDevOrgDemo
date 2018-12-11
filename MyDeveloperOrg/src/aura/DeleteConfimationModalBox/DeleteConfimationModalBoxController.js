({
	doInit : function(component, event, helper) {
        //helper.showModal(component,'backdrop1','slds-backdrop--');
        //helper.showModal(component,'deleteModalBox','slds-fade-in-');
        
	},
    hidemodalBox : function(component, event,helper){
       
        helper.hideModal(component,'deleteModalBox','slds-fade-in-'); 
        helper.hideModal(component,'backdrop1','slds-backdrop--');
   	},
    deleteRecConfirmation : function(component, event,helper){
        
        helper.hideModal(component,'deleteModalBox','slds-fade-in-'); 
        helper.hideModal(component,'backdrop1','slds-backdrop--');
        helper.DeleteItem(component, event,helper);
    }
    
})