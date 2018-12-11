public with sharing class FileUploadController {

  public Document document {
    get {
      if (document == null)
        document = new Document();
      return document;
    }
    set;
  }

  public PageReference upload() {

    document.AuthorId = UserInfo.getUserId();
    document.FolderId = UserInfo.getUserId(); 

    try {
      insert document;
    } catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
      return null;
    } finally {
      document.body = null;
      document = new Document();
    }

    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
    return null;
  }

}