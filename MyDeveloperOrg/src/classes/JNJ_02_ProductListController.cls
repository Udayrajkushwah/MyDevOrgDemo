public class JNJ_02_ProductListController {
    @AuraEnabled
    public static List<Product2> findAll() {
        return [SELECT id, name FROM Product2 LIMIT 50];
    }
    
    @AuraEnabled
    public static List<Product2> findByName(String searchKey,List<String> selectedList) {
        String name = '%' + searchKey + '%';
        return [SELECT id, name FROM Product2 WHERE name LIKE :name  and Name not in:selectedList LIMIT 50 ];
    }
    
    @AuraEnabled
    public static Product2 findById(String productID) {
        return [SELECT name 
                FROM Product2 WHERE Id = :productID];
    }

}