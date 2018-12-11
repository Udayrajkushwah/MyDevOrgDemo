({
	setfieldToSort : function(component, event, helper) {
		var sortEvt = component.getEvent("sortEventColumn");
        sortEvt.setParams({
            "fieldApi" : component.get("v.fieldApi")
        });
        sortEvt.fire();
	}
})