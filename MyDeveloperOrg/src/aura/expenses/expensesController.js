({
    // Load expenses from Salesforce
doInit: function(component, event, helper) {

    // Create the action
    var action = component.get("c.getExpenses");

    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            component.set("v.expenses", response.getReturnValue());
        }
        else {
            console.log("Failed with state: " + state);
        }
    });

    // Send action off to be executed
    $A.enqueueAction(action);
},   
    clickCreateExpense: function(component, event, helper) {
    if(helper.validateExpenseForm(component)){
        // Create the new expense
        var newExpense = component.get("v.newExpense");
        helper.createExpense(component, newExpense);
    }
},
    handleUpdateExpense: function(component, event, helper) {
    var updatedExp = event.getParam("expense");
    helper.updateExpense(component, updatedExp);
}
    
	  /* clickCreateExpense: function(component, event, helper) {

        // Simplistic error checking
        var validExpense = true;

        // Name must not be blank
        var nameField = component.find("expname");
        var expname = nameField.get("v.value");
        if ($A.util.isEmpty(expname)){
            validExpense = false;
            nameField.set("v.errors", [{message:"Expense name can't be blank."}]);
        }
        else {
            nameField.set("v.errors", null);
        }

        // ... hint: more error checking here ...

        // If we pass error checking, do some real work
        if(validExpense){
            // Create the new expense
            var newExpense = component.get("v.newExpense");
            console.log("Create expense: " + JSON.stringify(newExpense));
            helper.createExpense(component, newExpense);
        }
    } */
})