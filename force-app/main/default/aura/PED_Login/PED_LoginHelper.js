({
    doInit : function(component,event) {
        this.showSpinner(component);
        var i;
        var item = window.location.href.split('&');
        for (i = 0; i < item.length; i++) {
            if(item[i].includes('display'))
                component.set("v.isApp", item[i].split('=')[1].replace(']','') == 'touch');
            if(item[i].includes('login_hint'))
                component.set("v.username", item[i].split('=')[1].replace('%40','@').replace(']',''));
        }
        if(component.get("v.isApp")){
            //MM Sostituito .replaceAll('%2F','/'); perchè supportato solo da versione chrome > 85 --> possibili problemi per l'app mobile.
            // è necessario effettuare il replace, altrimenti lo startUrl passato all'apex e poi dato in pasto a site.login() non funziona con autenticazione oauth2.
            var startUrlsplit = window.location.href.split('startURL=')[1].split('%2F');
            component.set("v.startUrl",startUrlsplit.join('/'));
        }
        var action = component.get("c.init");
        action.setCallback(this, function(response){
            if(response.getReturnValue()){
                if(item[0].includes(response.getReturnValue().loginInfo.PED_LoginSPID__c)){
                    component.set("v.isSPID",true);
                    var cmpEvent =  $A.get("e.c:RecaptchaEvent1");
                    cmpEvent.setParams({"ViewRecap" : false });
                    cmpEvent.fire();
                }
                else{
                   var cmpEvent =  $A.get("e.c:RecaptchaEvent1");
                    cmpEvent.setParams({"ViewRecap" : true });
                    cmpEvent.fire(); 
                }
                    
                component.set("v.loginInformation", response.getReturnValue().loginInfo);
                component.set("v.maintenanceOn", response.getReturnValue().maintenanceOn);
            }
            else
                this.showError('Attenzione', 'Si è verificato un errore, si prega di ricaricare la pagina.');
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    //DF Prima era chiamata handleCallback
    doLogIn : function(component,event) {
        this.showSpinner(component);
        var action = component.get("c.loginUser");
        action.setParams({ 
            "username" : component.get("v.username"),
            "password" : component.get("v.password"),
            "startUrl" : component.get("v.startUrl")
        });
        action.setCallback(this, function(response){
            if(response.getReturnValue().includes('OK:'))
                window.open(response.getReturnValue().split('OK:')[1], "_self");
            else{
                if(response.getReturnValue().includes('KO:'))
                    component.set("v.errorMessage", response.getReturnValue().split('KO:')[1]);
                else
                    component.set("v.errorMessage", 'Il tentativo di accesso non è riuscito. Assicurarsi che il nome utente e la password siano corretti.');
                this.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);
    },
    
    goToUrl : function(component, event, operation) {
        this.showSpinner(component);
        var url = component.get("v.loginInformation."+operation);
        if(component.get("v.isApp")){
            //MM per l'app è necessario aprire un nuovo tab (sarebbe da ritestare approfonditamente)
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": url.split(',')[1]
            });
            urlEvent.fire();
        }
        else
        	window.open(url.split(',')[0], "_self");
    },
    
    noError : function(component, event) {
        if(component.get("v.username") == "" || component.get("v.password") == "")
            component.set("v.errorMessage", "");
    },
    
    togglePassword : function(component, event) {
        component.set("v.showpassword", !component.get("v.showpassword"));
    },
    
    //METODI DI SUPPORTO START
    showToast: function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }, 
    
    showError: function(title, message) {
        this.showToast('error', title, message);
    },
    
    showWarning: function(title, message) {
        this.showToast('warning', title, message);
    },
    
    showSuccess: function(title, message) {
        this.showToast('success', title, message);
    },
    
    showSpinner: function(component) {
        component.set("v.showSpinner", true);
    },
    
    hideSpinner: function(component) {
        component.set("v.showSpinner", false);
    }
    //METODI DI SUPPORTO END
})