@isTest
public class PED_ServiziTecnici_Controller_TEST {
	
	@testSetup static void setupData() {
		List<PED_Environment__c> eList = new List<PED_Environment__c>();
		PED_Environment__c e1 = new PED_Environment__c();
    	e1.name='ServiziTecniciTaratureEndpoint';
    	e1.Value__c='test';
    	PED_Environment__c e2 = new PED_Environment__c();
    	e2.name='ServiziTecniciBuchiTensioneEndpoint';
    	e2.Value__c='test';
    	eList.add(e1);
    	eList.add(e2);
    	insert eList;

		PED_Environment__c settings = new PED_Environment__c();
        settings.Name= 'noreplyMailSender';
        settings.value__c = 'noreply@crm.e-distribuzione.com';
        insert settings;   
	}
	
    @isTest static void testArchivioComunicazioni(){
    	test.startTest();
    	Test.setMock(WebServiceMock.class, new PED_ServiziTecnici_WS_Mock());
    	PED_ServiziTecnici_Controller.archivioComunicazioni('testPOD');
    	PED_ServiziTecnici_Controller.getUser();
    	test.stopTest();
    }
    
/*     @isTest static void testBuchiTensione(){
    	test.startTest();
    	Test.setMock(WebServiceMock.class, new PED_ServiziTecnici_WS_Mock());
    	PED_ServiziTecnici_Controller.buchiTension('testPOD','testDataInzio','testDataFine');
    	test.stopTest();
    }
     */
    @isTest static void testQualitaServizio(){
    	test.startTest();
    	Test.setMock(WebServiceMock.class, new PED_ServiziTecnici_WS_Mock());
    	PED_ServiziTecnici_Controller.qualitaServizio('testPOD');
    	test.stopTest();
    }
    
    @isTest static void testGetProtocollo(){
    	test.startTest();
    	Test.setMock(WebServiceMock.class, new PED_ServiziTecnici_WS_Mock());
    	PED_ServiziTecnici_Controller.GetProtocollo('testPOD');
    	test.stopTest();
    }
    
    @isTest static void testGetAdeguatezzaImpianti(){
    	test.startTest();
    	Test.setMock(WebServiceMock.class, new PED_ServiziTecnici_WS_Mock());
    	PED_ServiziTecnici_Controller.getAdeguatezzaImpianti('testPOD');
    	test.stopTest();
    }
    
    @isTest static void testGetImpiantoFornitura(){
    	test.startTest();
    	Test.setMock(WebServiceMock.class, new PED_ServiziTecnici_WS_Mock());
    	PED_ServiziTecnici_Controller.getImpiantoFornitura('testPOD');
    	test.stopTest();
    }
    
    @isTest static void testscriviImpiantoFornitura(){
    	Map<String,String> impiantoFornituraMap = new Map<String,String>();
    	impiantoFornituraMap.put('SvilReteAerea','1');
		impiantoFornituraMap.put('SvilReteCavo','2');
		impiantoFornituraMap.put('LunCavoColl','3');
		impiantoFornituraMap.put('SezCavoColl','4');
		impiantoFornituraMap.put('PotTrasfEnerg','5');
		impiantoFornituraMap.put('PotTrasfParall','6');
		impiantoFornituraMap.put('SezioneCliente','7');
		impiantoFornituraMap.put('DispGen','8');
		impiantoFornituraMap.put('ProtGen','9');
		impiantoFornituraMap.put('SezioneProdutt','10');
		impiantoFornituraMap.put('DispInterf','11');
		impiantoFornituraMap.put('ProtInterf','12');
		impiantoFornituraMap.put('DtAggiornam','13');
		impiantoFornituraMap.put('pod','14');
    	test.startTest();
    	Test.setMock(WebServiceMock.class, new PED_ServiziTecnici_WS_Mock());
    	PED_ServiziTecnici_Controller.scriviImpiantoFornitura(impiantoFornituraMap);
    	test.stopTest();
    }
    
    @isTest static void testGetImpiantoETarature(){
    	test.startTest();
    	Test.setMock(WebServiceMock.class, new PED_ServiziTecnici_WS_Mock());
    	PED_ServiziTecnici_Controller.getImpiantoETarature('testPOD');
    	test.stopTest();
    }
    
    @isTest static void testGetTaratureFornitura(){
    	test.startTest();
    	Test.setMock(WebServiceMock.class, new PED_ServiziTecnici_WS_Mock());
    	PED_ServiziTecnici_Controller.getTaratureFornitura('testPOD');
    	test.stopTest();
    }
    
    @isTest static void testinviaEmail(){
    	test.startTest();
    	Document document = new Document();
		document.Body = Blob.valueOf('Some Text');
		document.ContentType = 'application/pdf';
		document.DeveloperName = 'Enel_Distribution_Group_Logo_Primary_RGB_jpg';
		document.IsPublic = true;
		document.Name = 'My Document';
		document.FolderId = userinfo.getuserId();
		insert document;
    	
    	Test.setMock(WebServiceMock.class, new PED_ServiziTecnici_WS_Mock());
    	PED_ServiziTecnici_Controller.inviaEmail('nomeServizio', 'nomeFile', 'tipoAllegato', 'allegato','custombody');
    	test.stopTest();
    }
}