trigger Trg1 on Account (before insert, before update) {
  
    if(trigger.isBefore && trigger.isInsert){
        Trg1_handler.before_insert(trigger.new);
    }
    if(trigger.isBefore && trigger.isUpdate){
        Trg1_handler.before_update(trigger.new);
    }
}