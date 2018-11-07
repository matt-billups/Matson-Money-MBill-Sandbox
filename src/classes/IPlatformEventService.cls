public interface IPlatformEventService {
    void publish(List<SObject> eventsToPublish);
}