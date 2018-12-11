public class AwesomeProductController {
    @AuraEnabled
    public static List<Product2> getProducts() {
        return [select id, name from product2];
    }
    
    @AuraEnabled
    public static product2 getProductByName(String name) {
        return [select id, name from product2 where name = :name];
    }
}