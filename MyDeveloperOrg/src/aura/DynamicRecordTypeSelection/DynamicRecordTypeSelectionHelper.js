({
	hideModal : function(component,componentId,className) {
        
        var modal = component.find(componentId);
        $A.util.addClass(modal,className+'hide');
        $A.util.removeClass(modal,className+'open');
        
     }
})