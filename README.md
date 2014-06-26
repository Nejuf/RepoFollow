RepoFollow
==========

Follow any public repository and have commit messages show in your feed.  Additionally, users can pick and choose which branches of a repository to follow.

* MySQL
* MongoDB
* Rails 3.2.13
* Handlebars

The Mongo database is used as a server cache for some of the information loaded from the Github API.  Rather than specifying specific fields to save for the Mongo objects, dynamic fields are used to save whatever Github may happen to include in its resource objects.

Since we don't need to perform complex queries or prioritize data consistency, it is ultimately just a cache, the NoSQL nature of Mongo is a good fit.  However, for User information and complex relationship like following and branching, RDMS is used, specifically MySQL.  The site is anticipated to be read-heavy in that once you start following a repository or branch, you're not likely to be making changes or adding new ones often.  Because it's a feed, the MySQL database will mostly be asked to read.  Normally I use PostgreSQL, but MySQL is slightly faster at read operations, which is the priority for this app.

Fetching activity for large repositories from Github can be a very slow operation.  Thus, the feed page loads without the feed contents and loads them in afterwards.  If the activity is cached in Mongo, it'll be really fast, otherwise it'll have no choice but to query the Github API.  A delayed job could be used to presumptuously grow our cache for popular repositories or the most active users.

The assumption is made that whenever a user follows a repository, that user is following all of the branches of that repository.  This is why an unfollow concept is used with branches, unlike repositories.  Making this assumption saves us a number of queries and potential API requests and automatically subscribes users to newly created branches, even if we don't know about them yet.

