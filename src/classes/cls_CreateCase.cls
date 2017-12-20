public class cls_CreateCase {
	@AuraEnabled
	public static Case f_createCase (Case objCase) {
		insert objCase;
		return objCase;
	}
}