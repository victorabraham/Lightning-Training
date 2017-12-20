({
	doInit : function(component, event, helper) {
		helper.getCasesCreatedToday(component);
	},
    handleCaseCreatedEvent : function(component, event, helper) {
    	console.log("message passed by event"+event.getParam("message"));
        helper.getCasesCreatedToday(component);
    }
})