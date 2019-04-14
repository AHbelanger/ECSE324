extern int MAX_2(int x, int y);

int main(){
	int a[5] = {1, 48, 3, 4, 5};
	int max_val = a[0];
	int length = sizeof(a)/sizeof(int);
	int temp;
	int i;

	for( i = 0; i < length; i++){
		max_val = MAX_2(a[i], max_val);
	}

	return max_val; //R4 contains the result
}