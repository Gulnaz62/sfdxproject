import { LightningElement, track, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { getRecord } from 'lightning/uiRecordApi';
import getArticleList from '@salesforce/apex/ArticleController.getArticleList';
import upsertArticle from '@salesforce/apex/ArticleController.upsertArticle';
import saveAction from '@salesforce/apex/ArticleController.saveAction';
import deleteArticle from '@salesforce/apex/ArticleController.deleteArticle';
import canUserEdit from '@salesforce/apex/ArticleController.canUserEdit';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ITEM_NAME from '@salesforce/schema/Article__c.Item_Name__c';
import UNIT_VOLUME from '@salesforce/schema/Article__c.Unit_Volume__c'
import ENQUIRY_ID from '@salesforce/schema/Article__c.Enquiry_Id__c';
import OTHER_ITEM from '@salesforce/schema/Article__c.Other_Article__c';
import CFT from '@salesforce/schema/Article__c.CFT__c';
import QUANTITY from '@salesforce/schema/Article__c.Quantity__c';
import INSURANCE_VALUE from '@salesforce/schema/Article__c.Insurance_Value__c';

const actions = [
    { label: 'Delete', name: 'delete' }
 ];

const columns = [{
    label: 'Item Name',
    fieldName: 'itemName',
    type: 'text'
},
{
    label: 'Quantity',
    fieldName: 'quantity',
    type: 'number'
},
{
    label: 'Unit Volume',
    fieldName: 'unitVolume',
    type: 'number'
},
{
    label: 'CFT',
    fieldName: 'cft',
    type: 'number'
},
{
    label: 'Insurance',
    fieldName: 'insuranceValue',
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

export default class GraceArticleList extends LightningElement {
    @api recordId
    @track artRecord = {
        Item_Name__c: ITEM_NAME,
        Quantity__c: QUANTITY,
        Unit_Volume__c: UNIT_VOLUME,
        Insurance_Value__c: INSURANCE_VALUE,
        Enquiry_Id__c: ENQUIRY_ID,
        Other_Article__c: OTHER_ITEM
    };
    @track totalVol;
    @track totalQuan;
    @track totalIns;
    @track fetchRefreshedData = [];
    @track errorMsg;
    @track selectedRowsData = []
    @track enqType;
    @track showTable = false;
    @track value;
    @track error;
    @track data;
    result;
    records;
    @track data = [];
    @track columns;

    handleItemChange(event) {
        this.artRecord.Item_Name__c = event.target.value;
    }

    handleQuantityChange(event) {
        this.artRecord.Quantity__c = event.target.value;
    }

    handleUnitVolumeChange(event) {
        this.artRecord.Unit_Volume__c = event.target.value;
    }

    handleInsuranceChange(event) {
        this.artRecord.Insurance_Value__c = event.target.value;
    }

    connectedCallback() {
        canUserEdit()
            .then(result => {
                columns.forEach(function (item, index) {
                    if(item.fieldName == 'cft'){
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

    checkIfError() {
        let areAllValid = true;
        let inputs = this.template.querySelectorAll('.fieldValid');
        inputs.forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity();
                areAllValid = false;
            }
        });
        return areAllValid;
    }

    handleAdd() {
        let insuranceCmp = this.template.querySelector(".insurance");
        let insuranceCmpValue = insuranceCmp.value;
        if (insuranceCmpValue == null || insuranceCmpValue == '') {
            this.artRecord.Insurance_Value__c = 0;
        }
        this.artRecord.Enquiry_Id__c = this.recordId;
        this.artRecord.Other_Article__c = true;
        if (this.checkIfError()) {
            saveAction({ objArt: this.artRecord })
                .then(result => {
                    refreshApex(this.fetchRefreshedData);
                    this.artRecord = {};
                    console.log('Result -->', result);
                    if(result){
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Success!!',
                            message: 'Article Added Successfully!!',
                            variant: 'success'
                        }));
                    }                   
                })
                .catch(error => {
                    this.errorMsg = error.message;
                    console.log(this.errorMsg);
                });
        }

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

    @wire(getArticleList, { recordId: '$recordId', type: '$enqType' })
    wireArt(result) {
        this.fetchRefreshedData = result;
        if (result.error) {
            this.error = result.error;
        } else if (result.data) {
            this.columns = columns;
            console.log('refresh data--', result.data);
            this.records = result.data;
            this.totalQuan = this.records[0].totalQuantity;
            this.totalVol = this.records[0].totalCft;
            this.totalIns = this.records[0].totalInsuranceValue;
            console.log('Data -->', this.records);
        }
    }

    handleRowActions(event) {
        const row = event.detail.row;
        console.log('Row details--', row);
        console.log('Delete successful');
        deleteArticle({ objItem: row }).then(result => {
            window.console.log('delete result--' + result);
            refreshApex(this.fetchRefreshedData);
            if(result){
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!!',
                    message: 'Article Deleted Successfully',
                    variant: 'success'
                }));
            }           
        })
    }

    buttonClickHandler() {
        this.showTable = true;
    }

    handleCancel(){
        this.showTable = false;
    }

    @track draftValues = []
    @track selectedRowsData = []
    handleSave(event) {

        console.log('draft values ', event.detail.draftValues)
        console.log(JSON.stringify(event.detail.draftValues))

        let mydraft = this.template.querySelector('lightning-datatable').draftValues;
        console.log('mydraft before loop-->', mydraft);
        for (let i = 0; i < mydraft.length; i++) {
            console.log('ID -', mydraft[i].Id);
            let str = String(mydraft[i].Id);
            if(str.includes("row")){
                let j = str.split('-').pop();
                if(mydraft[i].itemName==null){
                    mydraft[i]['itemName'] = this.records[j].itemName;
                }
                mydraft[i]['unitVolume'] = this.records[j].unitVolume;
                mydraft[i]['Id'] = this.records[j].Id;
                mydraft[i]['enqId'] = this.records[j].enqId;
            }
        }
        console.log('mydraft after loop <-->', mydraft);
        console.log('String--', JSON.stringify(mydraft));
        const strDraft = JSON.stringify(mydraft);
        upsertArticle({ jsonresponse: strDraft }).then((resp) => {
            console.log('Successfully created --', resp);
            refreshApex(this.fetchRefreshedData);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Article Updated Successfully!!',
                    variant: 'success'
                })
            );
            this.draftValues = [];

        }).catch((err) => {
            console.log(JSON.stringify(err));
        });
    }


}