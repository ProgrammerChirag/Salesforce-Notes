public class NotesLoginController {
    
    @auraEnabled
    public static ActionResponse loginWithEmailAndPassword(String json){
        
        UserData data = (UserData)System.JSON.deserialize(json,UserData.class);
        System.debug(data.Email+' '+data.password);
        try{        
            List<NA_User__c> users = [SELECT Id, Name FROM NA_User__c WHERE Email__c= :data.Email AND Password__c= :data.password];
            if(!users.isEmpty()){
                return new ActionResponse(true, users[0], null);
            }
            return new ActionResponse(false, users, 'No User Found'+data);
            
        }catch(Exception ex){
            System.debug(ex.getMessage());
            return new ActionResponse(false, 'failed to login..', ex.getMessage());
        }
    }
    
    // notes wrapper class
    public class UserData{
        @AuraEnabled
        public String Email;
        @auraEnabled
        public String password;
        
        public UserData(String Email, String password){
            this.email = email;
            this.password = password;
        }
    }
    
    public class ActionResponse{
        @auraEnabled
        public Object data;
        @auraEnabled
        public String error;
        @auraEnabled
        public boolean status;
        
        public ActionResponse(){
            
        }
        
        public ActionResponse(boolean status, String error){
            this.error = error;
            this.status = status;
        }
        
        public ActionResponse(boolean status , Object message, String error){
            this.data = message;
            this.status = status;
            this.error = error;
        }
    }
}