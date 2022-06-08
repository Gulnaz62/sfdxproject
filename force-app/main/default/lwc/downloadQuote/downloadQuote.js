import { LightningElement, api } from 'lwc';
//import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class DownloadQuote extends LightningElement {
    @api recordId;
    openVisualForcePage(event) {
        window.open('/apex/page/PDFHandler?id=' + this.recordId,'_blank');
        this.dispatchEvent(new CloseActionScreenEvent());
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Quote Downloaded Successfully!!',
                variant: 'success'
            })
        );
    }

    handleCancel(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
}