import { LightningElement, track, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { getRecord } from 'lightning/uiRecordApi';
//import { updateRecord } from 'lightning/uiRecordApi'
import getArticleList from '@salesforce/apex/ArticleController.getArticleList';
import upsertArticle from '@salesforce/apex/ArticleController.upsertArticle';
import saveAction from '@salesforce/apex/ArticleController.saveAction';
import deleteArticle from '@salesforce/apex/ArticleController.deleteArticle';
//import { deleteRecord } from 'lightning/uiRecordApi';
//import generatePDF from '@salesforce/apex/pdfController.generatePDF';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
// import IMAGE_LOGO from '@salesforce/resourceUrl/grace'
import ITEM_NAME from '@salesforce/schema/Article__c.Item_Name__c';
import ENQUIRY_ID from '@salesforce/schema/Article__c.Enquiry_Id__c';
import OTHER_ITEM from '@salesforce/schema/Article__c.Other_Article__c';
import QUANTITY from '@salesforce/schema/Article__c.Quantity__c';
import INSURANCE_VALUE from '@salesforce/schema/Article__c.Insurance_Value__c';

const actions = [
    { label: 'Delete', name: 'delete' }
 ];

const columns = [{
    label: 'Item Name',
    fieldName: 'itemName',
    type: 'text',
},
{
    label: 'Insurance',
    fieldName: 'insuranceValue',
    editable: true
},
{
    label: 'Quantity',
    fieldName: 'quantity',
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

/* const column = [{
    label: 'Item Name',
    fieldName: 'Item_Name__c',
},
{
    label: 'Insurance Ammount',
    fieldName: 'Insurance_Value__c',editable:true,
},
{
    label: 'Quantity',
    fieldName: 'Quantity__c',editable:true,
}
]; */

const myFields = ['Enquiry__c.Enquiry_Type__c'];

export default class GraceArticleList extends LightningElement {
    @api recordId
    @track artRecord = {
        Item_Name__c: ITEM_NAME,
        Quantity__c: QUANTITY,
        Insurance_Value__c: INSURANCE_VALUE,
        Enquiry_Id__c: ENQUIRY_ID,
        Other_Article__c: OTHER_ITEM
    };
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
    wiredRecords;
    @track selectedData = [];

    //@track page = 1;
    @track items = [];
    @track data = [];
    @track columns;
    /* @track startingRecord = 1;
    @track endingRecord = 0;
    @track pageSize = 10;
    @track totalRecountCount = 0;
    @track totalPage = 1; */

    handleItemChange(event) {
        this.artRecord.Item_Name__c = event.target.value;
    }

    handleQuantityChange(event) {
        this.artRecord.Quantity__c = event.target.value;
    }

    handleInsuranceChange(event) {
        this.artRecord.Insurance_Value__c = event.target.value;
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
        /* let itemNameCmp = this.template.querySelector(".inputField");
        let quantityCmp = this.template.querySelector(".inputField");
        
        let itemNamevalue = itemNameCmp.value;
        let quantityValue = quantityCmp.value;
        

        console.log('insurance value--', insuranceCmpValue);

        if (!itemNamevalue) {
            itemNameCmp.setCustomValidity("Item Name is required");

        }
        else {
            itemNameCmp.setCustomValidity(""); // clear previous value
        }
        itemNameCmp.reportValidity();

        if (!quantityValue) {
            quantityCmp.setCustomValidity("Quantity is required");
        }
        else {
            quantityCmp.setCustomValidity(""); // clear previous value
        }
        quantityCmp.reportValidity();
 */
        let insuranceCmp = this.template.querySelector(".insurance");
        let insuranceCmpValue = insuranceCmp.value;
        if (insuranceCmpValue == null || insuranceCmpValue == '') {
            this.artRecord.Insurance_Value__c = 0;
        }
        //console.log('Record id-', this.recordId);
        this.artRecord.Enquiry_Id__c = this.recordId;
        this.artRecord.Other_Article__c = true;
        if (this.checkIfError()) {
            saveAction({ objArt: this.artRecord })
                //this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
                .then(result => {
                    //this.articleId = result.Id;
                    refreshApex(this.fetchRefreshedData);
                    this.artRecord = {};
                    console.log('Result -->', result);
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Success!!',
                        message: 'Article Added Successfully!!',
                        variant: 'success'
                    }));
                    //this.handler();
                    //setTimeout(function () { (eval("$A.get('e.force:refreshView').fire()")) }, 1000);
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
            console.log('Data -->', this.records);
        }
    }

    handleRowActions(event) {
        //const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.log('Row details--', row);
        console.log('Delete successful');
        //this.rId = row.Id;
        deleteArticle({ objItem: row }).then(result => {
            window.console.log('delete result--' + result);
            refreshApex(this.fetchRefreshedData);
            //this.showLoadingSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: 'Article Deleted Successfully',
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
        /* deleteRecord(this.rId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );})
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            }); */
    }

    /* delArticle(currentRow){
        deleteArticle({ objItem: currentRow }).then(result => {
            window.console.log('delete result--' + result);
            refreshApex(this.fetchRefreshedData);
            //this.showLoadingSpinner = false;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success!!',
                message: 'Article Deleted Successfully',
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
    } */

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

    buttonClickHandler() {
        this.showTable = true;
    }

    handleCancel(){
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
    @track selectedRowsData = []
    handleSave(event) {

        console.log('draft values ', event.detail.draftValues)
        console.log(JSON.stringify(event.detail.draftValues))

        let mydraft = this.template.querySelector('lightning-datatable').draftValues;
        //console.log('mydraft before loop-->', mydraft);
        for (let i = 0; i < mydraft.length; i++) {
            console.log('ID -', mydraft[i].Id);
            let str = String(mydraft[i].Id);
            let j = str.split('-').pop();
            mydraft[i]['itemName'] = this.records[j].itemName;
            mydraft[i]['Id'] = this.records[j].Id;
            mydraft[i]['enqId'] = this.records[j].enqId;
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
            // Handle any error that occurred in any of the previous// promises in the chain.console.log(JSON.stringify(err));
            console.log(JSON.stringify(err));
        });
    }

        /* Promise.all(
            mydraft.map(draft => {
                    const fields = {};
                    fields[ITEM_NAME.fieldApiName] = draft.itemName;
                    fields[QUANTITY.fieldApiName] = draft.quantity;
                    fields[INSURANCE_VALUE.fieldApiName] = draft.insuranceValue;
                    fields[ENQUIRY_ID.fieldApiName] = this.recordId;
                    for (let i = 0; i < this.records.length; i++){
                        console.log('Inside for loop --', this.records.length);
                        if(draft.itemName === this.records[i].itemName){
                            console.log('Inside first If--', this.records[i].itemName);
                            if(this.records[i].quantity === null && this.records[i].insuranceValue === null){
                                console.log('Inside create If- ', this.records[i].quantity)
                                const recordInput = { apiName: ARTICLE.objectApiName, fields };
                                return createRecord(recordInput);
                            }                           
                            else{ 
                                console.log('Inside update else-', fields);
                                const recordInputs = { fields };
                                return updateRecord(recordInputs);
                            }
                        }
                    }                   
                                    
            })).then(results => {
                console.log('Successfully created --', results);           
            }).catch(error => {
                console.log(JSON.stringify(error));
            }); */

        /* Promise.all(
            event.detail.draftValues.map(draft => {
                const fields = {};
                fields[QUANTITY.fieldApiName] = draft.quantity;
                fields[INSURANCE_VALUE.fieldApiName] = draft.insuranceValue;
                const recordInput = { apiName: ARTICLE.objectApiName, fields };
                return createRecord(recordInput);
            })).then(results => {
                console.log('Successfully created --', results);           
            }).catch(error => {
                console.log(JSON.stringify(error));
            }); */

        //const fields = {};

        //fields[ITEM_NAME.fieldApiName] = event.detail.draftValues[0].Id;
        /* console.log('Quantity name --',event.detail.draftValues[0].quantity );
        fields[QUANTITY.fieldApiName] = event.detail.draftValues[0].quantity;
        fields[INSURANCE_VALUE.fieldApiName] = event.detail.draftValues[0].insuranceValue;

        let newArticle = {fields};
        createMyArticle({art : newArticle}).then((resp)=>{
            console.log('Successfully created --', resp);


        }).catch((err) => { */
        // Handle any error that occurred in any of the previous// promises in the chain.console.log(JSON.stringify(err));
        /* console.log(JSON.stringify(err));
        });

        console.log('Field values--', fields); */
        /* const recordInputs = { apiName: ARTICLE.objectApiName, recordInput };

        createRecord(recordInputs)
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contact updated',
                    variant: 'success'
                })
            ); */
        // Display fresh data in the datatable
        /* return refreshApex(this.contact).then(() => {

            // Clear all draft values in the datatable
            this.draftValues = [];

        }); */
        /* }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or reloading record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
            console.error('Error -', error.body.message);
        }); */

        /* const recordInputs=event.detail.draftValues.map(draft=>{
            const fields = {...draft};
            return { fields:fields };
        }) */
        //  const mydraft=event.detail.draftValues
        /* const promises = recordInputs.map(recordInput=>updateRecord(recordInput))
        Promise.all(promises).then(()=>{
            console.log('EQ product updated Successfully')
            this.draftValues=[]
            this.selectedData=[]
            refreshApex(this.result)
        }).catch(error=>{
            console.error("Error updating the record", error)
        }) */
        // this.showChangedRows(mydraft)

    // showChangedRows(mydraft)
    // {

    //     const selectedRows =mydraft
    //     for (let i = 0; i < selectedRows.length; i++) {


    //         this.selectedRowsData.push({
    //             Id:selectedRows[i].Id,
    //             Name:selectedRows[i].Name,
    //             Insurance:selectedRows[i].Insurance_Ammount__c, 
    //             Quantity:selectedRows[i].Quantity__c

    //         })
    //         console.log('inside show change rows',selectedRows)
    // }

    /* getSelectedName(event) {
        console.log('my selectedRowsData ', event.detail.selectedRows)
        console.log('my record id ', this.recordId)

        const selectedRows = event.detail.selectedRows;


        for (let i = 0; i < selectedRows.length; i++) {
            // this._selectedData[selectedRows[i].id] = {
            //                                             Id:selectedRows[i].Id,
            //                                             Name:selectedRows[i].Name,
            //                                             Insurance:selectedRows[i].Insurance_Amount__c, 
            //                                             Quantity:selectedRows[i].Quantity__c
            //                                             }
            if (!this.selectedData.includes(selectedRows[i])) {
                this.selectedData = [...this.selectedData, selectedRows[i]];
            }


            // this.selectedRowsData.push({
            // Id:selectedRows[i].Id,
            // Name:selectedRows[i].Name,
            // Insurance:selectedRows[i].Insurance_Amount__c, 
            // Quantity:selectedRows[i].Quantity__c

            //   })
            //console.log('inside loop ',selectedRows[i].Insurance_Amount__c)
        }
        // this.selectedRowsData=[...new Map(this.selectedRowsData.map(v => [v.id, v])).values()]
        console.log("selectedData ", this.selectedData)
    }
 */
    /* pdfHandler()
     {
         
         let content = this.template.querySelector('.container')
         console.log(content.outerHTML)
          generatePDF({recordId:this.recordId,htmlData:content.outerHTML}).then(result=>{
 
             const event = new ShowToastEvent({ 
                 title :'Success',
                 message:'Articles to be Moved Document Created Successfully',
                 variant:'success',
                 
             })
             this.dispatchEvent(event)
 
             console.log("attachment id", result)
         }).catch(error=>{
             console.error(error)
         })
     } */

    viewToggle() {
        this.toggleview = !this.toggleview
    }


}