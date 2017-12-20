public class BMICalculator {
	@AuraEnabled
    public static Decimal calculateBmi(Decimal height, Decimal weight) {
        return weight/(height*height);
    }
    
    @AuraEnabled
    public static Boolean calculateRisk(Decimal bmi) {
        if(18.5 < bmi && bmi < 24.9) {
            return false;
        } else {
            return true;
        }
    }
}