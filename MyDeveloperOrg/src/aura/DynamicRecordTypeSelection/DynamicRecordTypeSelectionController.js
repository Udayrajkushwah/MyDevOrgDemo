({
	doInit : function(component, event, helper) {
		var conts = component.get("v.mapRecType");
        var custs = [];
                for ( var key in conts ) {
                    
                    custs.push({value:conts[key], key:key});
                }
                component.set("v.recordType", custs);
	},
    onGroup : function(component, event, helper) {
        component.set("v.RectypeId",event.getSource().get("v.text"));
    },
    hidemodalBox : function(component, event,helper){
        var recEvt = component.getEvent("recodTypeSet");
        recEvt.setParams({
            "recodTypeId" : component.get("v.RectypeId"),
            "defaultVal": component.get("v.defeaultToAll")
        });
        recEvt.fire();
        
        helper.hideModal(component,'recodTypeModalBox','slds-fade-in-'); 
        helper.hideModal(component,'backdrop1','slds-backdrop--');
   	},
    
})