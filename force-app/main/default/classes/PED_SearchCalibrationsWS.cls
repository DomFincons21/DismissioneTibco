public without sharing class PED_SearchCalibrationsWS {
    @TestVisible
    private static String continuationLabel;
    // Test variable used for holding the value of the Continuation.state attribute
    @TestVisible
    private static Map<String, String> continuationState;
    private static String wsName    = 'searchCalibrations';
    private static String wsProcessTarature = 'ServiziTecnici-TaratureImpianti';
    private static String wsProcessAdeguatezza = 'ServiziTecnici-AdeguatezzaImpianti';
    private static Set<String> processiAbilitati = new Set<String>{'Tarature','Adeguatezza'};
    
    @AuraEnabled(continuation=true)
    public static Continuation callSearchCalibrations(PED_SearchCalibrationsWrapper.Input input, String processo){
        if(!processiAbilitati.contains(processo)) throw new AuraHandledException('processo non configurato');
        PED_ServiceSettings__c serSet = PED_ServiceSettings__c.getValues('ServiziTecnici-SearchCalibrations'); 

        Map<String,String> wsInformation = new Map<String,String>();
        wsInformation.put('processo', processo);
        Continuation cont = new Continuation((integer)serSet.PED_TimeoutAsync__c);
        
            
        HttpRequest request = buildRequest(serSet, wsInformation, input);
        if(request == null) throw new AuraHandledException('errore token');
        continuationLabel = cont.addHttpRequest(request);
        continuationState = wsInformation;
        cont.state = wsInformation;
        cont.continuationMethod='processSearchCalibrations';
        
        System.debug('@@@@callSearchCalibrations cont >>>>>'+cont);
        return cont;      
    }

    @AuraEnabled 
    public static PED_SearchCalibrationsWrapper.Response processSearchCalibrations(List<String> labels, Object state){
        httpResponse response;
        map<String,String> myState = (map<String,String>) state;
        String processo = myState.get('processo').equals('Tarature')?wsProcessTarature:(myState.get('processo').equals('Adeguatezza')?wsProcessAdeguatezza : null);
        try{
            System.debug('PED_SearchCalibrationsWS.processSearchCalibrations -- START>' +labels[0]);
            
            response = Continuation.getResponse(labels[0]);
            myState.put('response',response.getBody());
            myState.put('statusCode',String.valueOf(response.getStatusCode()));
            System.debug('PED_SearchCalibrationsWS.processSearchCalibrations --> ' + response.getBody());
            PED_DebugLogger logger = PED_DebugLoggerFactory.getDefaultImpl();
            System.debug('PED_SearchCalibrationsWS.processSearchCalibrations>'+response.getStatusCode());
            
            if((response.getStatusCode() == 200) && !String.isBlank(response.getBody())){
                Map<String,Object> logWrapper= new Map<String,Object>{
                    'input'=> myState.get('request'),
                    'output'=> myState.get('response'),
                    'statusCode'=> Integer.valueOf(myState.get('statusCode')),
                    'result' => PED_DebugLoggerFactory.RESULT_OK,
                    'wsName'=> wsName,
                    'wsProcess'=>processo,
                    'endpoint'=>myState.get('endpoint'),
                    'podName'=> myState.get('podName') ,
                    'className'=> 'PED_SearchCalibrationsWS',
                    'methodName'=> 'processSearchCalibrations'
                };
                System.debug(logWrapper);
                logger.log(logWrapper);
            }  else {
                Map<String,Object> logWrapper= new Map<String,Object>{
                    'input'=> myState.get('request'),
                    'output'=> myState.get('response'),
                    'statusCode'=> Integer.valueOf(myState.get('statusCode')),
                    'result' => PED_DebugLoggerFactory.RESULT_KO,
                    'wsName'=> wsName,
                    'wsProcess'=>processo,
                    'endpoint'=>myState.get('endpoint'),
                    'podName'=> myState.get('podName') ,
                    'className'=> 'PED_SearchCalibrationsWS',
                    'methodName'=> 'processSearchCalibrations'
                };
                System.debug(logWrapper);
                logger.log(logWrapper);
            }
            
            String body = response.getBody();


            PED_SearchCalibrationsWrapper.Response resp = (PED_SearchCalibrationsWrapper.Response)JSON.deserialize(body, PED_SearchCalibrationsWrapper.Response.class);
            System.debug('resp-->'+resp);
            
            logger.flush(); 
            return resp;
        } catch(Exception e){
            String stackTrace;
			stackTrace = 'Cause: ' + e.getCause() + '\n'
							+ 'Line number: ' + e.getLineNumber() + '\n'
							+ 'Message: ' + e.getMessage() + '\n'
							+ 'Exception type: ' + e.getTypeName() + '\n'
							+ '----- Stack Trace -----\n' +
							e.getStackTraceString();
            System.debug('stackTrace-->'+stackTrace);

            PED_DebugLogger logger = PED_DebugLoggerFactory.getFutureImpl();
            Map<String,Object> logWrapper= new Map<String,Object>{
                'input'=> myState.get('request'),
                'output'=> myState.get('response'),
                'statusCode'=> Integer.valueOf(myState.get('statusCode')),
                'wsName'=> wsName,
                'wsProcess'=>processo,
                'endpoint'=>myState.get('endpoint'),
                'podName'=> myState.get('podName') ,
                'className'=> 'PED_SearchCalibrationsWS',
                'methodName'=> 'processSearchCalibrations',
                'e' => e
            };
            System.debug(logWrapper);
            logger.log(logWrapper);
            logger.flush();         
            return null;
        }
    }


    public static httpRequest buildRequest(PED_ServiceSettings__c serSet, Map<String,String> wsInformation, PED_SearchCalibrationsWrapper.Input input){
        HttpRequest request = new HttpRequest();
        String body;

        GetWSO2Token.respJWT result = GetWSO2Token.retrieveToken('RetrievePEDToken');
        System.debug('result->'+result);
        String myToken;
        if(result != null){
            myToken = result.access_token;
        } else return null;
        request.setHeader('Authorization', 'Bearer '+myToken);

        request.setMethod('GET');
        request.setHeader('x-plt-session-id', UserInfo.getSessionId().subString(15));
        request.setHeader('x-plt-user-id', UserInfo.getUserId());
        request.setHeader('x-plt-solution-user', 'PED'+UserInfo.getOrganizationId());
        System.debug('input-->'+input);
        body = Json.serialize(input,true);
        request.setBody(body);
        String endpoint = serSet.PED_Endpoint__c + '?customer_k='+input.customer_k+'&customer_l='+input.customer_l+'&customer_m='+input.customer_m;
        request.setEndpoint(endpoint);
        wsInformation.put('endpoint', endpoint);
        wsInformation.put('request', endpoint);
 
        System.debug('@@@@request'+ request);
        return request;
    }


}