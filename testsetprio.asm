
_testsetprio:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	8b 01                	mov    (%ecx),%eax
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
  int pid, prio, rc;

  if (argc == 1) {
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	74 2a                	je     4b <main+0x4b>
    pid = getpid();
    prio = 0;
  }
  else {
    if (argc != 3) {
  21:	83 f8 03             	cmp    $0x3,%eax
  24:	74 33                	je     59 <main+0x59>
      printf(2, "Error: invalid pid or priority\n");
  26:	83 ec 08             	sub    $0x8,%esp
  29:	68 94 07 00 00       	push   $0x794
  2e:	6a 02                	push   $0x2
  30:	e8 a1 04 00 00       	call   4d6 <printf>
      printf(2, "Usage: %s [<pid> <prio>]\n",argv[0]);
  35:	83 c4 0c             	add    $0xc,%esp
  38:	ff 33                	pushl  (%ebx)
  3a:	68 b4 07 00 00       	push   $0x7b4
  3f:	6a 02                	push   $0x2
  41:	e8 90 04 00 00       	call   4d6 <printf>
      exit();
  46:	e8 fa 02 00 00       	call   345 <exit>
    pid = getpid();
  4b:	e8 75 03 00 00       	call   3c5 <getpid>
  50:	89 c6                	mov    %eax,%esi
    prio = 0;
  52:	b8 00 00 00 00       	mov    $0x0,%eax
  57:	eb 1b                	jmp    74 <main+0x74>
    }
    else {
      pid = atoi(argv[1]);
  59:	83 ec 0c             	sub    $0xc,%esp
  5c:	ff 73 04             	pushl  0x4(%ebx)
  5f:	e8 9e 01 00 00       	call   202 <atoi>
  64:	89 c6                	mov    %eax,%esi
      prio = atoi(argv[2]);
  66:	83 c4 04             	add    $0x4,%esp
  69:	ff 73 08             	pushl  0x8(%ebx)
  6c:	e8 91 01 00 00       	call   202 <atoi>
  71:	83 c4 10             	add    $0x10,%esp
    }
  }

  rc = setpriority(pid, prio);
  74:	83 ec 08             	sub    $0x8,%esp
  77:	50                   	push   %eax
  78:	56                   	push   %esi
  79:	e8 a7 03 00 00       	call   425 <setpriority>
  if (rc != 0) {
  7e:	83 c4 10             	add    $0x10,%esp
  81:	85 c0                	test   %eax,%eax
  83:	75 05                	jne    8a <main+0x8a>
      printf(2, "Error: invalid pid\n");
      printf(2, "Usage: %s [<pid> <prio>]\n",argv[0]);
  }
  exit();
  85:	e8 bb 02 00 00       	call   345 <exit>
      printf(2, "Error: invalid pid\n");
  8a:	83 ec 08             	sub    $0x8,%esp
  8d:	68 ce 07 00 00       	push   $0x7ce
  92:	6a 02                	push   $0x2
  94:	e8 3d 04 00 00       	call   4d6 <printf>
      printf(2, "Usage: %s [<pid> <prio>]\n",argv[0]);
  99:	83 c4 0c             	add    $0xc,%esp
  9c:	ff 33                	pushl  (%ebx)
  9e:	68 b4 07 00 00       	push   $0x7b4
  a3:	6a 02                	push   $0x2
  a5:	e8 2c 04 00 00       	call   4d6 <printf>
  aa:	83 c4 10             	add    $0x10,%esp
  ad:	eb d6                	jmp    85 <main+0x85>

000000af <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  af:	f3 0f 1e fb          	endbr32 
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	56                   	push   %esi
  b7:	53                   	push   %ebx
  b8:	8b 75 08             	mov    0x8(%ebp),%esi
  bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  be:	89 f0                	mov    %esi,%eax
  c0:	89 d1                	mov    %edx,%ecx
  c2:	83 c2 01             	add    $0x1,%edx
  c5:	89 c3                	mov    %eax,%ebx
  c7:	83 c0 01             	add    $0x1,%eax
  ca:	0f b6 09             	movzbl (%ecx),%ecx
  cd:	88 0b                	mov    %cl,(%ebx)
  cf:	84 c9                	test   %cl,%cl
  d1:	75 ed                	jne    c0 <strcpy+0x11>
    ;
  return os;
}
  d3:	89 f0                	mov    %esi,%eax
  d5:	5b                   	pop    %ebx
  d6:	5e                   	pop    %esi
  d7:	5d                   	pop    %ebp
  d8:	c3                   	ret    

000000d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d9:	f3 0f 1e fb          	endbr32 
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  e6:	0f b6 01             	movzbl (%ecx),%eax
  e9:	84 c0                	test   %al,%al
  eb:	74 0c                	je     f9 <strcmp+0x20>
  ed:	3a 02                	cmp    (%edx),%al
  ef:	75 08                	jne    f9 <strcmp+0x20>
    p++, q++;
  f1:	83 c1 01             	add    $0x1,%ecx
  f4:	83 c2 01             	add    $0x1,%edx
  f7:	eb ed                	jmp    e6 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  f9:	0f b6 c0             	movzbl %al,%eax
  fc:	0f b6 12             	movzbl (%edx),%edx
  ff:	29 d0                	sub    %edx,%eax
}
 101:	5d                   	pop    %ebp
 102:	c3                   	ret    

00000103 <strlen>:

uint
strlen(char *s)
{
 103:	f3 0f 1e fb          	endbr32 
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 10d:	b8 00 00 00 00       	mov    $0x0,%eax
 112:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 116:	74 05                	je     11d <strlen+0x1a>
 118:	83 c0 01             	add    $0x1,%eax
 11b:	eb f5                	jmp    112 <strlen+0xf>
    ;
  return n;
}
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    

0000011f <memset>:

void*
memset(void *dst, int c, uint n)
{
 11f:	f3 0f 1e fb          	endbr32 
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	57                   	push   %edi
 127:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 12a:	89 d7                	mov    %edx,%edi
 12c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	fc                   	cld    
 133:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 135:	89 d0                	mov    %edx,%eax
 137:	5f                   	pop    %edi
 138:	5d                   	pop    %ebp
 139:	c3                   	ret    

0000013a <strchr>:

char*
strchr(const char *s, char c)
{
 13a:	f3 0f 1e fb          	endbr32 
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 148:	0f b6 10             	movzbl (%eax),%edx
 14b:	84 d2                	test   %dl,%dl
 14d:	74 09                	je     158 <strchr+0x1e>
    if(*s == c)
 14f:	38 ca                	cmp    %cl,%dl
 151:	74 0a                	je     15d <strchr+0x23>
  for(; *s; s++)
 153:	83 c0 01             	add    $0x1,%eax
 156:	eb f0                	jmp    148 <strchr+0xe>
      return (char*)s;
  return 0;
 158:	b8 00 00 00 00       	mov    $0x0,%eax
}
 15d:	5d                   	pop    %ebp
 15e:	c3                   	ret    

0000015f <gets>:

char*
gets(char *buf, int max)
{
 15f:	f3 0f 1e fb          	endbr32 
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
 166:	57                   	push   %edi
 167:	56                   	push   %esi
 168:	53                   	push   %ebx
 169:	83 ec 1c             	sub    $0x1c,%esp
 16c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16f:	bb 00 00 00 00       	mov    $0x0,%ebx
 174:	89 de                	mov    %ebx,%esi
 176:	83 c3 01             	add    $0x1,%ebx
 179:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 17c:	7d 2e                	jge    1ac <gets+0x4d>
    cc = read(0, &c, 1);
 17e:	83 ec 04             	sub    $0x4,%esp
 181:	6a 01                	push   $0x1
 183:	8d 45 e7             	lea    -0x19(%ebp),%eax
 186:	50                   	push   %eax
 187:	6a 00                	push   $0x0
 189:	e8 cf 01 00 00       	call   35d <read>
    if(cc < 1)
 18e:	83 c4 10             	add    $0x10,%esp
 191:	85 c0                	test   %eax,%eax
 193:	7e 17                	jle    1ac <gets+0x4d>
      break;
    buf[i++] = c;
 195:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 199:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 19c:	3c 0a                	cmp    $0xa,%al
 19e:	0f 94 c2             	sete   %dl
 1a1:	3c 0d                	cmp    $0xd,%al
 1a3:	0f 94 c0             	sete   %al
 1a6:	08 c2                	or     %al,%dl
 1a8:	74 ca                	je     174 <gets+0x15>
    buf[i++] = c;
 1aa:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1ac:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1b0:	89 f8                	mov    %edi,%eax
 1b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1b5:	5b                   	pop    %ebx
 1b6:	5e                   	pop    %esi
 1b7:	5f                   	pop    %edi
 1b8:	5d                   	pop    %ebp
 1b9:	c3                   	ret    

000001ba <stat>:

int
stat(char *n, struct stat *st)
{
 1ba:	f3 0f 1e fb          	endbr32 
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	56                   	push   %esi
 1c2:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c3:	83 ec 08             	sub    $0x8,%esp
 1c6:	6a 00                	push   $0x0
 1c8:	ff 75 08             	pushl  0x8(%ebp)
 1cb:	e8 b5 01 00 00       	call   385 <open>
  if(fd < 0)
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	85 c0                	test   %eax,%eax
 1d5:	78 24                	js     1fb <stat+0x41>
 1d7:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	ff 75 0c             	pushl  0xc(%ebp)
 1df:	50                   	push   %eax
 1e0:	e8 b8 01 00 00       	call   39d <fstat>
 1e5:	89 c6                	mov    %eax,%esi
  close(fd);
 1e7:	89 1c 24             	mov    %ebx,(%esp)
 1ea:	e8 7e 01 00 00       	call   36d <close>
  return r;
 1ef:	83 c4 10             	add    $0x10,%esp
}
 1f2:	89 f0                	mov    %esi,%eax
 1f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1f7:	5b                   	pop    %ebx
 1f8:	5e                   	pop    %esi
 1f9:	5d                   	pop    %ebp
 1fa:	c3                   	ret    
    return -1;
 1fb:	be ff ff ff ff       	mov    $0xffffffff,%esi
 200:	eb f0                	jmp    1f2 <stat+0x38>

00000202 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 202:	f3 0f 1e fb          	endbr32 
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	57                   	push   %edi
 20a:	56                   	push   %esi
 20b:	53                   	push   %ebx
 20c:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 20f:	0f b6 02             	movzbl (%edx),%eax
 212:	3c 20                	cmp    $0x20,%al
 214:	75 05                	jne    21b <atoi+0x19>
 216:	83 c2 01             	add    $0x1,%edx
 219:	eb f4                	jmp    20f <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 21b:	3c 2d                	cmp    $0x2d,%al
 21d:	74 1d                	je     23c <atoi+0x3a>
 21f:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 224:	3c 2b                	cmp    $0x2b,%al
 226:	0f 94 c1             	sete   %cl
 229:	3c 2d                	cmp    $0x2d,%al
 22b:	0f 94 c0             	sete   %al
 22e:	08 c1                	or     %al,%cl
 230:	74 03                	je     235 <atoi+0x33>
    s++;
 232:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 235:	b8 00 00 00 00       	mov    $0x0,%eax
 23a:	eb 17                	jmp    253 <atoi+0x51>
 23c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 241:	eb e1                	jmp    224 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 243:	8d 34 80             	lea    (%eax,%eax,4),%esi
 246:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 249:	83 c2 01             	add    $0x1,%edx
 24c:	0f be c9             	movsbl %cl,%ecx
 24f:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 253:	0f b6 0a             	movzbl (%edx),%ecx
 256:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 259:	80 fb 09             	cmp    $0x9,%bl
 25c:	76 e5                	jbe    243 <atoi+0x41>
  return sign*n;
 25e:	0f af c7             	imul   %edi,%eax
}
 261:	5b                   	pop    %ebx
 262:	5e                   	pop    %esi
 263:	5f                   	pop    %edi
 264:	5d                   	pop    %ebp
 265:	c3                   	ret    

00000266 <atoo>:

int
atoo(const char *s)
{
 266:	f3 0f 1e fb          	endbr32 
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
 26d:	57                   	push   %edi
 26e:	56                   	push   %esi
 26f:	53                   	push   %ebx
 270:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 273:	0f b6 0a             	movzbl (%edx),%ecx
 276:	80 f9 20             	cmp    $0x20,%cl
 279:	75 05                	jne    280 <atoo+0x1a>
 27b:	83 c2 01             	add    $0x1,%edx
 27e:	eb f3                	jmp    273 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 280:	80 f9 2d             	cmp    $0x2d,%cl
 283:	74 23                	je     2a8 <atoo+0x42>
 285:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 28a:	80 f9 2b             	cmp    $0x2b,%cl
 28d:	0f 94 c0             	sete   %al
 290:	89 c6                	mov    %eax,%esi
 292:	80 f9 2d             	cmp    $0x2d,%cl
 295:	0f 94 c0             	sete   %al
 298:	89 f3                	mov    %esi,%ebx
 29a:	08 c3                	or     %al,%bl
 29c:	74 03                	je     2a1 <atoo+0x3b>
    s++;
 29e:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2a1:	b8 00 00 00 00       	mov    $0x0,%eax
 2a6:	eb 11                	jmp    2b9 <atoo+0x53>
 2a8:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2ad:	eb db                	jmp    28a <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 2af:	83 c2 01             	add    $0x1,%edx
 2b2:	0f be c9             	movsbl %cl,%ecx
 2b5:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2b9:	0f b6 0a             	movzbl (%edx),%ecx
 2bc:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2bf:	80 fb 07             	cmp    $0x7,%bl
 2c2:	76 eb                	jbe    2af <atoo+0x49>
  return sign*n;
 2c4:	0f af c7             	imul   %edi,%eax
}
 2c7:	5b                   	pop    %ebx
 2c8:	5e                   	pop    %esi
 2c9:	5f                   	pop    %edi
 2ca:	5d                   	pop    %ebp
 2cb:	c3                   	ret    

000002cc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2cc:	f3 0f 1e fb          	endbr32 
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
 2d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2da:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 2dd:	eb 09                	jmp    2e8 <strncmp+0x1c>
      n--, p++, q++;
 2df:	83 e8 01             	sub    $0x1,%eax
 2e2:	83 c2 01             	add    $0x1,%edx
 2e5:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 2e8:	85 c0                	test   %eax,%eax
 2ea:	74 0b                	je     2f7 <strncmp+0x2b>
 2ec:	0f b6 1a             	movzbl (%edx),%ebx
 2ef:	84 db                	test   %bl,%bl
 2f1:	74 04                	je     2f7 <strncmp+0x2b>
 2f3:	3a 19                	cmp    (%ecx),%bl
 2f5:	74 e8                	je     2df <strncmp+0x13>
    if(n == 0)
 2f7:	85 c0                	test   %eax,%eax
 2f9:	74 0b                	je     306 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 2fb:	0f b6 02             	movzbl (%edx),%eax
 2fe:	0f b6 11             	movzbl (%ecx),%edx
 301:	29 d0                	sub    %edx,%eax
}
 303:	5b                   	pop    %ebx
 304:	5d                   	pop    %ebp
 305:	c3                   	ret    
      return 0;
 306:	b8 00 00 00 00       	mov    $0x0,%eax
 30b:	eb f6                	jmp    303 <strncmp+0x37>

0000030d <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 30d:	f3 0f 1e fb          	endbr32 
 311:	55                   	push   %ebp
 312:	89 e5                	mov    %esp,%ebp
 314:	56                   	push   %esi
 315:	53                   	push   %ebx
 316:	8b 75 08             	mov    0x8(%ebp),%esi
 319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 31c:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 31f:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 321:	8d 58 ff             	lea    -0x1(%eax),%ebx
 324:	85 c0                	test   %eax,%eax
 326:	7e 0f                	jle    337 <memmove+0x2a>
    *dst++ = *src++;
 328:	0f b6 01             	movzbl (%ecx),%eax
 32b:	88 02                	mov    %al,(%edx)
 32d:	8d 49 01             	lea    0x1(%ecx),%ecx
 330:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 333:	89 d8                	mov    %ebx,%eax
 335:	eb ea                	jmp    321 <memmove+0x14>
  return vdst;
}
 337:	89 f0                	mov    %esi,%eax
 339:	5b                   	pop    %ebx
 33a:	5e                   	pop    %esi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    

0000033d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33d:	b8 01 00 00 00       	mov    $0x1,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <exit>:
SYSCALL(exit)
 345:	b8 02 00 00 00       	mov    $0x2,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <wait>:
SYSCALL(wait)
 34d:	b8 03 00 00 00       	mov    $0x3,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <pipe>:
SYSCALL(pipe)
 355:	b8 04 00 00 00       	mov    $0x4,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <read>:
SYSCALL(read)
 35d:	b8 05 00 00 00       	mov    $0x5,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <write>:
SYSCALL(write)
 365:	b8 10 00 00 00       	mov    $0x10,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <close>:
SYSCALL(close)
 36d:	b8 15 00 00 00       	mov    $0x15,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <kill>:
SYSCALL(kill)
 375:	b8 06 00 00 00       	mov    $0x6,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <exec>:
SYSCALL(exec)
 37d:	b8 07 00 00 00       	mov    $0x7,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <open>:
SYSCALL(open)
 385:	b8 0f 00 00 00       	mov    $0xf,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <mknod>:
SYSCALL(mknod)
 38d:	b8 11 00 00 00       	mov    $0x11,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <unlink>:
SYSCALL(unlink)
 395:	b8 12 00 00 00       	mov    $0x12,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <fstat>:
SYSCALL(fstat)
 39d:	b8 08 00 00 00       	mov    $0x8,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <link>:
SYSCALL(link)
 3a5:	b8 13 00 00 00       	mov    $0x13,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <mkdir>:
SYSCALL(mkdir)
 3ad:	b8 14 00 00 00       	mov    $0x14,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <chdir>:
SYSCALL(chdir)
 3b5:	b8 09 00 00 00       	mov    $0x9,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <dup>:
SYSCALL(dup)
 3bd:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <getpid>:
SYSCALL(getpid)
 3c5:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <sbrk>:
SYSCALL(sbrk)
 3cd:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <sleep>:
SYSCALL(sleep)
 3d5:	b8 0d 00 00 00       	mov    $0xd,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <uptime>:
SYSCALL(uptime)
 3dd:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <halt>:
SYSCALL(halt)
 3e5:	b8 16 00 00 00       	mov    $0x16,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <date>:
SYSCALL(date)
 3ed:	b8 17 00 00 00       	mov    $0x17,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <getuid>:
SYSCALL(getuid)
 3f5:	b8 18 00 00 00       	mov    $0x18,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <getgid>:
SYSCALL(getgid)
 3fd:	b8 19 00 00 00       	mov    $0x19,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <getppid>:
SYSCALL(getppid)
 405:	b8 1a 00 00 00       	mov    $0x1a,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <setuid>:
SYSCALL(setuid)
 40d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <setgid>:
SYSCALL(setgid)
 415:	b8 1c 00 00 00       	mov    $0x1c,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <getprocs>:
SYSCALL(getprocs)
 41d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <setpriority>:
SYSCALL(setpriority)
 425:	b8 1e 00 00 00       	mov    $0x1e,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <getpriority>:
SYSCALL(getpriority)
 42d:	b8 1f 00 00 00       	mov    $0x1f,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 435:	55                   	push   %ebp
 436:	89 e5                	mov    %esp,%ebp
 438:	83 ec 1c             	sub    $0x1c,%esp
 43b:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 43e:	6a 01                	push   $0x1
 440:	8d 55 f4             	lea    -0xc(%ebp),%edx
 443:	52                   	push   %edx
 444:	50                   	push   %eax
 445:	e8 1b ff ff ff       	call   365 <write>
}
 44a:	83 c4 10             	add    $0x10,%esp
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	57                   	push   %edi
 453:	56                   	push   %esi
 454:	53                   	push   %ebx
 455:	83 ec 2c             	sub    $0x2c,%esp
 458:	89 45 d0             	mov    %eax,-0x30(%ebp)
 45b:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 461:	0f 95 c2             	setne  %dl
 464:	89 f0                	mov    %esi,%eax
 466:	c1 e8 1f             	shr    $0x1f,%eax
 469:	84 c2                	test   %al,%dl
 46b:	74 42                	je     4af <printint+0x60>
    neg = 1;
    x = -xx;
 46d:	f7 de                	neg    %esi
    neg = 1;
 46f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 476:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 47b:	89 f0                	mov    %esi,%eax
 47d:	ba 00 00 00 00       	mov    $0x0,%edx
 482:	f7 f1                	div    %ecx
 484:	89 df                	mov    %ebx,%edi
 486:	83 c3 01             	add    $0x1,%ebx
 489:	0f b6 92 ec 07 00 00 	movzbl 0x7ec(%edx),%edx
 490:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 494:	89 f2                	mov    %esi,%edx
 496:	89 c6                	mov    %eax,%esi
 498:	39 d1                	cmp    %edx,%ecx
 49a:	76 df                	jbe    47b <printint+0x2c>
  if(neg)
 49c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 4a0:	74 2f                	je     4d1 <printint+0x82>
    buf[i++] = '-';
 4a2:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4a7:	8d 5f 02             	lea    0x2(%edi),%ebx
 4aa:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4ad:	eb 15                	jmp    4c4 <printint+0x75>
  neg = 0;
 4af:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 4b6:	eb be                	jmp    476 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 4b8:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4bd:	89 f0                	mov    %esi,%eax
 4bf:	e8 71 ff ff ff       	call   435 <putc>
  while(--i >= 0)
 4c4:	83 eb 01             	sub    $0x1,%ebx
 4c7:	79 ef                	jns    4b8 <printint+0x69>
}
 4c9:	83 c4 2c             	add    $0x2c,%esp
 4cc:	5b                   	pop    %ebx
 4cd:	5e                   	pop    %esi
 4ce:	5f                   	pop    %edi
 4cf:	5d                   	pop    %ebp
 4d0:	c3                   	ret    
 4d1:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4d4:	eb ee                	jmp    4c4 <printint+0x75>

000004d6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d6:	f3 0f 1e fb          	endbr32 
 4da:	55                   	push   %ebp
 4db:	89 e5                	mov    %esp,%ebp
 4dd:	57                   	push   %edi
 4de:	56                   	push   %esi
 4df:	53                   	push   %ebx
 4e0:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4e3:	8d 45 10             	lea    0x10(%ebp),%eax
 4e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4e9:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4ee:	bb 00 00 00 00       	mov    $0x0,%ebx
 4f3:	eb 14                	jmp    509 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4f5:	89 fa                	mov    %edi,%edx
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	e8 36 ff ff ff       	call   435 <putc>
 4ff:	eb 05                	jmp    506 <printf+0x30>
      }
    } else if(state == '%'){
 501:	83 fe 25             	cmp    $0x25,%esi
 504:	74 25                	je     52b <printf+0x55>
  for(i = 0; fmt[i]; i++){
 506:	83 c3 01             	add    $0x1,%ebx
 509:	8b 45 0c             	mov    0xc(%ebp),%eax
 50c:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 510:	84 c0                	test   %al,%al
 512:	0f 84 23 01 00 00    	je     63b <printf+0x165>
    c = fmt[i] & 0xff;
 518:	0f be f8             	movsbl %al,%edi
 51b:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 51e:	85 f6                	test   %esi,%esi
 520:	75 df                	jne    501 <printf+0x2b>
      if(c == '%'){
 522:	83 f8 25             	cmp    $0x25,%eax
 525:	75 ce                	jne    4f5 <printf+0x1f>
        state = '%';
 527:	89 c6                	mov    %eax,%esi
 529:	eb db                	jmp    506 <printf+0x30>
      if(c == 'd'){
 52b:	83 f8 64             	cmp    $0x64,%eax
 52e:	74 49                	je     579 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 530:	83 f8 78             	cmp    $0x78,%eax
 533:	0f 94 c1             	sete   %cl
 536:	83 f8 70             	cmp    $0x70,%eax
 539:	0f 94 c2             	sete   %dl
 53c:	08 d1                	or     %dl,%cl
 53e:	75 63                	jne    5a3 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 540:	83 f8 73             	cmp    $0x73,%eax
 543:	0f 84 84 00 00 00    	je     5cd <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 549:	83 f8 63             	cmp    $0x63,%eax
 54c:	0f 84 b7 00 00 00    	je     609 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 552:	83 f8 25             	cmp    $0x25,%eax
 555:	0f 84 cc 00 00 00    	je     627 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 55b:	ba 25 00 00 00       	mov    $0x25,%edx
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	e8 cd fe ff ff       	call   435 <putc>
        putc(fd, c);
 568:	89 fa                	mov    %edi,%edx
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	e8 c3 fe ff ff       	call   435 <putc>
      }
      state = 0;
 572:	be 00 00 00 00       	mov    $0x0,%esi
 577:	eb 8d                	jmp    506 <printf+0x30>
        printint(fd, *ap, 10, 1);
 579:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 57c:	8b 17                	mov    (%edi),%edx
 57e:	83 ec 0c             	sub    $0xc,%esp
 581:	6a 01                	push   $0x1
 583:	b9 0a 00 00 00       	mov    $0xa,%ecx
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	e8 bf fe ff ff       	call   44f <printint>
        ap++;
 590:	83 c7 04             	add    $0x4,%edi
 593:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 596:	83 c4 10             	add    $0x10,%esp
      state = 0;
 599:	be 00 00 00 00       	mov    $0x0,%esi
 59e:	e9 63 ff ff ff       	jmp    506 <printf+0x30>
        printint(fd, *ap, 16, 0);
 5a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5a6:	8b 17                	mov    (%edi),%edx
 5a8:	83 ec 0c             	sub    $0xc,%esp
 5ab:	6a 00                	push   $0x0
 5ad:	b9 10 00 00 00       	mov    $0x10,%ecx
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	e8 95 fe ff ff       	call   44f <printint>
        ap++;
 5ba:	83 c7 04             	add    $0x4,%edi
 5bd:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5c0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5c3:	be 00 00 00 00       	mov    $0x0,%esi
 5c8:	e9 39 ff ff ff       	jmp    506 <printf+0x30>
        s = (char*)*ap;
 5cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d0:	8b 30                	mov    (%eax),%esi
        ap++;
 5d2:	83 c0 04             	add    $0x4,%eax
 5d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5d8:	85 f6                	test   %esi,%esi
 5da:	75 28                	jne    604 <printf+0x12e>
          s = "(null)";
 5dc:	be e2 07 00 00       	mov    $0x7e2,%esi
 5e1:	8b 7d 08             	mov    0x8(%ebp),%edi
 5e4:	eb 0d                	jmp    5f3 <printf+0x11d>
          putc(fd, *s);
 5e6:	0f be d2             	movsbl %dl,%edx
 5e9:	89 f8                	mov    %edi,%eax
 5eb:	e8 45 fe ff ff       	call   435 <putc>
          s++;
 5f0:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 5f3:	0f b6 16             	movzbl (%esi),%edx
 5f6:	84 d2                	test   %dl,%dl
 5f8:	75 ec                	jne    5e6 <printf+0x110>
      state = 0;
 5fa:	be 00 00 00 00       	mov    $0x0,%esi
 5ff:	e9 02 ff ff ff       	jmp    506 <printf+0x30>
 604:	8b 7d 08             	mov    0x8(%ebp),%edi
 607:	eb ea                	jmp    5f3 <printf+0x11d>
        putc(fd, *ap);
 609:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 60c:	0f be 17             	movsbl (%edi),%edx
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	e8 1e fe ff ff       	call   435 <putc>
        ap++;
 617:	83 c7 04             	add    $0x4,%edi
 61a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 61d:	be 00 00 00 00       	mov    $0x0,%esi
 622:	e9 df fe ff ff       	jmp    506 <printf+0x30>
        putc(fd, c);
 627:	89 fa                	mov    %edi,%edx
 629:	8b 45 08             	mov    0x8(%ebp),%eax
 62c:	e8 04 fe ff ff       	call   435 <putc>
      state = 0;
 631:	be 00 00 00 00       	mov    $0x0,%esi
 636:	e9 cb fe ff ff       	jmp    506 <printf+0x30>
    }
  }
}
 63b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 63e:	5b                   	pop    %ebx
 63f:	5e                   	pop    %esi
 640:	5f                   	pop    %edi
 641:	5d                   	pop    %ebp
 642:	c3                   	ret    

00000643 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 643:	f3 0f 1e fb          	endbr32 
 647:	55                   	push   %ebp
 648:	89 e5                	mov    %esp,%ebp
 64a:	57                   	push   %edi
 64b:	56                   	push   %esi
 64c:	53                   	push   %ebx
 64d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 650:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 653:	a1 f0 0a 00 00       	mov    0xaf0,%eax
 658:	eb 02                	jmp    65c <free+0x19>
 65a:	89 d0                	mov    %edx,%eax
 65c:	39 c8                	cmp    %ecx,%eax
 65e:	73 04                	jae    664 <free+0x21>
 660:	39 08                	cmp    %ecx,(%eax)
 662:	77 12                	ja     676 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 664:	8b 10                	mov    (%eax),%edx
 666:	39 c2                	cmp    %eax,%edx
 668:	77 f0                	ja     65a <free+0x17>
 66a:	39 c8                	cmp    %ecx,%eax
 66c:	72 08                	jb     676 <free+0x33>
 66e:	39 ca                	cmp    %ecx,%edx
 670:	77 04                	ja     676 <free+0x33>
 672:	89 d0                	mov    %edx,%eax
 674:	eb e6                	jmp    65c <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 676:	8b 73 fc             	mov    -0x4(%ebx),%esi
 679:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 67c:	8b 10                	mov    (%eax),%edx
 67e:	39 d7                	cmp    %edx,%edi
 680:	74 19                	je     69b <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 682:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 685:	8b 50 04             	mov    0x4(%eax),%edx
 688:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 68b:	39 ce                	cmp    %ecx,%esi
 68d:	74 1b                	je     6aa <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 68f:	89 08                	mov    %ecx,(%eax)
  freep = p;
 691:	a3 f0 0a 00 00       	mov    %eax,0xaf0
}
 696:	5b                   	pop    %ebx
 697:	5e                   	pop    %esi
 698:	5f                   	pop    %edi
 699:	5d                   	pop    %ebp
 69a:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 69b:	03 72 04             	add    0x4(%edx),%esi
 69e:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a1:	8b 10                	mov    (%eax),%edx
 6a3:	8b 12                	mov    (%edx),%edx
 6a5:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6a8:	eb db                	jmp    685 <free+0x42>
    p->s.size += bp->s.size;
 6aa:	03 53 fc             	add    -0x4(%ebx),%edx
 6ad:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b0:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6b3:	89 10                	mov    %edx,(%eax)
 6b5:	eb da                	jmp    691 <free+0x4e>

000006b7 <morecore>:

static Header*
morecore(uint nu)
{
 6b7:	55                   	push   %ebp
 6b8:	89 e5                	mov    %esp,%ebp
 6ba:	53                   	push   %ebx
 6bb:	83 ec 04             	sub    $0x4,%esp
 6be:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6c0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6c5:	77 05                	ja     6cc <morecore+0x15>
    nu = 4096;
 6c7:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6cc:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6d3:	83 ec 0c             	sub    $0xc,%esp
 6d6:	50                   	push   %eax
 6d7:	e8 f1 fc ff ff       	call   3cd <sbrk>
  if(p == (char*)-1)
 6dc:	83 c4 10             	add    $0x10,%esp
 6df:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e2:	74 1c                	je     700 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6e4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6e7:	83 c0 08             	add    $0x8,%eax
 6ea:	83 ec 0c             	sub    $0xc,%esp
 6ed:	50                   	push   %eax
 6ee:	e8 50 ff ff ff       	call   643 <free>
  return freep;
 6f3:	a1 f0 0a 00 00       	mov    0xaf0,%eax
 6f8:	83 c4 10             	add    $0x10,%esp
}
 6fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6fe:	c9                   	leave  
 6ff:	c3                   	ret    
    return 0;
 700:	b8 00 00 00 00       	mov    $0x0,%eax
 705:	eb f4                	jmp    6fb <morecore+0x44>

00000707 <malloc>:

void*
malloc(uint nbytes)
{
 707:	f3 0f 1e fb          	endbr32 
 70b:	55                   	push   %ebp
 70c:	89 e5                	mov    %esp,%ebp
 70e:	53                   	push   %ebx
 70f:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	8b 45 08             	mov    0x8(%ebp),%eax
 715:	8d 58 07             	lea    0x7(%eax),%ebx
 718:	c1 eb 03             	shr    $0x3,%ebx
 71b:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 71e:	8b 0d f0 0a 00 00    	mov    0xaf0,%ecx
 724:	85 c9                	test   %ecx,%ecx
 726:	74 04                	je     72c <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 728:	8b 01                	mov    (%ecx),%eax
 72a:	eb 4b                	jmp    777 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 72c:	c7 05 f0 0a 00 00 f4 	movl   $0xaf4,0xaf0
 733:	0a 00 00 
 736:	c7 05 f4 0a 00 00 f4 	movl   $0xaf4,0xaf4
 73d:	0a 00 00 
    base.s.size = 0;
 740:	c7 05 f8 0a 00 00 00 	movl   $0x0,0xaf8
 747:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 74a:	b9 f4 0a 00 00       	mov    $0xaf4,%ecx
 74f:	eb d7                	jmp    728 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 751:	74 1a                	je     76d <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 753:	29 da                	sub    %ebx,%edx
 755:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 758:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 75b:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 75e:	89 0d f0 0a 00 00    	mov    %ecx,0xaf0
      return (void*)(p + 1);
 764:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 767:	83 c4 04             	add    $0x4,%esp
 76a:	5b                   	pop    %ebx
 76b:	5d                   	pop    %ebp
 76c:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 76d:	8b 10                	mov    (%eax),%edx
 76f:	89 11                	mov    %edx,(%ecx)
 771:	eb eb                	jmp    75e <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 773:	89 c1                	mov    %eax,%ecx
 775:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 777:	8b 50 04             	mov    0x4(%eax),%edx
 77a:	39 da                	cmp    %ebx,%edx
 77c:	73 d3                	jae    751 <malloc+0x4a>
    if(p == freep)
 77e:	39 05 f0 0a 00 00    	cmp    %eax,0xaf0
 784:	75 ed                	jne    773 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 786:	89 d8                	mov    %ebx,%eax
 788:	e8 2a ff ff ff       	call   6b7 <morecore>
 78d:	85 c0                	test   %eax,%eax
 78f:	75 e2                	jne    773 <malloc+0x6c>
 791:	eb d4                	jmp    767 <malloc+0x60>
