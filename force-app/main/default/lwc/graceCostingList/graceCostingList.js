import { LightningElement, track, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getCostingList from '@salesforce/apex/CostingController.getCostingList';
import upsertCosting from '@salesforce/apex/CostingController.upsertCosting';
import deleteCost from '@salesforce/apex/CostingController.deleteCost';
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
    editable: true
},
{
    label: 'Volume',
    fieldName: 'volume',
    editable: true
},
{
    label: 'Rate',
    fieldName: 'rate',
    editable: true
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
    @track errorMsg;
    toggleview = false
    //@track selectedRowsData=[]
    @track enqType;
    showTable;
    @track value;
    @track error;
    @track data;
    @api sortedDirection = 'asc';
    @api sortedBy = 'Name';
    @api searchKey = '';
    result;
    records;
    wiredRecords;
    //@track selectedData = [];

    @track page = 1;
    @track items = [];
    @track data = [];
    @track columns;
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = 10;
    @track totalRecountCount = 0;
    @track totalPage = 1;

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
        //console.log('Record id-', this.recordId);
        this.costRecord.Enquiry_Id__c = this.recordId;
        this.costRecord.Other_Costing__c = true;
        console.log('cost rec--', this.costRecord);
        /* let costTypeCmp = this.template.querySelector(".costTypeReqd");
        let quanCmp = this.template.querySelector(".quanReqd");
        let volumeCmp = this.template.querySelector(".volReqd");
        let rateCmp = this.template.querySelector(".rateReqd");
        let costTypeValue = costTypeCmp.value;
        let quantValue = quanCmp.value;
        let volumeValue = volumeCmp.value;
        let rateValue = rateCmp.value;

        if (!costTypeValue) {
            costTypeCmp.setCustomValidity("Cost Type is required");
        }
        else {
            costTypeCmp.setCustomValidity(""); 
        } 
        costTypeCmp.reportValidity();

        if (!quantValue) {
            quanCmp.setCustomValidity("Quantity is required");
        }
        else {
            quanCmp.setCustomValidity("");
        } 
        quanCmp.reportValidity();

        if (!volumeValue) {
            volumeCmp.setCustomValidity("Volume is required");
        }
        else {
            volumeCmp.setCustomValidity("");
        } 
        volumeCmp.reportValidity();

        if (!rateValue) {
            rateCmp.setCustomValidity("Rate is required");
        }
        else {
            rateCmp.setCustomValidity("");}
        rateCmp.reportValidity(); */
        if (this.checkIfFieldError()) {
            saveCostAction({ objCost: this.costRecord })
                //this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
                .then(result => {
                    //this.articleId = result.Id;   
                    this.costRecord = {};
                    refreshApex(this.fetchRefreshData);
                    console.log('Result -->', result);
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Success!!',
                        message: 'Cost Added Successfully!!',
                        variant: 'success'
                    }));
                    //setTimeout(function () { (eval("$A.get('e.force:refreshView').fire()")) }, 1000);
                })
                .catch(error => {
                    this.errorMsg = error.message;
                    console.log('Error -->', this.errorMsg);
                });
        }

    }

    handleRowAction(event) {
        //const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log('Row details--', row);
        console.log('Delete successful');
        //this.rId = row.Id;
        deleteCost({ objCost: row }).then(result => {
            window.console.log('delete result--' + result);
            refreshApex(this.fetchRefreshData);
            //this.showLoadingSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: 'Cost Type Deleted Successfully',
                variant: 'success'
            }));
        }).catch(error => {
            window.console.log('Error ====> ' + error.message);
            //this.showLoadingSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!!',
                message: JSON.stringify(error),
                variant: 'error'
            }));
        });
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
            console.log('Data -->', this.records);
        }
    }

    /* @wire( fetchSampleRecs, {type: '$enqType'} )
    wiredRecs(value){
        this.wiredRecords = value;
        const{error,data} = value;

        if(data){
            console.log('data -- ', data);
            this.columns=columns;
            this.records = data;
            this.error = undefined;
        }
        else if(error){
            this.error = error;
            this.records = undefined;
        }
    } */


    /* @wire(getArticleList, {enqId: '$recordId',searchKey: '$searchKey', sortBy: '$sortedBy', sortDirection: '$sortedDirection'}) 
    wiredAccounts(refreshResult) {
        this.result=refreshResult;
        const {data,error} =refreshResult
        if (data) {       
            this.items = data;
            console.log('my data ',data)
            this.totalRecountCount = data.length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            
            this.data = this.items.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;
            this.columns = columns;

            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }
    } */

    
    addButtonHandler() {
        this.showTable = true;
    }

    cancelButtonHandler(){
        this.showTable = false;
    }

    /*   handler(){
          refreshApex(this.records);
      } */

    //clicking on previous button this method will be called
    /*  previousHandler() {
         if (this.page > 1) {
             this.page = this.page - 1; //decrease page by 1
             this.displayRecordPerPage(this.page);
         }
     }
 
     //clicking on next button this method will be called
     nextHandler() {
         if((this.page<this.totalPage) && this.page !== this.totalPage){
             this.page = this.page + 1; //increase page by 1
             this.displayRecordPerPage(this.page);            
         }             
     }
 
     //this method displays records page by page
     displayRecordPerPage(page){
 
         this.startingRecord = ((page -1) * this.pageSize) ;
         this.endingRecord = (this.pageSize * page);
 
         this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                             ? this.totalRecountCount : this.endingRecord; 
 
         this.data = this.items.slice(this.startingRecord, this.endingRecord);
 
         this.startingRecord = this.startingRecord + 1;
     } */

    /* sortColumns(event) {
        this.sortedBy = event.detail.fieldName;
        this.sortedDirection = event.detail.sortDirection;
        return refreshApex(this.result);

    }

    handleKeyChange(event) {
        this.searchKey = event.target.value;
        return refreshApex(this.result);
    } */

    @track draftValues = []
    //@track selectedRowsData=[]
    handleSave(event) {

        console.log('draft values ', event.detail.draftValues)
        console.log(JSON.stringify(event.detail.draftValues))

        let mydraft = this.template.querySelector('lightning-datatable').draftValues;
        //console.log('mydraft before loop-->', mydraft);
        for (let i = 0; i < mydraft.length; i++) {
            console.log('ID -', mydraft[i].Id);
            let str = String(mydraft[i].Id);
            let j = str.split('-').pop();
            mydraft[i]['costType'] = this.records[j].costType;
            mydraft[i]['Id'] = this.records[j].Id;
            mydraft[i]['enqId'] = this.records[j].enqId;
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
            // Handle any error that occurred in any of the previous// promises in the chain.console.log(JSON.stringify(err));
            console.log(JSON.stringify(err));
        });
    }

}