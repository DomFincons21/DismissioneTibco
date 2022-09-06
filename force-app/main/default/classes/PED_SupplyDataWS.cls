/**
 * @author Marco Speranza
 * @see PED_ServiziTecnici
 * @deprecated PED_ServiziTecnici_Controller
 * @process Adeguatezza Impianti
 * Creation data 27-08-2022
 */
public with sharing class PED_SupplyDataWS {
   
    @TestVisible
    public static String continuationLabel;

    private static String wsName = 'getSupplyData';
    private static String wsProcessTarature = 'ServiziTecnici-TaratureImpianti';
    private static String wsProcessAdeguatezza = 'ServiziTecnici-AdeguatezzaImpianti';
    private static String wsMethod = 'processGetSupplyData';
    private static Set<String> processiAbilitati = new Set<String>{'Tarature','Adeguatezza'};
    private final static Integer TIMEOUTASYNC = 60;


    @AuraEnabled (continuation=true)
    public static Continuation callGetSupplyData(Boolean fromDelegate, String processo){

        if(!processiAbilitati.contains(processo)) throw new AuraHandledException('processo non configurato');

        Map<String,String> wsInformation = new Map<String,String>();
        PED_PODInfoWrapper.Response  pod = fromDelegate ?  PED_PODInfoUtils.recuperaPodInCacheDelegato(): PED_PODInfoUtils.recuperaPodInCache();

        if(pod == null) throw new AuraHandledException('Nessun pod in cache');

        SupplyDataWrapper.Input input = new SupplyDataWrapper.Input(pod);
        PED_ServiceSettings__c endpoint = [select id, Name, PED_Endpoint__c from PED_ServiceSettings__c where Name = 'ServiziTecnici-getSupplyData' limit 1];

        System.debug(pod);
        System.debug(endpoint);

        HttpRequest request = buildRequest(endpoint,  input, wsInformation);
         // If request = null -> throw exception
         if(request == null) throw new AuraHandledException('errore token');

         wsInformation.put('fromDelegate', String.valueOf(fromDelegate)); 
         wsInformation.put('processo', processo); 


        Continuation cont = new Continuation(TIMEOUTASYNC);
        cont.continuationMethod='processGetSupplyData';
        continuationLabel = cont.addHttpRequest(request);
        cont.state = wsInformation;

        return cont;
    }

    public static httpRequest buildRequest(PED_ServiceSettings__c serviceEndpoint, SupplyDataWrapper.Input input, Map<String,String> wsInformation){
        

        HttpRequest request = new HttpRequest();
        // TOKEN
       GetWSO2Token.respJWT result = GetWSO2Token.retrieveToken('RetrievePEDTokenQA');
    
       System.debug('Result '+result);

       // If token is not inserted -> exit
       if(!Test.isRunningTest()){
            request.setHeader('Authorization', 'Bearer '+result.access_token);
       }else{
            request.setHeader('Authorization', 'Bearer '+'TestToken');
       }
       // TYPE
       request.setMethod('GET');

       // ? MOCK request.setBody('{"meta":{"status":"succeeded","message":"getSupplyData response","code":"0"},"data":{"reqDatetime":"29/08/2022 10:24:27","respDatetime":"29/08/2022 10:24:27","supplyData":[{"AUIUserId":"01","customerL":"0","customerM":"1000","customerK":"111335","nodeCode":"D810-2-520668","eneltel":"915993672","customerData":{"numberOfSupplies":"1","businessName":"COMUNE DI PALERMO AMM. PUB."},"supplyCity":"PALERMO (PA)","nodeAddress":"V,LE DE FANTE CIV N  13=","UCode":"2","socketId":"8264405501080","supplyTechInfo":{"calibrationsNumber":0},"voltageLevel":"M","supplyAddress":"VIALE DEL FANTE SNC","podId":"IT001E00231919"}]}}');
       //request.setBody('');

       serviceEndpoint.PED_Endpoint__c += input.podId;

       request.setEndpoint(serviceEndpoint.PED_Endpoint__c);

       wsInformation.put('request', serviceEndpoint.PED_Endpoint__c); 
       wsInformation.put('endpoint',  String.valueOf(serviceEndpoint)); 
       wsInformation.put('point_of_delivery', input.podId); 
       

        return request;
    }

    @AuraEnabled 
    public static PED_SupplyDataWrapper.Response processGetSupplyData(List<String> labels, Object state){

        httpResponse response;
        map<String,String> myState = (map<String,String>) state;
        PED_SupplyDataWrapper.Response resp;

        System.debug('SupplyDataWrapper.processGetSupplyData -- START>' + labels[0]);
        response = Continuation.getResponse(labels[0]);

          // CREAZIONE DEL PED_Log__c
          PED_DebugLogger logger = PED_DebugLoggerFactory.getDefaultImpl();
        
          System.debug(response.toString());
          System.debug(response.getStatusCode());
          System.debug(response.getStatus());
          System.debug(response.getBody());

          String processo = myState.get('processo').equals('Tarature')?wsProcessTarature:(myState.get('processo').equals('Adeguatezza')?wsProcessAdeguatezza : null);


          myState.put('response',response.getBody());
          myState.put('statusCode',String.valueOf(response.getStatusCode()));

          try{

            if(response.getStatusCode() == 201 || response.getStatusCode() == 200){
                String body = response.getBody();

                resp = (PED_SupplyDataWrapper.Response) JSON.deserialize(response.getBody(),  PED_SupplyDataWrapper.Response.class);

                //Extended wrapper
                resp.data.supplyData[0].year = System.now().AddYears(-1).format('YYYY');

                Map<String,Object> logWrapper= new Map<String,Object>{
                    'input'=> myState.get('request'),
                    'output'=> myState.get('response'),
                    'statusCode'=> Integer.valueOf(myState.get('statusCode')),
                    'result' => PED_DebugLoggerFactory.RESULT_OK,
                    'wsName'=> wsName,
                    'wsProcess'=>processo,
                    'endpoint'=>myState.get('endpoint'),
                    'podName'=> myState.get('point_of_delivery') ,
                    'className'=> 'PED_SupplyDataWS',
                    'methodName'=> wsMethod,
                    'delegato'=> Boolean.valueOf(myState.get('fromDelegate'))
                };
                logger.log(logWrapper);
                logger.flush(); 
                //todo sistemare servizio
            }else if(response.getStatusCode() == 401){ // ? ERROR NOT AUTHORIZED
        
                Map<String,Object> logWrapper= new Map<String,Object>{
                    'input'=> myState.get('request'),
                    'output'=> myState.get('response'),
                    'statusCode'=> Integer.valueOf(myState.get('statusCode')),
                    'result' => PED_DebugLoggerFactory.RESULT_KO,
                    'wsName'=> wsName,
                    'wsProcess'=>processo,
                    'endpoint'=>myState.get('endpoint'),
                    'podName'=> myState.get('point_of_delivery') ,
                    'className'=> 'PED_SupplyDataWS',
                    'methodName'=> wsMethod,
                    'delegato'=> Boolean.valueOf(myState.get('fromDelegate')),
                    'e'=> 'Non authorized user'
                };
                logger.log(logWrapper);
                logger.flush(); 
            }

        } catch(Exception e){
            String stackTrace;
            stackTrace = 'Cause: ' + e.getCause() + '\n'
                + 'Line number: ' + e.getLineNumber() + '\n'
                + 'Message: ' + e.getMessage() + '\n'
                + 'Exception type: ' + e.getTypeName() + '\n'
                + '----- Stack Trace -----\n' +
                e.getStackTraceString();

            Map<String,Object> logWrapper= new Map<String,Object>{
                'input'=> myState.get('request'),
                'output'=> myState.get('response'),
                'statusCode'=> Integer.valueOf(myState.get('statusCode')),
                'result' => PED_DebugLoggerFactory.RESULT_KO,
                'wsName'=> wsName,
                'wsProcess'=>processo,
                'endpoint'=>myState.get('endpoint'),
                'podName'=> myState.get('point_of_delivery') ,
                'className'=> 'PED_SupplyDataWS',
                'methodName'=> wsMethod, 
                'delegato'=> Boolean.valueOf(myState.get('fromDelegate')),
                'e'=> e
            };
            logger.log(logWrapper);
            logger.flush();         
            return null;
        }
        return resp;
    }
    

}
