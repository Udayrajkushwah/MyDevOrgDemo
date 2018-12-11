@isTest
public class DynamicDataTableController_Test {
	public static Account acc;
    public static Contact cont;
    public static void init(){
        acc = new account();
        acc.Name= 'TestAccount';
        insert acc;
        cont= new contact();
        cont.LastName = 'LastName';
        cont.FirstName ='FirstName';
        cont.AccountId =acc.Id;
        cont.LeadSource='Other';
        cont.Birthdate=Date.newInstance(1988, 10, 01);
        
        insert cont;
    }
    public static testMethod void getsObjectDataResultTest(){
        init();
        string Queryfields ='FirstName,LastName,Account.Name,LeadSource,Birthdate,LastCURequestDate';
        DynamicDataTableController.getsObjectDataResult('Contact',Queryfields,'','AccountId',acc.Id,'FirstName','ASC');
    }
    public static testMethod void getsObjectDataResultTest2(){
        init();
        string Queryfields ='FistName,LastName,Account.Name,LeadSource,Birthdate,LastCURequestDate';
        DynamicDataTableController.getsObjectDataResult('Contact',Queryfields,'','AccountId',acc.Id,'FirstName','ASC');
    }
    public static testMethod void saveMultipleRecordsDataTest(){
        init();
        list<DynamicDataTableController.Cell> lstFields = new list<DynamicDataTableController.Cell>();
        string Queryfields ='FirstName,LastName,Account.Name,LeadSource,Birthdate,LastCURequestDate';
        DynamicDataTableController.ResultSet rstSet = DynamicDataTableController.getsObjectDataResult('Contact',Queryfields,'','AccountId',acc.Id,'FirstName','ASC');
    	string rstSetJSON =json.serialize(rstSet.rows);
        system.debug('rstSetJSON==> '+rstSetJSON);
        DynamicDataTableController.saveMultipleRecordsData(rstSetJSON,'Contact',acc.Id,'AccountId');
        
    }
    public static testMethod void saveMultipleRecordsDataTest2(){
        init();
        string newrstSetJSON ='[{"fields":[{"fieldApi":"lastName","fieldType":"String","fieldValue":"LastNameTest","isWritable":true,"label":"Last Name","pickValues":[],"isAccessible":true},{"fieldApi":"email","fieldType":"EMAIL","fieldValue":"sample@1.com","isWritable":true,"label":"Email","pickValues":[],"isAccessible":true}],"newRec":true,"usrRecAcc":{"HasDeleteAccess":true,"HasEditAccess":true,"HasReadAccess":true}}]';
        DynamicDataTableController.saveMultipleRecordsData(newrstSetJSON,'Contact',acc.Id,'AccountId');
    }
    
    public static testMethod void deleteRecordTest(){
        init();
        string contId = cont.Id;
        DynamicDataTableController.deleteRecord(contId);
        contact ct = new contact();
        ct.LastName = 'delLstName';
        ct.AccountId=acc.Id;
        case cs = new case();
        cs.AccountId = acc.Id;
        cs.ContactId = ct.Id;
        cs.Origin ='Web';
        cs.Status='New';
        insert cs;
        DynamicDataTableController.deleteRecord(ct.Id);
    }
}