({
	fetchContacts : function(component, event, helper) {
		var action = component.get('c.getContactList');
        action.setParams({
            
        });
        
        action.setCallback(this , function(response){
            var state = response.getState();
            if(state='SUCCESS'){
                var contactList=response.getReturnValue();
                component.set('v.contactList',contactList);
            }else{
                alert('Error getting in data');
            }
        });
        $A.enqueueAction(action);
	}
})