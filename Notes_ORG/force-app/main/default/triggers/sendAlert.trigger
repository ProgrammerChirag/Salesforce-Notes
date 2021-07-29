trigger sendAlert on Contact (before insert , after insert , before update , after update) {
    User specificuser = new User();
    try{
        specificuser = [Select Id , Name From User Where Name = 'test'];
    }catch(Exception e){
        System.debug(e.getMessage());
    }
    
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
    if(Trigger.isAfter && specificuser.Id!=null && Trigger.new[0].LastModifiedById != specificuser.Id) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        List<String> sendTo = new List<String>();
        sendTo.add('junejachirag020@gmail.com');
        mail.setToAddresses(sendTo);
        
        mail.setSubject('URGENT BUSINESS PROPOSAL');
        
        mail.setHtmlBody('DATA CHANGED ALERT FOR USER'+specificuser.Name);
        mails.add(mail);
        
        Messaging.sendEmail(mails);
    }
}