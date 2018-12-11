({
    //init method to get sObject data on load of page
	doInit : function(component, event, helper) {
		helper.getsObjectResult(component,event,helper);
	},
    //Method will enable in line edit
    showEdit :function(component, event, helper) {
        var rowDataPre = component.get("v.sObjectRowData");
        var showNoEditmsg=true;
        for(var r=0;r<rowDataPre.length;r++){
            var userRec = rowDataPre[r].usrRecAcc;
            if(userRec.HasEditAccess){
                showNoEditmsg= false;
                break;
            }
        }
        if(showNoEditmsg){
            var spinnerMod = component.find("spinnerId");
            $A.util.removeClass(spinnerMod,'slds-spinner_container-hide');
            var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Action!",
                            "type": "Warning",
                            "message": 'Dont have edit access on any of records',
                            "mode": "sticky"    
                    	});
                    	toastEvent.fire();
        }else{
            component.set("v.edit", 1);
            helper.getsObjectResult(component,event,helper);
        }
    },
    //Method will disable inline edit
    cancelEdit : function(component, event, helper) {
        component.set("v.edit", 0);
        $A.get('e.force:refreshView').fire();
    },
    //Single or Multiple record update on click of Save button
    saveRecords : function(component, event, helper) {
        helper.saveMultipleRecords(component, event, helper);
    },
    //Method to delete selected record
    deleteRelatedInfo: function(component, event, helper) {
        helper.deleteSelectedRec(component,event,helper);
    },
    //Method to add new row in data table to create record
    addNewRow: function(component,event,helper){
        helper.addNewRowData(component,event,helper);
    },
    //Method to sort data table based on selection
    sortColumn: function(component,event,helper){
        helper.getSortTable(component,event,helper);
    },
    recTypeSelect : function(component,event,helper){
    	component.set("v.recordTypeId",event.getParam("recodTypeId"));
        component.set("v.defaultAllRecType",event.getParam("defaultVal"));
        console.log('recordTypeId==> '+component.get("v.recordTypeId"));
        helper.addRows(component,event,helper);
	},
    showSpinner: function(component,event,helper){
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    hideSpinner:function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    }
})