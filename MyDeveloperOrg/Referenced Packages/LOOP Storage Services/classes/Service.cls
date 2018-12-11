/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Service {
    global String SessionId {
        get;
        set;
    }
    global Service() {

    }
    global Service(String sessionId) {

    }
    global String FetchDownloadUrl(Id recordId) {
        return null;
    }
    global String QueueDocumentTransfer(List<Id> recordIds, Id relatedObjectId, Id parentFolderId) {
        return null;
    }
    global String QueueRelatedDocumentTransfer(Id oldRelatedObjectId, Id newRelatedObjectId) {
        return null;
    }
    webService static Boolean checkUserHasAccess(Id recordId) {
        return null;
    }
global class ServiceException extends Exception {
}
}
