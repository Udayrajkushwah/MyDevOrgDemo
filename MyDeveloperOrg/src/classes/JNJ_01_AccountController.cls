public with sharing class JNJ_01_AccountController {

    @AuraEnabled
    public static Account saveAccount (Account acc) {
        
        upsert acc;
        return acc;
    }
}