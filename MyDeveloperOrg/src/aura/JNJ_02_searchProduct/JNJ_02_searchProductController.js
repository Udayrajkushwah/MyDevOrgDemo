({
    doInit : function(component, event) {
        var action = component.get("c.findAll");
        action.setCallback(this, function(a) {
            component.set("v.products", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    searchKeyChange: function(component, event) {
        var searchKey = event.getParam("searchKey");
        var action = component.get("c.findByName");
        action.setParams({
            "searchKey": searchKey
        });
        action.setCallback(this, function(a) {
            component.set("v.products", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    searchKeyChange: function(component, event, helper) {
        var searchKey = event.target.value;
        var action = component.get("c.findByName");
        action.setParams({
            "searchKey": searchKey,
            "selectedList":component.get("v.productsSelected")
        });
        action.setCallback(this, function(a) {
            component.set("v.products", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    select:function(component, event, helper) {
        var recId=event.target.id;
        console.log("Uday"+ recId);
        var productsList=component.get("v.products");
        console.log("UdayproductsList"+ JSON.stringify(productsList));
        var productNewList=[];
        var selectedProductList=component.get("v.productsSelected");
        console.log("UdayselectedProductList"+ JSON.stringify(selectedProductList));
        selectedProductList.push(recId);
        component.set("v.productsSelected",selectedProductList);
        for(var i=0;i<productsList.length;i++){
            if(productsList[i].Name != recId){
                productNewList.unshift(productsList[i]);
            }
        }
        component.set("v.products",productNewList);
         console.log("UdayproductNewListSelect"+ JSON.stringify(productNewList));
    },
    
    Delete:function(component, event, helper){
        //alert("Deleted");
        var recId=event.target.id;
        console.log("UdayDelete"+ recId);
        var selectedProductList=component.get("v.productsSelected");
        console.log("UdayselectedProductListdelete"+ JSON.stringify(selectedProductList));
        var productNewList=[];
        var productsList=component.get("v.products");
        console.log("UdayproductsListdelete"+ JSON.stringify(productsList));
        productsList.push(recId);
        component.set("v.products",productsList);
        for(var i=0;i<selectedProductList.length;i++){
            if(selectedProductList[i].name != recId){
                productsList.unshift(selectedProductList[i]);
            }
        }
        component.set("v.products",productsList);
        console.log("UdayproductNewListdelete"+ JSON.stringify(productsList));
    }
    
})