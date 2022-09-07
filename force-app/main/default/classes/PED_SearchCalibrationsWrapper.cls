public with sharing class PED_SearchCalibrationsWrapper {

    public class Input {
        @AuraEnabled
        public String customer_k;
        @AuraEnabled
        public String customer_l;
        @AuraEnabled
        public String customer_m;
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
        public String code;
        @AuraEnabled
        public String message;
    }

    public class ResponseData { 
        public String reqDatetime; 
        public String respDatetime; 

        @AuraEnabled
        public ResponseSupplyTechInfo supplyTechInfo; 

        //Extended variables

        @AuraEnabled
        public String descriptionArt45; 

        @AuraEnabled
        public String descriptionArt34;

        @AuraEnabled
        public String dichiarazioneAdeguatezza; 

        @AuraEnabled
        public String tipoMessaggio; 

      
        
    }


    public class ResponseSupplyTechInfo { 
        @AuraEnabled
        public Map<String,List<String>> griglieMap;
        @AuraEnabled
        public String extCableNetworks; 
        @AuraEnabled
        public String neutralExercise;
        @AuraEnabled
        public String faultEliminationTime;
        @AuraEnabled
        public String faultCurrentMFT;
        @AuraEnabled
        public String declarationType;
        @AuraEnabled
        public String compensation;
        @AuraEnabled
        public String extInterruptionsReg;
        @AuraEnabled
        public String nominalVoltage;
        @AuraEnabled
        public String minShortCircuitCurrent;
        @AuraEnabled
        public String maxShortPhaseCurrent;
        @AuraEnabled
        public String convShortCircuitCurrent;
        @AuraEnabled
        public String CTS;
        @AuraEnabled
        public String CTSm;
        @AuraEnabled
        public String CTSn;
        @AuraEnabled
        public String totalCTS;
        @AuraEnabled
        public String CTSMDate;
        @AuraEnabled
        public String calibrationsDate;
        @AuraEnabled
        public String calibrationsNumber;
        @AuraEnabled
        public String address;
        @AuraEnabled
        public String email;
        @AuraEnabled
        public List<Responsecalibrations> calibrations;     

       
    }

    public class Responsecalibrations{ 
        @AuraEnabled
        public String calibrationCode;
        @AuraEnabled
        public String calibrationCom;
        @AuraEnabled
        public String calibrationPlant;
        @AuraEnabled
        public String calibrationUm;
       
    }

    
}