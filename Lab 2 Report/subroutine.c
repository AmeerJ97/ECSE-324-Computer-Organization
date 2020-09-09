		extern int MAX_2(int x, int y);

		int main(){
			int a[5] = {1,20,3,4,5};
			int c = 0;
			int i = 0;	
			int temp = 0;
				
			for (i = 0; i < 4; i++){
			temp = MAX_2(a[i] , a[i+1]);
				if (c <= temp) {
					c = temp;
					}
			}
			printf("%d",c);
			return c;
			


}
