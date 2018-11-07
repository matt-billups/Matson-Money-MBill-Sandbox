public interface IMassEmailEventRegistrantsService {
	Id sendEmails(MassEmailRequest massEmailRequest, Integer batchSize);
}