

### Dinosaur housing application for Prize Picks code evaluation

### About
Currently this application is designed to run synchronously and is not designed to be thread safe. 
However, since areas where this could potentially be an issue, such as max_capacity enforcement
are checked at the model layer prior to allowing new record creation, I do not see any potential race conditions
that would cause data inconsistencies in the event the app were re-designed to insert data in a concurrent work flow.

However, given there is a query based check at new dinosaur record insertion time to determine if 
the state of the cage, the diet of the dinosaurs and the cage capacity, if this were an insert heavy
application, that logic could be handled via background workers to improve API responsiveness during new
record insertions.  

However, this would require re-designing the API to a background worker/job model which could
pass a job_id back to the API consumer to check for a job_status of their newly created record(s).  The necessity
of such a workflow in this simple application is unnecessary, however if this were something more complex and
process heavy, this added complexity would be necessary to prevent blocking calls to the back end which
could result in dead locking processes during heavy use of a given endpoint.

### === Bootstrapping ===
    1. install gems - $ bundle install
    2. run specs - $ rspec
    3. bootstrap data - $ rake db:seed
    4. run application - $ bundle exec rails s

### === API Usage ===
 
#### Dinosaurs

        a. get#/dinosaurs.json - returns all dinosaur records
        b. get#/dinosaur/:id.json - returns a specific dinosaur by the primary key
        c. delete#/dinosaur/:id.json - deletes a dinosaur record by the primary key
        d. put#/update/:id.json - updates a dinosaur record by primary key, passing in the updated record payload (Note dinosaurs can only be placed in cages with other dinosaurs with the same diet)
        e. post#add_to_available_cage - adds a dinosaur to a given cage.  If the cage is at max capacity, a new cage is created and the dinosaur is placed in the newly created cage.

#### Cages
    
        a. get#/cages.json - returns all cage records
        b. get#/cage/:id.json - returns a specific cage by the primary key
        c. delete#/cage/:id.json - deletes a cage record by the primary key (note: the dinosaur cage must be empty prior to deletion)
        d. update#/update/:id.json - updates a cage record by primary key, passing in the updated record payload

#### Species

        a. get#/speciess.json - returns all species records
        b. get#/species/:id.json - returns a specific species by the primary key
        c. delete#/species/:id.json - deletes a species record by the primary key
        d. update#/update/:id.json - updates a species record by primary key, passing in the updated record payload


### === Improvements  ===
    
    1. Exceptions are thrown under certain conditions, but errors are not handled gracefully with a nice error passed back to the user.
    2. The endpoints do not currently support filtering based on user supplied criteria
    3. There is no support for pagination.  If the "all" methods are hit, the full data set is returned for a given table.
    4. There are some basic checks around data consistency such as disallowing the deletion of cages if the cage has associated dinosaurs.  
       However, if this were a production application there are plenty of other checks that should be in place such as doing the same check for species via DB level constraints or at a minimum model level checks.
