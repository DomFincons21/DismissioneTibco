public with sharing class SupplyDataWrapper {
    public class Input {

        @AuraEnabled
        public String podId;

        public Input(PED_PODInfoWrapper.Response podId){

            this.podId = podId.data[0].pods.IdPod;
        }
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
       
        @AuraEnabled
        public String reqDatetime;

        @AuraEnabled
        public String respDatetime;

        @AuraEnabled
        public List<ResponseSupplyData> supplyData;

    }

    public class ResponseSupplyData {

        @AuraEnabled
        public String AUIUserId;

        @AuraEnabled
        public String customerL;

        @AuraEnabled
        public String customerM;

        @AuraEnabled
        public String customerK;

        @AuraEnabled
        public String nodeCode;

        @AuraEnabled
        public String eneltel;

        @AuraEnabled
        public ResponseCustomerData customerData;

        @AuraEnabled
        public String supplyCity;

        @AuraEnabled
        public String nodeAddress;

        @AuraEnabled
        public String UCode;

        @AuraEnabled
        public String socketId;

        @AuraEnabled
        public String voltageLevel;

        @AuraEnabled
        public String supplyAddress;

        @AuraEnabled
        public String podId;

        @AuraEnabled
        public ResponseSupplyTechInfo supplyTechInfo;
    }

    public class ResponseCustomerData{

        @AuraEnabled
        public String numberOfSupplies;

        @AuraEnabled
        public String businessName;
    }

    public class ResponseSupplyTechInfo{

        @AuraEnabled
        public String calibrationsNumber;
    }
}
