public class CaseTilesController {
	@AuraEnabled
    public static List<Case> getCasesCreatedToday()	{
        return [SELECT Subject , Priority, Status, Description FROM Case WHERE CreatedDate = TODAY];
    }
}