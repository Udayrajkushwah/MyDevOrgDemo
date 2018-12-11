public class DynamicDataTableController {
    private static final string NEWRECVAL = 'newRec';
    private static final string SINGLE_parentheses_OPEN='(';
    private static final string DOUBLE_parentheses_OPEN='((';
    private static final string SINGLE_parentheses_CLOSE=')';
    private static final string DOT = '.';
    private static final string REFERENCE = 'REFERENCE';
    private static final string PICKLIST='picklist';
    private static string ERRORMESG='Some recods are not saved';
    @AuraEnabled
    public static ResultSet getsObjectDataResult(string sObjectName, string Queryfields,string whereClaus,string parentLookup,string parentRecordId, string sortFieldApi,string ascDescVal){
        objectAccess objAccess = new objectAccess();
        Boolean newRecObj = false;
        map<string,boolean> mapFldAccess =  new map<string,boolean>();
        try{
            list<Row> rows = new list<Row>();
            list<Row> rowsNew = new list<Row>();
            list<Cell> colNames = new list<Cell>();
            list<Cell> newColList = new list<Cell>();
            
            if(!string.isBlank(sObjectName)){
                string query = 'Select '+Queryfields+' From '+sObjectName;
                if(!string.isBlank(parentLookup))
                    query+=' Where '+parentLookup+'=:parentRecordId';
                if(!string.isBlank(whereClaus) && !string.isBlank(parentLookup))
                    query+=' and '+whereClaus;
                else if(!string.isBlank(whereClaus))
                    query+=' Where '+whereClaus;
                if(!string.isBlank(sortFieldApi)){
                    query+= ' Order By '+sortFieldApi+' '+ascDescVal;
                }
                system.debug('query===> '+query);
                //define sObject list to typecast any Object recods based on query string
                List<sObject> sObjects = Database.query(query);
                set<string> setrecId =  new set<string>();
                for(sObject sobj : sObjects){
                    setrecId.add(sObj.Id);
                }
                if(sObjects.isEmpty())
                    newRecObj = true;
                map<string,UserRecordAccess> mapRecAccess = new map<string,UserRecordAccess>();
                mapRecAccess = getRecordLevelAccess(setrecId);
                system.debug('mapRecAccess==> '+json.serialize(mapRecAccess));
                List<String> fields =   splitQStr(Queryfields);
                Map<String, Schema.DescribeFieldResult> fieldType = describeFields(sObjectName);
                for (String fld : fields) {
                    if (String.isEmpty(fld)) continue;
                    fld = fld.trim().toLowerCase();
                    
                    if (fld.containsAny(SINGLE_parentheses_OPEN) || fld.containsAny(DOUBLE_parentheses_OPEN)) {
                        fld = fld.substring(fld.lastIndexOfIgnoreCase(SINGLE_parentheses_OPEN)+1, fld.IndexOfIgnoreCase(SINGLE_parentheses_CLOSE)).trim();
                        System.debug(logginglevel.info, 'formatted field == '+fld);
                    }
                    
                    String flabel = fld.contains('.') ? getRelatedObjectFieldLabel(fld, fieldType) : fieldType.get(fld).getLabel();
                    boolean isAccessible = fld.contains('.') ? true : verifyPRS(fld,fieldType);
                    colNames.add(new Cell(fld, flabel, (!fld.contains(DOT) ? fieldType.get(fld).getType().name() : REFERENCE), null, false,'',isAccessible)); 
                    system.debug('colNames ==> '+colNames);
                    mapFldAccess.put(fld,isAccessible);
                    if(fld !='id'){
                        Cell newCol;
                        List<String> pickVals = new List<String>();
                        string fldVal ='';
                        if (fieldType.get(fld) !=null && fieldType.get(fld).getType().name().equalsIgnoreCase(PICKLIST) && fieldType.get(fld) != null) pickVals = getPicklistValues(fieldType.get(fld).getPicklistValues());
                        if (fieldType.get(fld) !=null && fieldType.get(fld).getType().name().equalsIgnoreCase(PICKLIST))
                            pickVals.add(0,'--Select--');
                        newCol = new Cell(fld,fldVal,(!fld.contains(DOT) ? fieldType.get(fld).getType().name() : REFERENCE),pickVals,(!fld.contains(DOT) ? fieldType.get(fld).isUpdateable() : false),flabel,isAccessible);
                    	newColList.add(newCol);
                }
                    
                }
                UserRecordAccess usr = new UserRecordAccess();
                rowsNew.add(new Row(newColList,usr,true));
                
                for(sObject temp : sObjects) {
                    
                    
                    List<Cell> cols = new List<Cell>();
                    for (String fld : fields) {
                        fld = fld.trim().toLowerCase();
                        Cell col;
                        System.debug(logginglevel.info,'fld = '+fld+'fieldType.get(fld)= '+fieldType.get(fld));
                        
                        List<String> pickVals = new List<String>();
                        if (fieldType.get(fld) !=null && fieldType.get(fld).getType().name().equalsIgnoreCase(PICKLIST) && fieldType.get(fld) != null) pickVals = getPicklistValues(fieldType.get(fld).getPicklistValues());
                        
                        if (fld.containsAny(SINGLE_parentheses_OPEN) || fld.containsAny(DOUBLE_parentheses_OPEN)) {
                            fld = fld.substring(fld.lastIndexOfIgnoreCase(SINGLE_parentheses_OPEN)+1, fld.IndexOfIgnoreCase(SINGLE_parentheses_CLOSE)).trim();
                        }
                        boolean isAccessible = fld.contains('.') ? true : verifyPRS(fld,fieldType);
                        if (fld.contains(DOT)) {
                            Object fieldVal = getRelatedObjectFieldValue(fld, temp);
                            col = new Cell(fld, fieldVal,  REFERENCE, pickVals, false,getRelatedObjectFieldLabel(fld, fieldType),isAccessible); //update based object only in release one    
                        } else if (temp.get(fld) != null){
                            system.debug('isAccessible==>'+fld+' = '+fieldType.get(fld).isAccessible());
                            col = new Cell(fld, temp.get(fld),  fieldType.get(fld).getType().name(), pickVals, fieldType.get(fld).isUpdateable(),fieldType.get(fld).getLabel(),isAccessible);
                        } else {
                            
                            col = new Cell(fld, '',  fieldType.get(fld).getType().name(), pickVals, fieldType.get(fld).isUpdateable(),fieldType.get(fld).getLabel(),isAccessible);
                        }
                        System.debug(logginglevel.info, 'data cell ==== '+col);
                        cols.add(col);
                        
                    }
                    rows.add(new Row(cols,mapRecAccess.get(temp.Id),false));
                }
                
                
            }
            DescribeSObjectResult objResult = Schema.getGlobalDescribe().get(sObjectName).getDescribe();
            objAccess.isEdit = objResult.sObjectType.getDescribe().isUpdateable();
        	objAccess.isCreateable = objResult.sObjectType.getDescribe().isCreateable();
        	objAccess.isDelete = objResult.sObjectType.getDescribe().isDeletable();
    		
            return new ResultSet(rows,rowsNew, colNames, sObjectName,true,'',objAccess,getRecordTypeDetails(sObjectName));
        }catch(exception e){
            system.debug('e===> '+e.getMessage());
            return new ResultSet(null,null, null, null,false,e.getMessage(),objAccess,getRecordTypeDetails(sObjectName));
        }
    }
    @AuraEnabled
    public static responseResult saveMultipleRecordsData(String recDataJson, String sObjName,string parentRecId, string parentFieldAPI){
        list<string> lstErrorMsg = new list<string>();
        try{
            
            list<Object> recData = (list<Object>)JSON.deserializeUntyped(recDataJson);
            List<sObject> sObjRecToUpdate = new List<sObject>();
            List<sObject> sObjRecToInsert = new List<sObject>();
            for(Object objData : recData){
                Map<String, Object> objVal = (Map<String, Object>) objData;
                system.debug('objVal ==> '+json.serialize(objVal));
                if(objVal.containsKey('usrRecAcc')){
                    Map<String, Object> userObj = (Map<String, Object>) objVal.get('usrRecAcc');
                    if(Boolean.valueOf(userObj.get('HasEditAccess'))){
                        system.debug('newRec == >'+Boolean.valueOf(objVal.get('newRec')));
                    	if(!Boolean.valueOf(objVal.get('newRec'))){
                            sObjRecToUpdate.addAll(getListsObjToUpdate(objVal,sObjName,'',''));
                        }
                        else{
                            sObjRecToInsert.addAll(getListsObjToUpdate(objVal,sObjName,parentRecId,parentFieldAPI));
                        }
                    }
                }
            }
            system.debug('sObjRecToUpdate== > '+json.serialize(sObjRecToUpdate));
            system.debug('sObjRecToInsert== > '+json.serialize(sObjRecToInsert));
            if(!sObjRecToUpdate.isEmpty()){
                
                Database.SaveResult[] srList = Database.update(sObjRecToUpdate, false);
                // Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            lstErrorMsg.add(string.valueOf(err.getStatusCode() + ': ' + err.getMessage()));
                        }
                    }
                }
            }
            
            if(!sObjRecToInsert.isEmpty()){
                
                Database.SaveResult[] srList = Database.Insert(sObjRecToInsert, false);
                // Iterate through each returned result
                for (Database.SaveResult sr : srList) {
                    if (!sr.isSuccess()) {
                        // Operation failed, so get all errors                
                        for(Database.Error err : sr.getErrors()) {
                            lstErrorMsg.add(string.valueOf(err.getStatusCode() + ': ' + err.getMessage()));
                        }
                    }
                    else{
                        ERRORMESG = 'True';
                    }
                }
            }
        }catch(Exception e){
            system.debug('e===> '+e.getMessage());
        }
        if(!lstErrorMsg.isEmpty()){
            return (new responseResult(true,ERRORMESG,lstErrorMsg));
        }
        else
            return null;
    }
    private static map<string,Id> getRecordTypeDetails(string sObjName){
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(sObjName).getDescribe();
   		List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
    	Map<String,Id> mapofObjectRecordTypeNameandId = new Map<String,Id>();
    	for(Schema.RecordTypeInfo info : recordTypeInfo){
            if(!info.getName().equalsIgnoreCase('Master'))
     			mapofObjectRecordTypeNameandId.put(info.getName(),info.getRecordTypeId());
    	}
   		system.debug('****'+mapofObjectRecordTypeNameandId);
        return mapofObjectRecordTypeNameandId;
    }
    private static list<sObject> getListsObjToUpdate(Map<String, Object> objVal, string sObjName,string parentRecId, string parentFieldAPI){
        list<sObject> sobjList = new list<sObject>(); 
        string recTypeId='';
        for (String key : objVal.keySet()) {
            if(key.equalsIgnoreCase('recordTypeId'))
                recTypeId = string.valueOf(objVal.get(key));
            if(!key.equalsIgnoreCase(NEWRECVAL) && !key.equalsIgnoreCase('usrRecAcc') && !key.equalsIgnoreCase('recordTypeId')){
                system.debug('key 11== >'+key);
                List<Object> sObjData = (List<Object>) objVal.get(key);
                system.debug('sObjData== >'+json.serialize(sObjData));
                sObject newsObject = Schema.getGlobalDescribe().get(sObjName).newSObject();
                
                for (Object rowData : sObjData) {
                    Map<String, Object> objMap = (Map<String, Object>) rowData;
                    
                    try {
                        if ((Boolean.valueOf(objMap.get('isWritable')) || String.valueOf(objMap.get('fieldApi')).equalsIgnoreCase('Id')) /*&& String.isNotBlank(String.valueOf(objMap.get('fieldValue')))*/) {
                            String dataType = String.Valueof(objMap.get('fieldType'));
                            
                            if (dataType.equalsIgnoreCase('Currency') || dataType.equalsIgnoreCase('Percent')) {
                                newsObject.put(String.Valueof(objMap.get('fieldApi')), Decimal.valueOf(String.valueOf(objMap.get('fieldValue'))));
                            } 
                            else if (dataType.equalsIgnoreCase('Date')) {
                                newsObject.put(String.Valueof(objMap.get('fieldApi')), Date.valueOf(String.ValueOf(objMap.get('fieldValue'))));
                            }
                            else if (dataType.equalsIgnoreCase('DateTime')) {
                                System.debug(logginglevel.INFO, objMap.get('fieldApi')+'datetime before === '+objMap.get('fieldValue'));
                                Datetime dt = (Datetime)JSON.deserialize(String.valueOf(objMap.get('fieldValue')).trim(), Datetime.class);
                                //Datetime dt = Datetime.valueOf(String.valueOf(obMap.get('fieldValue')).replace('T', ' ').replace('Z', '').trim());
                                System.debug(logginglevel.INFO,'datetime after === '+dt);
                                newsObject.put(String.Valueof(objMap.get('fieldApi')), dt);
                            }
                            else if (dataType.equalsIgnoreCase('Double')){
                                newsObject.put(String.Valueof(objMap.get('fieldApi')), Double.valueOf(objMap.get('fieldValue')));
                            }
                            else if (dataType.equalsIgnoreCase('Integer')){
                                newsObject.put(String.Valueof(objMap.get('fieldApi')), Integer.valueOf(objMap.get('fieldValue')));
                            }
                            else {
                                if(String.valueOf(objMap.get('fieldValue')) !='--Select--')
                                	newsObject.put(String.Valueof(objMap.get('fieldApi')), objMap.get('fieldValue'));    
                            }   
                        }  
                        
                    } catch (Exception ex) {
                        
                    }
                }
                if(!string.isBlank(parentFieldAPI)){
                    newsObject.put(parentFieldAPI,parentRecId);
                    if(!string.isBlank(recTypeId)){
                        newsObject.put('recordTypeId',recTypeId);
                    }
                }
                sobjList.add(newsObject);
                
            }
        }
        return sobjList;
    }
    @AuraEnabled
    public static responseResult deleteRecord(string delRecID){
        try{
            Database.delete(delRecID);
            return (new responseResult(true,'',null));
        }catch(exception e){
            
            //String after = e.getMessage().substring(e.getMessage().indexOf('DELETE_FAILED,') + 14);
            //system.debug('e==> '+after);
            return (new responseResult(false,e.getMessage(),null));
        }
    }
    private static Object getRelatedObjectFieldValue(String relationshipField, sObject resultObj) {
        Object result;
        if (String.isNotBlank(relationshipField) && resultObj != null) {
            List<String> tempLevels = relationshipField.split('\\.');
            String findRelField = tempLevels[tempLevels.size()-1];
            tempLevels.remove(tempLevels.size()-1);
            for (Integer i=0; i<tempLevels.size(); i++) {
                if (resultObj != null)  resultObj = resultObj.getsObject(tempLevels[i]);
            }   
            result = resultObj != null ? resultObj.get(findRelField) : null;    
        }
        return result;
    }
    private static List<String> getPicklistValues(List<Schema.PicklistEntry> pickEntries) {
        List<String> pickVals = new List<String>();
        for (Schema.PicklistEntry pick : pickEntries) {
            pickVals.add(pick.getValue());    
        }
        return pickVals;
    }
    private static list<string> splitQStr(string Queryfields){
        Set<String> fields = new Set<String>();
        boolean idFound = false;
        if (String.isNotBlank(Queryfields)) {
            for (String fld : Queryfields.split(',')) {
                if (String.isNotBlank(fld)) {
                    fields.add(fld.trim());
                    if (fld.trim().equalsIgnoreCase('id')) idFound = true;
                }
            }    
        }
        if (!idFound) fields.add('Id');
        system.debug('fields ==> '+fields);
        return new List<String>(fields);
    }
    private static Map<String, Schema.DescribeFieldResult> describeFields(String sObjectName) {
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new List<String>{sObjectName});
        Map<String, Schema.DescribeSObjectResult> childObjects = new Map<String, Schema.DescribeSObjectResult>();
        Map<String, Schema.DescribeFieldResult> fieldResults = new Map<String, Schema.DescribeFieldResult>();
        //describe object
        for(Schema.SObjectField field : results[0].fields.getMap().values()) {
            Schema.DescribeFieldResult fResult = field.getDescribe();
            System.debug(logginglevel.info, 'fResult.getName() == '+fResult.getName().toLowerCase()+', fResult = '+fResult);
            fieldResults.put(fResult.getName().toLowerCase(), fResult);
        }
        return fieldResults;
    }
    private static String getRelatedObjectFieldLabel(String relationshipField, Map<String, Schema.DescribeFieldResult> fieldResults) {
        List<String> tempLevels = relationshipField.split('\\.');
        String findRelField = tempLevels[tempLevels.size()-1];
        tempLevels.remove(tempLevels.size()-1);
        for (Integer i=0; i<tempLevels.size(); i++) {
            String qualifiedAPIName = formatLookupFieldAPI(tempLevels[i], !tempLevels[i].endsWithIgnoreCase('__r'));
            System.debug(logginglevel.info, 'qualifiedAPIName  == '+qualifiedAPIName);
            Schema.SObjectType childRel =   descRelationShips(tempLevels[i], fieldResults.get(qualifiedAPIName));
            fieldResults = describeFields(childRel.getDescribe().getName());
        }
        String fieldLabel;
        if (fieldResults != null ) {
            for(Schema.DescribeFieldResult fResult : fieldResults.values()) {
                if (fResult.getName().equalsIgnoreCase(findRelField) ) {
                    fieldLabel = fResult.getLabel();
                    break;
                }
            }
        }
        System.debug(logginglevel.info, 'fieldLabel final value  == '+fieldLabel);
        return fieldLabel;
    }
    private static String formatLookupFieldAPI(String ref, boolean flag) {
        String lookupApi = '';
        if (String.isNotBlank(ref)) {
            lookupApi = ref.trim().endsWithIgnoreCase('__r') ? ref.removeEndIgnoreCase('__r')+'__c' : ref.trim();//'Id'
            lookupApi = flag && !lookupApi.endsWithIgnoreCase('__c') ? lookupApi+'id' : lookupApi;
        }
        return lookupApi;
    }
    private static Schema.SObjectType descRelationShips(String relationshipField, Schema.DescribeFieldResult objResult) {
        List<Schema.sObjectType> returnObj = objResult.getReferenceTo();
        return returnObj != null && returnObj.size() > 0 ? returnObj[0] : null;
    }
    private static Boolean verifyPRS(String fld,Map<String, Schema.DescribeFieldResult> fieldType){
        Boolean fld_Permission =false;
        //Verify the fields are having editable
        fld = fld.trim().toLowerCase();
        if(!fld.contains(DOT)){
        	if(fieldType.get(fld).isAccessible())
        		fld_Permission= fieldType.get(fld).isAccessible();
        	else
        		fld_Permission=fieldType.get(fld).isAccessible();
        }
               
        system.debug('Field Accessibility==>'+fld_Permission);     
        return fld_Permission;
    }
    private static map<string,UserRecordAccess> getRecordLevelAccess(set<string> recId){
        map<string,UserRecordAccess> mapRecAccess =  new map<string,UserRecordAccess>();
        list<UserRecordAccess> lstUsrAccess = new list<UserRecordAccess>();
        lstUsrAccess =  [SELECT HasAllAccess,HasDeleteAccess,HasEditAccess,HasReadAccess,recordId 
                         FROM UserRecordAccess where recordId IN :recId and userId=:Userinfo.getUserId()];
        if(!lstUsrAccess.isEmpty()){
            for(UserRecordAccess usr : lstUsrAccess){
                mapRecAccess.put(usr.recordId,usr);
            }
        } 
        return mapRecAccess;
    }
    
    public class Cell {
        @AuraEnabled public String fieldApi {get; set;}
        @AuraEnabled public String fieldType {get; set;}
        @AuraEnabled public Object fieldValue {get; set;}
        @AuraEnabled public Long unixTime {get; set;}
        @AuraEnabled public Decimal currencyVal {get; set;}
        @AuraEnabled public List<String> pickValues {get; set;}
        @AuraEnabled public boolean isWritable {get; set;}
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public boolean isAccessible{get;set;}
        
         
        
        public Cell (String fApi, Object fVal, String fType, List<String> pickVal, boolean readOnly , string label,boolean isAccessible) {
            this.fieldApi = fApi;
            this.fieldType = fType;
            this.fieldValue = fVal;
            this.isWritable = readOnly;
            this.pickValues = pickVal;
            this.label = label;
            this.isAccessible =isAccessible;
            //this.isAccessible = isAccessible;
            if (fType.equalsIgnoreCase('datetime') && this.fieldValue instanceof Datetime && this.fieldValue !=null) {
                //System.debug(logginglevel.info, 'fieldValue ==== '+fieldValue);
                Datetime temp = Datetime.valueOf(this.fieldValue);
                this.unixTime = temp.getTime();
            }
            if (fType.equalsIgnoreCase('currency') && this.fieldValue instanceof Decimal && this.fieldValue !=null) {
                ///System.debug(logginglevel.info, 'fieldValue ==== '+fieldValue);
                this.currencyVal = (Decimal)this.fieldValue;
            }
        }
    }
    public class Row {
        @AuraEnabled 
        public List<Cell> fields {get; set;}
        @AuraEnabled
        public  UserRecordAccess usrRecAcc{get;set;}
        @AuraEnabled
        public boolean newRec{get;set;}
        public Row(List<Cell> cols,UserRecordAccess usrRecAcc,boolean newRec) {
            this.fields = cols;
            this.usrRecAcc =usrRecAcc;
            this.newRec = newRec;
        }
    }
    public class objectAccess{
        @AuraEnabled public boolean isEdit{get;set;}
        @AuraEnabled public boolean isCreateable{get;set;}
        @AuraEnabled public boolean isDelete{get;set;}
    }
    public class ResultSet {
        @AuraEnabled 
        public List<Row> rows {get; set;}
        @AuraEnabled 
        public List<Row> rowsNew {get; set;}
        @AuraEnabled 
        public List<Cell> columnHeader {get; set;}
        @AuraEnabled
        public string obName{get;set;}
        @AuraEnabled
        public boolean isSuccess{get;set;}
        @AuraEnabled
        public string message{get;set;}
        @AuraEnabled
        public objectAccess objAccess{get;set;}
		@AuraEnabled
        public map<string,Id> objRecordType{get;set;}        
        public ResultSet(List<Row> rw,List<Row> rwnew, List<Cell> ch, String obName,boolean isSuccess,string message,objectAccess objAccess,map<string,Id> objRecordType) {
            this.rows = rw;
            this.rowsNew = rwnew;
            this.columnHeader = ch;
            this.obName = obName;
            this.isSuccess = isSuccess;
            this.message =message;
            this.objAccess =objAccess;
            this.objRecordType =objRecordType;
        }
    }
    public class responseResult{
        @AuraEnabled
        public boolean isSuccess{get;set;}
        @AuraEnabled
        public string message{get;set;}
        @AuraEnabled
        public list<string> lstMsg{get;set;}
        public responseResult(boolean isSuccess,string message,list<string> lstMsg){
            this.isSuccess =isSuccess;
            this.message = message;
            this.lstMsg = lstMsg;
        }
    }
}