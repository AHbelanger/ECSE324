
int main(){
	int a[5] = {1, 21, 3, 4, 5};
	int max_val;
	
	max_val = a[0];
	int length = sizeof(a)/sizeof(int);
	int i;

	for( i = 1; i < length; i++){
	
		if(a[i] > max_val)
			max_val = a[i];

	}

	return max_val; //R4 contains the result
}