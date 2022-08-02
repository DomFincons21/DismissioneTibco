public with sharing class PED_BuchiDiTensioneWrapper {
   
    public class Input {

    }

    public class Response {
        @AuraEnabled
        public ResponseMeta meta;
        @AuraEnabled
        public ResponseData data;

    }

    public class ResponseMeta {
        @AuraEnabled
        public String status;
        @AuraEnabled
        public Integer code;
        @AuraEnabled
        public String message;
    }

    public class ResponseData { 
       
    }
}
