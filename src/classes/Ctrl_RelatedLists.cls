public class Ctrl_RelatedLists{
    
    public String searchTxt    { get; set; }  
    public String selFilterOppType    { get; set; }
    public String selFilterOppStatus    { get; set; } 
    public List<cOpportunity> listWrappedOpps   { get; set; }
    public Integer listSize { get; set; }
    public string morOppUrl {get;set;}
    public Integer oppSize  { get; set; }
    public Account account { get; set; }
    public Id accid {get;set;}
    
    public List<SelectOption> buildSelectFromPicklist( String defaultOpt, List<Schema.PicklistEntry> otherOpts, Set<String> exclude ) {
        List<SelectOption> options = new List<SelectOption>();
        options.add( new SelectOption(defaultOpt, defaultOpt) );
        for ( Schema.PicklistEntry opt : otherOpts ) {
            if ( !exclude.contains( opt.getValue() ) )    {
                options.add(new SelectOption( opt.getValue(), opt.getValue() ));
            }
        }
        return options;
    }
    
    // Build a picklist from a list of strings
    public List<SelectOption> buildSelectFromValues( List<String> opts ) {
        List<SelectOption> options = new List<SelectOption>();
        for ( String opt : opts )    {
            options.add(new SelectOption( opt, opt ));
        }
        return options;
    }
    
    // Prepare filter for Opportunity Type
    public List<SelectOption> getFilterOppType() {
        return buildSelectFromPicklist( 'All', Opportunity.Type.getDescribe().getPicklistValues(), new Set<String>());
    }

    // Prepare filter for Opportunity Status
    public List<SelectOption> getFilterOppStatus() {
        return buildSelectFromValues( new List<String>{'All', 'Open', 'Closed/Won', 'Closed/Lost'} );
    }

    public Ctrl_RelatedLists(ApexPages.StandardController controller) {
        this.account = [SELECT Id FROM Account WHERE Id = :controller.getId()];
        accid = this.account.Id;
        listSize = 20;
        searchTxt='';

        listWrappedOpps = new List<cOpportunity>();
        List<Opportunity> listOppTemp = database.Query( 'SELECT Name , Account.Name , Type , StageName , Amount, Closedate , Owner.Name FROM Opportunity WHERE AccountId  =: accId ORDER BY LastModifiedDate DESC LIMIT 200' );
        oppSize =database.Query( 'SELECT id from Opportunity WHERE AccountId  =: accId' ).size();    
        for ( Opportunity c : listOppTemp )    {
            listWrappedOpps.add( new cOpportunity( c));    
        }
    }

    public void searchOpportunities() {
        listSize = 20;
        listWrappedOpps = new List<cOpportunity>();
        String searchOpp =  '%' + String.escapeSingleQuotes(searchTxt.trim()) + '%';
        String querySOQL = 'SELECT Name , Account.Name , Type , StageName , Amount, Closedate , Owner.Name  FROM Opportunity WHERE';
        querySOQL += ' (Account.Name LIKE \'' + searchOpp+ '\' OR Name LIKE \'' + searchOpp+ '\') AND ' + 'AccountId  =: accId' ;
        
        if (selFilterOppType != 'All')   
            querySOQL += ' AND Type= \'' + selFilterOppType+ '\'';     
        if (selFilterOppStatus != 'All') {
            if (selFilterOppStatus == 'Open')
                querySOQL += ' AND IsClosed = false';
            else if (selFilterOppStatus == 'Closed/Won')
                querySOQL += ' AND IsClosed = true AND IsWon = true';
            else if (selFilterOppStatus == 'Closed/Lost')
                querySOQL += ' AND IsClosed = true AND IsWon = false';
        }
        querySOQL += ' ORDER BY LastModifiedDate DESC LIMIT 200';
        List<Opportunity> listOppTemp = database.Query( querySOQL );

        for ( Opportunity c : listOppTemp )
            listWrappedOpps.add( new cOpportunity( c));
    }


    //Aura Pieces

    @AuraEnabled
    public static List<cOpportunity> getOpportunityList(string accountId) {
        List<cOpportunity> listWrappedOpps = new List<cOpportunity>();
        string querySOQLAccts = 'AccountId =: accountId';          
        List<Opportunity> listOppTemp = database.Query( 'SELECT Name , Account.Name , Type , StageName , Amount, Closedate , Owner.Name FROM Opportunity WHERE ' + querySOQLAccts + ' ORDER BY LastModifiedDate DESC LIMIT 200' );
        Integer oppSize =database.Query( 'SELECT id from Opportunity WHERE ' + querySOQLAccts ).size();             
        for ( Opportunity c : listOppTemp )    {
            listWrappedOpps.add( new cOpportunity(c));    
        }
        return listWrappedOpps;
    }
    
    @AuraEnabled 
    public static List<String> getOppTypes(){
        List<String> lstType= new List<String>();
        try{
            Schema.DescribeFieldResult fieldResult = Opportunity.Type.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
            for( Schema.PicklistEntry f : ple)    {
                  lstType.add(f.getValue());
            }  
            return lstType;     
        }
        catch(Exception e){
            System.debug('Error in AEXP_AccountHierarchyCtrl.getOppTypes: '+ e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled 
    public static List<String> getOppStages(){
        List<String> lstStage= new List<String>();
        try{
            Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();    
            for( Schema.PicklistEntry f : ple)    {
                  lstStage.add(f.getValue());
             }       
             return lstStage;
        }
        catch(Exception e){
            System.debug('Error in AEXP_AccountHierarchyCtrl.getOppStage: '+ e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled 
    public static List<cOpportunity> getSearchOpportunitiesAura(string searchTxt, string selFilterOppType, string selFilterOppStatus, string accountId) {
        Integer listSize = 20;
        List<Id> listIds = new List<Id>();
        Set<id> childAccIds;
        List<cOpportunity> listWrappedOpps = new List<cOpportunity>();
        String searchOpp;
        String querySOQL;
        string querySOQLAccts = 'AccountId = :accountId';  
        querySOQL = 'SELECT Name , Account.Name , Type , StageName , Amount, Closedate , Owner.Name  FROM Opportunity WHERE';
        
        if(searchTxt != null && searchTxt != '') {
            searchOpp =  '%' + String.escapeSingleQuotes(searchTxt.trim()) + '%';
            querySOQL += ' (Account.Name LIKE \'' + searchOpp+ '\' OR Name LIKE \'' + searchOpp+ '\') AND ' ;
        }
        
        querySOQL = querySOQL + ' ' + querySOQLAccts ;
        
        
        if (selFilterOppType != 'All')   
            querySOQL += ' AND Type= \'' + selFilterOppType+ '\'';     
        if (selFilterOppStatus != 'All') {
            if (selFilterOppStatus == 'Open')
                querySOQL += ' AND IsClosed = false';
            else if (selFilterOppStatus == 'Closed/Won')
                querySOQL += ' AND IsClosed = true AND IsWon = true';
            else if (selFilterOppStatus == 'Closed/Lost')
                querySOQL += ' AND IsClosed = true AND IsWon = false';
        }
        
        querySOQL += ' ORDER BY LastModifiedDate DESC LIMIT 200';        
        List<Opportunity> listOppTemp = database.Query( querySOQL );
        
        for ( Opportunity c : listOppTemp )    {
            listIds.add( c.Id );
        }

        for ( Opportunity c : listOppTemp )    {
            listWrappedOpps.add( new cOpportunity( c));
        }
        
        return listWrappedOpps;
    }
    
    // Opportunity wrapper
    public class cOpportunity {
        @AuraEnabled
        public Opportunity obj          { get; set; }

        public cOpportunity( Opportunity o) {
            this.obj = o;
        }
    }

}