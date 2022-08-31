public with sharing class PED_PODInfoWrapper {
    private Input inputRequest;
    public Input getDefaultImpl(String POD) {
        inputRequest = new Input();
        inputRequest.podId = POD;
        return inputRequest;
    }

    public class Input {
        @AuraEnabled
        public String podId;
    }

    public class Response {
        @AuraEnabled
        public ResponseMeta meta;
        @AuraEnabled
        public List<ResponseData> data;

        //custom info
        @AuraEnabled
        public Boolean validaData = false; //logiche per intestario
        
    }

    public class ResponseData {
        @AuraEnabled
        public PED_PODWrapper.ResponsePod pods;


    }

    public class ResponseMeta {
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String code;
        @AuraEnabled
        public String message;
    }

}