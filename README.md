# README

Fetch the list of top N movies from the IMDb website and build an DB knowledge base comprising of
the names of the movies
the names of the cast of each movie
This should be built at runtime and stored in a suitable data structure of your choice.
Provide a query interface (command line would do) to query this knowledge base by actor’s name. For a given actor and a number M (< N), it should return the top M movies they have acted in.


curl -X GET http://localhost:3000/print_top_movies/5  
curl -X GET http://localhost:3000/fetch_movies_by_actor/Morgan%20Freeman/2
