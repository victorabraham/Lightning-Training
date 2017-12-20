({
	createCaseCall : function(component, event, helper) {
        var caseObj = component.get("v.newCase");
        
        console.log('###Case Subject-->'+component.get("v.newCase.Subject"));
        console.log('###Case Priority-->'+component.get("v.newCase.Priority"));
        console.log('###Case Status-->'+component.get("v.newCase.Status"));
        console.log('###Case Description-->'+component.get("v.newCase.Description"));
        
		helper.callHelperCreateCase(component);
   },
   closeModel : function(component, event, helper) {
   	 component.set("v.isOpen", false);
     component.set("v.newCase",{'sobjectType': 'Case',
                             'Subject': '',
                             'Description':'',
                             'Priority':'',
                             'Status':''}); 
   }
})