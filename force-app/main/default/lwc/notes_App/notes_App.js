import { LightningElement, track } from 'lwc';
import loginWithEmailAndPassword from '@salesforce/apex/NotesAppController.loginWithEmailAndPassword';
import createNewUser from '@salesforce/apex/NotesAppController.createNewUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Notes_App extends LightningElement {

    constructor() {
        super();
        this.input = {
            email: "",
            password: ""
        };
        this.newUserInput = {
            email: "",
            password: "",
            name: "",
        };

        this.secretCred = {
            password: "",
            confirmPassword: ""
        };

    }

    userEmailChange(event) {
        this.input.email = event.target.value;
    }

    userPassChange(event) {
        this.input.password = event.target.value;
    }

    newUserEmailChange(event) {
        this.newUserInput.email = event.target.value;
    }

    newUserNameChange(event) {
        this.newUserInput.name = event.target.value;
    }

    newUserPassChange(event) {
        this.secretCred.password = event.target.value;
    }

    newUserConfirmPassChange(event) {
        this.secretCred.confirmPassword = event.target.value;
    }

    _validateSecreetCred() {
        return this.secretCred.password == this.secretCred.confirmPassword
    }

    _loginWithEmailAndPassword() {
        const parameters = JSON.stringify(this.input);
        loginWithEmailAndPassword({ json: parameters })
            .then(result => {
                //console.log('result: ' + JSON.stringify(result));
                if (result.status != '000') {
                    const event = new ShowToastEvent({
                        "title": "Success!",
                        "message": "Login Success",
                        variant: 'success'
                    });
                    this.dispatchEvent(event);
                } else {
                    const event = new ShowToastEvent({
                        "title": "Login Failed!",
                        "message": result.error,
                        variant: 'error'
                    });
                    this.dispatchEvent(event);
                }
            })
            .catch(error => {
                const event = new ShowToastEvent({
                    "title": "Error",
                    "message": 'please refresh page and try again!!',
                    variant: 'error'
                });
                this.dispatchEvent(event);
                //console.log(error);
            });
    }

    _signUpWithEmailAndPassword(event) {
        if (this._validateSecreetCred()) {
            this.newUserInput.password = this.secretCred.password;
            const parameters = JSON.stringify(this.newUserInput);
            createNewUser({ json: parameters })
                .then(result => {
                    {
                        if (result.status) {
                            const event = new ShowToastEvent({
                                "title": "Success!",
                                "message": "Account Created Success",
                                variant: 'success'
                            });
                            this.dispatchEvent(event);
                        } else {
                            const event = new ShowToastEvent({
                                "title": "Failed!",
                                "message": "Error in creating Account",
                                variant: 'error'
                            });
                            this.dispatchEvent(event);
                        }
                    }

                });
            }else{  
                // console.log('error while matching password');
                const event = new ShowToastEvent({
                    "title": "warning",
                    "message": "please User Same Password",
                    variant: 'warning'
                });
                this.dispatchEvent(event);
            }
    }

}