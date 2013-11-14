#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include <sys/resource.h>

const int ROW_NUM = 1000000;

/* definition of the structure */
typedef struct {
	int id;
	char name[20];
	char desc[90];
} Row;

struct rusage mem;

/* allocate memory for one row */
Row * allocate_row(int idx) {
	Row *r = malloc(sizeof(Row));
	if (!r) {
		fprintf(stderr, "Memory allocate error\n");
		return EXIT_FAILURE;
	}
	r->id = idx;
	strcpy(r->name, "name");
	strcpy(r->desc, "desc");
	return r;
}

/* allocate memory for ROW_NUM number of rows */
void allocate_rows(Row **rows) {
	int i;
	for(i=0; i<ROW_NUM; i++) {
		rows[i] = allocate_row(i);
	}
}

/* free the memory allocated by row */
void free_row(Row *r) {
	free(r);
}

/* search for the row with id = 999999 */
void find_row(Row **rows) {
	int i;
	int x = ROW_NUM - 1;
	for (i=0; i<ROW_NUM; i++) {
		if(rows[i]->id == x) {
			printf("Found!\n");
			break;
		}
	}
}

int main() {
	printf("Lab 01 - Task 1\n");
	clock_t c1,c2;
	
	printf("Allocating\n");
	
	c1=clock();
	Row **rows = malloc(ROW_NUM * sizeof(Row*));
	allocate_rows(rows);
	c2=clock();

	printf("Time, c2-c1[s]: %f\n", ((float)c2 - (float)c1) / CLOCKS_PER_SEC);

	printf("Finding\n");
	
	c1=clock();
	find_row(rows);
	c2=clock();

	printf("Time, c2-c1[s]: %f\n", ((float)c2 - (float)c1) / CLOCKS_PER_SEC);

	getrusage(RUSAGE_SELF,&mem);
	printf("Max mem usage[kB]: %ld\n", mem.ru_maxrss);

	return EXIT_SUCCESS;
}