({
    doInit: function (component, event, helper) {
        debugger;
        component.invocationCallbacks = {};
        component.set("v.vfBaseURL", window.location.origin); 
        component.set('v.srcIFrame' , window.location.origin +'/PortaleClienti/PED_ProxyCallWSAsyncServiziTecnici');
        window.addEventListener("message", function (event,component) {
            debugger;
            if(event.data.isEddie==undefined && event.data.result!=undefined){
                var result = event.data.result;
                document.getElementById('result').innerHTML=event.data.result;            
                document.getElementById('methodName').innerHTML=event.data.method;
                document.getElementById('triggerButton').click();
            }
            
        }, false);       
    },
    callEventLightning: function (component, event, helper) {
        debugger;
        helper.callEventLightning(component, event, helper); 
    },
    callWSAsync: function (component, event, helper) {
        debugger;
        var vfBaseURL = component.get("v.vfBaseURL");
        var topic = component.get("v.topic");
        
        var UniqueId = event.getParam("UniqueId");
        document.getElementById('uniqueID').innerHTML=UniqueId;  
        var methodName = event.getParam("methodName");
        var methodParams = event.getParam("methodParams");
        component.invocationCallbacks[UniqueId] = UniqueId;
        var message = {
            invocationId: UniqueId,
            methodName: methodName,
            methodParams: methodParams.toString()
        };
        setTimeout( $A.getCallback(function() {

            	var vf = component.find("vfFrame").getElement().contentWindow;
            try{
               vf.postMessage(message, component.get("v.vfBaseURL")); 
            }catch(e){
                debugger;
            }   
        }), 5000);
    }
    
})