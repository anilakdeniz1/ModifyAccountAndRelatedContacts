import { LightningElement, api, track } from 'lwc';

import { ShowToastEvent} from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';

import NAME_FIELD from '@salesforce/schema/Account.Name';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
import ACCOUNT_NUMBER_FIELD from '@salesforce/schema/Account.AccountNumber';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';
import FAX_FIELD from '@salesforce/schema/Account.Fax';
import ACTIVE_FIELD from '@salesforce/schema/Account.Active__c'

import searchContacts from '@salesforce/apex/ContactController.searchContacts';
import setPrimaryContact from '@salesforce/apex/ContactController.setPrimaryContact';

const COLS = [
    { label: 'Name', fieldName: 'Name', type: 'text'},
    { label: 'Title', fieldName: 'Title', type: 'text'},
    { label: 'Phone', fieldName: 'Phone', type: 'phone'},
    { label: 'Is Primary Contact', fieldName: 'Is_Primary_Contact__c', type: 'checkbox', editable: false},
    { label: '',
        type: 'button',
        typeAttributes: { 
            label: 'Set Primary Contact', name: 'set_primary', variant: 'base' }
    }
]
export default class RelatedContactandPrimaryContactUpdater extends LightningElement {
    @api recordId;
    searchKey;
    @track relatedContacts
    columns = COLSisSearched = false;
    objectName = ACCOUNT_OBJECT
    fields = {
        name : NAME_FIELD,
        type : TYPE_FIELD,
        accNumber : ACCOUNT_NUMBER_FIELD,
        phone : PHONE_FIELD,
        active : ACTIVE_FIELD,
        fax : FAX_FIELD,
    }

    handleSuccess(){
        this.dispatchEvent(new RefreshEvent())
    }

    handleCancel(){
        const fields = this.template.querySelectorAll("lightning-input-field");
        Array.from(fields).forEach(field => {
            field.reset();
        })
    }

    handleChange(event){
        this.searchKey = event.target.value;
    }

    handleSearch(){
        searchContacts({ searchKey: this.searchKey, accId: this.recordId})
        .then(result => {
            this.relatedContacts = result;
            console.log(this.relatedContacts);
        }).catch(error => {
            console.log(error);
        })
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        switch (action.name) {
            case 'set_primary':
                this.createToast('Warning', 'You have changed the Primary Contact', 'sticky', 'error')
                this.dispatchEvent(new RefreshEvent())
                this.setPrimaryContact(row);
                break;
            default:
                break;
        }  
    }

    async setPrimaryContact(clickedContact) {
        try {
            await setPrimaryContact({ contactId: clickedContact.Id });
            
            await refreshApex(this.relatedContacts);
        } catch (error) {
            console.error('Error setting primary contact:', error);
        }
    }

        /** 
     * @descritpion creates toast for warning
     * @param title
     * @param message
     * @param mode
     * @param variant
     */ 
        createToast(title, message, mode, variant){
            const toast = new ShowToastEvent({
                title,
                message,
                mode,
                variant: variant || 'success'
            })
            this.dispatchEvent(toast)
        }
}