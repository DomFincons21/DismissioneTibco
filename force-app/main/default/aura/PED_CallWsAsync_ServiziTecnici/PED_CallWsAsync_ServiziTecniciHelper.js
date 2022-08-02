({
    getUniqueId : function() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    },callEventLightning: function (component, event, helper) {
        var method = document.getElementById('methodName').innerHTML;
            var result = document.getElementById('result').innerHTML;
            var action1 = component.get('c.convertJSONtoObject');
            action1.setParams({stringaJson : result});
            action1.setCallback(this, function (response) {
                debugger;
                var callEvent = $A.get("e.c:PED_CallbackWSAsyncEvent");
                callEvent.setParams({
                    "result" : response.getReturnValue(),
                    "UniqueId" :document.getElementById('uniqueID').innerHTML,
                    "methodName" : method});
                callEvent.fire();
            });
            $A.enqueueAction(action1);       
    },
})