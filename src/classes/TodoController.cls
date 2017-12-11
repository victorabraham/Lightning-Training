/****************************************************************************************************************
* Name         : TodoController 
* @Author      : Victor Abraham <vicabraham@deloitte.com>
* @Date        : 11/16/2016
* @Group       : TodoApp
* @Description : This class contains static methods required for ToDo case study app. 
* UPDATES
* Version          Developer                    Date                        Description
*-----------------------------------------------------------------------------------------------------------------
*     1.0                 Victor                  11/16/2016              Initial Creation                                                      
****************************************************************************************************************/
public with sharing class TodoController {
    /************************************************************************************************************
    * @Description : This method returns list of all ToDo items available in Salesforce
    * @Return      : List<Todo__c>
    *************************************************************************************************************/ 
	@AuraEnabled
	public static List<Todo__c> getTodoList() {
	    // Check to make sure all fields are accessible to this user
	    String[] fieldsToCheck = new String[] {'Id', 'Name', 'Description__c'};
	    Map<String,Schema.SObjectField> fieldDescribeTokens = Schema.SObjectType.Todo__c.fields.getMap();
	    for(String field : fieldsToCheck) {
	        if( ! fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
	            throw new System.NoAccessException();
	            return null;
	        }
	    }
	    
	    // returning Todo__c records
	    return [SELECT Id, Name, Description__c, Completed__c  
	            FROM Todo__c];
	}

	/************************************************************************************************************
    * @Description : This method updates a particular Todo item to Salesforce
    * @Return      : Todo__c
    *************************************************************************************************************/ 
	@AuraEnabled
    public static Todo__c saveTodo(Todo__c todo) {
    	//Need to add isUpdatable check
        upsert todo;
        return todo;
    }

    /************************************************************************************************************
    * @Description : This method deletes a particular Todo item to Salesforce
    * @Return      : Todo__c
    *************************************************************************************************************/ 
    @AuraEnabled
    public static Todo__c deleteTodo(Todo__c todo) {
        System.debug(todo);
        delete todo;
        return todo;
    }
}