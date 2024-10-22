/** 
* @author Sami Anıl Akdeniz <anilakdeniz1@gmail.com>
* @date 22/10/2024
* @description Test class for ContactController Class
*/
@isTest
public with sharing class PrimaryContactControllerTest {

    @TestSetup
    static void makeData() {
        Account anAccount = TestUtility.createAccount();
        List<Contact> contacts = TestUtility.createMultipleContactWithAccount(anAccount.Id, 10);
    }

    @isTest
    static void setPrimaryContact_successfully() {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Name LIKE '%Test%'];

        Test.startTest();
        ContactController.setPrimaryContact(conList[0].Id);
        Test.stopTest();

        Contact aPrimaryContact = [SELECT Id, Is_Primary_Contact__c FROM Contact WHERE Id = :contacts[0].Id];
        System.assertEquals(true, aPrimaryContact.Is_Primary_Contact__c, 'Primary contact should be set to true');
    }

    @isTest
    static void getContacts_whenSearchKeyIsEntered() {
        Account anAccount = [SELECT Id FROM Account WHERE Name = 'Test Account'];

        Test.startTest();
        List<Contact> contacts = PrimaryContactController.searchContacts('Test', anAccount.Id);
        Test.stopTest();

        System.assertEquals('Test', contacts[0].FirstName, 'First name should be \'Test\'.');
    }
}