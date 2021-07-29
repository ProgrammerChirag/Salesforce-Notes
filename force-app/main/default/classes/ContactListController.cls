public class ContactListController {
	@AuraEnabled
    public static List<Contact> getContactList(){
        List<Contact> contactList = [SELECT Id, FirstName, LastName, Email, Phone, AccountId FROM Contact limit 10];
        return contactList;
    }
}