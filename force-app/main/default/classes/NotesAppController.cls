public class NotesAppController {
    
    @AuraEnabled
    public static ActionResponse putAndUpdateNote(Note note, String uid){
        String dbURL='https://notes-salesforce-default-rtdb.firebaseio.com';
        String extensionURL='.json?auth=';
        String authKey = 'gQHPosmt6fPIReF4BYATFaaF9yugtfLc3TJLPYPS';
        String keyNotes='UserData';
        String noteJson = JSON.serialize(note);
        String endPointURL = dbURL + '/' + keyNotes + '/' + uid + '/' + note.Title + extensionURL + authKey;
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPointURL);
        request.setHeader('Content-Type', 'Application/Json');
        request.setMethod('PUT');
        request.setBody(noteJson);
        HttpResponse res = h.send(request);
        if(res.getStatusCode() == 200){
            return new ActionResponse(res.getStatus(), '', res.getBody());
        }
        
        return new ActionResponse(res.getStatus(), 'error while putting Note', res.getBody());
    }
    
    @AuraEnabled
    public static ActionResponse loginWithEmailAndPassword(String json){
        try{
            UserData data = (UserData)System.JSON.deserialize(json,UserData.class);
            String dbURL='https://notes-salesforce-default-rtdb.firebaseio.com';
            String extensionURL='.json?auth=';
            String authKey = 'gQHPosmt6fPIReF4BYATFaaF9yugtfLc3TJLPYPS';
            String keyNotes='Users';
            User user = new User(data.email, '', '', data.password);
            String uid = getUID(user);
            String endPointURL = dbURL + '/' + keyNotes + '/' + uid + '/' + extensionURL + authKey;
            System.debug(endPointURL);
            Http h = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endPointURL);
            request.setHeader('Content-Type', 'Application/Json');
            request.setMethod('GET');
            HttpResponse res = h.send(request);
            System.debug(res);
            if(res.getStatusCode() == 200 && res.getBody() != null){
                User resUserData = (User) System.JSON.deserialize(res.getBody(), User.class);
                if(resUserData.password == data.password){
                    return new ActionResponse(res.getStatus(), 'login Success!', res.getBody());
                }
                return new ActionResponse('000', 'Incorrect password', 'null');
            }
            return new ActionResponse('000', 'User not found' , 'null');
        }catch(NullPointerException ex){
            return new ActionResponse('000', 'User not found' , 'null');
        }
    }
    
    @AuraEnabled
    public static ActionResponse createNewUser(String json){       
        UserInfo userInfo = (UserInfo) System.JSON.deserialize(json,UserInfo.class);
        User newUser = new User(userInfo.email, '', userInfo.name, userInfo.password);
        newUser.Username = getUID(newUser);
        String dbURL='https://notes-salesforce-default-rtdb.firebaseio.com';
        String extensionURL='.json?auth=';
        String authKey = 'gQHPosmt6fPIReF4BYATFaaF9yugtfLc3TJLPYPS';
        String keyNotes='Users';
        String userJson = System.JSON.serialize(newUser);
        String endPointURL = dbURL + '/' + keyNotes + '/' + newUser.Username + extensionURL + authKey;
        
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPointURL);
        request.setHeader('Content-Type', 'Application/Json');
        request.setHeader('accept', 'Application/Json');
        request.setMethod('PUT');
        request.setBody(userJson);
        HttpResponse res = h.send(request);
        if(res.getStatusCode() == 200){
            return new ActionResponse(res.getStatus(), '', res.getBody());
        }
        
        return new ActionResponse(res.getStatus(), 'error while creating account', res.getBody());
    }
    
    public static String getUID(User user){
        //String name = user.name.replaceAll( '\\s+', '');
        String uid = user.email.split('@').get(0);
        //String uid = mail+name;
        return uid+'Notes';
    }
    
    @AuraEnabled
    public static String getUserData(String uid){
        String response = NULL;
        String dbURL='https://notes-salesforce-default-rtdb.firebaseio.com';
        String extensionURL='.json?auth=';
        String authKey = 'gQHPosmt6fPIReF4BYATFaaF9yugtfLc3TJLPYPS';
        String keyNotes='UserData';
        String endPointURL = dbURL + '/' + keyNotes + '/' + uid + '/' + extensionURL + authKey;
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPointURL);
        request.setHeader('Content-Type', 'Application/Json');
        request.setHeader('accept','Application/Json');
        request.setMethod('GET');
        HttpResponse res =  h.send(request);
        response = res.getBody();
        if(response == null)
            response = '';
        return response;
    }
    
    public class Note{
        @AuraEnabled
        public String Description;
        @AuraEnabled
        public String Title;
        
        public Note(){}
        
        public Note(String description, String title) {
            this.Description = description;
            this.Title = title;
        }
    }
    
    public class ActionResponse{
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String error;
        @AuraEnabled
        public String message;
        
        public ActionResponse(){}
        
        public ActionResponse(String status, String error, String message){
            this.status = status;
            this.error = error;
            this.message = message;
        }
    }
    
    public class User{
        @AuraEnabled
        public String email;
        @AuraEnabled
        public String username;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String password;
        
        public User(){}
        
        public User(String email, String username, String name, String password){
            this.email = email;
            this.username = username;
            this.name = name;
            this.password = password;
        }
    } 
    
    public class UserInfo{
        @AuraEnabled
        public String email;
        @AuraEnabled
        public String password;
        @AuraEnabled
        public String name;
        
        public UserInfo(){}
        
        public UserInfo(String email, String password, String name){
            this.email = email;
            this.password = password;
            this.name = name;
        }
    }
    
    public class UserData{
        @AuraEnabled
        public String email;
        @AuraEnabled
        public String password;
        
        public UserData(){}
        
        public UserData(String email, String password){
            this.email = email;
            this.password = password;
        }
    }
}