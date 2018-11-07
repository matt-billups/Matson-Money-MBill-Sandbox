trigger PrintTableTentEventsTrigger on Print_Table_Tent__e (after insert) {
    ApplicationDomain.triggerHandler(PrintTableTentEvents.class);
}