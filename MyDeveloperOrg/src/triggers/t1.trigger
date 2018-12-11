trigger t1 on Account (Before insert) {
  for(account a:Trigger.new){
  if(a.industry=='Education'){
  a.addError('We dont have this record');
  }
  }
}