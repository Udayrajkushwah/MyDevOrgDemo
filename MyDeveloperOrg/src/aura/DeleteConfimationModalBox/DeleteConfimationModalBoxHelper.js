({
	showModal : function(component,componentId,className) {
        
        var modal = component.find(componentId);
        $A.util.removeClass(modal,className+'hide');
        $A.util.addClass(modal,className+'open');
        
     },
     hideModal : function(component,componentId,className) {
        
        var modal = component.find(componentId);
        $A.util.addClass(modal,className+'hide');
        $A.util.removeClass(modal,className+'open');
        
     },
    DeleteItem : function(component) {
                
        var action = component.get("c.deleteRecord");
        action.setParams({
            "delRecID" : component.get("v.delRecID")
        });
        action.setCallback(this,function(response){
            if(response.getReturnValue().isSuccess){
                var toastEvent = $A.get("e.force:showToast");
            	toastEvent.setParams({
                	"title": "Success!",
        			"type": "success",
        			"message": "The record has been deleted successfully."
            	});
            	toastEvent.fire(); 
                 $A.get('e.force:refreshView').fire();
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
            	toastEvent.setParams({
                	"title": "Error!",
                	"type":"error",
                	"message": response.getReturnValue().message
            	});
            	toastEvent.fire(); 
            }
            
        });
        $A.enqueueAction(action);      
       
    },
})