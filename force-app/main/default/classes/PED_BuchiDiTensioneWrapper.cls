// Created by Marco Speranza 2-8-2022
public with sharing class PED_BuchiDiTensioneWrapper {
   
    public class Input {

        @AuraEnabled
        public String start_date;
        @AuraEnabled
        public String end_date;
        @AuraEnabled
        public String podId;

        public Input(String start_date, String end_date, String podId){

            this.start_date = start_date;
            this.end_date = end_date;
            this.podId = podId;
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
        public List<ResponseBuchiSemisbarra> voltageDips;

        @AuraEnabled
        public Map<String,Integer> sintesi;

        @AuraEnabled
        public Map<String,Integer> sintesiAT;
    }

    public class ResponseBuchiSemisbarra{

        @AuraEnabled
        public String duration;

        @AuraEnabled
        public String RSCode;

        @AuraEnabled
        public String STCode;

        @AuraEnabled
        public String TRCode;

        @AuraEnabled
        public String halfBarId;

        @AuraEnabled
        public String residualVoltage;

        @AuraEnabled
        public String origin;

        @AuraEnabled
        public String category;

        @AuraEnabled
        public String event;

        @AuraEnabled
        public String instant;

    }
}