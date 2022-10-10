
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  15:	e8 a6 02 00 00       	call   2c0 <fork>
  1a:	85 c0                	test   %eax,%eax
  1c:	7f 05                	jg     23 <main+0x23>
    sleep(5);  // Let child exit before parent.
  exit();
  1e:	e8 a5 02 00 00       	call   2c8 <exit>
    sleep(5);  // Let child exit before parent.
  23:	83 ec 0c             	sub    $0xc,%esp
  26:	6a 05                	push   $0x5
  28:	e8 2b 03 00 00       	call   358 <sleep>
  2d:	83 c4 10             	add    $0x10,%esp
  30:	eb ec                	jmp    1e <main+0x1e>

00000032 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  32:	f3 0f 1e fb          	endbr32 
  36:	55                   	push   %ebp
  37:	89 e5                	mov    %esp,%ebp
  39:	56                   	push   %esi
  3a:	53                   	push   %ebx
  3b:	8b 75 08             	mov    0x8(%ebp),%esi
  3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  41:	89 f0                	mov    %esi,%eax
  43:	89 d1                	mov    %edx,%ecx
  45:	83 c2 01             	add    $0x1,%edx
  48:	89 c3                	mov    %eax,%ebx
  4a:	83 c0 01             	add    $0x1,%eax
  4d:	0f b6 09             	movzbl (%ecx),%ecx
  50:	88 0b                	mov    %cl,(%ebx)
  52:	84 c9                	test   %cl,%cl
  54:	75 ed                	jne    43 <strcpy+0x11>
    ;
  return os;
}
  56:	89 f0                	mov    %esi,%eax
  58:	5b                   	pop    %ebx
  59:	5e                   	pop    %esi
  5a:	5d                   	pop    %ebp
  5b:	c3                   	ret    

0000005c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  5c:	f3 0f 1e fb          	endbr32 
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  66:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  69:	0f b6 01             	movzbl (%ecx),%eax
  6c:	84 c0                	test   %al,%al
  6e:	74 0c                	je     7c <strcmp+0x20>
  70:	3a 02                	cmp    (%edx),%al
  72:	75 08                	jne    7c <strcmp+0x20>
    p++, q++;
  74:	83 c1 01             	add    $0x1,%ecx
  77:	83 c2 01             	add    $0x1,%edx
  7a:	eb ed                	jmp    69 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  7c:	0f b6 c0             	movzbl %al,%eax
  7f:	0f b6 12             	movzbl (%edx),%edx
  82:	29 d0                	sub    %edx,%eax
}
  84:	5d                   	pop    %ebp
  85:	c3                   	ret    

00000086 <strlen>:

uint
strlen(char *s)
{
  86:	f3 0f 1e fb          	endbr32 
  8a:	55                   	push   %ebp
  8b:	89 e5                	mov    %esp,%ebp
  8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  90:	b8 00 00 00 00       	mov    $0x0,%eax
  95:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  99:	74 05                	je     a0 <strlen+0x1a>
  9b:	83 c0 01             	add    $0x1,%eax
  9e:	eb f5                	jmp    95 <strlen+0xf>
    ;
  return n;
}
  a0:	5d                   	pop    %ebp
  a1:	c3                   	ret    

000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	f3 0f 1e fb          	endbr32 
  a6:	55                   	push   %ebp
  a7:	89 e5                	mov    %esp,%ebp
  a9:	57                   	push   %edi
  aa:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ad:	89 d7                	mov    %edx,%edi
  af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	fc                   	cld    
  b6:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b8:	89 d0                	mov    %edx,%eax
  ba:	5f                   	pop    %edi
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    

000000bd <strchr>:

char*
strchr(const char *s, char c)
{
  bd:	f3 0f 1e fb          	endbr32 
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  cb:	0f b6 10             	movzbl (%eax),%edx
  ce:	84 d2                	test   %dl,%dl
  d0:	74 09                	je     db <strchr+0x1e>
    if(*s == c)
  d2:	38 ca                	cmp    %cl,%dl
  d4:	74 0a                	je     e0 <strchr+0x23>
  for(; *s; s++)
  d6:	83 c0 01             	add    $0x1,%eax
  d9:	eb f0                	jmp    cb <strchr+0xe>
      return (char*)s;
  return 0;
  db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e0:	5d                   	pop    %ebp
  e1:	c3                   	ret    

000000e2 <gets>:

char*
gets(char *buf, int max)
{
  e2:	f3 0f 1e fb          	endbr32 
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  e9:	57                   	push   %edi
  ea:	56                   	push   %esi
  eb:	53                   	push   %ebx
  ec:	83 ec 1c             	sub    $0x1c,%esp
  ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  f7:	89 de                	mov    %ebx,%esi
  f9:	83 c3 01             	add    $0x1,%ebx
  fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  ff:	7d 2e                	jge    12f <gets+0x4d>
    cc = read(0, &c, 1);
 101:	83 ec 04             	sub    $0x4,%esp
 104:	6a 01                	push   $0x1
 106:	8d 45 e7             	lea    -0x19(%ebp),%eax
 109:	50                   	push   %eax
 10a:	6a 00                	push   $0x0
 10c:	e8 cf 01 00 00       	call   2e0 <read>
    if(cc < 1)
 111:	83 c4 10             	add    $0x10,%esp
 114:	85 c0                	test   %eax,%eax
 116:	7e 17                	jle    12f <gets+0x4d>
      break;
    buf[i++] = c;
 118:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 11c:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 11f:	3c 0a                	cmp    $0xa,%al
 121:	0f 94 c2             	sete   %dl
 124:	3c 0d                	cmp    $0xd,%al
 126:	0f 94 c0             	sete   %al
 129:	08 c2                	or     %al,%dl
 12b:	74 ca                	je     f7 <gets+0x15>
    buf[i++] = c;
 12d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 12f:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 133:	89 f8                	mov    %edi,%eax
 135:	8d 65 f4             	lea    -0xc(%ebp),%esp
 138:	5b                   	pop    %ebx
 139:	5e                   	pop    %esi
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <stat>:

int
stat(char *n, struct stat *st)
{
 13d:	f3 0f 1e fb          	endbr32 
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	56                   	push   %esi
 145:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 146:	83 ec 08             	sub    $0x8,%esp
 149:	6a 00                	push   $0x0
 14b:	ff 75 08             	pushl  0x8(%ebp)
 14e:	e8 b5 01 00 00       	call   308 <open>
  if(fd < 0)
 153:	83 c4 10             	add    $0x10,%esp
 156:	85 c0                	test   %eax,%eax
 158:	78 24                	js     17e <stat+0x41>
 15a:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 15c:	83 ec 08             	sub    $0x8,%esp
 15f:	ff 75 0c             	pushl  0xc(%ebp)
 162:	50                   	push   %eax
 163:	e8 b8 01 00 00       	call   320 <fstat>
 168:	89 c6                	mov    %eax,%esi
  close(fd);
 16a:	89 1c 24             	mov    %ebx,(%esp)
 16d:	e8 7e 01 00 00       	call   2f0 <close>
  return r;
 172:	83 c4 10             	add    $0x10,%esp
}
 175:	89 f0                	mov    %esi,%eax
 177:	8d 65 f8             	lea    -0x8(%ebp),%esp
 17a:	5b                   	pop    %ebx
 17b:	5e                   	pop    %esi
 17c:	5d                   	pop    %ebp
 17d:	c3                   	ret    
    return -1;
 17e:	be ff ff ff ff       	mov    $0xffffffff,%esi
 183:	eb f0                	jmp    175 <stat+0x38>

00000185 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 185:	f3 0f 1e fb          	endbr32 
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	57                   	push   %edi
 18d:	56                   	push   %esi
 18e:	53                   	push   %ebx
 18f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 192:	0f b6 02             	movzbl (%edx),%eax
 195:	3c 20                	cmp    $0x20,%al
 197:	75 05                	jne    19e <atoi+0x19>
 199:	83 c2 01             	add    $0x1,%edx
 19c:	eb f4                	jmp    192 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 19e:	3c 2d                	cmp    $0x2d,%al
 1a0:	74 1d                	je     1bf <atoi+0x3a>
 1a2:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1a7:	3c 2b                	cmp    $0x2b,%al
 1a9:	0f 94 c1             	sete   %cl
 1ac:	3c 2d                	cmp    $0x2d,%al
 1ae:	0f 94 c0             	sete   %al
 1b1:	08 c1                	or     %al,%cl
 1b3:	74 03                	je     1b8 <atoi+0x33>
    s++;
 1b5:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 1b8:	b8 00 00 00 00       	mov    $0x0,%eax
 1bd:	eb 17                	jmp    1d6 <atoi+0x51>
 1bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1c4:	eb e1                	jmp    1a7 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1c6:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1c9:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1cc:	83 c2 01             	add    $0x1,%edx
 1cf:	0f be c9             	movsbl %cl,%ecx
 1d2:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 1d6:	0f b6 0a             	movzbl (%edx),%ecx
 1d9:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1dc:	80 fb 09             	cmp    $0x9,%bl
 1df:	76 e5                	jbe    1c6 <atoi+0x41>
  return sign*n;
 1e1:	0f af c7             	imul   %edi,%eax
}
 1e4:	5b                   	pop    %ebx
 1e5:	5e                   	pop    %esi
 1e6:	5f                   	pop    %edi
 1e7:	5d                   	pop    %ebp
 1e8:	c3                   	ret    

000001e9 <atoo>:

int
atoo(const char *s)
{
 1e9:	f3 0f 1e fb          	endbr32 
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	57                   	push   %edi
 1f1:	56                   	push   %esi
 1f2:	53                   	push   %ebx
 1f3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1f6:	0f b6 0a             	movzbl (%edx),%ecx
 1f9:	80 f9 20             	cmp    $0x20,%cl
 1fc:	75 05                	jne    203 <atoo+0x1a>
 1fe:	83 c2 01             	add    $0x1,%edx
 201:	eb f3                	jmp    1f6 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 203:	80 f9 2d             	cmp    $0x2d,%cl
 206:	74 23                	je     22b <atoo+0x42>
 208:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 20d:	80 f9 2b             	cmp    $0x2b,%cl
 210:	0f 94 c0             	sete   %al
 213:	89 c6                	mov    %eax,%esi
 215:	80 f9 2d             	cmp    $0x2d,%cl
 218:	0f 94 c0             	sete   %al
 21b:	89 f3                	mov    %esi,%ebx
 21d:	08 c3                	or     %al,%bl
 21f:	74 03                	je     224 <atoo+0x3b>
    s++;
 221:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 224:	b8 00 00 00 00       	mov    $0x0,%eax
 229:	eb 11                	jmp    23c <atoo+0x53>
 22b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 230:	eb db                	jmp    20d <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 232:	83 c2 01             	add    $0x1,%edx
 235:	0f be c9             	movsbl %cl,%ecx
 238:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 23c:	0f b6 0a             	movzbl (%edx),%ecx
 23f:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 242:	80 fb 07             	cmp    $0x7,%bl
 245:	76 eb                	jbe    232 <atoo+0x49>
  return sign*n;
 247:	0f af c7             	imul   %edi,%eax
}
 24a:	5b                   	pop    %ebx
 24b:	5e                   	pop    %esi
 24c:	5f                   	pop    %edi
 24d:	5d                   	pop    %ebp
 24e:	c3                   	ret    

0000024f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 24f:	f3 0f 1e fb          	endbr32 
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	53                   	push   %ebx
 257:	8b 55 08             	mov    0x8(%ebp),%edx
 25a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 25d:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 260:	eb 09                	jmp    26b <strncmp+0x1c>
      n--, p++, q++;
 262:	83 e8 01             	sub    $0x1,%eax
 265:	83 c2 01             	add    $0x1,%edx
 268:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 26b:	85 c0                	test   %eax,%eax
 26d:	74 0b                	je     27a <strncmp+0x2b>
 26f:	0f b6 1a             	movzbl (%edx),%ebx
 272:	84 db                	test   %bl,%bl
 274:	74 04                	je     27a <strncmp+0x2b>
 276:	3a 19                	cmp    (%ecx),%bl
 278:	74 e8                	je     262 <strncmp+0x13>
    if(n == 0)
 27a:	85 c0                	test   %eax,%eax
 27c:	74 0b                	je     289 <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 27e:	0f b6 02             	movzbl (%edx),%eax
 281:	0f b6 11             	movzbl (%ecx),%edx
 284:	29 d0                	sub    %edx,%eax
}
 286:	5b                   	pop    %ebx
 287:	5d                   	pop    %ebp
 288:	c3                   	ret    
      return 0;
 289:	b8 00 00 00 00       	mov    $0x0,%eax
 28e:	eb f6                	jmp    286 <strncmp+0x37>

00000290 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 290:	f3 0f 1e fb          	endbr32 
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	56                   	push   %esi
 298:	53                   	push   %ebx
 299:	8b 75 08             	mov    0x8(%ebp),%esi
 29c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 29f:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 2a2:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2a4:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2a7:	85 c0                	test   %eax,%eax
 2a9:	7e 0f                	jle    2ba <memmove+0x2a>
    *dst++ = *src++;
 2ab:	0f b6 01             	movzbl (%ecx),%eax
 2ae:	88 02                	mov    %al,(%edx)
 2b0:	8d 49 01             	lea    0x1(%ecx),%ecx
 2b3:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2b6:	89 d8                	mov    %ebx,%eax
 2b8:	eb ea                	jmp    2a4 <memmove+0x14>
  return vdst;
}
 2ba:	89 f0                	mov    %esi,%eax
 2bc:	5b                   	pop    %ebx
 2bd:	5e                   	pop    %esi
 2be:	5d                   	pop    %ebp
 2bf:	c3                   	ret    

000002c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c0:	b8 01 00 00 00       	mov    $0x1,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exit>:
SYSCALL(exit)
 2c8:	b8 02 00 00 00       	mov    $0x2,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <wait>:
SYSCALL(wait)
 2d0:	b8 03 00 00 00       	mov    $0x3,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <pipe>:
SYSCALL(pipe)
 2d8:	b8 04 00 00 00       	mov    $0x4,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <read>:
SYSCALL(read)
 2e0:	b8 05 00 00 00       	mov    $0x5,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <write>:
SYSCALL(write)
 2e8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <close>:
SYSCALL(close)
 2f0:	b8 15 00 00 00       	mov    $0x15,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <kill>:
SYSCALL(kill)
 2f8:	b8 06 00 00 00       	mov    $0x6,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <exec>:
SYSCALL(exec)
 300:	b8 07 00 00 00       	mov    $0x7,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <open>:
SYSCALL(open)
 308:	b8 0f 00 00 00       	mov    $0xf,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mknod>:
SYSCALL(mknod)
 310:	b8 11 00 00 00       	mov    $0x11,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <unlink>:
SYSCALL(unlink)
 318:	b8 12 00 00 00       	mov    $0x12,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <fstat>:
SYSCALL(fstat)
 320:	b8 08 00 00 00       	mov    $0x8,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <link>:
SYSCALL(link)
 328:	b8 13 00 00 00       	mov    $0x13,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mkdir>:
SYSCALL(mkdir)
 330:	b8 14 00 00 00       	mov    $0x14,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <chdir>:
SYSCALL(chdir)
 338:	b8 09 00 00 00       	mov    $0x9,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <dup>:
SYSCALL(dup)
 340:	b8 0a 00 00 00       	mov    $0xa,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <getpid>:
SYSCALL(getpid)
 348:	b8 0b 00 00 00       	mov    $0xb,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sbrk>:
SYSCALL(sbrk)
 350:	b8 0c 00 00 00       	mov    $0xc,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sleep>:
SYSCALL(sleep)
 358:	b8 0d 00 00 00       	mov    $0xd,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <uptime>:
SYSCALL(uptime)
 360:	b8 0e 00 00 00       	mov    $0xe,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <halt>:
SYSCALL(halt)
 368:	b8 16 00 00 00       	mov    $0x16,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <date>:
SYSCALL(date)
 370:	b8 17 00 00 00       	mov    $0x17,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <getuid>:
SYSCALL(getuid)
 378:	b8 18 00 00 00       	mov    $0x18,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <getgid>:
SYSCALL(getgid)
 380:	b8 19 00 00 00       	mov    $0x19,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <getppid>:
SYSCALL(getppid)
 388:	b8 1a 00 00 00       	mov    $0x1a,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <setuid>:
SYSCALL(setuid)
 390:	b8 1b 00 00 00       	mov    $0x1b,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <setgid>:
SYSCALL(setgid)
 398:	b8 1c 00 00 00       	mov    $0x1c,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <getprocs>:
SYSCALL(getprocs)
 3a0:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <setpriority>:
SYSCALL(setpriority)
 3a8:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <getpriority>:
SYSCALL(getpriority)
 3b0:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b8:	55                   	push   %ebp
 3b9:	89 e5                	mov    %esp,%ebp
 3bb:	83 ec 1c             	sub    $0x1c,%esp
 3be:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3c1:	6a 01                	push   $0x1
 3c3:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3c6:	52                   	push   %edx
 3c7:	50                   	push   %eax
 3c8:	e8 1b ff ff ff       	call   2e8 <write>
}
 3cd:	83 c4 10             	add    $0x10,%esp
 3d0:	c9                   	leave  
 3d1:	c3                   	ret    

000003d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d2:	55                   	push   %ebp
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	57                   	push   %edi
 3d6:	56                   	push   %esi
 3d7:	53                   	push   %ebx
 3d8:	83 ec 2c             	sub    $0x2c,%esp
 3db:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3de:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3e4:	0f 95 c2             	setne  %dl
 3e7:	89 f0                	mov    %esi,%eax
 3e9:	c1 e8 1f             	shr    $0x1f,%eax
 3ec:	84 c2                	test   %al,%dl
 3ee:	74 42                	je     432 <printint+0x60>
    neg = 1;
    x = -xx;
 3f0:	f7 de                	neg    %esi
    neg = 1;
 3f2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3fe:	89 f0                	mov    %esi,%eax
 400:	ba 00 00 00 00       	mov    $0x0,%edx
 405:	f7 f1                	div    %ecx
 407:	89 df                	mov    %ebx,%edi
 409:	83 c3 01             	add    $0x1,%ebx
 40c:	0f b6 92 20 07 00 00 	movzbl 0x720(%edx),%edx
 413:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 417:	89 f2                	mov    %esi,%edx
 419:	89 c6                	mov    %eax,%esi
 41b:	39 d1                	cmp    %edx,%ecx
 41d:	76 df                	jbe    3fe <printint+0x2c>
  if(neg)
 41f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 423:	74 2f                	je     454 <printint+0x82>
    buf[i++] = '-';
 425:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 42a:	8d 5f 02             	lea    0x2(%edi),%ebx
 42d:	8b 75 d0             	mov    -0x30(%ebp),%esi
 430:	eb 15                	jmp    447 <printint+0x75>
  neg = 0;
 432:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 439:	eb be                	jmp    3f9 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 43b:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 440:	89 f0                	mov    %esi,%eax
 442:	e8 71 ff ff ff       	call   3b8 <putc>
  while(--i >= 0)
 447:	83 eb 01             	sub    $0x1,%ebx
 44a:	79 ef                	jns    43b <printint+0x69>
}
 44c:	83 c4 2c             	add    $0x2c,%esp
 44f:	5b                   	pop    %ebx
 450:	5e                   	pop    %esi
 451:	5f                   	pop    %edi
 452:	5d                   	pop    %ebp
 453:	c3                   	ret    
 454:	8b 75 d0             	mov    -0x30(%ebp),%esi
 457:	eb ee                	jmp    447 <printint+0x75>

00000459 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 459:	f3 0f 1e fb          	endbr32 
 45d:	55                   	push   %ebp
 45e:	89 e5                	mov    %esp,%ebp
 460:	57                   	push   %edi
 461:	56                   	push   %esi
 462:	53                   	push   %ebx
 463:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 466:	8d 45 10             	lea    0x10(%ebp),%eax
 469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 46c:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 471:	bb 00 00 00 00       	mov    $0x0,%ebx
 476:	eb 14                	jmp    48c <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 478:	89 fa                	mov    %edi,%edx
 47a:	8b 45 08             	mov    0x8(%ebp),%eax
 47d:	e8 36 ff ff ff       	call   3b8 <putc>
 482:	eb 05                	jmp    489 <printf+0x30>
      }
    } else if(state == '%'){
 484:	83 fe 25             	cmp    $0x25,%esi
 487:	74 25                	je     4ae <printf+0x55>
  for(i = 0; fmt[i]; i++){
 489:	83 c3 01             	add    $0x1,%ebx
 48c:	8b 45 0c             	mov    0xc(%ebp),%eax
 48f:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 493:	84 c0                	test   %al,%al
 495:	0f 84 23 01 00 00    	je     5be <printf+0x165>
    c = fmt[i] & 0xff;
 49b:	0f be f8             	movsbl %al,%edi
 49e:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4a1:	85 f6                	test   %esi,%esi
 4a3:	75 df                	jne    484 <printf+0x2b>
      if(c == '%'){
 4a5:	83 f8 25             	cmp    $0x25,%eax
 4a8:	75 ce                	jne    478 <printf+0x1f>
        state = '%';
 4aa:	89 c6                	mov    %eax,%esi
 4ac:	eb db                	jmp    489 <printf+0x30>
      if(c == 'd'){
 4ae:	83 f8 64             	cmp    $0x64,%eax
 4b1:	74 49                	je     4fc <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4b3:	83 f8 78             	cmp    $0x78,%eax
 4b6:	0f 94 c1             	sete   %cl
 4b9:	83 f8 70             	cmp    $0x70,%eax
 4bc:	0f 94 c2             	sete   %dl
 4bf:	08 d1                	or     %dl,%cl
 4c1:	75 63                	jne    526 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4c3:	83 f8 73             	cmp    $0x73,%eax
 4c6:	0f 84 84 00 00 00    	je     550 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4cc:	83 f8 63             	cmp    $0x63,%eax
 4cf:	0f 84 b7 00 00 00    	je     58c <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4d5:	83 f8 25             	cmp    $0x25,%eax
 4d8:	0f 84 cc 00 00 00    	je     5aa <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4de:	ba 25 00 00 00       	mov    $0x25,%edx
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	e8 cd fe ff ff       	call   3b8 <putc>
        putc(fd, c);
 4eb:	89 fa                	mov    %edi,%edx
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
 4f0:	e8 c3 fe ff ff       	call   3b8 <putc>
      }
      state = 0;
 4f5:	be 00 00 00 00       	mov    $0x0,%esi
 4fa:	eb 8d                	jmp    489 <printf+0x30>
        printint(fd, *ap, 10, 1);
 4fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ff:	8b 17                	mov    (%edi),%edx
 501:	83 ec 0c             	sub    $0xc,%esp
 504:	6a 01                	push   $0x1
 506:	b9 0a 00 00 00       	mov    $0xa,%ecx
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	e8 bf fe ff ff       	call   3d2 <printint>
        ap++;
 513:	83 c7 04             	add    $0x4,%edi
 516:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 519:	83 c4 10             	add    $0x10,%esp
      state = 0;
 51c:	be 00 00 00 00       	mov    $0x0,%esi
 521:	e9 63 ff ff ff       	jmp    489 <printf+0x30>
        printint(fd, *ap, 16, 0);
 526:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 529:	8b 17                	mov    (%edi),%edx
 52b:	83 ec 0c             	sub    $0xc,%esp
 52e:	6a 00                	push   $0x0
 530:	b9 10 00 00 00       	mov    $0x10,%ecx
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	e8 95 fe ff ff       	call   3d2 <printint>
        ap++;
 53d:	83 c7 04             	add    $0x4,%edi
 540:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 543:	83 c4 10             	add    $0x10,%esp
      state = 0;
 546:	be 00 00 00 00       	mov    $0x0,%esi
 54b:	e9 39 ff ff ff       	jmp    489 <printf+0x30>
        s = (char*)*ap;
 550:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 553:	8b 30                	mov    (%eax),%esi
        ap++;
 555:	83 c0 04             	add    $0x4,%eax
 558:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 55b:	85 f6                	test   %esi,%esi
 55d:	75 28                	jne    587 <printf+0x12e>
          s = "(null)";
 55f:	be 18 07 00 00       	mov    $0x718,%esi
 564:	8b 7d 08             	mov    0x8(%ebp),%edi
 567:	eb 0d                	jmp    576 <printf+0x11d>
          putc(fd, *s);
 569:	0f be d2             	movsbl %dl,%edx
 56c:	89 f8                	mov    %edi,%eax
 56e:	e8 45 fe ff ff       	call   3b8 <putc>
          s++;
 573:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 576:	0f b6 16             	movzbl (%esi),%edx
 579:	84 d2                	test   %dl,%dl
 57b:	75 ec                	jne    569 <printf+0x110>
      state = 0;
 57d:	be 00 00 00 00       	mov    $0x0,%esi
 582:	e9 02 ff ff ff       	jmp    489 <printf+0x30>
 587:	8b 7d 08             	mov    0x8(%ebp),%edi
 58a:	eb ea                	jmp    576 <printf+0x11d>
        putc(fd, *ap);
 58c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 58f:	0f be 17             	movsbl (%edi),%edx
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	e8 1e fe ff ff       	call   3b8 <putc>
        ap++;
 59a:	83 c7 04             	add    $0x4,%edi
 59d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5a0:	be 00 00 00 00       	mov    $0x0,%esi
 5a5:	e9 df fe ff ff       	jmp    489 <printf+0x30>
        putc(fd, c);
 5aa:	89 fa                	mov    %edi,%edx
 5ac:	8b 45 08             	mov    0x8(%ebp),%eax
 5af:	e8 04 fe ff ff       	call   3b8 <putc>
      state = 0;
 5b4:	be 00 00 00 00       	mov    $0x0,%esi
 5b9:	e9 cb fe ff ff       	jmp    489 <printf+0x30>
    }
  }
}
 5be:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c1:	5b                   	pop    %ebx
 5c2:	5e                   	pop    %esi
 5c3:	5f                   	pop    %edi
 5c4:	5d                   	pop    %ebp
 5c5:	c3                   	ret    

000005c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c6:	f3 0f 1e fb          	endbr32 
 5ca:	55                   	push   %ebp
 5cb:	89 e5                	mov    %esp,%ebp
 5cd:	57                   	push   %edi
 5ce:	56                   	push   %esi
 5cf:	53                   	push   %ebx
 5d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d3:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d6:	a1 1c 0a 00 00       	mov    0xa1c,%eax
 5db:	eb 02                	jmp    5df <free+0x19>
 5dd:	89 d0                	mov    %edx,%eax
 5df:	39 c8                	cmp    %ecx,%eax
 5e1:	73 04                	jae    5e7 <free+0x21>
 5e3:	39 08                	cmp    %ecx,(%eax)
 5e5:	77 12                	ja     5f9 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e7:	8b 10                	mov    (%eax),%edx
 5e9:	39 c2                	cmp    %eax,%edx
 5eb:	77 f0                	ja     5dd <free+0x17>
 5ed:	39 c8                	cmp    %ecx,%eax
 5ef:	72 08                	jb     5f9 <free+0x33>
 5f1:	39 ca                	cmp    %ecx,%edx
 5f3:	77 04                	ja     5f9 <free+0x33>
 5f5:	89 d0                	mov    %edx,%eax
 5f7:	eb e6                	jmp    5df <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f9:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5fc:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5ff:	8b 10                	mov    (%eax),%edx
 601:	39 d7                	cmp    %edx,%edi
 603:	74 19                	je     61e <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 605:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 608:	8b 50 04             	mov    0x4(%eax),%edx
 60b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 60e:	39 ce                	cmp    %ecx,%esi
 610:	74 1b                	je     62d <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 612:	89 08                	mov    %ecx,(%eax)
  freep = p;
 614:	a3 1c 0a 00 00       	mov    %eax,0xa1c
}
 619:	5b                   	pop    %ebx
 61a:	5e                   	pop    %esi
 61b:	5f                   	pop    %edi
 61c:	5d                   	pop    %ebp
 61d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 61e:	03 72 04             	add    0x4(%edx),%esi
 621:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 624:	8b 10                	mov    (%eax),%edx
 626:	8b 12                	mov    (%edx),%edx
 628:	89 53 f8             	mov    %edx,-0x8(%ebx)
 62b:	eb db                	jmp    608 <free+0x42>
    p->s.size += bp->s.size;
 62d:	03 53 fc             	add    -0x4(%ebx),%edx
 630:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 633:	8b 53 f8             	mov    -0x8(%ebx),%edx
 636:	89 10                	mov    %edx,(%eax)
 638:	eb da                	jmp    614 <free+0x4e>

0000063a <morecore>:

static Header*
morecore(uint nu)
{
 63a:	55                   	push   %ebp
 63b:	89 e5                	mov    %esp,%ebp
 63d:	53                   	push   %ebx
 63e:	83 ec 04             	sub    $0x4,%esp
 641:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 643:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 648:	77 05                	ja     64f <morecore+0x15>
    nu = 4096;
 64a:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 64f:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 656:	83 ec 0c             	sub    $0xc,%esp
 659:	50                   	push   %eax
 65a:	e8 f1 fc ff ff       	call   350 <sbrk>
  if(p == (char*)-1)
 65f:	83 c4 10             	add    $0x10,%esp
 662:	83 f8 ff             	cmp    $0xffffffff,%eax
 665:	74 1c                	je     683 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 667:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 66a:	83 c0 08             	add    $0x8,%eax
 66d:	83 ec 0c             	sub    $0xc,%esp
 670:	50                   	push   %eax
 671:	e8 50 ff ff ff       	call   5c6 <free>
  return freep;
 676:	a1 1c 0a 00 00       	mov    0xa1c,%eax
 67b:	83 c4 10             	add    $0x10,%esp
}
 67e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 681:	c9                   	leave  
 682:	c3                   	ret    
    return 0;
 683:	b8 00 00 00 00       	mov    $0x0,%eax
 688:	eb f4                	jmp    67e <morecore+0x44>

0000068a <malloc>:

void*
malloc(uint nbytes)
{
 68a:	f3 0f 1e fb          	endbr32 
 68e:	55                   	push   %ebp
 68f:	89 e5                	mov    %esp,%ebp
 691:	53                   	push   %ebx
 692:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	8d 58 07             	lea    0x7(%eax),%ebx
 69b:	c1 eb 03             	shr    $0x3,%ebx
 69e:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6a1:	8b 0d 1c 0a 00 00    	mov    0xa1c,%ecx
 6a7:	85 c9                	test   %ecx,%ecx
 6a9:	74 04                	je     6af <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6ab:	8b 01                	mov    (%ecx),%eax
 6ad:	eb 4b                	jmp    6fa <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6af:	c7 05 1c 0a 00 00 20 	movl   $0xa20,0xa1c
 6b6:	0a 00 00 
 6b9:	c7 05 20 0a 00 00 20 	movl   $0xa20,0xa20
 6c0:	0a 00 00 
    base.s.size = 0;
 6c3:	c7 05 24 0a 00 00 00 	movl   $0x0,0xa24
 6ca:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6cd:	b9 20 0a 00 00       	mov    $0xa20,%ecx
 6d2:	eb d7                	jmp    6ab <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6d4:	74 1a                	je     6f0 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6d6:	29 da                	sub    %ebx,%edx
 6d8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6db:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6de:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6e1:	89 0d 1c 0a 00 00    	mov    %ecx,0xa1c
      return (void*)(p + 1);
 6e7:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6ea:	83 c4 04             	add    $0x4,%esp
 6ed:	5b                   	pop    %ebx
 6ee:	5d                   	pop    %ebp
 6ef:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6f0:	8b 10                	mov    (%eax),%edx
 6f2:	89 11                	mov    %edx,(%ecx)
 6f4:	eb eb                	jmp    6e1 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f6:	89 c1                	mov    %eax,%ecx
 6f8:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6fa:	8b 50 04             	mov    0x4(%eax),%edx
 6fd:	39 da                	cmp    %ebx,%edx
 6ff:	73 d3                	jae    6d4 <malloc+0x4a>
    if(p == freep)
 701:	39 05 1c 0a 00 00    	cmp    %eax,0xa1c
 707:	75 ed                	jne    6f6 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 709:	89 d8                	mov    %ebx,%eax
 70b:	e8 2a ff ff ff       	call   63a <morecore>
 710:	85 c0                	test   %eax,%eax
 712:	75 e2                	jne    6f6 <malloc+0x6c>
 714:	eb d4                	jmp    6ea <malloc+0x60>
