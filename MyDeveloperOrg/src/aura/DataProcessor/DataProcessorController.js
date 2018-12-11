({
 downloadDocument : function(component, event, helper){

     var sendDataProc = component.get("v.sendData");
     var dataToSend = "<table><tbody><tr> This is Test</tr></tbody></table>";
         
         
         
      //this is data you want to send for PDF generation
     
     //invoke vf page js method
     sendDataProc(dataToSend, function(){
         //handle callback
     });
 }
})