trigger opt_trigger on Opportunity (before insert) {
          Trigger_class.check_opt(Trigger.new);

}