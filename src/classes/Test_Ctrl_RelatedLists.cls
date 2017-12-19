@isTest 
public class Test_Ctrl_RelatedLists{
    static testMethod void method1() {
       Account acc = new Account(Name='Test Account');
       insert acc;
       
       Opportunity opp = new Opportunity (Name='Test Opp',AccountId=acc.id,StageName='New',CloseDate=Date.today());
       insert opp;
       
       Test.startTest();
           ApexPages.StandardController sc = new ApexPages.StandardController(acc);
           Ctrl_RelatedLists ct = new Ctrl_RelatedLists(sc);
           
           PageReference pageRef = Page.OpptyRelatedList;
           pageRef.getParameters().put('id',String.valueOf(acc.Id));
           Test.setCurrentPage(pageRef);
           
           ct.searchOpportunities();
           ct.getFilterOppType();
           ct.getFilterOppStatus();
           
       Test.stopTest();
    }
    
    
    static testMethod void method2() {
       Account acc = new Account(Name='Test Account');
       insert acc;
       
       Opportunity opp = new Opportunity (Name='Test Opp',AccountId=acc.id,StageName='New',CloseDate=Date.today());
       insert opp;
       
       Test.startTest();
           ApexPages.StandardController sc = new ApexPages.StandardController(acc);
           Ctrl_RelatedLists ct = new Ctrl_RelatedLists(sc);
           
           PageReference pageRef = Page.OpptyRelatedList;
           pageRef.getParameters().put('id',String.valueOf(acc.Id));
           Test.setCurrentPage(pageRef);
           
           Ctrl_RelatedLists.getOppTypes();
           Ctrl_RelatedLists.getOppStages();
           Ctrl_RelatedLists.getOpportunityList(acc.id);
           Ctrl_RelatedLists.getSearchOpportunitiesAura('','All','All',acc.id);
           
       Test.stopTest();
    }
}