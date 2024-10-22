/** 
* @author Sami Anıl Akdeniz <anilakdeniz1@gmail.com>
* @date 22/10/2024
* @description Contact controller class for changing the selected contact to a primary contact
* Test Class : ContactControllerTest
* Test Class Coverage : %100
*/
public with sharing class PrimaryContactController {
    /** 
     * @descritpion Sets the contact to primary Contact for LWC version of this project
     * @param contactId Id
     */ 
    @AuraEnabled
    public static void setPrimaryContact(Id contactId) {
        Contact conToBeUpdated = [SELECT Id, Is_Primary_Contact__c, AccountId FROM Contact WHERE Id = :contactId WITH SECURITY_ENFORCED];

        List<Contact> nonPrimaryContacts = [SELECT Id FROM Contact WHERE Id != :contactId AND AccountId = :conToBeUpdated.AccountId];

        for (Contact con :nonPrimaryContacts) {
            con.Is_Primary_Contact__c = false;
        }

        conToBeUpdated.Is_Primary_Contact__c = true;

        if (nonPrimaryContacts.size() > 0) {
            update nonPrimaryContacts;
        }
        
        update conToBeUpdated;
    }

    /** 
     * @descritpion Searches for the account's related contacts
     * @param searchKey String
     * @param accId Id
     */ 
    @AuraEnabled 
    public static List<Contact> searchContacts(String searchKey, Id accountId) {
        String formatedSearchKey =  '½' + searchKey + '%';
        return [SELECT Id, Name, FirstName, Title, Phone, Is_Primary_Contact__c 
                FROM Contact 
                WHERE AccountId = :accId
                AND Name LIKE :formatedSearchKey
                WITH SECURITY_ENFORCED
                LIMIT 12];
    }
}