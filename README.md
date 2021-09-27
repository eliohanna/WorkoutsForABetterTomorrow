# WorkoutsForABetterTomorrow
This project was created to fetch the list of user goals, as well as the user's activity, and showcase them.

## Project Architecture
For this project, MVVM with combine was used. As far as the app architecture is concerned, i will explain it below.

* Services (`CoreDataService`, `NetworkService`)  
In general a Service is a class that communicates with external libraries or systems. For example `CoreDataService` is used to communicate with Core Data.
However, we never directly use the Service from the View. We always use a UseCase.
* UseCase  
A UseCase is where the logic happens and abstracts the service layer. For example when loading goals, the UseCase handles reading from cache and saving to cache.
* ViewModel  
ViewModels interact with the View from one side, and the UseCases from the other side. The ViewModel contains View related logic as well.

## Packages
For this project, I created the `HealthKitHelper` to help manage `HealthKit` tasks.
It has a `HealthKitPermissionManager` responsible for managing the permissions, including requesting permission. 
`HealthKitWorker` is a class that executes a query for a given time period, and a type, and observes any changes, in order to query again.
The results are transformed to fit our needs. The `HealthKitQuery` is a wrapper over Apple's `HKStatisticsQuery`, and is used in `HealthKitWorker`.

## Things to keep in mind:
Some things had to be made in a simple way to accomodate for the timeframe and scope given for this demo. 
Below you can find some of things that can be enhanced for a production vready version.
- [ ] Add more unit tests, (maybe even UI Tests)
- [ ] Use SwiftGen for localization and autogeneration of assets
- [ ] More powerful Services: `NetworkService` and `CoreDataService` are fairly simplistic at the moment
- [ ] Make the project more protocol oriented (can be used with dependency injection)
- [ ] Handling of all `GoalsListState` cases from a UI perspective: loading view, empty state view, error view, request authorization view 
