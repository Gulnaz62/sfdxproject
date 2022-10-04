public class TATENQSelector {
	public static List<Enquiry__c> getById(List<String> ids)
    {
        return [SELECT CreatedDate, Stage_Change__c,Survey_Date_Time__c, Stage__c, TAT_Date_Time__c, Survey_Type__c, Survey_Acknowledgement_TAT_DateTime__c, Survey_DateTime_Update__c,Survey_Acknowledgement__c FROM Enquiry__c WHERE Id in :ids];
    }
}