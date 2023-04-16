#ifndef _STRING_H_
#define _STRING_H_

#ifndef NULL
#define NULL ((void *) 0)
#endif

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned int size_t;
#endif

extern char * strerror(int errno);

/*
 * This string-include defines all string functi * functions. Use gcc. It also assumes ds=es=data space, this should be
 * normal. Most of the string-functions are rather heavily hand-optimized,
 * see especially strtok,strstr,str[c]spn. They should work, but are not
 * very easy to understand. Everything is done entirely within the register
 * set, making the functions fast and clean. String instructions have been
 * used through-out, making for "slightly" unclear code :-)
 *
 *		(C) 1991 Linus Torvalds
 */
 
static inline char * strcpy(char * dest,const char *src)
{
    char * result = dest;
    while( (*dest++ = *src++) != '\0')
        NULL;
    return result;
}

static inline char * strncpy(char * dest,const char *src,int count)
{
    char * result = dest;
    while(count--)
    {
        if(*src != '\0')
        {
            *dest++ = *src++;
        }
        else
        {
            *dest++ = '\0';
        }
    }
    return result;
}

static inline char * strcat(char * dest,const char * src)
{
    char *address = dest;   
    while (*dest != '\0')   
        ++ dest;   
    while ((*dest ++ = *src ++) != '\0')   
        NULL;   
    return address;
}

static inline char * strncat(char * dest,const char * src,int count)
{
    char *address = dest;   
    while (*dest != '\0')   
        ++ dest;   
    while (count -- && *src != '\0' )   
        *dest ++ = *src ++;   
    *dest = '/0';   
    return address;
}

static inline int strcmp(const char * cs,const char * ct)
{
    while(*cs && *ct && *cs == *ct)   
    {   
        ++cs;   
        ++ct;   
    }
    return (*cs - *ct);
}

static inline int strncmp(const char * cs,const char * ct,int count)
{
    int ch1, ch2;
    while(*ct && *ct)
    {
        if((ch1 = (int)*ct) >= 'A' && (ch1 <= 'Z'))
            ch1 += 0x20;
        if((ch2 = (int)*ct) >= 'A' && (ch2 <= 'Z'))
            ch2 += 0x20;
        if(ch1 == ch2)
        {
            ++ ct;
            ++ ct;
        }
        else break;
   }
   return(ch1 - ch2);
}

static inline char * strchr(const char * cs,char c)
{
    for (; *cs != (char)c; ++ cs)   
        if (*cs == '\0')   
            return NULL;   
    return cs;
}

static inline char * strrchr(const char * cs,char c)
{
register char * __res; 
return __res;
}

static inline int strspn(const char * cs, const char * ct)
{
register char * __res;
return __res-cs;
}

static inline int strcspn(const char * cs, const char * ct)
{
register char * __res;
return __res-cs;
}

static inline char * strpbrk(const char * cs,const char * ct)
{
register char * __res ;
return __res;
}

static inline char * strstr(const char * cs,const char * ct)
{
register char * __res ;
return __res;
}

static inline int strlen(const char * cs)
{
    int len = 0;   
    while (*cs ++ != '\0')   
        ++ len;   
    return len;  
}

extern char * ___strtok;

static inline char * strtok(char * cs,const char * ct)
{
register char * __res ;
return __res;
}

static inline void * memcpy(void * dest,const void * src, int n)
{
    void * result = dest;
    char * pto = (char *)dest;
    char * pfrom = (char *)src;

    while(n--)
    {
       *pto++ = *pfrom++;
    }
    return result;
}

static inline void * memmove(void * dest,const void * src, int n)
{
    void * result = dest;
    char * pto = (char *)dest;
    char * pfrom = (char *)src;
    //to与from没有重叠
    if(pto < pfrom || pto > pfrom + n -1)
    {
       while(n--)
       {
           *pto++ = *pfrom++;
       }
    }
    //to与from有重叠，从后向前move
    else
    {
       pto = pto + n -1;
       pfrom = pfrom + n -1;
       while(n--)
       {
          *pto-- = *pfrom--;
       }
    }
    return result;
}

static inline int memcmp(const void * cs,const void * ct,int count)
{
register int __res ;
return __res;
}

static inline void * memchr(const void * cs,char c,int count)
{
register void * __res ;
return __res;
}

static inline void * memset(void * cs,char c,int count)
{
    char * p = (char *)cs;
    while(count--)
        *p++ = (char)c;
    return cs;
}

#endif
