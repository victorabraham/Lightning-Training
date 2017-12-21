({
	editCase : function (component) {
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("{!v.recordId}")
        });
        editRecordEvent.fire();
	},
    navigateToCase : function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": component.get("{!v.recordId}"),
          "slideDevName": "related"
        });
        navEvt.fire();
    }
})