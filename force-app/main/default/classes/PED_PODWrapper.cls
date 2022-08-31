/**
 * @description       : Wrapper contenente le informazioni del POD derivante dai servizi:
 *                      -Check Anag
 *                      -RetrieveInfoPod
 *                      -AnagTecnica
 * 
 *                      i campi hanno nomi abbreviati per evitare di 
 *                      raggiungere i limiti di dimensioni della cache
 * @author            : DOM
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   14-05-2021   DOM   Initial Version
**/

public class PED_PODWrapper { 

    public class ResponsePod {
        /**custom data - start**/
        @AuraEnabled
        public Boolean is2G = null;
        @AuraEnabled
        public Boolean orario =  null;
        @AuraEnabled
        public Boolean podSubscribed =  null;
        /**custom data - end**/
        /*@AuraEnabled
        public List<ResponsePlantHeader> Plant; //da cancellare
        @AuraEnabled
        public String Pod; //da cancellare*/
        @AuraEnabled
        public PODScambio POD_Scambio;
        @AuraEnabled
        public String IdPod;
        @AuraEnabled
        public String SupplyStatusId;
        @AuraEnabled
        public String TaxCode;
        @AuraEnabled
        public String VatNumber;
        @AuraEnabled
        public String PointOfMeasurePostalCode;
        @AuraEnabled
        public String PointOfMeasureApartmentNumber;
        @AuraEnabled
        public String PointOfMeasureDistrict;
        @AuraEnabled
        public String PointOfMeasureStreetNumber;
        @AuraEnabled
        public String PointOfMeasureFloor;
        @AuraEnabled
        public String PointOfMeasureProvince;
        @AuraEnabled
        public String PointOfMeasureApartmentBlock;
        @AuraEnabled
        public String PointOfMeasureStreet;
        @AuraEnabled
        public String PointOfMeasureIstatCode;
        @AuraEnabled
        public String PointOfMeasureMunicipality;
        @AuraEnabled
        public String PointOfMeasureNation;
        @AuraEnabled
        public String PointOfMeasureStreetPrefix;
        @AuraEnabled
        public String VoltageLevel;
        @AuraEnabled
        public String ContractualPower;
        @AuraEnabled
        public String NominalProductionPower;
        @AuraEnabled
        public String AvailablePower;
        @AuraEnabled
        public String DeductiblePower;
        @AuraEnabled
        public String DeductiblePowerInput;
        @AuraEnabled
        public String PlantCommercialRegimeId;
        @AuraEnabled
        public String IncentivizedPlant;
        @AuraEnabled
        public String MeteringPointType;
        @AuraEnabled
        public String HasPlant;
        @AuraEnabled
        public boolean isPodScambio;
        @AuraEnabled
        public String accountId;
        @AuraEnabled
        public String accountName;
        @AuraEnabled
        public CommercialData PodCommercialData;
        @AuraEnabled
        public TechnicalData PodTechnicalData;
    }

    public class CommercialData {
        @AuraEnabled
        public String EnelTel;
        @AuraEnabled
        public String Voltage;
        @AuraEnabled
        public String FlagInterrupted;
        @AuraEnabled
        public String FlagFraudPredisp;
        @AuraEnabled
        public String FlagSuspendedVerification;
        @AuraEnabled
        public String ProductionEnablementDate;
        @AuraEnabled
        public String HourlyMgmtDate;
        @AuraEnabled
        public String ElectronicMeter;
        @AuraEnabled
        public String PowerMeterSerialNum;
        @AuraEnabled
        public String MeterType;
    }

    public class TechnicalData {
        @AuraEnabled
        public String tenantId;
        @AuraEnabled
        public String podCode;
        @AuraEnabled
        public String dtIniRef;
        @AuraEnabled
        public String dtEndref;
        @AuraEnabled
        public Decimal limitPower;
        @AuraEnabled
        public Decimal powerReductionPercentage; // fattore K
        @AuraEnabled
        public Decimal supplyVoltage;
        @AuraEnabled
        public String supplyStatus;
        @AuraEnabled
        public String insertionDirection;
        @AuraEnabled
        public String withdrawalDirection;
        @AuraEnabled
        public Decimal billingTimeTreatmentType ;
        @AuraEnabled
        public String meterType;
        @AuraEnabled
        public Decimal titularProductionPower;
        @AuraEnabled
        public String productionPlantType;
        @AuraEnabled
        public String zoneName;
        @AuraEnabled
        public Decimal geographicalRangeCode;
        @AuraEnabled
        public String sunshineBandShortDesc;
        @AuraEnabled
        public String toRegimeDate;
        @AuraEnabled
        public String oraCommDate;
        @AuraEnabled
        public Boolean RetrieveInfoOrarieta;
        @AuraEnabled
        public String phase;
        @AuraEnabled
        public String meterCode;
        @AuraEnabled
        public String meterSerialNumber;
        @AuraEnabled
        public String ka;
        @AuraEnabled
        public String kr;
        @AuraEnabled
        public String kp;
        @AuraEnabled
        public String podm1;
    }

    public class PODScambio {
        @AuraEnabled
        public String POD;
        @AuraEnabled
        public String TaxCode;
        @AuraEnabled
        public String VatNumber;
    }

    /*public class ResponsePlantHeader { //da cancellare
        @AuraEnabled
        public ResponsePlant Plant;
    }*/

    /*public class ResponsePlant { //da cancellare
        @AuraEnabled
        public List<ResponseProductionHeader> ProductionPod;
        @AuraEnabled
        public String PlantCodeCENSIMP;
        @AuraEnabled
        public String ProducersTaxCode;
        @AuraEnabled
        public String ProducersVatNumber;
        @AuraEnabled
        public String AgentTaxCode;
        @AuraEnabled
        public String AgentVatNumber;
    }*/

    /*public class ResponseProductionHeader { //da cancellare
        @AuraEnabled
        public ResponseProduction ProductionPod;
    }*/

    /*public class ResponseProduction { //da cancellare
        @AuraEnabled
        public String ProductionPod;
        @AuraEnabled
        public String MeteringPointType;
        @AuraEnabled
        public String VoltageLevel;
        @AuraEnabled
        public String NominalProductionPower;
        @AuraEnabled
        public String DeductiblePowerInput;
    }*/

    public static POD getNewPodWrapper(){
        POD p = new POD();
        p.checkAnag = new CheckAnag();
        p.commerciale = new RetrieveInfoPOD();
        p.tecnica = new AnagraficaTecnica();
        return p;
    }

    public class POD {
        @AuraEnabled
        public RetrieveInfoPOD commerciale {get; set;} 
        @AuraEnabled
        public CheckAnag checkAnag {get; set;} 
        @AuraEnabled
        public AnagraficaTecnica tecnica {get; set;} 
        @AuraEnabled
        public POD m1 {get; set;} 
    }

    /**
     * Dati derivanti dalla Retrieve Info Pod / Dati commerciali
     */
    public class RetrieveInfoPOD {
        @AuraEnabled
        public String pod {get; set;} //Nome POD                    X
        /*@AuraEnabled
        public String prod {get; set;} //POD di produzione (Y/N)    ?  */
        @AuraEnabled
        public String presa {get; set;} //Presa POD                 X
        @AuraEnabled
        public String enelTel {get; set;} //EnelTel POD             X
        @AuraEnabled
        public String dataAtt {get; set;} //Data attivazione POD    x
        @AuraEnabled
        public String stato {get; set;} //Stato Fornitura POD (RIP + CHECK ANAG + TECNICA)  x
        @AuraEnabled
        public String cf {get; set;} //Codice fiscale Intestatario POD (RIP + CHECK ANAG)  X
        @AuraEnabled
        public String vat {get; set;} //Partita Iva Intestatario POD (RIP + CHECK ANAG)     X
        @AuraEnabled
        public String indirizzo {get; set;} //Ubicazione POD - Indirizzo fornitura (RIP + CHECK ANAG) X
        @AuraEnabled
        public String cap {get; set;} //Ubicazione POD - Cap fornitura (RIP + CHECK ANAG) X
        @AuraEnabled
        public String citta {get; set;} //Ubicazione POD - Città fornitura (RIP + CHECK ANAG) X
        @AuraEnabled
        public String prov {get; set;} //Ubicazione POD - Provincia fornitura (RIP + CHECK ANAG)  X
        @AuraEnabled
        public String tens {get; set;} //Tensione POD (RIP + CHECK ANAG + TECNICA) X
        @AuraEnabled
        public String potenza {get; set;} //Potenza POD (RIP + CHECK ANAG)  X
        @AuraEnabled
        public String potenzaDisponibile {get; set;} //Potenza Disponibile POD (RIP + CHECK ANAG)  X
        /*@AuraEnabled
        public String is2G {get; set;} //Tipologia POD 2G (Y/N) (RIP + TECNICA) ?     */
        @AuraEnabled
        public String codMis {get; set;} //Codice Misuratore (RIP + TECNICA)
        @AuraEnabled
        public String matMis {get; set;} //Matricola Misuratore (RIP + TECNICA)
        @AuraEnabled
        public String franchigia {get; set;} //POD DI SCAMBIO (Y/N) (RIP + TECNICA)
        @AuraEnabled
        public String dMessaRegime {get; set;} //Data Messa a Regime (RIP + TECNICA)
        @AuraEnabled
        public String tipoCont {get; set;} //Tipo contatore (RIP + TECNICA)
        @AuraEnabled
        public String misEl {get; set;} //Misuratore Elettronico (RIP + TECNICA)
        @AuraEnabled
        public String unitOp {get; set;} //Unità Operativa (RIP + TECNICA)
    }
    /**
     * Dati derivanti dalla Check Anag
     */
    public class CheckAnag{
        @AuraEnabled
        public String pod {get; set;} //@@DonF
        @AuraEnabled
        public String tipo {get; set;} //Tipologia Fornitura (M1/M2)      
        @AuraEnabled
        public String incentivato {get; set;} //Impianto incentivato (Y/N)
        @AuraEnabled
        public String isParziale {get; set;} //Output Completo/Parziale (Y/N)
        @AuraEnabled
        public String stato {get; set;} //Stato Fornitura POD (RIP + CHECK ANAG + TECNICA) 
        @AuraEnabled
        public String cf {get; set;} //Codice fiscale Intestatario POD (RIP + CHECK ANAG) 
        @AuraEnabled
        public String vat {get; set;} //Partita Iva Intestatario POD (RIP + CHECK ANAG) 
        @AuraEnabled
        public String indirizzo {get; set;} //Ubicazione POD - Indirizzo fornitura (RIP + CHECK ANAG) 
        @AuraEnabled
        public String cap {get; set;} //Ubicazione POD - Cap fornitura (RIP + CHECK ANAG)
        @AuraEnabled
        public String citta {get; set;} //Ubicazione POD - Città fornitura (RIP + CHECK ANAG) 
        @AuraEnabled
        public String prov {get; set;} //Ubicazione POD - Provincia fornitura (RIP + CHECK ANAG)
        @AuraEnabled
        public String tens {get; set;} //Tensione POD (RIP + CHECK ANAG + TECNICA) 
        @AuraEnabled
        public String potenza {get; set;} //Potenza POD (RIP + CHECK ANAG) 
        @AuraEnabled
        public String potenzaDisponibile {get; set;} //Potenza Disponibile POD (RIP + CHECK ANAG) 
        @AuraEnabled
        public String scambio {get; set;} //POD DI SCAMBIO (Y/N) (CHECK ANAG + TECNICA)
        
         /*INFO M1*/ //se pod selezionato è un M2
         @AuraEnabled
         public String podM1 {get; set;} //Nome POD M1
         /*INFO INTESTATARIO POD M1*/ //se pod selezionato è un M2
         @AuraEnabled
         public String cfM1 {get; set;} //Codice Fiscale Intestatario M1
         @AuraEnabled
         public String vatM1 {get; set;} //Partita Iva Intestatario M1

    }

    /**
     * Dati derivanti dall'Anagrafica Tecnica / Dati tecnici
     */
    public class AnagraficaTecnica{
        @AuraEnabled
        public String dMessaRegime {get; set;} //Data Messa a Regime (RIP + TECNICA)
        @AuraEnabled
        public String dOrarieta {get; set;} //Data Orarietà
        @AuraEnabled
        public String fase {get; set;} //Fase
        @AuraEnabled
        public String fatK {get; set;} //Fattore K
        @AuraEnabled
        public String misEl {get; set;} //Misuratore Elettronico (RIP + TECNICA)
        @AuraEnabled
        public String tipoCont {get; set;} //Tipo contatore (RIP + TECNICA)
        @AuraEnabled
        public String codMis {get; set;} //Codice Misuratore (RIP + TECNICA)
        @AuraEnabled
        public String matMis {get; set;} //Matricola Misuratore (RIP + TECNICA)
        @AuraEnabled
        public String unitOp {get; set;} //Unità Operativa (RIP + TECNICA)
        @AuraEnabled
        public String stato {get; set;} //Stato Fornitura POD (RIP + CHECK ANAG + TECNICA)
        @AuraEnabled
        public String tens {get; set;} //Tensione POD (RIP + CHECK ANAG + TECNICA)
        @AuraEnabled
        public String is2G {get; set;} //Tipologia POD 2G (Y/N) (RIP + TECNICA)
        @AuraEnabled
        public String scambio {get; set;} //POD DI SCAMBIO (Y/N) (CHECK ANAG + TECNICA)
        @AuraEnabled
        public String franchigia {get; set;} //POD DI SCAMBIO (Y/N) (RIP + TECNICA)
    }
    

    
}