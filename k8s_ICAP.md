# K8s ICAP flow of requests between microservices/pods.

Below diagram shows the flow of request between different pods.
![image](https://user-images.githubusercontent.com/64909674/110074117-ad45ad80-7da6-11eb-9dc4-5385a380c28f.png)


*	ICAP Service receives the request to process file(.pdf)
*	ICAP Service stores the file in to the Original Store (Persistent Volume)
*	rabbitmq-controller message to adaptation-service (Adaptation job) saying the   arrival of the new file
*	adaptation-service create a rebuild pod to fetch the file from Original Store, check with ncfs-reference-ncfs service to understand the type of file is allowed to process and then process it and drop it in to Rebuilt Store.
*	Once the file is processed pod-janitor updates the status to completed
*	event-submission-service updates the transaction event store with the metadata.
*	adaptation-icap-adaptation-event-api updates the number of files processed to transaction event handlers.
*	fluent-bit logging captures the transaction log messages, pod logs and send it to ELK.
*	Policies from management UI are updated to ncfs-ncfs-policy-update-service which in turn updates to ncfs-reference-ncfs.

# Observations:
*	policy-update-service is no more in use and it is replaced by ncfs-ncfs-policy-update-service.
*	pvc-transaction-query-service is no more in use.

# Issues:
*	Current K8s ICAP setup works only on single node cluster but not on multinode Kubernetes cluster.
