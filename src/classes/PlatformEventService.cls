public with sharing class PlatformEventService implements IPlatformEventService {
    public void publish(List<SObject> eventsToPublish) {
        EventBus.publish(eventsToPublish);
    }
}