({
	getBmi : function(component) {
        var action = component.get("c.calculateBmi");
        action.setParams({ height : component.get("v.height"), weight: component.get("v.weight") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var bmi = response.getReturnValue();
                component.set("v.bmi", bmi);
            }else if (state === "ERROR") {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
	}
})