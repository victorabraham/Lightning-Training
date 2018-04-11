({
    
	calculateBMI : function(component) {
        component.set("v.bmi", "20.0");
        var displayBox = component.find("display");
        if(component.get("v.bmi") >= 20.0) {
           $A.util.removeClass(displayBox, 'is-risk');
           $A.util.addClass(displayBox, 'no-risk'); 
        } else{
           $A.util.addClass(displayBox, 'is-risk');
           $A.util.removeClass(displayBox, 'no-risk'); 
        }
	},
    
    calculateBMIVal : function(component) {
        
        var heightVal = component.get("v.height");
        var weightVal = component.get("v.weight");
        var bmiVal = (weightVal * 0.45)/ (heightVal*heightVal) ;
        component.set("v.bmi", bmiVal);
        
        
        var displayBox = component.find("display");
        if(component.get("v.bmi") >= 20.0) {
           $A.util.removeClass(displayBox, 'is-risk');
           $A.util.addClass(displayBox, 'no-risk'); 
        } else{
           $A.util.addClass(displayBox, 'is-risk');
           $A.util.removeClass(displayBox, 'no-risk'); 
        }
	},
    
    saveCommentsToDB : function(component){
        alert('comments entered     ' + component.get("v.comments"));
    }
    
    /*
	getBmi : function(component) {
        var action = component.get("c.calculateBmi");
        action.setParams({ height : component.get("v.height"), weight: component.get("v.weight") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var bmi = response.getReturnValue();
                component.set("v.bmi", bmi);
                this.calculateRisk(component, bmi);
            }else if (state === "ERROR") {
                console.log(response.getError());
            }
        });
        $A.enqueueAction(action);
	}, 
    calculateRisk: function(component, bmi) {
        console.log(bmi);
        var riskAction = component.get("c.calculateRisk");
        riskAction.setParams({bmi: bmi});
        riskAction.setCallback(this, function(riskResponse) {
            var riskState = riskResponse.getState();
            if (riskState === "SUCCESS") {
                console.log(riskResponse.getReturnValue());
                var displayBox = component.find("display");
                if(riskResponse.getReturnValue()) {
                    $A.util.removeClass(displayBox, 'no-risk');
                    $A.util.addClass(displayBox, 'is-risk');
                }else {
                    $A.util.removeClass(displayBox, 'is-risk');
                    $A.util.addClass(displayBox, 'no-risk');
                }
            }else if (state === "ERROR") {
                console.log(riskResponse.getError());
            }
        });
        $A.enqueueAction(riskAction);
    }
    */
})