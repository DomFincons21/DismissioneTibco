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
    private final static Integer TIMEOUTASYNC = 60;


    @AuraEnabled (continuation=true)
    public static Continuation callGetSupplyData(String processo){

        if(processo != 'Tarature' && processo != 'Adeguatezza') throw new AuraHandledException('processo non configurato');

        Map<String,String> wsInformation = new Map<String,String>();
        SupplyDataWrapper.Input input = new SupplyDataWrapper.Input(pod);

        System.debug(pod);

        PED_ServiceSettings__c endpoint = [select id, Name, PED_Endpoint__c from PED_ServiceSettings__c where Name = 'ServizioAdeguatezzaImpianti' limit 1];
        endpoint.PED_Endpoint__c += pod;

        HttpRequest request = buildRequest(endpoint.PED_Endpoint__c, input);
         // If request = null -> throw exception
         if(request == null) throw new AuraHandledException('errore token');


        wsInformation.put('request', endpoint.PED_Endpoint__c); 
        wsInformation.put('endpoint',  String.valueOf(endpoint)); 
        wsInformation.put('point_of_delivery', pod); 
        wsInformation.put('fromDelegate', String.valueOf(fromDelegate)); 
        

        Continuation cont = new Continuation(TIMEOUTASYNC);
        cont.continuationMethod='processGetSupplyData';

         // Store the reference to the HttRequest and make it accessible for a test-context
         continuationLabel = cont.addHttpRequest(request);
         cont.state = wsInformation;

        return cont;
    }

    public static httpRequest buildRequest(String endpoint, SupplyDataWrapper.Input input){
        

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

       request.setEndpoint(endpoint);

        return request;
    }

    @AuraEnabled 
    public static PED_SupplyDataWrapper.Response processGetSupplyData(List<String> labels, Object state){

        httpResponse response;
        map<String,String> myState = (map<String,String>) state;
        PED_SupplyDataWrapper.Response resp;

        System.debug('PED_SupplyDataWrapper.processGetSupplyData -- START>' + labels[0]);
        response = Continuation.getResponse(labels[0]);

          // CREAZIONE DEL PED_Log__c
          PED_DebugLogger logger = PED_DebugLoggerFactory.getDefaultImpl();
        
          System.debug(response.toString());
          System.debug(response.getStatusCode());
          System.debug(response.getStatus());
          System.debug(response.getBody());

          myState.put('response',response.getBody());
          myState.put('statusCode',String.valueOf(response.getStatusCode()));

          try{

            if(response.getStatusCode() == 201 || response.getStatusCode() == 200){
                String body = response.getBody();

                resp = (SupplyDataWrapper.Response) JSON.deserialize(response.getBody(), SupplyDataWrapper.Response.class);

                PED_ServiziTecnici_TaratureData.cl cliente = PED_ServiziTecnici_Controller.getCliente(myState.get('point_of_delivery'));
                system.debug(cliente);

                Map<String,Object> logWrapper= new Map<String,Object>{
                    'input'=> myState.get('request'),
                    'output'=> myState.get('response'),
                    'statusCode'=> Integer.valueOf(myState.get('statusCode')),
                    'result' => PED_DebugLoggerFactory.RESULT_OK,
                    'wsName'=> wsName,
                    'wsProcess'=>wsProcessAdeguatezza,
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
                    'wsProcess'=>wsProcessAdeguatezza,
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
                'wsProcess'=>wsProcessAdeguatezza,
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

    @AuraEnabled 
    public static PED_PODInfoWrapper.Response getDetails(String url){
        System.debug(url);
        if(!url.containsIgnoreCase('delegato'))
             return PED_PODInfoUtils.recuperaPodInCache();

        return PED_PODInfoUtils.recuperaPodInCacheDelegato();
    }

    @AuraEnabled
    public static PED_ServiziTecnici_TaratureData.cl getCliente(String pod){
       return PED_ServiziTecnici_Controller.getCliente(pod);
    }

    @AuraEnabled
    public static string inviaEmail(string nomeServizio, String nomeFile, string tipoAllegato, String allegato, string customBody){
        return PED_ServiziTecnici_Controller.inviaEmail(nomeServizio, nomeFile, tipoAllegato, allegato, customBody);
    }

    @AuraEnabled
    public static user getUser(){
        User u = [select id, firstname, lastname, name from user where id=:userinfo.getUserId()];
        return u;
    }
    


}
