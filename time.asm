
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "date.h"

int
main (int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 08             	sub    $0x8,%esp
  18:	8b 79 04             	mov    0x4(%ecx),%edi
  int start;
  start = uptime();
  1b:	e8 e4 03 00 00       	call   404 <uptime>
  20:	89 c6                	mov    %eax,%esi

  int pid = fork();
  22:	e8 3d 03 00 00       	call   364 <fork>
  if (pid < 0) 
  27:	85 c0                	test   %eax,%eax
  29:	78 74                	js     9f <main+0x9f>
  2b:	89 c3                	mov    %eax,%ebx
  {
    printf(2, "Error: Invalid PID\n");
    exit();
  }
  if (pid > 0)
  2d:	0f 8f 80 00 00 00    	jg     b3 <main+0xb3>
    wait();
  if (pid == 0) 
  33:	85 db                	test   %ebx,%ebx
  35:	75 16                	jne    4d <main+0x4d>
  {
    if (exec(argv[1], argv + 1) < 0) 
  37:	83 ec 08             	sub    $0x8,%esp
  3a:	8d 47 04             	lea    0x4(%edi),%eax
  3d:	50                   	push   %eax
  3e:	ff 77 04             	pushl  0x4(%edi)
  41:	e8 5e 03 00 00       	call   3a4 <exec>
  46:	83 c4 10             	add    $0x10,%esp
  49:	85 c0                	test   %eax,%eax
  4b:	78 70                	js     bd <main+0xbd>
    {
      exit();
    }
  }

  int end = uptime();
  4d:	e8 b2 03 00 00       	call   404 <uptime>

  int sec = (end - start)/1000;
  52:	29 f0                	sub    %esi,%eax
  54:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  59:	99                   	cltd   
  5a:	f7 f9                	idiv   %ecx
  5c:	89 d6                	mov    %edx,%esi
  5e:	89 c3                	mov    %eax,%ebx
  int milli = (end - start)%1000;
  
  printf(1, "%s", argv[1]);
  60:	83 ec 04             	sub    $0x4,%esp
  63:	ff 77 04             	pushl  0x4(%edi)
  66:	68 d0 07 00 00       	push   $0x7d0
  6b:	6a 01                	push   $0x1
  6d:	e8 8b 04 00 00       	call   4fd <printf>
  printf(1, " ran in %d.", sec);
  72:	83 c4 0c             	add    $0xc,%esp
  75:	53                   	push   %ebx
  76:	68 d3 07 00 00       	push   $0x7d3
  7b:	6a 01                	push   $0x1
  7d:	e8 7b 04 00 00       	call   4fd <printf>
  if (milli < 10)
  82:	83 c4 10             	add    $0x10,%esp
  85:	83 fe 09             	cmp    $0x9,%esi
  88:	7e 38                	jle    c2 <main+0xc2>
    printf(1, "0");
  printf(1, "%d\n", milli);
  8a:	83 ec 04             	sub    $0x4,%esp
  8d:	56                   	push   %esi
  8e:	68 e1 07 00 00       	push   $0x7e1
  93:	6a 01                	push   $0x1
  95:	e8 63 04 00 00       	call   4fd <printf>
  exit();
  9a:	e8 cd 02 00 00       	call   36c <exit>
    printf(2, "Error: Invalid PID\n");
  9f:	83 ec 08             	sub    $0x8,%esp
  a2:	68 bc 07 00 00       	push   $0x7bc
  a7:	6a 02                	push   $0x2
  a9:	e8 4f 04 00 00       	call   4fd <printf>
    exit();
  ae:	e8 b9 02 00 00       	call   36c <exit>
    wait();
  b3:	e8 bc 02 00 00       	call   374 <wait>
  b8:	e9 76 ff ff ff       	jmp    33 <main+0x33>
      exit();
  bd:	e8 aa 02 00 00       	call   36c <exit>
    printf(1, "0");
  c2:	83 ec 08             	sub    $0x8,%esp
  c5:	68 df 07 00 00       	push   $0x7df
  ca:	6a 01                	push   $0x1
  cc:	e8 2c 04 00 00       	call   4fd <printf>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	eb b4                	jmp    8a <main+0x8a>

000000d6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  d6:	f3 0f 1e fb          	endbr32 
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	56                   	push   %esi
  de:	53                   	push   %ebx
  df:	8b 75 08             	mov    0x8(%ebp),%esi
  e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e5:	89 f0                	mov    %esi,%eax
  e7:	89 d1                	mov    %edx,%ecx
  e9:	83 c2 01             	add    $0x1,%edx
  ec:	89 c3                	mov    %eax,%ebx
  ee:	83 c0 01             	add    $0x1,%eax
  f1:	0f b6 09             	movzbl (%ecx),%ecx
  f4:	88 0b                	mov    %cl,(%ebx)
  f6:	84 c9                	test   %cl,%cl
  f8:	75 ed                	jne    e7 <strcpy+0x11>
    ;
  return os;
}
  fa:	89 f0                	mov    %esi,%eax
  fc:	5b                   	pop    %ebx
  fd:	5e                   	pop    %esi
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 10d:	0f b6 01             	movzbl (%ecx),%eax
 110:	84 c0                	test   %al,%al
 112:	74 0c                	je     120 <strcmp+0x20>
 114:	3a 02                	cmp    (%edx),%al
 116:	75 08                	jne    120 <strcmp+0x20>
    p++, q++;
 118:	83 c1 01             	add    $0x1,%ecx
 11b:	83 c2 01             	add    $0x1,%edx
 11e:	eb ed                	jmp    10d <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 120:	0f b6 c0             	movzbl %al,%eax
 123:	0f b6 12             	movzbl (%edx),%edx
 126:	29 d0                	sub    %edx,%eax
}
 128:	5d                   	pop    %ebp
 129:	c3                   	ret    

0000012a <strlen>:

uint
strlen(char *s)
{
 12a:	f3 0f 1e fb          	endbr32 
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
 131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 134:	b8 00 00 00 00       	mov    $0x0,%eax
 139:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 13d:	74 05                	je     144 <strlen+0x1a>
 13f:	83 c0 01             	add    $0x1,%eax
 142:	eb f5                	jmp    139 <strlen+0xf>
    ;
  return n;
}
 144:	5d                   	pop    %ebp
 145:	c3                   	ret    

00000146 <memset>:

void*
memset(void *dst, int c, uint n)
{
 146:	f3 0f 1e fb          	endbr32 
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	57                   	push   %edi
 14e:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 151:	89 d7                	mov    %edx,%edi
 153:	8b 4d 10             	mov    0x10(%ebp),%ecx
 156:	8b 45 0c             	mov    0xc(%ebp),%eax
 159:	fc                   	cld    
 15a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 15c:	89 d0                	mov    %edx,%eax
 15e:	5f                   	pop    %edi
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    

00000161 <strchr>:

char*
strchr(const char *s, char c)
{
 161:	f3 0f 1e fb          	endbr32 
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 16f:	0f b6 10             	movzbl (%eax),%edx
 172:	84 d2                	test   %dl,%dl
 174:	74 09                	je     17f <strchr+0x1e>
    if(*s == c)
 176:	38 ca                	cmp    %cl,%dl
 178:	74 0a                	je     184 <strchr+0x23>
  for(; *s; s++)
 17a:	83 c0 01             	add    $0x1,%eax
 17d:	eb f0                	jmp    16f <strchr+0xe>
      return (char*)s;
  return 0;
 17f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    

00000186 <gets>:

char*
gets(char *buf, int max)
{
 186:	f3 0f 1e fb          	endbr32 
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	57                   	push   %edi
 18e:	56                   	push   %esi
 18f:	53                   	push   %ebx
 190:	83 ec 1c             	sub    $0x1c,%esp
 193:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 196:	bb 00 00 00 00       	mov    $0x0,%ebx
 19b:	89 de                	mov    %ebx,%esi
 19d:	83 c3 01             	add    $0x1,%ebx
 1a0:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1a3:	7d 2e                	jge    1d3 <gets+0x4d>
    cc = read(0, &c, 1);
 1a5:	83 ec 04             	sub    $0x4,%esp
 1a8:	6a 01                	push   $0x1
 1aa:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1ad:	50                   	push   %eax
 1ae:	6a 00                	push   $0x0
 1b0:	e8 cf 01 00 00       	call   384 <read>
    if(cc < 1)
 1b5:	83 c4 10             	add    $0x10,%esp
 1b8:	85 c0                	test   %eax,%eax
 1ba:	7e 17                	jle    1d3 <gets+0x4d>
      break;
    buf[i++] = c;
 1bc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1c0:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1c3:	3c 0a                	cmp    $0xa,%al
 1c5:	0f 94 c2             	sete   %dl
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	0f 94 c0             	sete   %al
 1cd:	08 c2                	or     %al,%dl
 1cf:	74 ca                	je     19b <gets+0x15>
    buf[i++] = c;
 1d1:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1d3:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1d7:	89 f8                	mov    %edi,%eax
 1d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    

000001e1 <stat>:

int
stat(char *n, struct stat *st)
{
 1e1:	f3 0f 1e fb          	endbr32 
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	56                   	push   %esi
 1e9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ea:	83 ec 08             	sub    $0x8,%esp
 1ed:	6a 00                	push   $0x0
 1ef:	ff 75 08             	pushl  0x8(%ebp)
 1f2:	e8 b5 01 00 00       	call   3ac <open>
  if(fd < 0)
 1f7:	83 c4 10             	add    $0x10,%esp
 1fa:	85 c0                	test   %eax,%eax
 1fc:	78 24                	js     222 <stat+0x41>
 1fe:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 200:	83 ec 08             	sub    $0x8,%esp
 203:	ff 75 0c             	pushl  0xc(%ebp)
 206:	50                   	push   %eax
 207:	e8 b8 01 00 00       	call   3c4 <fstat>
 20c:	89 c6                	mov    %eax,%esi
  close(fd);
 20e:	89 1c 24             	mov    %ebx,(%esp)
 211:	e8 7e 01 00 00       	call   394 <close>
  return r;
 216:	83 c4 10             	add    $0x10,%esp
}
 219:	89 f0                	mov    %esi,%eax
 21b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 21e:	5b                   	pop    %ebx
 21f:	5e                   	pop    %esi
 220:	5d                   	pop    %ebp
 221:	c3                   	ret    
    return -1;
 222:	be ff ff ff ff       	mov    $0xffffffff,%esi
 227:	eb f0                	jmp    219 <stat+0x38>

00000229 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 229:	f3 0f 1e fb          	endbr32 
 22d:	55                   	push   %ebp
 22e:	89 e5                	mov    %esp,%ebp
 230:	57                   	push   %edi
 231:	56                   	push   %esi
 232:	53                   	push   %ebx
 233:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 236:	0f b6 02             	movzbl (%edx),%eax
 239:	3c 20                	cmp    $0x20,%al
 23b:	75 05                	jne    242 <atoi+0x19>
 23d:	83 c2 01             	add    $0x1,%edx
 240:	eb f4                	jmp    236 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 242:	3c 2d                	cmp    $0x2d,%al
 244:	74 1d                	je     263 <atoi+0x3a>
 246:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 24b:	3c 2b                	cmp    $0x2b,%al
 24d:	0f 94 c1             	sete   %cl
 250:	3c 2d                	cmp    $0x2d,%al
 252:	0f 94 c0             	sete   %al
 255:	08 c1                	or     %al,%cl
 257:	74 03                	je     25c <atoi+0x33>
    s++;
 259:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 25c:	b8 00 00 00 00       	mov    $0x0,%eax
 261:	eb 17                	jmp    27a <atoi+0x51>
 263:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 268:	eb e1                	jmp    24b <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 26a:	8d 34 80             	lea    (%eax,%eax,4),%esi
 26d:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 270:	83 c2 01             	add    $0x1,%edx
 273:	0f be c9             	movsbl %cl,%ecx
 276:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 27a:	0f b6 0a             	movzbl (%edx),%ecx
 27d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	76 e5                	jbe    26a <atoi+0x41>
  return sign*n;
 285:	0f af c7             	imul   %edi,%eax
}
 288:	5b                   	pop    %ebx
 289:	5e                   	pop    %esi
 28a:	5f                   	pop    %edi
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    

0000028d <atoo>:

int
atoo(const char *s)
{
 28d:	f3 0f 1e fb          	endbr32 
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
 294:	57                   	push   %edi
 295:	56                   	push   %esi
 296:	53                   	push   %ebx
 297:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 29a:	0f b6 0a             	movzbl (%edx),%ecx
 29d:	80 f9 20             	cmp    $0x20,%cl
 2a0:	75 05                	jne    2a7 <atoo+0x1a>
 2a2:	83 c2 01             	add    $0x1,%edx
 2a5:	eb f3                	jmp    29a <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 2a7:	80 f9 2d             	cmp    $0x2d,%cl
 2aa:	74 23                	je     2cf <atoo+0x42>
 2ac:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 2b1:	80 f9 2b             	cmp    $0x2b,%cl
 2b4:	0f 94 c0             	sete   %al
 2b7:	89 c6                	mov    %eax,%esi
 2b9:	80 f9 2d             	cmp    $0x2d,%cl
 2bc:	0f 94 c0             	sete   %al
 2bf:	89 f3                	mov    %esi,%ebx
 2c1:	08 c3                	or     %al,%bl
 2c3:	74 03                	je     2c8 <atoo+0x3b>
    s++;
 2c5:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 2c8:	b8 00 00 00 00       	mov    $0x0,%eax
 2cd:	eb 11                	jmp    2e0 <atoo+0x53>
 2cf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 2d4:	eb db                	jmp    2b1 <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 2d6:	83 c2 01             	add    $0x1,%edx
 2d9:	0f be c9             	movsbl %cl,%ecx
 2dc:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2e0:	0f b6 0a             	movzbl (%edx),%ecx
 2e3:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2e6:	80 fb 07             	cmp    $0x7,%bl
 2e9:	76 eb                	jbe    2d6 <atoo+0x49>
  return sign*n;
 2eb:	0f af c7             	imul   %edi,%eax
}
 2ee:	5b                   	pop    %ebx
 2ef:	5e                   	pop    %esi
 2f0:	5f                   	pop    %edi
 2f1:	5d                   	pop    %ebp
 2f2:	c3                   	ret    

000002f3 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2f3:	f3 0f 1e fb          	endbr32 
 2f7:	55                   	push   %ebp
 2f8:	89 e5                	mov    %esp,%ebp
 2fa:	53                   	push   %ebx
 2fb:	8b 55 08             	mov    0x8(%ebp),%edx
 2fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 301:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 304:	eb 09                	jmp    30f <strncmp+0x1c>
      n--, p++, q++;
 306:	83 e8 01             	sub    $0x1,%eax
 309:	83 c2 01             	add    $0x1,%edx
 30c:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 30f:	85 c0                	test   %eax,%eax
 311:	74 0b                	je     31e <strncmp+0x2b>
 313:	0f b6 1a             	movzbl (%edx),%ebx
 316:	84 db                	test   %bl,%bl
 318:	74 04                	je     31e <strncmp+0x2b>
 31a:	3a 19                	cmp    (%ecx),%bl
 31c:	74 e8                	je     306 <strncmp+0x13>
    if(n == 0)
 31e:	85 c0                	test   %eax,%eax
 320:	74 0b                	je     32d <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 322:	0f b6 02             	movzbl (%edx),%eax
 325:	0f b6 11             	movzbl (%ecx),%edx
 328:	29 d0                	sub    %edx,%eax
}
 32a:	5b                   	pop    %ebx
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
      return 0;
 32d:	b8 00 00 00 00       	mov    $0x0,%eax
 332:	eb f6                	jmp    32a <strncmp+0x37>

00000334 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 334:	f3 0f 1e fb          	endbr32 
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	56                   	push   %esi
 33c:	53                   	push   %ebx
 33d:	8b 75 08             	mov    0x8(%ebp),%esi
 340:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 343:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 346:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 348:	8d 58 ff             	lea    -0x1(%eax),%ebx
 34b:	85 c0                	test   %eax,%eax
 34d:	7e 0f                	jle    35e <memmove+0x2a>
    *dst++ = *src++;
 34f:	0f b6 01             	movzbl (%ecx),%eax
 352:	88 02                	mov    %al,(%edx)
 354:	8d 49 01             	lea    0x1(%ecx),%ecx
 357:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 35a:	89 d8                	mov    %ebx,%eax
 35c:	eb ea                	jmp    348 <memmove+0x14>
  return vdst;
}
 35e:	89 f0                	mov    %esi,%eax
 360:	5b                   	pop    %ebx
 361:	5e                   	pop    %esi
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    

00000364 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 364:	b8 01 00 00 00       	mov    $0x1,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <exit>:
SYSCALL(exit)
 36c:	b8 02 00 00 00       	mov    $0x2,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <wait>:
SYSCALL(wait)
 374:	b8 03 00 00 00       	mov    $0x3,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <pipe>:
SYSCALL(pipe)
 37c:	b8 04 00 00 00       	mov    $0x4,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <read>:
SYSCALL(read)
 384:	b8 05 00 00 00       	mov    $0x5,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <write>:
SYSCALL(write)
 38c:	b8 10 00 00 00       	mov    $0x10,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <close>:
SYSCALL(close)
 394:	b8 15 00 00 00       	mov    $0x15,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <kill>:
SYSCALL(kill)
 39c:	b8 06 00 00 00       	mov    $0x6,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <exec>:
SYSCALL(exec)
 3a4:	b8 07 00 00 00       	mov    $0x7,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <open>:
SYSCALL(open)
 3ac:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <mknod>:
SYSCALL(mknod)
 3b4:	b8 11 00 00 00       	mov    $0x11,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <unlink>:
SYSCALL(unlink)
 3bc:	b8 12 00 00 00       	mov    $0x12,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <fstat>:
SYSCALL(fstat)
 3c4:	b8 08 00 00 00       	mov    $0x8,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <link>:
SYSCALL(link)
 3cc:	b8 13 00 00 00       	mov    $0x13,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <mkdir>:
SYSCALL(mkdir)
 3d4:	b8 14 00 00 00       	mov    $0x14,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <chdir>:
SYSCALL(chdir)
 3dc:	b8 09 00 00 00       	mov    $0x9,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <dup>:
SYSCALL(dup)
 3e4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <getpid>:
SYSCALL(getpid)
 3ec:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <sbrk>:
SYSCALL(sbrk)
 3f4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <sleep>:
SYSCALL(sleep)
 3fc:	b8 0d 00 00 00       	mov    $0xd,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <uptime>:
SYSCALL(uptime)
 404:	b8 0e 00 00 00       	mov    $0xe,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <halt>:
SYSCALL(halt)
 40c:	b8 16 00 00 00       	mov    $0x16,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <date>:
SYSCALL(date)
 414:	b8 17 00 00 00       	mov    $0x17,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <getuid>:
SYSCALL(getuid)
 41c:	b8 18 00 00 00       	mov    $0x18,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <getgid>:
SYSCALL(getgid)
 424:	b8 19 00 00 00       	mov    $0x19,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <getppid>:
SYSCALL(getppid)
 42c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <setuid>:
SYSCALL(setuid)
 434:	b8 1b 00 00 00       	mov    $0x1b,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <setgid>:
SYSCALL(setgid)
 43c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <getprocs>:
SYSCALL(getprocs)
 444:	b8 1d 00 00 00       	mov    $0x1d,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <setpriority>:
SYSCALL(setpriority)
 44c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <getpriority>:
SYSCALL(getpriority)
 454:	b8 1f 00 00 00       	mov    $0x1f,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	83 ec 1c             	sub    $0x1c,%esp
 462:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 465:	6a 01                	push   $0x1
 467:	8d 55 f4             	lea    -0xc(%ebp),%edx
 46a:	52                   	push   %edx
 46b:	50                   	push   %eax
 46c:	e8 1b ff ff ff       	call   38c <write>
}
 471:	83 c4 10             	add    $0x10,%esp
 474:	c9                   	leave  
 475:	c3                   	ret    

00000476 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 476:	55                   	push   %ebp
 477:	89 e5                	mov    %esp,%ebp
 479:	57                   	push   %edi
 47a:	56                   	push   %esi
 47b:	53                   	push   %ebx
 47c:	83 ec 2c             	sub    $0x2c,%esp
 47f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 482:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 484:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 488:	0f 95 c2             	setne  %dl
 48b:	89 f0                	mov    %esi,%eax
 48d:	c1 e8 1f             	shr    $0x1f,%eax
 490:	84 c2                	test   %al,%dl
 492:	74 42                	je     4d6 <printint+0x60>
    neg = 1;
    x = -xx;
 494:	f7 de                	neg    %esi
    neg = 1;
 496:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 49d:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 4a2:	89 f0                	mov    %esi,%eax
 4a4:	ba 00 00 00 00       	mov    $0x0,%edx
 4a9:	f7 f1                	div    %ecx
 4ab:	89 df                	mov    %ebx,%edi
 4ad:	83 c3 01             	add    $0x1,%ebx
 4b0:	0f b6 92 ec 07 00 00 	movzbl 0x7ec(%edx),%edx
 4b7:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 4bb:	89 f2                	mov    %esi,%edx
 4bd:	89 c6                	mov    %eax,%esi
 4bf:	39 d1                	cmp    %edx,%ecx
 4c1:	76 df                	jbe    4a2 <printint+0x2c>
  if(neg)
 4c3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 4c7:	74 2f                	je     4f8 <printint+0x82>
    buf[i++] = '-';
 4c9:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4ce:	8d 5f 02             	lea    0x2(%edi),%ebx
 4d1:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4d4:	eb 15                	jmp    4eb <printint+0x75>
  neg = 0;
 4d6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 4dd:	eb be                	jmp    49d <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 4df:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4e4:	89 f0                	mov    %esi,%eax
 4e6:	e8 71 ff ff ff       	call   45c <putc>
  while(--i >= 0)
 4eb:	83 eb 01             	sub    $0x1,%ebx
 4ee:	79 ef                	jns    4df <printint+0x69>
}
 4f0:	83 c4 2c             	add    $0x2c,%esp
 4f3:	5b                   	pop    %ebx
 4f4:	5e                   	pop    %esi
 4f5:	5f                   	pop    %edi
 4f6:	5d                   	pop    %ebp
 4f7:	c3                   	ret    
 4f8:	8b 75 d0             	mov    -0x30(%ebp),%esi
 4fb:	eb ee                	jmp    4eb <printint+0x75>

000004fd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4fd:	f3 0f 1e fb          	endbr32 
 501:	55                   	push   %ebp
 502:	89 e5                	mov    %esp,%ebp
 504:	57                   	push   %edi
 505:	56                   	push   %esi
 506:	53                   	push   %ebx
 507:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 50a:	8d 45 10             	lea    0x10(%ebp),%eax
 50d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 510:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 515:	bb 00 00 00 00       	mov    $0x0,%ebx
 51a:	eb 14                	jmp    530 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 51c:	89 fa                	mov    %edi,%edx
 51e:	8b 45 08             	mov    0x8(%ebp),%eax
 521:	e8 36 ff ff ff       	call   45c <putc>
 526:	eb 05                	jmp    52d <printf+0x30>
      }
    } else if(state == '%'){
 528:	83 fe 25             	cmp    $0x25,%esi
 52b:	74 25                	je     552 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 52d:	83 c3 01             	add    $0x1,%ebx
 530:	8b 45 0c             	mov    0xc(%ebp),%eax
 533:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 537:	84 c0                	test   %al,%al
 539:	0f 84 23 01 00 00    	je     662 <printf+0x165>
    c = fmt[i] & 0xff;
 53f:	0f be f8             	movsbl %al,%edi
 542:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 545:	85 f6                	test   %esi,%esi
 547:	75 df                	jne    528 <printf+0x2b>
      if(c == '%'){
 549:	83 f8 25             	cmp    $0x25,%eax
 54c:	75 ce                	jne    51c <printf+0x1f>
        state = '%';
 54e:	89 c6                	mov    %eax,%esi
 550:	eb db                	jmp    52d <printf+0x30>
      if(c == 'd'){
 552:	83 f8 64             	cmp    $0x64,%eax
 555:	74 49                	je     5a0 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 557:	83 f8 78             	cmp    $0x78,%eax
 55a:	0f 94 c1             	sete   %cl
 55d:	83 f8 70             	cmp    $0x70,%eax
 560:	0f 94 c2             	sete   %dl
 563:	08 d1                	or     %dl,%cl
 565:	75 63                	jne    5ca <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 567:	83 f8 73             	cmp    $0x73,%eax
 56a:	0f 84 84 00 00 00    	je     5f4 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 570:	83 f8 63             	cmp    $0x63,%eax
 573:	0f 84 b7 00 00 00    	je     630 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 579:	83 f8 25             	cmp    $0x25,%eax
 57c:	0f 84 cc 00 00 00    	je     64e <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 582:	ba 25 00 00 00       	mov    $0x25,%edx
 587:	8b 45 08             	mov    0x8(%ebp),%eax
 58a:	e8 cd fe ff ff       	call   45c <putc>
        putc(fd, c);
 58f:	89 fa                	mov    %edi,%edx
 591:	8b 45 08             	mov    0x8(%ebp),%eax
 594:	e8 c3 fe ff ff       	call   45c <putc>
      }
      state = 0;
 599:	be 00 00 00 00       	mov    $0x0,%esi
 59e:	eb 8d                	jmp    52d <printf+0x30>
        printint(fd, *ap, 10, 1);
 5a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5a3:	8b 17                	mov    (%edi),%edx
 5a5:	83 ec 0c             	sub    $0xc,%esp
 5a8:	6a 01                	push   $0x1
 5aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	e8 bf fe ff ff       	call   476 <printint>
        ap++;
 5b7:	83 c7 04             	add    $0x4,%edi
 5ba:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5bd:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5c0:	be 00 00 00 00       	mov    $0x0,%esi
 5c5:	e9 63 ff ff ff       	jmp    52d <printf+0x30>
        printint(fd, *ap, 16, 0);
 5ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5cd:	8b 17                	mov    (%edi),%edx
 5cf:	83 ec 0c             	sub    $0xc,%esp
 5d2:	6a 00                	push   $0x0
 5d4:	b9 10 00 00 00       	mov    $0x10,%ecx
 5d9:	8b 45 08             	mov    0x8(%ebp),%eax
 5dc:	e8 95 fe ff ff       	call   476 <printint>
        ap++;
 5e1:	83 c7 04             	add    $0x4,%edi
 5e4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 5e7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ea:	be 00 00 00 00       	mov    $0x0,%esi
 5ef:	e9 39 ff ff ff       	jmp    52d <printf+0x30>
        s = (char*)*ap;
 5f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f7:	8b 30                	mov    (%eax),%esi
        ap++;
 5f9:	83 c0 04             	add    $0x4,%eax
 5fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5ff:	85 f6                	test   %esi,%esi
 601:	75 28                	jne    62b <printf+0x12e>
          s = "(null)";
 603:	be e5 07 00 00       	mov    $0x7e5,%esi
 608:	8b 7d 08             	mov    0x8(%ebp),%edi
 60b:	eb 0d                	jmp    61a <printf+0x11d>
          putc(fd, *s);
 60d:	0f be d2             	movsbl %dl,%edx
 610:	89 f8                	mov    %edi,%eax
 612:	e8 45 fe ff ff       	call   45c <putc>
          s++;
 617:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 61a:	0f b6 16             	movzbl (%esi),%edx
 61d:	84 d2                	test   %dl,%dl
 61f:	75 ec                	jne    60d <printf+0x110>
      state = 0;
 621:	be 00 00 00 00       	mov    $0x0,%esi
 626:	e9 02 ff ff ff       	jmp    52d <printf+0x30>
 62b:	8b 7d 08             	mov    0x8(%ebp),%edi
 62e:	eb ea                	jmp    61a <printf+0x11d>
        putc(fd, *ap);
 630:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 633:	0f be 17             	movsbl (%edi),%edx
 636:	8b 45 08             	mov    0x8(%ebp),%eax
 639:	e8 1e fe ff ff       	call   45c <putc>
        ap++;
 63e:	83 c7 04             	add    $0x4,%edi
 641:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 644:	be 00 00 00 00       	mov    $0x0,%esi
 649:	e9 df fe ff ff       	jmp    52d <printf+0x30>
        putc(fd, c);
 64e:	89 fa                	mov    %edi,%edx
 650:	8b 45 08             	mov    0x8(%ebp),%eax
 653:	e8 04 fe ff ff       	call   45c <putc>
      state = 0;
 658:	be 00 00 00 00       	mov    $0x0,%esi
 65d:	e9 cb fe ff ff       	jmp    52d <printf+0x30>
    }
  }
}
 662:	8d 65 f4             	lea    -0xc(%ebp),%esp
 665:	5b                   	pop    %ebx
 666:	5e                   	pop    %esi
 667:	5f                   	pop    %edi
 668:	5d                   	pop    %ebp
 669:	c3                   	ret    

0000066a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66a:	f3 0f 1e fb          	endbr32 
 66e:	55                   	push   %ebp
 66f:	89 e5                	mov    %esp,%ebp
 671:	57                   	push   %edi
 672:	56                   	push   %esi
 673:	53                   	push   %ebx
 674:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 677:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 67a:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 67f:	eb 02                	jmp    683 <free+0x19>
 681:	89 d0                	mov    %edx,%eax
 683:	39 c8                	cmp    %ecx,%eax
 685:	73 04                	jae    68b <free+0x21>
 687:	39 08                	cmp    %ecx,(%eax)
 689:	77 12                	ja     69d <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68b:	8b 10                	mov    (%eax),%edx
 68d:	39 c2                	cmp    %eax,%edx
 68f:	77 f0                	ja     681 <free+0x17>
 691:	39 c8                	cmp    %ecx,%eax
 693:	72 08                	jb     69d <free+0x33>
 695:	39 ca                	cmp    %ecx,%edx
 697:	77 04                	ja     69d <free+0x33>
 699:	89 d0                	mov    %edx,%eax
 69b:	eb e6                	jmp    683 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 69d:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6a0:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6a3:	8b 10                	mov    (%eax),%edx
 6a5:	39 d7                	cmp    %edx,%edi
 6a7:	74 19                	je     6c2 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6a9:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ac:	8b 50 04             	mov    0x4(%eax),%edx
 6af:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6b2:	39 ce                	cmp    %ecx,%esi
 6b4:	74 1b                	je     6d1 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6b6:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6b8:	a3 f4 0a 00 00       	mov    %eax,0xaf4
}
 6bd:	5b                   	pop    %ebx
 6be:	5e                   	pop    %esi
 6bf:	5f                   	pop    %edi
 6c0:	5d                   	pop    %ebp
 6c1:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6c2:	03 72 04             	add    0x4(%edx),%esi
 6c5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c8:	8b 10                	mov    (%eax),%edx
 6ca:	8b 12                	mov    (%edx),%edx
 6cc:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6cf:	eb db                	jmp    6ac <free+0x42>
    p->s.size += bp->s.size;
 6d1:	03 53 fc             	add    -0x4(%ebx),%edx
 6d4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d7:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6da:	89 10                	mov    %edx,(%eax)
 6dc:	eb da                	jmp    6b8 <free+0x4e>

000006de <morecore>:

static Header*
morecore(uint nu)
{
 6de:	55                   	push   %ebp
 6df:	89 e5                	mov    %esp,%ebp
 6e1:	53                   	push   %ebx
 6e2:	83 ec 04             	sub    $0x4,%esp
 6e5:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6e7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6ec:	77 05                	ja     6f3 <morecore+0x15>
    nu = 4096;
 6ee:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6f3:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6fa:	83 ec 0c             	sub    $0xc,%esp
 6fd:	50                   	push   %eax
 6fe:	e8 f1 fc ff ff       	call   3f4 <sbrk>
  if(p == (char*)-1)
 703:	83 c4 10             	add    $0x10,%esp
 706:	83 f8 ff             	cmp    $0xffffffff,%eax
 709:	74 1c                	je     727 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 70b:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 70e:	83 c0 08             	add    $0x8,%eax
 711:	83 ec 0c             	sub    $0xc,%esp
 714:	50                   	push   %eax
 715:	e8 50 ff ff ff       	call   66a <free>
  return freep;
 71a:	a1 f4 0a 00 00       	mov    0xaf4,%eax
 71f:	83 c4 10             	add    $0x10,%esp
}
 722:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 725:	c9                   	leave  
 726:	c3                   	ret    
    return 0;
 727:	b8 00 00 00 00       	mov    $0x0,%eax
 72c:	eb f4                	jmp    722 <morecore+0x44>

0000072e <malloc>:

void*
malloc(uint nbytes)
{
 72e:	f3 0f 1e fb          	endbr32 
 732:	55                   	push   %ebp
 733:	89 e5                	mov    %esp,%ebp
 735:	53                   	push   %ebx
 736:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	8d 58 07             	lea    0x7(%eax),%ebx
 73f:	c1 eb 03             	shr    $0x3,%ebx
 742:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 745:	8b 0d f4 0a 00 00    	mov    0xaf4,%ecx
 74b:	85 c9                	test   %ecx,%ecx
 74d:	74 04                	je     753 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 74f:	8b 01                	mov    (%ecx),%eax
 751:	eb 4b                	jmp    79e <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 753:	c7 05 f4 0a 00 00 f8 	movl   $0xaf8,0xaf4
 75a:	0a 00 00 
 75d:	c7 05 f8 0a 00 00 f8 	movl   $0xaf8,0xaf8
 764:	0a 00 00 
    base.s.size = 0;
 767:	c7 05 fc 0a 00 00 00 	movl   $0x0,0xafc
 76e:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 771:	b9 f8 0a 00 00       	mov    $0xaf8,%ecx
 776:	eb d7                	jmp    74f <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 778:	74 1a                	je     794 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 77a:	29 da                	sub    %ebx,%edx
 77c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 77f:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 782:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 785:	89 0d f4 0a 00 00    	mov    %ecx,0xaf4
      return (void*)(p + 1);
 78b:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 78e:	83 c4 04             	add    $0x4,%esp
 791:	5b                   	pop    %ebx
 792:	5d                   	pop    %ebp
 793:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 794:	8b 10                	mov    (%eax),%edx
 796:	89 11                	mov    %edx,(%ecx)
 798:	eb eb                	jmp    785 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79a:	89 c1                	mov    %eax,%ecx
 79c:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 79e:	8b 50 04             	mov    0x4(%eax),%edx
 7a1:	39 da                	cmp    %ebx,%edx
 7a3:	73 d3                	jae    778 <malloc+0x4a>
    if(p == freep)
 7a5:	39 05 f4 0a 00 00    	cmp    %eax,0xaf4
 7ab:	75 ed                	jne    79a <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 7ad:	89 d8                	mov    %ebx,%eax
 7af:	e8 2a ff ff ff       	call   6de <morecore>
 7b4:	85 c0                	test   %eax,%eax
 7b6:	75 e2                	jne    79a <malloc+0x6c>
 7b8:	eb d4                	jmp    78e <malloc+0x60>
