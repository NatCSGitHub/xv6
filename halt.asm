
_halt:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "pdx.h"

int
main(void) {
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 e4 f0             	and    $0xfffffff0,%esp
  halt();
   a:	e8 3b 03 00 00       	call   34a <halt>
  exit();
   f:	e8 96 02 00 00       	call   2aa <exit>

00000014 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  14:	f3 0f 1e fb          	endbr32 
  18:	55                   	push   %ebp
  19:	89 e5                	mov    %esp,%ebp
  1b:	56                   	push   %esi
  1c:	53                   	push   %ebx
  1d:	8b 75 08             	mov    0x8(%ebp),%esi
  20:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  23:	89 f0                	mov    %esi,%eax
  25:	89 d1                	mov    %edx,%ecx
  27:	83 c2 01             	add    $0x1,%edx
  2a:	89 c3                	mov    %eax,%ebx
  2c:	83 c0 01             	add    $0x1,%eax
  2f:	0f b6 09             	movzbl (%ecx),%ecx
  32:	88 0b                	mov    %cl,(%ebx)
  34:	84 c9                	test   %cl,%cl
  36:	75 ed                	jne    25 <strcpy+0x11>
    ;
  return os;
}
  38:	89 f0                	mov    %esi,%eax
  3a:	5b                   	pop    %ebx
  3b:	5e                   	pop    %esi
  3c:	5d                   	pop    %ebp
  3d:	c3                   	ret    

0000003e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  3e:	f3 0f 1e fb          	endbr32 
  42:	55                   	push   %ebp
  43:	89 e5                	mov    %esp,%ebp
  45:	8b 4d 08             	mov    0x8(%ebp),%ecx
  48:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  4b:	0f b6 01             	movzbl (%ecx),%eax
  4e:	84 c0                	test   %al,%al
  50:	74 0c                	je     5e <strcmp+0x20>
  52:	3a 02                	cmp    (%edx),%al
  54:	75 08                	jne    5e <strcmp+0x20>
    p++, q++;
  56:	83 c1 01             	add    $0x1,%ecx
  59:	83 c2 01             	add    $0x1,%edx
  5c:	eb ed                	jmp    4b <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  5e:	0f b6 c0             	movzbl %al,%eax
  61:	0f b6 12             	movzbl (%edx),%edx
  64:	29 d0                	sub    %edx,%eax
}
  66:	5d                   	pop    %ebp
  67:	c3                   	ret    

00000068 <strlen>:

uint
strlen(char *s)
{
  68:	f3 0f 1e fb          	endbr32 
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  72:	b8 00 00 00 00       	mov    $0x0,%eax
  77:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  7b:	74 05                	je     82 <strlen+0x1a>
  7d:	83 c0 01             	add    $0x1,%eax
  80:	eb f5                	jmp    77 <strlen+0xf>
    ;
  return n;
}
  82:	5d                   	pop    %ebp
  83:	c3                   	ret    

00000084 <memset>:

void*
memset(void *dst, int c, uint n)
{
  84:	f3 0f 1e fb          	endbr32 
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  8b:	57                   	push   %edi
  8c:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  8f:	89 d7                	mov    %edx,%edi
  91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  94:	8b 45 0c             	mov    0xc(%ebp),%eax
  97:	fc                   	cld    
  98:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  9a:	89 d0                	mov    %edx,%eax
  9c:	5f                   	pop    %edi
  9d:	5d                   	pop    %ebp
  9e:	c3                   	ret    

0000009f <strchr>:

char*
strchr(const char *s, char c)
{
  9f:	f3 0f 1e fb          	endbr32 
  a3:	55                   	push   %ebp
  a4:	89 e5                	mov    %esp,%ebp
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ad:	0f b6 10             	movzbl (%eax),%edx
  b0:	84 d2                	test   %dl,%dl
  b2:	74 09                	je     bd <strchr+0x1e>
    if(*s == c)
  b4:	38 ca                	cmp    %cl,%dl
  b6:	74 0a                	je     c2 <strchr+0x23>
  for(; *s; s++)
  b8:	83 c0 01             	add    $0x1,%eax
  bb:	eb f0                	jmp    ad <strchr+0xe>
      return (char*)s;
  return 0;
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    

000000c4 <gets>:

char*
gets(char *buf, int max)
{
  c4:	f3 0f 1e fb          	endbr32 
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	57                   	push   %edi
  cc:	56                   	push   %esi
  cd:	53                   	push   %ebx
  ce:	83 ec 1c             	sub    $0x1c,%esp
  d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  d9:	89 de                	mov    %ebx,%esi
  db:	83 c3 01             	add    $0x1,%ebx
  de:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  e1:	7d 2e                	jge    111 <gets+0x4d>
    cc = read(0, &c, 1);
  e3:	83 ec 04             	sub    $0x4,%esp
  e6:	6a 01                	push   $0x1
  e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
  eb:	50                   	push   %eax
  ec:	6a 00                	push   $0x0
  ee:	e8 cf 01 00 00       	call   2c2 <read>
    if(cc < 1)
  f3:	83 c4 10             	add    $0x10,%esp
  f6:	85 c0                	test   %eax,%eax
  f8:	7e 17                	jle    111 <gets+0x4d>
      break;
    buf[i++] = c;
  fa:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  fe:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 101:	3c 0a                	cmp    $0xa,%al
 103:	0f 94 c2             	sete   %dl
 106:	3c 0d                	cmp    $0xd,%al
 108:	0f 94 c0             	sete   %al
 10b:	08 c2                	or     %al,%dl
 10d:	74 ca                	je     d9 <gets+0x15>
    buf[i++] = c;
 10f:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 111:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 115:	89 f8                	mov    %edi,%eax
 117:	8d 65 f4             	lea    -0xc(%ebp),%esp
 11a:	5b                   	pop    %ebx
 11b:	5e                   	pop    %esi
 11c:	5f                   	pop    %edi
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    

0000011f <stat>:

int
stat(char *n, struct stat *st)
{
 11f:	f3 0f 1e fb          	endbr32 
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	56                   	push   %esi
 127:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 128:	83 ec 08             	sub    $0x8,%esp
 12b:	6a 00                	push   $0x0
 12d:	ff 75 08             	pushl  0x8(%ebp)
 130:	e8 b5 01 00 00       	call   2ea <open>
  if(fd < 0)
 135:	83 c4 10             	add    $0x10,%esp
 138:	85 c0                	test   %eax,%eax
 13a:	78 24                	js     160 <stat+0x41>
 13c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 13e:	83 ec 08             	sub    $0x8,%esp
 141:	ff 75 0c             	pushl  0xc(%ebp)
 144:	50                   	push   %eax
 145:	e8 b8 01 00 00       	call   302 <fstat>
 14a:	89 c6                	mov    %eax,%esi
  close(fd);
 14c:	89 1c 24             	mov    %ebx,(%esp)
 14f:	e8 7e 01 00 00       	call   2d2 <close>
  return r;
 154:	83 c4 10             	add    $0x10,%esp
}
 157:	89 f0                	mov    %esi,%eax
 159:	8d 65 f8             	lea    -0x8(%ebp),%esp
 15c:	5b                   	pop    %ebx
 15d:	5e                   	pop    %esi
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    
    return -1;
 160:	be ff ff ff ff       	mov    $0xffffffff,%esi
 165:	eb f0                	jmp    157 <stat+0x38>

00000167 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 167:	f3 0f 1e fb          	endbr32 
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	57                   	push   %edi
 16f:	56                   	push   %esi
 170:	53                   	push   %ebx
 171:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 174:	0f b6 02             	movzbl (%edx),%eax
 177:	3c 20                	cmp    $0x20,%al
 179:	75 05                	jne    180 <atoi+0x19>
 17b:	83 c2 01             	add    $0x1,%edx
 17e:	eb f4                	jmp    174 <atoi+0xd>
  sign = (*s == '-') ? -1 : 1;
 180:	3c 2d                	cmp    $0x2d,%al
 182:	74 1d                	je     1a1 <atoi+0x3a>
 184:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 189:	3c 2b                	cmp    $0x2b,%al
 18b:	0f 94 c1             	sete   %cl
 18e:	3c 2d                	cmp    $0x2d,%al
 190:	0f 94 c0             	sete   %al
 193:	08 c1                	or     %al,%cl
 195:	74 03                	je     19a <atoi+0x33>
    s++;
 197:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 19a:	b8 00 00 00 00       	mov    $0x0,%eax
 19f:	eb 17                	jmp    1b8 <atoi+0x51>
 1a1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 1a6:	eb e1                	jmp    189 <atoi+0x22>
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
 1a8:	8d 34 80             	lea    (%eax,%eax,4),%esi
 1ab:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
 1ae:	83 c2 01             	add    $0x1,%edx
 1b1:	0f be c9             	movsbl %cl,%ecx
 1b4:	8d 44 19 d0          	lea    -0x30(%ecx,%ebx,1),%eax
  while('0' <= *s && *s <= '9')
 1b8:	0f b6 0a             	movzbl (%edx),%ecx
 1bb:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1be:	80 fb 09             	cmp    $0x9,%bl
 1c1:	76 e5                	jbe    1a8 <atoi+0x41>
  return sign*n;
 1c3:	0f af c7             	imul   %edi,%eax
}
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5f                   	pop    %edi
 1c9:	5d                   	pop    %ebp
 1ca:	c3                   	ret    

000001cb <atoo>:

int
atoo(const char *s)
{
 1cb:	f3 0f 1e fb          	endbr32 
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	57                   	push   %edi
 1d3:	56                   	push   %esi
 1d4:	53                   	push   %ebx
 1d5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1d8:	0f b6 0a             	movzbl (%edx),%ecx
 1db:	80 f9 20             	cmp    $0x20,%cl
 1de:	75 05                	jne    1e5 <atoo+0x1a>
 1e0:	83 c2 01             	add    $0x1,%edx
 1e3:	eb f3                	jmp    1d8 <atoo+0xd>
  sign = (*s == '-') ? -1 : 1;
 1e5:	80 f9 2d             	cmp    $0x2d,%cl
 1e8:	74 23                	je     20d <atoo+0x42>
 1ea:	bf 01 00 00 00       	mov    $0x1,%edi
  if (*s == '+'  || *s == '-')
 1ef:	80 f9 2b             	cmp    $0x2b,%cl
 1f2:	0f 94 c0             	sete   %al
 1f5:	89 c6                	mov    %eax,%esi
 1f7:	80 f9 2d             	cmp    $0x2d,%cl
 1fa:	0f 94 c0             	sete   %al
 1fd:	89 f3                	mov    %esi,%ebx
 1ff:	08 c3                	or     %al,%bl
 201:	74 03                	je     206 <atoo+0x3b>
    s++;
 203:	83 c2 01             	add    $0x1,%edx
  sign = (*s == '-') ? -1 : 1;
 206:	b8 00 00 00 00       	mov    $0x0,%eax
 20b:	eb 11                	jmp    21e <atoo+0x53>
 20d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
 212:	eb db                	jmp    1ef <atoo+0x24>
  while('0' <= *s && *s <= '7')
    n = n*8 + *s++ - '0';
 214:	83 c2 01             	add    $0x1,%edx
 217:	0f be c9             	movsbl %cl,%ecx
 21a:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 21e:	0f b6 0a             	movzbl (%edx),%ecx
 221:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 224:	80 fb 07             	cmp    $0x7,%bl
 227:	76 eb                	jbe    214 <atoo+0x49>
  return sign*n;
 229:	0f af c7             	imul   %edi,%eax
}
 22c:	5b                   	pop    %ebx
 22d:	5e                   	pop    %esi
 22e:	5f                   	pop    %edi
 22f:	5d                   	pop    %ebp
 230:	c3                   	ret    

00000231 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 231:	f3 0f 1e fb          	endbr32 
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	53                   	push   %ebx
 239:	8b 55 08             	mov    0x8(%ebp),%edx
 23c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 23f:	8b 45 10             	mov    0x10(%ebp),%eax
    while(n > 0 && *p && *p == *q)
 242:	eb 09                	jmp    24d <strncmp+0x1c>
      n--, p++, q++;
 244:	83 e8 01             	sub    $0x1,%eax
 247:	83 c2 01             	add    $0x1,%edx
 24a:	83 c1 01             	add    $0x1,%ecx
    while(n > 0 && *p && *p == *q)
 24d:	85 c0                	test   %eax,%eax
 24f:	74 0b                	je     25c <strncmp+0x2b>
 251:	0f b6 1a             	movzbl (%edx),%ebx
 254:	84 db                	test   %bl,%bl
 256:	74 04                	je     25c <strncmp+0x2b>
 258:	3a 19                	cmp    (%ecx),%bl
 25a:	74 e8                	je     244 <strncmp+0x13>
    if(n == 0)
 25c:	85 c0                	test   %eax,%eax
 25e:	74 0b                	je     26b <strncmp+0x3a>
      return 0;
    return (uchar)*p - (uchar)*q;
 260:	0f b6 02             	movzbl (%edx),%eax
 263:	0f b6 11             	movzbl (%ecx),%edx
 266:	29 d0                	sub    %edx,%eax
}
 268:	5b                   	pop    %ebx
 269:	5d                   	pop    %ebp
 26a:	c3                   	ret    
      return 0;
 26b:	b8 00 00 00 00       	mov    $0x0,%eax
 270:	eb f6                	jmp    268 <strncmp+0x37>

00000272 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 272:	f3 0f 1e fb          	endbr32 
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	56                   	push   %esi
 27a:	53                   	push   %ebx
 27b:	8b 75 08             	mov    0x8(%ebp),%esi
 27e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 281:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst, *src;

  dst = vdst;
 284:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 286:	8d 58 ff             	lea    -0x1(%eax),%ebx
 289:	85 c0                	test   %eax,%eax
 28b:	7e 0f                	jle    29c <memmove+0x2a>
    *dst++ = *src++;
 28d:	0f b6 01             	movzbl (%ecx),%eax
 290:	88 02                	mov    %al,(%edx)
 292:	8d 49 01             	lea    0x1(%ecx),%ecx
 295:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 298:	89 d8                	mov    %ebx,%eax
 29a:	eb ea                	jmp    286 <memmove+0x14>
  return vdst;
}
 29c:	89 f0                	mov    %esi,%eax
 29e:	5b                   	pop    %ebx
 29f:	5e                   	pop    %esi
 2a0:	5d                   	pop    %ebp
 2a1:	c3                   	ret    

000002a2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a2:	b8 01 00 00 00       	mov    $0x1,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <exit>:
SYSCALL(exit)
 2aa:	b8 02 00 00 00       	mov    $0x2,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <wait>:
SYSCALL(wait)
 2b2:	b8 03 00 00 00       	mov    $0x3,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <pipe>:
SYSCALL(pipe)
 2ba:	b8 04 00 00 00       	mov    $0x4,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <read>:
SYSCALL(read)
 2c2:	b8 05 00 00 00       	mov    $0x5,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <write>:
SYSCALL(write)
 2ca:	b8 10 00 00 00       	mov    $0x10,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <close>:
SYSCALL(close)
 2d2:	b8 15 00 00 00       	mov    $0x15,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <kill>:
SYSCALL(kill)
 2da:	b8 06 00 00 00       	mov    $0x6,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <exec>:
SYSCALL(exec)
 2e2:	b8 07 00 00 00       	mov    $0x7,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <open>:
SYSCALL(open)
 2ea:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <mknod>:
SYSCALL(mknod)
 2f2:	b8 11 00 00 00       	mov    $0x11,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <unlink>:
SYSCALL(unlink)
 2fa:	b8 12 00 00 00       	mov    $0x12,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <fstat>:
SYSCALL(fstat)
 302:	b8 08 00 00 00       	mov    $0x8,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <link>:
SYSCALL(link)
 30a:	b8 13 00 00 00       	mov    $0x13,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <mkdir>:
SYSCALL(mkdir)
 312:	b8 14 00 00 00       	mov    $0x14,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <chdir>:
SYSCALL(chdir)
 31a:	b8 09 00 00 00       	mov    $0x9,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <dup>:
SYSCALL(dup)
 322:	b8 0a 00 00 00       	mov    $0xa,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <getpid>:
SYSCALL(getpid)
 32a:	b8 0b 00 00 00       	mov    $0xb,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <sbrk>:
SYSCALL(sbrk)
 332:	b8 0c 00 00 00       	mov    $0xc,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sleep>:
SYSCALL(sleep)
 33a:	b8 0d 00 00 00       	mov    $0xd,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <uptime>:
SYSCALL(uptime)
 342:	b8 0e 00 00 00       	mov    $0xe,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <halt>:
SYSCALL(halt)
 34a:	b8 16 00 00 00       	mov    $0x16,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <date>:
SYSCALL(date)
 352:	b8 17 00 00 00       	mov    $0x17,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <getuid>:
SYSCALL(getuid)
 35a:	b8 18 00 00 00       	mov    $0x18,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <getgid>:
SYSCALL(getgid)
 362:	b8 19 00 00 00       	mov    $0x19,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <getppid>:
SYSCALL(getppid)
 36a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <setuid>:
SYSCALL(setuid)
 372:	b8 1b 00 00 00       	mov    $0x1b,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <setgid>:
SYSCALL(setgid)
 37a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <getprocs>:
SYSCALL(getprocs)
 382:	b8 1d 00 00 00       	mov    $0x1d,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <setpriority>:
SYSCALL(setpriority)
 38a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <getpriority>:
SYSCALL(getpriority)
 392:	b8 1f 00 00 00       	mov    $0x1f,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
 39d:	83 ec 1c             	sub    $0x1c,%esp
 3a0:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3a3:	6a 01                	push   $0x1
 3a5:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3a8:	52                   	push   %edx
 3a9:	50                   	push   %eax
 3aa:	e8 1b ff ff ff       	call   2ca <write>
}
 3af:	83 c4 10             	add    $0x10,%esp
 3b2:	c9                   	leave  
 3b3:	c3                   	ret    

000003b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	57                   	push   %edi
 3b8:	56                   	push   %esi
 3b9:	53                   	push   %ebx
 3ba:	83 ec 2c             	sub    $0x2c,%esp
 3bd:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3c0:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3c6:	0f 95 c2             	setne  %dl
 3c9:	89 f0                	mov    %esi,%eax
 3cb:	c1 e8 1f             	shr    $0x1f,%eax
 3ce:	84 c2                	test   %al,%dl
 3d0:	74 42                	je     414 <printint+0x60>
    neg = 1;
    x = -xx;
 3d2:	f7 de                	neg    %esi
    neg = 1;
 3d4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3db:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3e0:	89 f0                	mov    %esi,%eax
 3e2:	ba 00 00 00 00       	mov    $0x0,%edx
 3e7:	f7 f1                	div    %ecx
 3e9:	89 df                	mov    %ebx,%edi
 3eb:	83 c3 01             	add    $0x1,%ebx
 3ee:	0f b6 92 00 07 00 00 	movzbl 0x700(%edx),%edx
 3f5:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3f9:	89 f2                	mov    %esi,%edx
 3fb:	89 c6                	mov    %eax,%esi
 3fd:	39 d1                	cmp    %edx,%ecx
 3ff:	76 df                	jbe    3e0 <printint+0x2c>
  if(neg)
 401:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 405:	74 2f                	je     436 <printint+0x82>
    buf[i++] = '-';
 407:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 40c:	8d 5f 02             	lea    0x2(%edi),%ebx
 40f:	8b 75 d0             	mov    -0x30(%ebp),%esi
 412:	eb 15                	jmp    429 <printint+0x75>
  neg = 0;
 414:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 41b:	eb be                	jmp    3db <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 41d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 422:	89 f0                	mov    %esi,%eax
 424:	e8 71 ff ff ff       	call   39a <putc>
  while(--i >= 0)
 429:	83 eb 01             	sub    $0x1,%ebx
 42c:	79 ef                	jns    41d <printint+0x69>
}
 42e:	83 c4 2c             	add    $0x2c,%esp
 431:	5b                   	pop    %ebx
 432:	5e                   	pop    %esi
 433:	5f                   	pop    %edi
 434:	5d                   	pop    %ebp
 435:	c3                   	ret    
 436:	8b 75 d0             	mov    -0x30(%ebp),%esi
 439:	eb ee                	jmp    429 <printint+0x75>

0000043b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43b:	f3 0f 1e fb          	endbr32 
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	57                   	push   %edi
 443:	56                   	push   %esi
 444:	53                   	push   %ebx
 445:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 448:	8d 45 10             	lea    0x10(%ebp),%eax
 44b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 44e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 453:	bb 00 00 00 00       	mov    $0x0,%ebx
 458:	eb 14                	jmp    46e <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 45a:	89 fa                	mov    %edi,%edx
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	e8 36 ff ff ff       	call   39a <putc>
 464:	eb 05                	jmp    46b <printf+0x30>
      }
    } else if(state == '%'){
 466:	83 fe 25             	cmp    $0x25,%esi
 469:	74 25                	je     490 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 46b:	83 c3 01             	add    $0x1,%ebx
 46e:	8b 45 0c             	mov    0xc(%ebp),%eax
 471:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 475:	84 c0                	test   %al,%al
 477:	0f 84 23 01 00 00    	je     5a0 <printf+0x165>
    c = fmt[i] & 0xff;
 47d:	0f be f8             	movsbl %al,%edi
 480:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 483:	85 f6                	test   %esi,%esi
 485:	75 df                	jne    466 <printf+0x2b>
      if(c == '%'){
 487:	83 f8 25             	cmp    $0x25,%eax
 48a:	75 ce                	jne    45a <printf+0x1f>
        state = '%';
 48c:	89 c6                	mov    %eax,%esi
 48e:	eb db                	jmp    46b <printf+0x30>
      if(c == 'd'){
 490:	83 f8 64             	cmp    $0x64,%eax
 493:	74 49                	je     4de <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 495:	83 f8 78             	cmp    $0x78,%eax
 498:	0f 94 c1             	sete   %cl
 49b:	83 f8 70             	cmp    $0x70,%eax
 49e:	0f 94 c2             	sete   %dl
 4a1:	08 d1                	or     %dl,%cl
 4a3:	75 63                	jne    508 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4a5:	83 f8 73             	cmp    $0x73,%eax
 4a8:	0f 84 84 00 00 00    	je     532 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4ae:	83 f8 63             	cmp    $0x63,%eax
 4b1:	0f 84 b7 00 00 00    	je     56e <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4b7:	83 f8 25             	cmp    $0x25,%eax
 4ba:	0f 84 cc 00 00 00    	je     58c <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4c0:	ba 25 00 00 00       	mov    $0x25,%edx
 4c5:	8b 45 08             	mov    0x8(%ebp),%eax
 4c8:	e8 cd fe ff ff       	call   39a <putc>
        putc(fd, c);
 4cd:	89 fa                	mov    %edi,%edx
 4cf:	8b 45 08             	mov    0x8(%ebp),%eax
 4d2:	e8 c3 fe ff ff       	call   39a <putc>
      }
      state = 0;
 4d7:	be 00 00 00 00       	mov    $0x0,%esi
 4dc:	eb 8d                	jmp    46b <printf+0x30>
        printint(fd, *ap, 10, 1);
 4de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4e1:	8b 17                	mov    (%edi),%edx
 4e3:	83 ec 0c             	sub    $0xc,%esp
 4e6:	6a 01                	push   $0x1
 4e8:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
 4f0:	e8 bf fe ff ff       	call   3b4 <printint>
        ap++;
 4f5:	83 c7 04             	add    $0x4,%edi
 4f8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4fb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4fe:	be 00 00 00 00       	mov    $0x0,%esi
 503:	e9 63 ff ff ff       	jmp    46b <printf+0x30>
        printint(fd, *ap, 16, 0);
 508:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 50b:	8b 17                	mov    (%edi),%edx
 50d:	83 ec 0c             	sub    $0xc,%esp
 510:	6a 00                	push   $0x0
 512:	b9 10 00 00 00       	mov    $0x10,%ecx
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	e8 95 fe ff ff       	call   3b4 <printint>
        ap++;
 51f:	83 c7 04             	add    $0x4,%edi
 522:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 525:	83 c4 10             	add    $0x10,%esp
      state = 0;
 528:	be 00 00 00 00       	mov    $0x0,%esi
 52d:	e9 39 ff ff ff       	jmp    46b <printf+0x30>
        s = (char*)*ap;
 532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 535:	8b 30                	mov    (%eax),%esi
        ap++;
 537:	83 c0 04             	add    $0x4,%eax
 53a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 53d:	85 f6                	test   %esi,%esi
 53f:	75 28                	jne    569 <printf+0x12e>
          s = "(null)";
 541:	be f8 06 00 00       	mov    $0x6f8,%esi
 546:	8b 7d 08             	mov    0x8(%ebp),%edi
 549:	eb 0d                	jmp    558 <printf+0x11d>
          putc(fd, *s);
 54b:	0f be d2             	movsbl %dl,%edx
 54e:	89 f8                	mov    %edi,%eax
 550:	e8 45 fe ff ff       	call   39a <putc>
          s++;
 555:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 558:	0f b6 16             	movzbl (%esi),%edx
 55b:	84 d2                	test   %dl,%dl
 55d:	75 ec                	jne    54b <printf+0x110>
      state = 0;
 55f:	be 00 00 00 00       	mov    $0x0,%esi
 564:	e9 02 ff ff ff       	jmp    46b <printf+0x30>
 569:	8b 7d 08             	mov    0x8(%ebp),%edi
 56c:	eb ea                	jmp    558 <printf+0x11d>
        putc(fd, *ap);
 56e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 571:	0f be 17             	movsbl (%edi),%edx
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	e8 1e fe ff ff       	call   39a <putc>
        ap++;
 57c:	83 c7 04             	add    $0x4,%edi
 57f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 582:	be 00 00 00 00       	mov    $0x0,%esi
 587:	e9 df fe ff ff       	jmp    46b <printf+0x30>
        putc(fd, c);
 58c:	89 fa                	mov    %edi,%edx
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	e8 04 fe ff ff       	call   39a <putc>
      state = 0;
 596:	be 00 00 00 00       	mov    $0x0,%esi
 59b:	e9 cb fe ff ff       	jmp    46b <printf+0x30>
    }
  }
}
 5a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5a3:	5b                   	pop    %ebx
 5a4:	5e                   	pop    %esi
 5a5:	5f                   	pop    %edi
 5a6:	5d                   	pop    %ebp
 5a7:	c3                   	ret    

000005a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a8:	f3 0f 1e fb          	endbr32 
 5ac:	55                   	push   %ebp
 5ad:	89 e5                	mov    %esp,%ebp
 5af:	57                   	push   %edi
 5b0:	56                   	push   %esi
 5b1:	53                   	push   %ebx
 5b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b8:	a1 f4 09 00 00       	mov    0x9f4,%eax
 5bd:	eb 02                	jmp    5c1 <free+0x19>
 5bf:	89 d0                	mov    %edx,%eax
 5c1:	39 c8                	cmp    %ecx,%eax
 5c3:	73 04                	jae    5c9 <free+0x21>
 5c5:	39 08                	cmp    %ecx,(%eax)
 5c7:	77 12                	ja     5db <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c9:	8b 10                	mov    (%eax),%edx
 5cb:	39 c2                	cmp    %eax,%edx
 5cd:	77 f0                	ja     5bf <free+0x17>
 5cf:	39 c8                	cmp    %ecx,%eax
 5d1:	72 08                	jb     5db <free+0x33>
 5d3:	39 ca                	cmp    %ecx,%edx
 5d5:	77 04                	ja     5db <free+0x33>
 5d7:	89 d0                	mov    %edx,%eax
 5d9:	eb e6                	jmp    5c1 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5db:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5de:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5e1:	8b 10                	mov    (%eax),%edx
 5e3:	39 d7                	cmp    %edx,%edi
 5e5:	74 19                	je     600 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5e7:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ea:	8b 50 04             	mov    0x4(%eax),%edx
 5ed:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5f0:	39 ce                	cmp    %ecx,%esi
 5f2:	74 1b                	je     60f <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5f4:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5f6:	a3 f4 09 00 00       	mov    %eax,0x9f4
}
 5fb:	5b                   	pop    %ebx
 5fc:	5e                   	pop    %esi
 5fd:	5f                   	pop    %edi
 5fe:	5d                   	pop    %ebp
 5ff:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 600:	03 72 04             	add    0x4(%edx),%esi
 603:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 606:	8b 10                	mov    (%eax),%edx
 608:	8b 12                	mov    (%edx),%edx
 60a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 60d:	eb db                	jmp    5ea <free+0x42>
    p->s.size += bp->s.size;
 60f:	03 53 fc             	add    -0x4(%ebx),%edx
 612:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 615:	8b 53 f8             	mov    -0x8(%ebx),%edx
 618:	89 10                	mov    %edx,(%eax)
 61a:	eb da                	jmp    5f6 <free+0x4e>

0000061c <morecore>:

static Header*
morecore(uint nu)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	53                   	push   %ebx
 620:	83 ec 04             	sub    $0x4,%esp
 623:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 625:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 62a:	77 05                	ja     631 <morecore+0x15>
    nu = 4096;
 62c:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 631:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 638:	83 ec 0c             	sub    $0xc,%esp
 63b:	50                   	push   %eax
 63c:	e8 f1 fc ff ff       	call   332 <sbrk>
  if(p == (char*)-1)
 641:	83 c4 10             	add    $0x10,%esp
 644:	83 f8 ff             	cmp    $0xffffffff,%eax
 647:	74 1c                	je     665 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 649:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 64c:	83 c0 08             	add    $0x8,%eax
 64f:	83 ec 0c             	sub    $0xc,%esp
 652:	50                   	push   %eax
 653:	e8 50 ff ff ff       	call   5a8 <free>
  return freep;
 658:	a1 f4 09 00 00       	mov    0x9f4,%eax
 65d:	83 c4 10             	add    $0x10,%esp
}
 660:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 663:	c9                   	leave  
 664:	c3                   	ret    
    return 0;
 665:	b8 00 00 00 00       	mov    $0x0,%eax
 66a:	eb f4                	jmp    660 <morecore+0x44>

0000066c <malloc>:

void*
malloc(uint nbytes)
{
 66c:	f3 0f 1e fb          	endbr32 
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	53                   	push   %ebx
 674:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	8d 58 07             	lea    0x7(%eax),%ebx
 67d:	c1 eb 03             	shr    $0x3,%ebx
 680:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 683:	8b 0d f4 09 00 00    	mov    0x9f4,%ecx
 689:	85 c9                	test   %ecx,%ecx
 68b:	74 04                	je     691 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 68d:	8b 01                	mov    (%ecx),%eax
 68f:	eb 4b                	jmp    6dc <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 691:	c7 05 f4 09 00 00 f8 	movl   $0x9f8,0x9f4
 698:	09 00 00 
 69b:	c7 05 f8 09 00 00 f8 	movl   $0x9f8,0x9f8
 6a2:	09 00 00 
    base.s.size = 0;
 6a5:	c7 05 fc 09 00 00 00 	movl   $0x0,0x9fc
 6ac:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6af:	b9 f8 09 00 00       	mov    $0x9f8,%ecx
 6b4:	eb d7                	jmp    68d <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6b6:	74 1a                	je     6d2 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6b8:	29 da                	sub    %ebx,%edx
 6ba:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6bd:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6c0:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6c3:	89 0d f4 09 00 00    	mov    %ecx,0x9f4
      return (void*)(p + 1);
 6c9:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6cc:	83 c4 04             	add    $0x4,%esp
 6cf:	5b                   	pop    %ebx
 6d0:	5d                   	pop    %ebp
 6d1:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	89 11                	mov    %edx,(%ecx)
 6d6:	eb eb                	jmp    6c3 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d8:	89 c1                	mov    %eax,%ecx
 6da:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6dc:	8b 50 04             	mov    0x4(%eax),%edx
 6df:	39 da                	cmp    %ebx,%edx
 6e1:	73 d3                	jae    6b6 <malloc+0x4a>
    if(p == freep)
 6e3:	39 05 f4 09 00 00    	cmp    %eax,0x9f4
 6e9:	75 ed                	jne    6d8 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 6eb:	89 d8                	mov    %ebx,%eax
 6ed:	e8 2a ff ff ff       	call   61c <morecore>
 6f2:	85 c0                	test   %eax,%eax
 6f4:	75 e2                	jne    6d8 <malloc+0x6c>
 6f6:	eb d4                	jmp    6cc <malloc+0x60>
