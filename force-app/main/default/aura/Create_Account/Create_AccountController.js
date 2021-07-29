({
	myAction : function(component, event, helper) {
        //try{
        component.set('v.name','world');
        helper.fetchContacts(component, event, helper);
        //}catch(err){
        //    alert(err);	
        //}
	}
})