({
    gotoURL : function(component, event, helper) {
        var address = component.find("address").get("v.value");
        var ExcId ="a0c3B000000DqE0";
        var ProId ="a003B000001LQoe";
        var Cl1 =$A.get("$Label.c.CL0012");
        var Cl2 =$A.get("$Label.c.CL0010");
        var Cl3 =$A.get("$Label.c.CL0006");
        var Cl4 =$A.get("$Label.c.CL0008");
        var Cl5 =$A.get("$Label.c.CL0011");
        var Cl6 =$A.get("$Label.c.CL0013");
        var Cl7 =$A.get("$Label.c.CL0014");
        var Cl8 =$A.get("$Label.c.CL0104");
        var Cl9 =$A.get("$Label.c.CL0020");

        window.open("/apex/APXTConga4__Conga_Composer"+ 
"?id=" + ExcId + 
"&queryid=[ProgramObject]" + Cl1 + "?pv0=" + ProId + 
",[programChannel]" + Cl2 + "?pv0=" + ProId + 
",[KeyVisual]" + Cl3 + "?pv0=" + ProId + 
",[PinWheel]" + Cl4 + "?pv0=" + ProId + 
",[ProgramContent]" + Cl5 + "?pv0=" + ProId + 
",[ProgramPrimary]" + Cl6 + "?pv0=" +ProId + 
",[ProgramSecondary]" + Cl7 + "?pv0=" + ProId + 
",[Contacts]" + Cl8 + "?pv0=" + ProId + 
"&templateid=" + Cl9 + 
"&ofn=Executive Summary " + "Program__r.Name" + " " + "TEXT(Version_Number__c)" + 
"&QMode=Download" + 
"&DS7=13" +address);
        //helper.gotoURL(component,url);
    },
    /*,
    navigate : function(component, event, helper) {
        helper.navigate(component);
    }*/
    
    gotoURL : function(component, event, helper) {
    document.getElementById("btn").disabled = 'true';
}
    
})