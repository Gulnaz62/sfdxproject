global class OPSAcknowledgementTATController {
    @InvocableMethod(label='Set OPS Acknowledgement TAT' description='Set OPS Acknowledgement TAT')
    global static List<Job_Process__c> setTime(List<String> ids) {
        decimal reminderTime;
        
        List<Job_Process__c> jobs = TATJobSelector.getById(ids);
        List<Job_Process__c> reslist = new list<Job_Process__c>();

        for(Job_Process__c job:jobs)
        {
            boolean flgUpdateTAT = true;
            
            if(job.Job_Acknowledgement__c == null ){
                reminderTime = 0.5;
            }
            else {
                flgUpdateTAT = false;
            }
            
            if(flgUpdateTAT){
                Id businessHourId = BusinessHoursService.defaultBH.id;
                Datetime targetDT = BusinessHoursService.getReminderTimeByBusinessHour(system.now(), reminderTime);
                job.OPS_TAT_DateTime__c = targetDT;
                reslist.add(job);
            }
        }
        
        if(!reslist.isEmpty())
            update reslist;
        
        return reslist;
    }      

}