import { LightningElement, api } from 'lwc';
//import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class ScheduleQuote extends LightningElement {
    @api recordId;  
    openScheduleVisualForcePage(event){
        window.open('/apex/page/Relocation_HouseHoldGoods_CSD?id=' + this.recordId,'_blank');
        this.dispatchEvent(new CloseActionScreenEvent());
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Quote Scheduled Successfully!!',
                variant: 'success'
            })
        );

    }

    handleCancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}