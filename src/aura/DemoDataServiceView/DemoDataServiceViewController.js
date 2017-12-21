({
    handleRecordUpdated: function(component, event, helper) {
        console.log(component.get("v.simpleRecord"));
        console.log(component.get("v.record"));
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            console.log(eventParams);
           // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    }
})