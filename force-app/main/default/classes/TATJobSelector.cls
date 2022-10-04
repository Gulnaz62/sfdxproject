public class TATJobSelector {
    public static List<Job_Process__c> getById(List<String> ids)
    {
        return [SELECT Transit_Status__c, TAT_DateTime__c, Extra_Charges_Acknowledgement_by_KAM__c, Job_Acknowledgement__c FROM Job_Process__c WHERE Id in :ids];
    }

}