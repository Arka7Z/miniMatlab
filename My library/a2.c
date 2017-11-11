#include "myl.h"

int printStr(char* string)
{
	int i=0,length=0,retValue;
	while(string[i]!='\0')
		i++;
	length=i;
	asm volatile(
			      "syscall;"
			      :"=a"(retValue)
			      :"a"(1),"D"(1),"S"(string),"d"(length)
			    );
	return retValue;
}

int readInt(int* n)
{
	char string[12];
	int i=0,retValue,leftLimit,offset,tmp=0,length;
	asm volatile(
					"syscall;"
					:"=a" (retValue)
					:"a"(0), "D"(0), "S"(string), "d"(12)
				);
	//printf("string in print int %s\n", string );
	while((i<12)&&  string[i]!='\0' && ((string[i]>='0'&&string[i]<='9')||(string[i]=='-')))
	{
		i++;
	}

	(string[0]=='-')?(leftLimit=1):(leftLimit=0);
	(string[0]=='-')?(length=i-1):(length=i);
	if (length>10)
		return ERR;
	int j=i-1;
	int multiplier=1;
	while(j>=leftLimit)
	{
		offset=(int)(string[j]-'0');
		tmp+=(multiplier*offset);
		//printf("%d tmp\n",tmp );
		multiplier*=10;
		j--;
	}

	(string[0]=='-')?(tmp=((-1)*tmp)):(tmp=tmp);
	(*n)=tmp;
	if (retValue>=0)
		return OK;
	return ERR;
}

int printInt(int n)
{
	char buff[14];
	int i=0,length,digit,start,end,retValue;

	if (n==0)
		buff[i++]='0';
	else
	{
		if (n<0)
		{
			buff[i++]='-';
			n=(-1)*n;
		}
		while(n)
		{
			digit=n%10;
			buff[i++]=(char)(digit+'0');
			n/=10;
		}
	}
	if (buff[0]=='-')
		start=1;
	else
		start=0;
	//reverse the buffer
	char tmp;
	end=i-1;
	while(start<end)
	{
		tmp=buff[start];
		buff[start++]=buff[end];
		buff[end--]=tmp;
	}
	buff[i]='\n';
	length=(++i);
	asm volatile(
			      "syscall;"
			      :"=a"(retValue)
			      :"a"(1),"D"(1),"S"(buff),"d"(length)
			      );
	if (retValue>=0)
		return (int) retValue;
	else
		return ERR;

}

int readFlt(float* f)
{
	char integer[12],string[20];
	int i=0,retValue,leftLimit,offset,tmp=0,intLength,fracLength=0,intNum,fracNum;
	asm volatile(
					"syscall;"
					:"=a" (retValue)
					:"a"(0), "D"(0), "S"(string), "d"(20)
				);

	while(  (i<20)  && string[i]!='.'  &&  string[i]!='\0' && ( (string[i]>='0'&&string[i]<='9') || (string[i]=='-') ) )
	{
		integer[i]=string[i];
		if (i>0)
			if(!(string[i]>='0'&&string[i]<='9'))
				return ERR;
		i++;
	}
	if (i>0)
		if(!((string[i]>='0'&&string[i]<='9')||string[i]))
				return ERR;
	intLength=(i);
	if (intLength>10)
		return ERR;

	(integer[0]=='-')?(leftLimit=1):(leftLimit=0);
	int j=i-1;
	int multiplier=1;
	while(j>=leftLimit)
	{
		offset=(int)(integer[j]-'0');
		tmp+=(multiplier*offset);
		multiplier*=10;
		j--;
	}

	(integer[0]=='-')?(tmp=((-1)*tmp)):(tmp=tmp);
	intNum=tmp;
	tmp=0;
	int k=i+1;
	while(k<20&&string[k]>='0'&&string[k]<='9'&& fracLength<6)
	{
		k++;
		fracLength++;
	}	
	k--;
	i++;
	leftLimit=i;
	multiplier=1;
	while(k>=leftLimit && k<20 )
	{
		offset=(int)(string[k]-'0');
		tmp+=(multiplier*offset);
		multiplier*=10;
		k--;
	}

	fracNum=tmp;
	float frac=((float)fracNum/(float)multiplier);
	int absNum=(intNum>0)?intNum:((-1)*intNum);
	float diff=frac+((float)absNum);
	(intNum>0)?(diff=diff):(diff=(-diff));
	*f=diff;
	if (retValue>=0)
		return OK;
	else
		return ERR;

}

int printFlt(float f)
{
	char buff[14];
	int i=0,length,digit,start,end,retValue;
	float absF=(f<0)?(-f):(f);
	int integer=f/1;
	int absInt=absF/1;
	float fraction=absF-((float)absInt);
	if (absF<1.175494e-38|| absF > 3.402823e+38)
		return ERR;
	if (f==0.0)
		{
			buff[i++]='0';
			buff[i++]='.';
			buff[i++]='0';
		}
	else
	{
		if (integer<0.0)
		{
			buff[i++]='-';
			integer=(-1.0)*integer;
		}
		while(integer)
		{
			digit=integer%10;
			buff[i++]=(char)(digit+'0');
			integer/=10;
		}
	}
	if (buff[0]=='-')
		start=1;
	else
		start=0;
	//reverse the buffer
	char tmp;
	end=i-1;
	while(start<end)
	{
		tmp=buff[start];
		buff[start++]=buff[end];
		buff[end--]=tmp;
	}
	buff[i]='.';
	int fracNum=((int)((1000000)*fraction));
	if (fracNum==0)
	{
		buff[++i]='0';
		buff[++i]='\n';
		length=i+1;
	}
	else
	{
		i+=6;
		while(fracNum)
		{
			digit=fracNum%10;
			buff[i--]=(char)(digit+'0');
			fracNum/=10;
		}
		buff[i+7]='\n';
		length=(i+8);
	}

	asm volatile(
			      "syscall;"
			      :"=a"(retValue)
			      :"a"(1),"D"(1),"S"(buff),"d"(length)
			    );
	if (retValue>=0)
		return (int) retValue;
	else
		return ERR;
}

