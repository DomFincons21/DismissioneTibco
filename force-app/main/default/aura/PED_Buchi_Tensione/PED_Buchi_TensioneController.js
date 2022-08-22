({

    setPageSize: function (component, event, helper) {
        var newPgSize = component.find("Pgntn").get("v.value");
        component.set("v.pageSize", newPgSize);
        var records = component.get("v.PODList");
        // helper.initializePagination(component, event, records);
    },

    selectSemibarra: function (component, event, helper) {
        var valueselect = component.find("semibarraSelect").get("v.value");
        if (valueselect === 'void') {
            component.set('v.ActualSemibarreList', component.get('v.allSemibarraList'));
            component.set('v.ActualSemisbarra', '');
            helper.initializePagination(component, null, component.get('v.ActualSemibarreList'));
        } else {
            var obj = component.get('v.ObjSemibarreList');
            for (var i = 0; i < obj.length; i++) {
                if (obj[i].semibarraitem === valueselect) {
                    component.set('v.ActualSemibarreList', obj[i].listItem);
                    component.set('v.ActualSemisbarra', obj[i].semibarraitem);
                    helper.initializePagination(component, null, obj[i].listItem);
                    break;
                }
            }
        }
    },

    goBack: function (component, event, helper) {
        helper.goBack(component, event);
    },

    doInit: function (component, event, helper) {


        if (((window.location.href.split("/s/")[0]).includes("livepreview"))) {
            component.set("v.spinner", false);

        } else {
            console.log('En el doInit');
            let action = component.get("c.getDetails");
            action.setParams(
                { "url": window.location.href }
            );

            component.set('v.fromDelegate', window.location.href.includes("delegato"));

            // Inizializa la data DAL to AL
            var today = new Date();
            var mm = 1;
            var dd = 1;
            var yy = today.getFullYear();

            if (today.getMonth() + 1 < 5) {
                yy = yy - 2;
            } else {
                yy = yy - 1;
            }
            var mmfinal = 12;
            var ddfinal = 31;
            var mydateinitial = mm + '/' + dd + '/' + yy;
            var mydatefinal = mmfinal + '/' + ddfinal + '/' + yy;
            var myDate1 = new Date(mydateinitial);
            var dayOfMonth = new Date(mydatefinal);

            component.set('v.startDate', (myDate1.getFullYear()) + "-" + (myDate1.getMonth() + 1) + "-" + myDate1.getDate());
            component.set('v.endDate', (dayOfMonth.getFullYear()) + "-" + (dayOfMonth.getMonth() + 1) + "-" + dayOfMonth.getDate());

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var returnedValue = response.getReturnValue();
                    component.set("v.spinner", true);
                    component.set('v.selectedPod', returnedValue.data[0].pods.IdPod);
                    helper.callBuchiDiTensione(component, event, helper);
                }
            });
            $A.enqueueAction(action);
        }
    },

    ValidateSdate: function (component, event, helper) {
        helper.ValidateSdate(component, event);

    },

    nullifySDate: function (component, event, helper) {
        var dp = component.find('startdateField');
        dp.set('v.value', '');
    },


    ValidateEdate: function (component, event, helper) {
        helper.ValidateEdate(component, event);

    },

    nullifyEDate: function (component, event, helper) {
        var dp = component.find('enddateField');
        dp.set('v.value', '');
    },

    FilterButtonClick: function (component, event, helper) {

        if (component.get('v.sDateErrorNotExist') == true && component.get('v.eDateErrorNotExist') == true) {


            window.scroll(0, 0);
            component.set("v.spinner", true);
            helper.callBuchiDiTensione(component, event, helper);

        } else {
            window.scroll(0, 0);
        }
    },

    sortSemibarra: function (component, event, helper) {
        helper.sortBy(component, "semisbarra");
    },
    sortevento: function (component, event, helper) {
        helper.sortBy(component, "evento");
    },
    sortrs: function (component, event, helper) {
        helper.sortBy(component, "rs");
    },
    sortst: function (component, event, helper) {
        helper.sortBy(component, "st");
    },
    sorttr: function (component, event, helper) {
        helper.sortBy(component, "tr");
    },
    sortistante: function (component, event, helper) {
        helper.sortBy(component, "dataSort");
    },
    sortdurata: function (component, event, helper) {
        helper.sortBy(component, "durata");
    },
    sorttensioneResidua: function (component, event, helper) {
        helper.sortBy(component, "tensioneResidua");
    },
    sortorigin: function (component, event, helper) {
        helper.sortBy(component, "origine");
    },
    ExportPDFSintesi: function (component, event, helper) {
        //var spinner = component.find("mySpinner");
        //$A.util.toggleClass(spinner, "slds-hide");
        component.set('v.callPDF', 'sintesi');
        helper.getDatiUtenteCaratteristiche(component, event);


    },
    ExportPDFSintesiAT: function (component, event, helper) {
        //var spinner = component.find("mySpinner");
        //$A.util.toggleClass(spinner, "slds-hide");
        component.set('v.callPDF', 'sintesi');
        component.set('v.callPDF', 'sintesiAT');
        helper.getDatiUtenteCaratteristiche(component, event);

    },


    DownloadCSVBuchi: function (component, event, helper) {
        // var spinner = component.find("mySpinner");
        // $A.util.toggleClass(spinner, "slds-hide");
        var lista = component.get("v.ActualSemibarreList");
        // ! ASK TO-DO CHANGE IN ENGLISH
        var header = ['Semibarra', 'N.Evento', 'RS', 'ST', 'TR', 'Istante [DD/MM/YYYY HH:MM:SS.CC]', 'Durata [HH:MM:SS.CC]', 'Tensione Residua [%]', 'Origine'];
        var keyArray = ['semisbarra', 'event', 'RSCode', 'STCode', 'TRCode', 'instant', 'duration', 'residualVoltage', 'origin'];
        var csv = helper.convertArrayOfObjectsToCSV(component, lista, header, keyArray);

        var endDateField = component.find("enddateField");
        var endDateValue = endDateField.get("v.value");
        var endDateSplit = endDateValue.split('-');
        var selectedEndDate = new Date(endDateSplit[0], endDateSplit[1] - 1, endDateSplit[2]);
        var enddate = selectedEndDate.getDate() + '-' + (selectedEndDate.getMonth() + 1) + '-' + selectedEndDate.getFullYear();
        var startDateField = component.find("startdateField");
        var startDateValue = startDateField.get("v.value");
        var startDateSplit = startDateValue.split('-');
        var selectedStartDate = new Date(startDateSplit[0], startDateSplit[1] - 1, startDateSplit[2]);
        var selectedPod = component.get('v.selectedPod');
        var startdate = selectedStartDate.getDate() + '-' + (selectedStartDate.getMonth() + 1) + '-' + selectedStartDate.getFullYear();
        var myblob = new Blob([csv]);
        var filename = 'BuchiDiTensione' + '_' + selectedPod + '_' + startdate + '_' + enddate;
        var extension = 'csv';
        helper.downloadFile(component, myblob, filename, extension, event);

    },
    sendMailsintesiAt: function (component, event, helper) {
        //var spinner = component.find("mySpinner");
        //$A.util.toggleClass(spinner, "slds-hide");
        component.set('v.callPDF', 'sintesiAT');
        helper.getDatiUtenteCaratteristiche(component, event, true);

    },
    sendMailSintesi: function (component, event, helper) {
        //var spinner = component.find("mySpinner");
        // $A.util.toggleClass(spinner, "slds-hide");
        component.set('v.callPDF', 'sintesi');
        helper.getDatiUtenteCaratteristiche(component, event, true);

    }

})