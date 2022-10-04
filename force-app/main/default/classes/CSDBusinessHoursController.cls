global class CSDBusinessHoursController {
    @InvocableMethod(label='Set CSD Reminder TAT' description='Set CSD Reminder TAT')
    global static List<Job_Process__c> setTime(List<String> ids) {
        decimal reminderTime;
        
        List<Job_Process__c> jobs = TATJobSelector.getById(ids);
        List<Job_Process__c> rslist = new list<Job_Process__c>();

        for(Job_Process__c job:jobs)
        {
            boolean flgUpdateTAT = true;
            
            if(job.Transit_Status__c == 'Not Started' ){
                reminderTime = 4;
            }
            else if(job.Transit_Status__c == 'Delivered'){
                reminderTime = 2;
            }
            else if(job.Extra_Charges_Acknowledgement_by_KAM__c == null){
                reminderTime = 0.5;                
            }
            else {
                flgUpdateTAT = false;
            }
            
            if(flgUpdateTAT){
                Id businessHourId = BusinessHoursService.defaultBH.id;
                Datetime targetDT = BusinessHoursService.getReminderTimeByBusinessHour(system.now(), reminderTime);
                job.TAT_DateTime__c = targetDT;
                rslist.add(job);
            }
        }
        
        if(!rslist.isEmpty())
            update rslist;
        
        return rslist;
    }      

}