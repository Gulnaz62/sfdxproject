import { LightningElement, track, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getCostingList from '@salesforce/apex/CostingController.getCostingList';
import upsertCosting from '@salesforce/apex/CostingController.upsertCosting';
import deleteCost from '@salesforce/apex/CostingController.deleteCost';
import canUserEdit from '@salesforce/apex/CostingController.canUserEdit';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveCostAction from '@salesforce/apex/CostingController.saveCostAction';
import COST_NAME from '@salesforce/schema/Costing__c.Particulars__c';
import ID_FIELD from '@salesforce/schema/Enquiry__c.Id';
import USER_ID from '@salesforce/user/Id';
import USERPROFILE_ID from '@salesforce/schema/User.ProfileId';
import TRANSIT_TIME from '@salesforce/schema/Enquiry__c.Transit_Time__c';
import SHIPMENT_TYPE from '@salesforce/schema/Enquiry__c.Shipment_Type__c';
import ENQUIRY_ID from '@salesforce/schema/Costing__c.Enquiry_Id__c';
import VOLUME from '@salesforce/schema/Costing__c.Volume__c';
import COST_INCLUDED from '@salesforce/schema/Costing__c.Cost_Included__c';
import ACTUALCOST from '@salesforce/schema/Costing__c.Actual_Cost__c';
import OTHER_COST from '@salesforce/schema/Costing__c.Other_Costing__c';
import RATE from '@salesforce/schema/Costing__c.Rate__c';

const actions = [
    { label: 'Delete', name: 'delete' }
];

const columns = [{
    label: 'Cost Type',
    fieldName: 'costType',
    type: 'text',
},
{
    label: 'Quantity/Volume',
    fieldName: 'volume',
    type: 'number'
},
{
    label: 'Rate',
    fieldName: 'rate',
    type: 'number',
    typeAttributes: {
        maximumFractionDigits: 2
    }
},
{
    label: 'Amount',
    fieldName: 'amount',
    type: 'number',
    typeAttributes: {
        maximumFractionDigits: 2
    }
},
{
    label: 'Cost Included',
    fieldName: 'costIncluded',
    type: 'boolean',
    cellAttributes:{ iconName: 'utility:check', iconPosition: 'Right'}
},
{
    label: 'Actual Cost',
    fieldName: 'actualCost',
    type: 'number',
    typeAttributes: {
        maximumFractionDigits: 2
    }
},
{
    type: 'action',
    typeAttributes: {
        rowActions: actions,
        menuAlignment: 'right'
    }
}

];

const myFields = ['Enquiry__c.Enquiry_Type__c', 'Enquiry__c.Transit_Time__c', 'Enquiry__c.Shipment_Type__c'];

export default class GraceCostingList extends LightningElement {
    @api recordId
    @track fetchRefreshData = [];
    @track costRecord = {
        Particulars__c: COST_NAME,
        Actual_Cost__c: ACTUALCOST,
        Volume__c: VOLUME,
        Enquiry_Id__c: ENQUIRY_ID,
        Other_Costing__c: OTHER_COST,
        Rate__c: RATE,
        Cost_Included__c: COST_INCLUDED
    };
    @track enqRecord = {
        Transit_Time__c: TRANSIT_TIME,
        Shipment_Type__c: SHIPMENT_TYPE
    };
    @track totalCostVol;
    @track totalCostActual;
    @track totalCostRate;
    @track totalCostAmount;
    @track errorMsg;
    @track enqType;
    showTable;
    @track value;
    @track error;
    @track data;
    result;
    records;
    @track data = [];
    @track columns;

    handleCostChange(event) {
        this.costRecord.Particulars__c = event.target.value;
        console.log('cost --', event.target.value);
    }

    handleActualCostChange(event) {
        this.costRecord.Actual_Cost__c = event.target.value;
    }

    handleVolumeChange(event) {
        this.costRecord.Volume__c = event.target.value;
    }

    handleRateChange(event) {
        this.costRecord.Rate__c = event.target.value;
    }

    handleTransitChange(event) {
        this.enqRecord.Transit_Time__c = event.target.value;
    }

    handleShipmentChange(event) {
        this.enqRecord.Shipment_Type__c = event.target.value;
    }


    @track currentUserProfileId;
    @wire(getRecord, { recordId: USER_ID, fields: [USERPROFILE_ID] })
    userDetails({ error, data }) {
        if (data) {
            this.currentUserProfileId = data.fields.ProfileId.value;
            console.log('Profile Id-->', this.currentUserProfileId );

        } else if (error) {
            this.error = error;
            console.log('error-', this.error.message);
        }
    }

    connectedCallback() {
        canUserEdit()
            .then(result => {
                if(this.currentUserProfileId == '00e0p000000IejiAAC'){
                    columns.forEach(function (item, index) {
                        if(item.fieldName == 'amount' || item.fieldName == 'volume' || item.fieldName == 'costType'
                        || item.fieldName == 'rate' || item.fieldName == 'actualCost'){
                            item.editable = false;
                        }
                        else {
                            item.editable = result;     
                        }
                    });
                    this.columns = [...this.columns];
                }
                else if(this.currentUserProfileId == '00e0p000000IejsAAC'){
                    columns.forEach(function (item, index) {
                        if(item.fieldName == 'amount' || item.fieldName == 'costIncluded'){
                            item.editable = false;
                        }
                        else {
                            item.editable = result;     
                        }
                    });
                    this.columns = [...this.columns];
                }
                else{
                    columns.forEach(function (item, index) {
                        if(item.fieldName == 'amount'){
                            item.editable = false;
                        }
                        else {
                            item.editable = result;     
                        }
                    });
                    this.columns = [...this.columns];
                }
                }) 
            .catch(error => {
                console.log(error);
            })
    }

    checkIfFieldError() {
        let areAllValidField = true;
        let inputs = this.template.querySelectorAll('.validField');
        inputs.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity();
                areAllValidField = false;
            }
        });
        return areAllValidField;
    }

    checkUpdateFieldError() {
        let areAllRequiredField = true;
        let inputs = this.template.querySelectorAll('.requiredField');
        inputs.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity();
                areAllRequiredField = false;
            }
        });
        return areAllRequiredField;
    }

    handleAdd() {
        let actualCmp = this.template.querySelector(".actual");
        let actualCmpValue = actualCmp.value;
        if (actualCmpValue == null || actualCmpValue == '') {
            this.costRecord.Actual_Cost__c = 0;
        }
        this.costRecord.Enquiry_Id__c = this.recordId;
        this.costRecord.Cost_Included__c = false;
        this.costRecord.Other_Costing__c = true;
        console.log('cost rec--', this.costRecord);
        if (this.checkIfFieldError()) {
            saveCostAction({ objCost: this.costRecord })
                .then(result => {
                    this.costRecord = {};
                    refreshApex(this.fetchRefreshData);
                    console.log('Result -->', result);
                    if (result) {
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Success!!',
                            message: 'Cost Added Successfully!!',
                            variant: 'success'
                        }));
                    }
                })
                .catch(error => {
                    this.errorMsg = error.message;
                    console.log('Error -->', this.errorMsg);
                });
        }

    }

    handleUpdate() {
        if (this.currentUserProfileId == '00e0p000000IejsAAC' || this.currentUserProfileId == '00e0p000000IftFAAS' || this.currentUserProfileId == '00e5j000002m9dvAAA' || this.currentUserProfileId == '00e0p000000Imu5AAC') {
            if (this.checkUpdateFieldError()) {
                const fields = {};

                fields[ID_FIELD.fieldApiName] = this.recordId;
                fields[TRANSIT_TIME.fieldApiName] = this.enqRecord.Transit_Time__c;
                fields[SHIPMENT_TYPE.fieldApiName] = this.enqRecord.Shipment_Type__c;

                const recordInput = {
                    fields: fields
                };

                updateRecord(recordInput).then(() => {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Success!!',
                        message: 'Enquiry Updated Successfully!!',
                        variant: 'success'
                    }));
                })
                    .catch(error => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error creating record',
                                message: error.body.message,
                                variant: 'error'
                            })
                        );
                    });
            }
        }

    }

    handleRowAction(event) {
        const row = event.detail.row;
        console.log('Row details--', row);
        deleteCost({ objCost: row }).then(result => {
            window.console.log('delete result--' + result);
            refreshApex(this.fetchRefreshData);
            if (result) {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Cost Type Deleted Successfully',
                    variant: 'success'
                }));
            }
        })
    }

    @wire(getRecord, { recordId: '$recordId', fields: myFields })
    wireEnq({ error, data }) {
        if (error) {
            this.error = error;
            console.error('Error -->', error);
        } else if (data) {
            this.enqType = data.fields.Enquiry_Type__c.value;
            this.enqRecord.Shipment_Type__c = data.fields.Shipment_Type__c.value;
            this.enqRecord.Transit_Time__c = data.fields.Transit_Time__c.value;
            console.log('Enquiry Type --', this.enqType)
        }
    }

    @wire(getCostingList, { recordId: '$recordId', type: '$enqType' })
    wireArt(result) {
        this.fetchRefreshData = result;

        if (result.error) {
            this.error = result.error;
        } else if (result.data) {
            this.columns = columns;
            this.records = result.data;
            this.totalCostVol = this.records[0].totalVol;
            this.totalCostRate = this.records[0].totalRate;
            this.totalCostAmount = this.records[0].totalAmount;
            this.totalCostActual = this.records[0].totalActualCost;
            console.log('Data -->', this.records);
        }
    }

    addButtonHandler() {
        this.showTable = true;
    }

    cancelButtonHandler() {
        this.showTable = false;
    }

    @track draftValues = []

    handleSave(event) {
        console.log('draft values ', event.detail.draftValues)

        let mydraft = this.template.querySelector('lightning-datatable').draftValues;
        for (let i = 0; i < mydraft.length; i++) {
            console.log('ID -', mydraft[i].Id);
            let str = String(mydraft[i].Id);
            if (str.includes("row")) {
                let j = str.split('-').pop();
                if (mydraft[i].costType == null) {
                    mydraft[i]['costType'] = this.records[j].costType;
                }
                if (mydraft[i].actualCost == null) {
                    mydraft[i]['actualCost'] = this.records[j].actualCost;
                }
                if (mydraft[i].costIncluded == null) {
                    mydraft[i]['costIncluded'] = this.records[j].costIncluded;
                }
                mydraft[i]['Id'] = this.records[j].Id;
                mydraft[i]['enqId'] = this.records[j].enqId;
            }
        }
        console.log('mydraft after loop <-->', mydraft);
        console.log('String--', JSON.stringify(mydraft));
        const strDraft = JSON.stringify(mydraft);
        upsertCosting({ jsonresponse: strDraft }).then((resp) => {
            console.log('Successfully created --', resp);
            refreshApex(this.fetchRefreshData);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Costing Updated Successfully!!',
                    variant: 'success'
                })
            );
            this.draftValues = [];

        }).catch((err) => {
            console.log(JSON.stringify(err));
        });
    }

}