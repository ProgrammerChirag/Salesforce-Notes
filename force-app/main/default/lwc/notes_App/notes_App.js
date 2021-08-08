import { LightningElement, track } from 'lwc';
import loginWithEmailAndPassword from '@salesforce/apex/NotesLoginController.loginWithEmailAndPassword';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Notes_App extends LightningElement {

    constructor() {
        super();
        this.input={
            email :"",
            password:""
        };
    }

    userEmailChange(event){
        this.input.email = event.target.value;
    }

    userPassChange(event){
        this.input.password = event.target.value;
    }

    _loginWithEmailAndPassword() {
        const parameters = JSON.stringify(this.input);
        loginWithEmailAndPassword({json:parameters})
            .then(result => {
                console.log('result: '+JSON.stringify(result));
                if(result.status){
                    const event = new ShowToastEvent({
                        "title": "Success!",
                        "message": "Login Success",
                        variant:'success'
                    });
                    this.dispatchEvent(event);
                }else{
                    const event = new ShowToastEvent({
                        "title": "Failed!",
                        "message": "Login failed",
                        variant:'error'
                    });
                    this.dispatchEvent(event);
                }
            })
            .catch(error => {
                console.log(error);
            });
    }

}