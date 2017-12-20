({
    callHelperCreateCase : function(component) {
        var caseObj = component.get("v.newCase");
        var action = component.get("c.f_createCase");
        action.setParams({ 
            "objCase": caseObj
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var name = response.getReturnValue();
                component.set("v.isOpen", true);
            }
        });
        $A.enqueueAction(action);
    }
})