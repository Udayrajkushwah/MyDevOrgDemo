({
    //Method To pass Admin input data to backend to get related result to be displayed on UI 
	getsObjectResult : function(component,event,helper) {
        var sortFieldApi = component.get("v.sortFieldColumn");
        var showEditButton=false;
        if(sortFieldApi ==undefined){
            sortFieldApi = '';
        }
        var action =  component.get("c.getsObjectDataResult");
        action.setParams({
            "sObjectName": component.get("v.sObjectName"),
            "Queryfields": component.get("v.Queryfields"),
            "whereClaus": component.get("v.whereClaus"),
            "parentLookup": component.get("v.parentLookup"),
            "parentRecordId":component.get("v.recordId"),
            "sortFieldApi": sortFieldApi,
            "ascDescVal" : component.get("v.ascDescVal")
        });
        action.setCallback(this,function(response){
            var state =  response.getState();
            if(state ==="SUCCESS"){
                var resultSet = response.getReturnValue();
                console.log('resultSet ==> '+JSON.stringify(resultSet));
                if(resultSet){
                    if(resultSet.isSuccess){
                        var spinnerMod = component.find("spinnerId");
            			$A.util.addClass(spinnerMod,'slds-hide');
                        component.set("v.tableHeader",resultSet.columnHeader);
                        component.set("v.ObjectAccess",resultSet.objAccess);
                        if(resultSet.rowsNew.length ==1){
                            if(resultSet.rowsNew[0].newRec){
								component.set("v.sObjectRowDataNew",resultSet.rowsNew);                                
                            }
                        component.set("v.sObjectRowData",resultSet.rows);
                        component.set("v.sObjectRowDataTemp",resultSet.rows);
                        component.set("v.mapRecType",resultSet.objRecordType);
                            
                        if(resultSet.rows.length>0){
                            component.set("v.sObjectCreateRowData",resultSet.rows[0].fields);
                            var rowFieldsData= resultSet.rows[0].fields;
                            for(var i=0;i<rowFieldsData.length;i++){
                                if(rowFieldsData[i].isWritable){
                                    showEditButton=true;
                                    break;
                                }
                            }
                                }
                            if(!showEditButton){
                                component.set("v.edit",0);
                            }
                            
                        }
                        
                        
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type": "Error",
                            "message": resultSet.message,
                            "mode": "sticky"    
                    	});
                    	toastEvent.fire();
                    }
                }
            }
        });
        $A.enqueueAction(action);
	},
    saveMultipleRecords : function(component,event,helper) {
        var action = component.get("c.saveMultipleRecordsData");
        var records = component.get("v.sObjectRowData");
        console.log('records==> '+JSON.stringify(records));
        var endMsg='';
        action.setParams({
            "recDataJson" : JSON.stringify(records),
            "sObjName" : component.get("v.sObjectName"),
            "parentRecId":component.get("v.recordId"),
            "parentFieldAPI":component.get("v.parentLookup")
        });
        action.setCallback(this, function(response) {
            if(response.getState()==="SUCCESS"){
                if(response.getReturnValue()){
                    console.log('response==> '+JSON.stringify(response.getReturnValue()));
                    var lstMsg = response.getReturnValue().lstMsg;
                    if(response.getReturnValue().message ==='True')
                        endMsg = 'Record created with partial success';
                    if(lstMsg!=null){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                        "title": "Error!",
                        "type": "Error",
                        "message": JSON.stringify(lstMsg)+'\n'+endMsg,
                        "mode": "sticky"    
                    });
                    toastEvent.fire();
                    }
                    if(response.getReturnValue().message ==='True'){
                    	$A.get('e.force:refreshView').fire();
                        component.set("v.edit", 0);
                    }
                }    
                else{
                    $A.get('e.force:refreshView').fire();
                	component.set("v.edit", 0);
                     var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                        "title": "Success!",
                        "type": "SUCCESS",
                        "message": "Records created successfully"
                        });
                    	toastEvent.fire();
                }
                
            }
        });
        $A.enqueueAction(action);
                           
    },
    addNewRowData: function(component,event,helper){
        
        
            if(component.get("v.mapRecType").length>0 && !component.get("v.defaultAllRecType")){
                $A.createComponent(
                    "c:DynamicRecordTypeSelection",
                    {
                        "mapRecType": component.get("v.mapRecType")
                    },
                    function(newComponent){component.set("v.body",newComponent);}
                ); 
            }
        else{
            helper.addRows(component,event,helper);
        }
    },
    addRows: function (component,event,helper){
        var rowNum =  component.get("v.rowNum");
        
            if(component.get("v.sObjectRowDataNew")!=null){
                component.set("v.edit", 1);
                var addRow=false;
                var tempRowFlds = component.get("v.sObjectRowDataNew")[0].fields;
                var tempRowFldsarray =[];
                for(var i=0;i<tempRowFlds.length;i++){
                    tempRowFldsarray.push({
                        "fieldApi" : tempRowFlds[i].fieldApi,
                        "fieldType" : tempRowFlds[i].fieldType,
                        "fieldValue" : tempRowFlds[i].fieldValue,
                        "isAccessible" :tempRowFlds[i].isAccessible,
                        "isWritable":tempRowFlds[i].isWritable,
                        "label" :tempRowFlds[i].label,
                        "pickValues" : tempRowFlds[i].pickValues
                    });
                }
                for(var i=0;i<tempRowFlds.length;i++){
                    if(tempRowFlds[i].isWritable){
                        addRow=true;
                        break;
                    }
                }
                if(addRow){
                    var usrRecAccNew={
                        "HasDeleteAccess":true,
                        "HasEditAccess":true,
                        "HasReadAccess":true
                    };
                    var rowFldsData={
                        "fields":tempRowFldsarray,
                        "newRec":true,
                        "usrRecAcc":usrRecAccNew,
                        "recordTypeId": component.get("v.recordTypeId")
                    };
                    var tempRows = component.get("v.sObjectRowData");
                    
                    tempRows.splice(0, 0,rowFldsData);
                    
                    component.set("v.sObjectRowData",tempRows); 
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Action!",
                                    "type": "Warning",
                                    "message": 'Please contact Admistrator, to add mandetory fields and field on which you have edit access',
                                    "mode": "sticky"    
                                });
                                toastEvent.fire();
                }
            }
	
        
    },
    deleteSelectedRec : function(component,event,helper){
        var delRecID = event.currentTarget.dataset.customattribute;
        var delRecNew = event.currentTarget.dataset.customattribute1;
        
        if(delRecID.length>0){
            $A.createComponent(
                "c:DeleteConfimationModalBox",
                {
                    "delRecID": delRecID
                },
                function(newComponent){component.set("v.body",newComponent);}
            ); 
        }
        else{
            var delRecNew = event.currentTarget.dataset.customattribute2;
            
            var rowData = component.get("v.sObjectRowData");
            rowData.splice(delRecNew,1);
            component.set("v.sObjectRowData",rowData);
        }
    },
    getSortTable : function(component,event,helper){
        component.set("v.sortFieldColumn",event.getParam("fieldApi"));
        
        	if (component.get("v.ascDescVal") === "asc") {
                component.set("v.ascDescVal", "desc");
            } else if (component.get("v.ascDescVal") === "desc") {
                component.set("v.ascDescVal", "asc");
            } else {
                component.set("v.ascDescVal", "desc");
            }    
        
        helper.getsObjectResult(component,event,helper);
    }
})