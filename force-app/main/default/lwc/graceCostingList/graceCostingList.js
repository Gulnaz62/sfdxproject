import { LightningElement, track, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getCostingList from '@salesforce/apex/CostingController.getCostingList';
import upsertCosting from '@salesforce/apex/CostingController.upsertCosting';
import deleteCost from '@salesforce/apex/CostingController.deleteCost';
import canUserEdit from '@salesforce/apex/CostingController.canUserEdit';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveCostAction from '@salesforce/apex/CostingController.saveCostAction';
import COST_NAME from '@salesforce/schema/Costing__c.Particulars__c';
import ENQUIRY_ID from '@salesforce/schema/Costing__c.Enquiry_Id__c';
import VOLUME from '@salesforce/schema/Costing__c.Volume__c';
import QUANTITY from '@salesforce/schema/Costing__c.Quantity__c';
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
    label: 'Quantity',
    fieldName: 'quantity',
    type: 'number'
},
{
    label: 'Volume',
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
    type: 'action',
    typeAttributes: {
        rowActions: actions,
        menuAlignment: 'right'
    }
}

];

const myFields = ['Enquiry__c.Enquiry_Type__c'];

export default class GraceCostingList extends LightningElement {
    @api recordId
    @track fetchRefreshData = [];
    @track costRecord = {
        Particulars__c: COST_NAME,
        Quantity__c: QUANTITY,
        Volume__c: VOLUME,
        Enquiry_Id__c: ENQUIRY_ID,
        Other_Costing__c: OTHER_COST,
        Rate__c: RATE
    };
    @track totalCostVol;
    @track totalCostQuan;
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

    handleQuantityChange(event) {
        this.costRecord.Quantity__c = event.target.value;
    }

    handleVolumeChange(event) {
        this.costRecord.Volume__c = event.target.value;
    }

    handleRateChange(event) {
        this.costRecord.Rate__c = event.target.value;
    }

    connectedCallback() {
        canUserEdit()
            .then(result => {
                columns.forEach(function (item, index) {
                    if(item.fieldName == 'costType' || item.fieldName == 'amount'){
                        item.editable = false;
                    }
                    else{
                        item.editable = result;
                    }                   
                });
                this.columns = [...this.columns];
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

    handleAdd() {
        this.costRecord.Enquiry_Id__c = this.recordId;
        this.costRecord.Other_Costing__c = true;
        console.log('cost rec--', this.costRecord);
        if (this.checkIfFieldError()) {
            saveCostAction({ objCost: this.costRecord })
                .then(result => {  
                    this.costRecord = {};
                    refreshApex(this.fetchRefreshData);
                    console.log('Result -->', result);
                    if(result){
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

    handleRowAction(event) {
        const row = event.detail.row;
        console.log('Row details--', row);
        deleteCost({ objCost: row }).then(result => {
            window.console.log('delete result--' + result);           
            refreshApex(this.fetchRefreshData);
            if(result){
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
            this.totalCostQuan = this.records[0].totalQuant;
            this.totalCostVol = this.records[0].totalVol;
            this.totalCostRate = this.records[0].totalRate;
            this.totalCostAmount = this.records[0].totalAmount;
            console.log('Data -->', this.records);
        }
    }
   
    addButtonHandler() {
        this.showTable = true;
    }

    cancelButtonHandler(){
        this.showTable = false;
    }

    @track draftValues = []

    handleSave(event) {
        console.log('draft values ', event.detail.draftValues)

        let mydraft = this.template.querySelector('lightning-datatable').draftValues;
        for (let i = 0; i < mydraft.length; i++) {
            console.log('ID -', mydraft[i].Id);
            let str = String(mydraft[i].Id);
            if(str.includes("row")){
                let j = str.split('-').pop();
                mydraft[i]['costType'] = this.records[j].costType;
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