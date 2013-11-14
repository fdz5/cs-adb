#include <stdio.h>
#include <sqlite3.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include <sys/resource.h>

//gcc t2.c -o t2 -lsqlite3

const int ROW_NUM = 1000000;

struct rusage mem;

int main() {
	printf("Lab 02 - Task 2\n");
	clock_t c1,c2;
	char sql[1024];
	int i;

	// connecting to db
	printf("Connecting to database");
	int rc;
	sqlite3 *db;
	// memory db
	char loc[] = ":memory:";
	// file db
	// char loc[] = "test.db";

	rc=sqlite3_open(loc,&db);
  	if (rc) {
		fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
		return EXIT_FAILURE;
  	}

	// inserting
	printf("Inserting\n");
	c1=clock();
	sqlite3_exec(db, "BEGIN TRANSACTION", NULL, NULL, NULL);
	sqlite3_exec(db, "create table row(id integer primary key, name varchar(18), desc varchar(80))", NULL, NULL, NULL); 
	for(i=0; i<ROW_NUM; i++) {
		sprintf(sql, "insert into row values('%d', 'name', 'description')", i);
		sqlite3_exec(db, sql, NULL, NULL, NULL);
	}
	sqlite3_exec(db, "COMMIT TRANSACTION", NULL, NULL, NULL);
	c2=clock();

	printf("Time, c2-c1[s]: %f\n", ((float)c2-(float)c1)/CLOCKS_PER_SEC);

	// searching
	printf("Searching\n");
	c1=clock();
	sqlite3_exec(db, "select * from values where id='999999'", NULL, NULL, NULL); 
	c2=clock();
	printf("Time, c2-c1[s]: %f\n", ((float)c2 - (float)c1) / CLOCKS_PER_SEC);

	// checking memory usage
	getrusage(RUSAGE_SELF,&mem);
	printf("ROW_NUM mem usage[kB]: %ld\n", mem.ru_ROW_NUMrss);
	
	// close db connection
	sqlite3_close(db);
}
